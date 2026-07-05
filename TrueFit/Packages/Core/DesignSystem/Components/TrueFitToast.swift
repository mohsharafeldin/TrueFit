import SwiftUI

public enum ToastStyle {
    case success
    case error
    
    var backgroundColor: Color {
        switch self {
        case .success:
            return .semanticSuccess
        case .error:
            return .textSecondary // Gray background as requested
        }
    }
}

public struct TrueFitToastModifier: ViewModifier {
    @Binding var message: String?
    let style: ToastStyle
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            if let msg = message {
                VStack {
                    Spacer()
                    Text(msg)
                        .trueFitTextStyle(.callout)
                        .foregroundColor(.white)
                        .padding(Spacing.md)
                        .background(style.backgroundColor)
                        .clipShape(RoundedRectangle.trueFit(Radius.md))
                        .shadow(color: Color.shadowColor.opacity(0.15), radius: 10, x: 0, y: 4)
                        .padding(.horizontal, Spacing.md)
                        .padding(.bottom, Spacing.xxxxl)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    if message == msg {
                                        message = nil
                                    }
                                }
                            }
                        }
                        .onTapGesture {
                            withAnimation {
                                message = nil
                            }
                        }
                }
                .zIndex(100)
            }
        }
        .animation(.default, value: message != nil)
    }
}

public extension View {
    func trueFitToast(message: Binding<String?>, style: ToastStyle = .success) -> some View {
        self.modifier(TrueFitToastModifier(message: message, style: style))
    }
}
