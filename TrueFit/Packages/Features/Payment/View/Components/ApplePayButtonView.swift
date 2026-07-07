//
//  ApplePayButtonView.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//
import SwiftUI
import PassKit

// MARK: - Apple Pay Button


struct ApplePayButtonView: UIViewRepresentable {

    // MARK: - Configuration

    let buttonStyle: PKPaymentButtonStyle

    let buttonType: PKPaymentButtonType

    let action: () -> Void


    init(
        buttonStyle: PKPaymentButtonStyle = .automatic,
        buttonType: PKPaymentButtonType = .plain,
        action: @escaping () -> Void
    ) {
        self.buttonStyle = buttonStyle
        self.buttonType = buttonType
        self.action = action
    }


    func makeCoordinator() -> Coordinator { Coordinator(action: action) }

    func makeUIView(context: Context) -> PKPaymentButton {
        let button = PKPaymentButton(paymentButtonType: buttonType, paymentButtonStyle: buttonStyle)
        button.addTarget(
            context.coordinator,
            action: #selector(Coordinator.buttonTapped),
            for: .touchUpInside
        )
        button.cornerRadius = Radius.md
        return button
    }

    func updateUIView(_ uiView: PKPaymentButton, context: Context) {
       
    }

    // MARK: - Coordinator

    final class Coordinator {
        let action: () -> Void
        init(action: @escaping () -> Void) { self.action = action }

        @objc func buttonTapped() { action() }
    }
}

// MARK: - Preview

#Preview {
    ApplePayButtonView(buttonStyle: .black, buttonType: .plain) {}
        .frame(height: 50)
        .padding()
}
