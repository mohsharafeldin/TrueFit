import SwiftUI

struct CartView: View {
    @StateObject var viewModel: CartViewModel
    @EnvironmentObject var globalCartState: CartState
    @EnvironmentObject var appRouter: AppRouter
    let onStartShopping: () -> Void
    
    @State private var isDiscountExpanded: Bool = false

    init(viewModelFactory: @escaping () -> CartViewModel, onStartShopping: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
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
                        Task { await viewModel.retry() }
                    } : nil
                )
            case .success(let cart):
                if cart.isEmpty {
                    CartEmptyView(onStartShopping: onStartShopping)
                } else {
                    CartContentView(
                        cart: cart,
                        viewModel: viewModel,
                        isDiscountExpanded: $isDiscountExpanded,
                        onCheckout: {
                            appRouter.navigate(to: .checkout)
                        }
                    )
                }
            }
            
        }
        .navigationTitle("My Cart")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if case .idle = viewModel.cartState {
                await viewModel.loadCart()
            }
        }
        .onChange(of: globalCartState.itemCount) { newCount in
            if case .success(let cart) = viewModel.cartState {
                if cart.totalQuantity != newCount {
                    Task {
                        await viewModel.loadCart(silent: true)
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
