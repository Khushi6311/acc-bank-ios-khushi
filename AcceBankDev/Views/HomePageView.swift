import SwiftUI

struct HomePageView: View {
    var username: String

    @State private var bankAccounts: [BankAccount] = []
    @State private var selectedAccount: BankAccount?
    let cardImages = ["Card", "Card2", "Card3"]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.colorTeal, Color.colorBlue]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    HeaderView()
                        .zIndex(1)
                        .frame(height: 25)
                        .background(Color.white)

                    Spacer().frame(height: 60)

                    Image("profilePic")
                        .resizable()
                        .frame(width: geometry.size.width * 0.18, height: geometry.size.width * 0.18)
                        .clipShape(Circle())
                        .padding(.top, -geometry.size.height * 0.05)

                    VStack(spacing: 1) {
                        Text(String(format: NSLocalizedString("welcome_text", comment: ""), username))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)

                        Text(NSLocalizedString("bank_name", comment: ""))
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)

                        Text(getGreeting())
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 20)

                    HStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.55)
                            .overlay(
                                VStack(spacing: 15) {
                                    accountTabsView
                                    accountCardView
                                }
                            )
                    }
                    .padding(.top, 20)
                    .animation(.easeInOut(duration: 0.3), value: selectedAccount)

                    Spacer()
                }
            }
            .onAppear {
                fetchAccounts()
            }
        }
    }

    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return NSLocalizedString("greeting_text", comment: "")
        case 12..<17: return NSLocalizedString("good_afternoon", comment: "")
        default: return NSLocalizedString("good_evening", comment: "")
        }
    }

    func fetchAccounts() {
        guard let contactId = TokenManager.shared.getContactId() else {
            print("No Contact ID found in TokenManager")
            return
        }

        guard let token = TokenManager.shared.getToken() else {
            print("No auth token found in TokenManager")
            return
        }

        let urlString = AppConfig.GetAccountsURL(for: contactId)

        guard let url = URL(string: urlString) else {
            print("Invalid API URL: \(urlString)")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        print("Sending GET Request:")
           print("URL: \(url.absoluteString)")
           print("Method: \(request.httpMethod ?? "")")
           print("Headers:")
           request.allHTTPHeaderFields?.forEach { key, value in
               print("   \(key): \(value)")
           }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("API error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                print("Server error or no data")
                return
            }

            do {
                // Print the raw JSON for debugging
                if let raw = String(data: data, encoding: .utf8) {
                    print("\nRaw API Response:\n\(raw)")
                }

                //  Try decoding
                let response = try JSONDecoder().decode(BankAccountAPIResponse.self, from: data)
                let accounts = response.data
                DispatchQueue.main.async {
                    self.bankAccounts = accounts
                    self.selectedAccount = accounts.first
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }


    // MARK: - ViewBuilder Subviews

    var accountTabsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(bankAccounts) { account in
                    AccountListView(
                        icon: "banknote.fill",
                        title: account.accountType,
                        //title: account.accountCategoryName,

                        number: "(\(account.accountNumber))",
                        amount: account.balance,
                        //amount: "$ \(String(format: "%.2f", account.balance))",

                        isSelected: selectedAccount?.id == account.id
                    )
                    .onTapGesture {
                        withAnimation {
                            selectedAccount = account
                        }
                    }

                    Divider()
                        .frame(width: 1, height: 40)
                        .background(Color.black.opacity(0.5))
                }
            }
            .padding(.horizontal, 20)
            .frame(minWidth: 700)
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .padding(.top, -50)
    }

    @ViewBuilder
    var accountCardView: some View {
        if selectedAccount?.accountType == "Spending (Chequing)" {
        //if selectedAccount?.accountCategoryName.contains("Chequing") == true {

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(Array(cardImages.enumerated()), id: \.offset) { _, card in
                        CreditCardView(imageName: card)
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 190)
            .transition(.opacity)
            .padding(.bottom, 20)
        } else if selectedAccount?.accountType == "Savings" {
            if cardImages.indices.contains(1) {
                CreditCardView(imageName: cardImages[1])
                    .frame(height: 190)
                    .padding(.horizontal)
                    .transition(.opacity)
                    .padding(.bottom, 20)
            }
        } else {
            Spacer()
                .frame(height: 190)
                .padding(.bottom, 20)
        }
    }
}
struct BankAccountAPIResponse: Codable {
    let status: String
    let data: [BankAccount]
    let statusCode: Int
}

// MARK: - Credit Card View
struct CreditCardView: View {
    var imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 350, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

// MARK: - Account Model


// MARK: - Placeholder Account View
struct AccountListView: View {
    var icon: String
    var title: String
    var number: String
    var amount: String
    var isSelected: Bool
    
    //for different icons 
    var resolvedIcon: String {
        switch title.lowercased() {
        case let text where text.contains("loan"):
            return "dollarsign.circle"
        case let text where text.contains("mortgage"):
            return "house.fill"
        case let text where text.contains("savings"):
            return "banknote.fill"
        case let text where text.contains("chequing"):
            return "wallet.pass"
        case let text where text.contains("term deposit"):
            return "clock.arrow.circlepath" // Or "calendar" if better fit
        default:
            return icon
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            // Top Icon with checkmark overlay
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 50, height: 50)

                    .overlay(
                                            //Image(systemName: icon)
                        Image(systemName: resolvedIcon)

                                                .font(.system(size: 22))
                                                .foregroundColor(.black)
                                        )
                    .overlay( // Add border here
                                Circle()
                                    .stroke(Color.gray, lineWidth: 1)
                            )

                if isSelected {
                    ZStack {
                        Circle()
                            .fill(Color.colorBlue)
                            .frame(width: 18, height: 18)
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 10, weight: .bold))
                    }
                    .offset(x: 10, y: -20)
                }
            }

            // Account title and number
            Text("\(title) \(number)")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)

            // Balance
            Text(amount)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
        .padding(.vertical)
        .frame(width: 140)
    }
}


// MARK: - Placeholder Header View
struct AccountHeaderView: View {
    var body: some View {
        Text("Header")
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
    }
}

// MARK: - Preview
struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(username: "Danielle")
    }
}
