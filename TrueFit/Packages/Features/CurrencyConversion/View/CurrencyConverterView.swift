import SwiftUI

struct CurrencyConverterView: View {
    @StateObject var viewModel: CurrencyConverterViewModel
    @EnvironmentObject var appRouter: AppRouter
    
    init(viewModelFactory: @autoclosure @escaping () -> CurrencyConverterViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
    }
    
    var body: some View {
        ZStack {
            Color.trueFitBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Content
                switch viewModel.state {
                case .idle, .loading:
                    Spacer()
                    ProgressView("Loading currencies...")
                        .tint(.brandPrimary)
                    Spacer()
                    
                case .failure(let error):
                    Spacer()
                    ErrorView(
                        message: error.userMessage,
                        showRetry: true,
                        onRetry: {
                            Task {
                                await viewModel.loadRates()
                            }
                        }
                    )
                    Spacer()
                    
                case .success(let rates):
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: Spacing.md) {
                            // Current Selection Info
                            currentSelectionCard(rates: rates)
                            
                            // Currencies List
                            currenciesList
                        }
                        .padding(.top, Spacing.md)
                        .padding(.bottom, Spacing.xxxl)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            if case .idle = viewModel.state {
                await viewModel.loadRates()
            }
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        HStack {
            Button(action: {
                appRouter.goBack()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .frame(width: 40, height: 40)
                    .background(Color.surface)
                    .clipShape(Circle())
                    .trueFitShadow(.xs)
            }
            
            Spacer()
            
            Text("Currency")
                .trueFitTextStyle(.headline)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            // Invisible placeholder to center the title
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.sm)
        .padding(.bottom, Spacing.sm)
    }
    
    // MARK: - Current Selection
    
    private func currentSelectionCard(rates: CurrencyRates) -> some View {
        VStack(spacing: Spacing.sm) {
            Text("Current Currency")
                .trueFitTextStyle(.subheadline)
                .foregroundColor(.textSecondary)
            
            HStack(spacing: Spacing.sm) {
                Text(currencyFlag(for: viewModel.selectedCurrency))
                    .font(.system(size: 32))
                
                Text(viewModel.selectedCurrency)
                    .trueFitTextStyle(.title2)
                    .foregroundColor(.brandPrimary)
            }
            
            Text(viewModel.rateDisplayText)
                .trueFitTextStyle(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.lg)
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.lg))
        .trueFitShadow(.xs)
        .padding(.horizontal, Spacing.lg)
    }
    
    // MARK: - Currencies List
    
    private var currenciesList: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Available Currencies")
                .trueFitTextStyle(.title3)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, Spacing.lg)
            
            LazyVStack(spacing: Spacing.sm) {
                ForEach(viewModel.availableCurrencies, id: \.self) { currency in
                    currencyRow(for: currency)
                }
            }
            .padding(.horizontal, Spacing.lg)
        }
    }
    
    private func currencyRow(for currency: String) -> some View {
        Button(action: {
            withAnimation {
                viewModel.selectCurrency(currency)
            }
        }) {
            HStack {
                Text(currencyFlag(for: currency))
                    .font(.system(size: 24))
                
                Text(currencyName(for: currency))
                    .trueFitTextStyle(.body)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text(currency)
                    .trueFitTextStyle(.subheadline)
                    .foregroundColor(.textSecondary)
                
                if viewModel.selectedCurrency == currency {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.brandPrimary)
                        .font(.system(size: 20))
                } else {
                    Circle()
                        .stroke(Color.borderColor, lineWidth: 1)
                        .frame(width: 20, height: 20)
                }
            }
            .padding()
            .background(Color.surface)
            .clipShape(RoundedRectangle.trueFit(Radius.md))
            .overlay(
                RoundedRectangle.trueFit(Radius.md)
                    .stroke(viewModel.selectedCurrency == currency ? Color.brandPrimary : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Helpers
    
    private func currencyFlag(for code: String) -> String {
        let base = 127397
        var usv = String.UnicodeScalarView()
        let countryCode = String(code.prefix(2))
        for i in countryCode.utf16 {
            usv.append(UnicodeScalar(base + Int(i))!)
        }
        return String(usv)
    }
    
    private func currencyName(for code: String) -> String {
        let locale = Locale(identifier: Locale.current.identifier)
        return locale.localizedString(forCurrencyCode: code) ?? code
    }
}
