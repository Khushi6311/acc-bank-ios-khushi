

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    @State private var isPasswordVisible: Bool = false // Toggle for password visibility

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 25)
                .strokeBorder(text.isEmpty ? Color.white.opacity(0.5) : Color.white.opacity(0.9), lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                )
                .frame(width: 350, height: 50)
                .shadow(radius: 2)

            HStack {
                if isSecure {
                    if isPasswordVisible {
                        TextField("", text: $text)
                            .placeholder(when: text.isEmpty) {
                                Text(placeholder)
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.leading, 5)
                            }
                            .padding(.leading, 20)
                            .foregroundColor(.white)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .frame(width: 300, height: 50, alignment: .leading)
                            .tint(.white)// Adjusted width for icon space
                    } else {
                        SecureField("", text: $text)
                            .placeholder(when: text.isEmpty) {
                                Text(placeholder)
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.leading, 5)
                            }
                            .padding(.leading, 20)
                            .foregroundColor(.white)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .frame(width: 300, height: 50, alignment: .leading)
                            .tint(.white)// Adjusted width for icon space
                    }

                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 15)
                } else {
                    TextField("", text: $text)
                        .placeholder(when: text.isEmpty) {
                            Text(placeholder)
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.leading, 5)
                        }
                        .padding(.leading, 20)
                        .foregroundColor(.white)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .frame(width: 350, height: 50, alignment: .leading)
                        .tint(.white)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40)
        .animation(.easeInOut(duration: 0.2), value: text)
    }
}

// Placeholder Extension
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
