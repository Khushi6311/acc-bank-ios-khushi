import SwiftUI

struct AccountListScreen: View {
    @ObservedObject var accountManager = AccountManager()
    @State private var showAddAccountSheet = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {

                // Back Arrow and Title
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                            .font(.title2)
                    }

                    //Text("My Accounts")
                    Text(NSLocalizedString("My_Accounts_Title", comment: "Title for the user's accounts screen"))

                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // Add Account Button
                Button(action: {
                    showAddAccountSheet = true
                }) {
                    HStack {
                        Spacer()
                        HStack(spacing: 6) {
                            Image(systemName: "plus.circle.fill")
                            //Text("Add Account")
                            Text(NSLocalizedString("Add_Account_Button", comment: "Button to add account"))

                                .font(.headline)
                        }
                        .foregroundColor(.black)
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.1), radius: 1, x: 0, y: 1)
                    .padding(.horizontal)
                }

                // Scrollable Account List
                ScrollView {
                    if accountManager.accounts.isEmpty {
                        //Text("No accounts found.")
//                        Text(NSLocalizedString("No_Accounts_Found", comment: "Empty state message"))
//
//                            .foregroundColor(.gray)
//                            .padding()
                        VStack(spacing: 12) {
                            Spacer()
        //                    Image(systemName: "tray")
        //                        .resizable()
        //                        .frame(width: 50, height: 50)
        //                        .foregroundColor(.gray.opacity(0.4))
                            //Text("No payees found.")
                            Text(NSLocalizedString("No_Accounts_Found", comment: "Empty state message"))

                                .foregroundColor(.gray)
                                .font(.body)
                                .padding(.top,250)
                            Spacer()
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        
                        ForEach(accountManager.accounts, id: \.id) { account in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(account.accountName)
                                        .font(.headline)
                                        .foregroundColor(.black)

                                    if let type = getAccountTypeDisplayName(for: account.accountType) {
                                        Text(type)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }

                                    Text(account.accountNumber)
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                Text(account.balance)
                                    .font(.headline)
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                            .shadow(color: .gray.opacity(0.1), radius: 1, x: 0, y: 1)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
            
            .sheet(isPresented: $showAddAccountSheet, onDismiss: {
                accountManager.fetchAccounts()
            }) {
                AddAccountFormView(accountManager: accountManager)
            }
            .onAppear {
                accountManager.fetchAccounts()
            }
        }
    }

    private func getAccountTypeDisplayName(for typeId: String) -> String? {
        switch typeId {
        case "1": return "Spending (Chequing)"
        case "2": return "Savings"
        case "3": return "Loan"
        default: return nil
        }
    }
}

#if DEBUG
struct AccountListScreen_Previews: PreviewProvider {
    static var previews: some View {
        let mockManager = AccountManager()
        mockManager.accounts = [
            BankAccount(accountId: "1", accountName: "Checking", accountType: "1", accountNumber: "1234567890", balance: "$1,200.00"),
            BankAccount(accountId: "2", accountName: "Savings", accountType: "2", accountNumber: "9876543210", balance: "$5,000.00")
        ]
        return AccountListScreen(accountManager: mockManager)
    }
}
#endif


//#if DEBUG
//struct AccountListScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        let emptyManager = AccountManager()
//        emptyManager.accounts = [] // Empty list to simulate no accounts
//
//        return AccountListScreen(accountManager: emptyManager)
//            .previewDisplayName("No Accounts Found State")
//    }
//}
//#endif
