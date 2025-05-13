//import SwiftUI
//
//struct DepositView: View {
//    @State private var selectedAccount: String = ""
//    @State private var amount: String = ""
//
//    let accounts = ["Savings Account", "Checking Account", "Business Account"]
//
//    var body: some View {
//        VStack(spacing: 24) {
//            // Step indicator (circle dots)
//            HStack(spacing: 8) {
//                Circle()
//                    .fill(Color.blue)
//                    .frame(width: 10, height: 10)
//                Circle()
//                    .fill(Color.gray.opacity(0.3))
//                    .frame(width: 10, height: 10)
//            }
//            .padding(.top, 30)
//
//            // Title
//            Text("Deposit cheques")
//                .font(.title2)
//                .fontWeight(.semibold)
//
//            // Description text
//            VStack(spacing: 6) {
//                Text("Deposit cheques here as quickly, easily, and securely as a paper one.")
//                    .font(.body)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal)
//
//                VStack(alignment: .leading, spacing: 4) {
//                    Text("Important:")
//                        .font(.headline)
//                    Text("• You must have a cheque that is less than 6 months old.")
//                    Text("• Standard hold times may apply, which may restrict your ability to access your deposited funds.")
//                }
//                .font(.footnote)
//                .foregroundColor(.gray)
//                .padding(.top, 4)
//                .padding(.horizontal)
//            }
//
//            // Dropdown and Amount field
//            VStack(spacing: 12) {
//                Menu {
//                    ForEach(accounts, id: \.self) { account in
//                        Button(account) {
//                            selectedAccount = account
//                        }
//                    }
//                } label: {
//                    HStack {
//                        Text(selectedAccount.isEmpty ? "Select Account" : selectedAccount)
//                            .foregroundColor(selectedAccount.isEmpty ? .gray : .primary)
//                        Spacer()
//                        Image(systemName: "chevron.down")
//                            .foregroundColor(.gray)
//                    }
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(
//                        RoundedRectangle(cornerRadius: 8)
//                            .stroke(Color.gray.opacity(0.5))
//                    )
//                }
//
//                TextField("Amount", text: $amount)
//                    .keyboardType(.decimalPad)
//                    .padding()
//                    .background(
//                        RoundedRectangle(cornerRadius: 8)
//                            .stroke(Color.gray.opacity(0.5))
//                    )
//            }
//            .padding(.horizontal)
//
//            // Continue button
//            Button(action: {
//                // Action on continue
//            }) {
//                Text("Continue")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(6)
//            }
//            .padding(.horizontal)
//            .padding(.top, 20)
//
//            Spacer()
//        }
//        .padding(.bottom)
//    }
//}
//
//struct DepositView_Previews: PreviewProvider {
//    static var previews: some View {
//        DepositView()
//    }
//}
