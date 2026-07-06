import ShopifyAPI
import Foundation
import Apollo

final class NetworkInterceptorProvider: DefaultInterceptorProvider {
    private let authManager: AuthManagerProtocol
    
    init(client: URLSessionClient, store: ApolloStore, authManager: AuthManagerProtocol) {
        self.authManager = authManager
        super.init(client: client, store: store)
    }
    
    override func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        var interceptors = super.interceptors(for: operation)
        // Insert the auth interceptor right before the network fetch
        interceptors.insert(StorefrontAuthInterceptor(authManager: authManager), at: 0)
        return interceptors
    }
}

@MainActor
final class ApolloManager {
    let authManager: AuthManagerProtocol
    let client: ApolloClient
    
    init(authManager: AuthManagerProtocol) {
        self.authManager = authManager
        let storeName = Bundle.main.shopifyStoreName
        let apiVersion = Bundle.main.shopifyGraphQLAPIVersion
        
        guard let url = URL(string: Constants.storefrontGraphQLBaseURL) else {
            fatalError("Invalid GraphQL endpoint URL.")
        }
     
        
        let urlSessionClient = URLSessionClient()
        // TODO: Upgrade to SQLiteNormalizedCache later for offline support
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = NetworkInterceptorProvider(client: urlSessionClient, store: store, authManager: authManager)
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)
        
        self.client = ApolloClient(networkTransport: transport, store: store)
    }
    
    func fetch<Q: GraphQLQuery>(query: Q) async throws -> Q.Data {
        return try await withCheckedThrowingContinuation { continuation in
            client.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { result in
                self.handleResult(result, continuation: continuation)
            }
        }
    }
    
    func perform<M: GraphQLMutation>(mutation: M) async throws -> M.Data {
        return try await withCheckedThrowingContinuation { continuation in
            client.perform(mutation: mutation) { result in
                self.handleResult(result, continuation: continuation)
            }
        }
    }
    
    private func handleResult<Data>(_ result: Result<GraphQLResult<Data>, Error>, continuation: CheckedContinuation<Data, Error>) {
        switch result {
        case .success(let graphQLResult):
            if let errors = graphQLResult.errors, !errors.isEmpty {
                continuation.resume(throwing: APIError.graphQLErrors(errors.map { $0.message ?? "Unknown GraphQL Error" }))
            } else if let data = graphQLResult.data {
                continuation.resume(returning: data)
            } else {
                continuation.resume(throwing: APIError.noData)
            }
        case .failure(let error):
            if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                continuation.resume(throwing: APIError.noInternetConnection)
            } else {
                continuation.resume(throwing: APIError.unknown(error))
            }
        }
    }
}
