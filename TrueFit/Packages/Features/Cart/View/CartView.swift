import SwiftUI

struct CartView: View {
    @StateObject var viewModel: CartViewModel
    @EnvironmentObject var globalCartState: CartState
    let cartId: String
    let onStartShopping: () -> Void
    
    @State private var isDiscountExpanded: Bool = false
    @Environment(\.openURL) private var openURL

    init(viewModelFactory: @escaping () -> CartViewModel, cartId: String, onStartShopping: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
        self.cartId = cartId
        self.onStartShopping = onStartShopping
    }
    

    var body: some View {
        ZStack {
            Color.trueFitBackground.ignoresSafeArea()
            
            switch viewModel.cartState {
            case .idle:
                EmptyView()
            case .loading:
                CartLoadingView()
            case .failure(let error):
                CartFailureView(
                    error: error,
                    onRetry: error.isRetryable ? {
                        Task { await viewModel.retry(cartId: cartId) }
                    } : nil
                )
            case .success(let cart):
                if cart.isEmpty {
                    CartEmptyView(onStartShopping: onStartShopping)
                } else {
                    CartContentView(
                        cart: cart,
                        viewModel: viewModel,
                        cartId: cartId,
                        isDiscountExpanded: $isDiscountExpanded,
                        openURL: openURL
                    )
                }
            }
            
        }
        .navigationTitle("My Cart")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if case .idle = viewModel.cartState {
                await viewModel.loadCart(id: cartId)
            }
        }
        .onChange(of: globalCartState.itemCount) { newCount in
            if case .success(let cart) = viewModel.cartState {
                if cart.totalQuantity != newCount {
                    Task {
                        await viewModel.loadCart(id: cartId, silent: true)
                    }
                }
            }
        }
        .trueFitToast(
            message: Binding(
                get: { viewModel.lastError?.userMessage },
                set: { if $0 == nil { viewModel.lastError = nil } }
            ),
            style: .error
        )
    }
}
