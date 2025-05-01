import SwiftUI

struct HomePageView: View {
    var username: String

    @State private var bankAccounts: [BankAccount] = []
    @State private var selectedAccount: BankAccount?
    //let cardImages = ["Card", "Card2", "Card3"]
//    var cardImages: [String] {
//        switch username.lowercased() {
//        case "sarahmckenzie":
//            return ["SarahCard1"]
//        case "michaelthompson":
//            return ["MichaelCard1", "MichaelCard2"]
//        default:
//            return ["Card", "Card2", "Card3"]
//        }
//    }
    var cardImages: [String] {
        let userImageMap: [String: [String]] = [
            "michaelthompson": ["MichaelCard1", "MichaelCard2"],
            "sarahmckenzie": ["SarahCard1", "SarahCard2"],
            "emilyfraser": ["EmilyCard1", "EmilyCard2"],
            "johnathanbrooks": ["JonathanCard1", "JonathanCard2"],
            "haanahleblanc": ["HaanahCard1", "HaanahCard2"],
            "danielrobertson": ["DanielCard1", "DanielCard2"],
            "matthewoconnor": ["MatthewCard1", "MatthewCard2"],
            "rachelsinclair": ["RachelCard1", "RachelCard2"],
            "davidpelletier": ["DavidCard1", "DavidCard2"],
            "gracemacdonald": ["GraceCard1", "GraceCard2"]
        ]
        
        return userImageMap[username.lowercased()] ?? ["Card", "Card2", "Card3"]
    }



    @State private var showHistory = false
    @State private var selectedAccountForHistory: BankAccount? = nil
    @State private var isLoading = true
    var firstName: String = ""
    var lastName: String = ""

    var body: some View {
        NavigationView{
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
//                        
//                        Image("profilePic")
//                            .resizable()
//                            .frame(width: geometry.size.width * 0.18, height: geometry.size.width * 0.18)
//                            .clipShape(Circle())
//                            .padding(.top, -geometry.size.height * 0.05)
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: geometry.size.width * 0.18, height: geometry.size.width * 0.18)

                            Text(getInitials(firstName: TokenManager.shared.firstName, lastName: TokenManager.shared.lastName))
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.top, -geometry.size.height * 0.05)

                        
                        VStack(spacing: 1) {
//                            Text(String(format: NSLocalizedString("welcome_text", comment: ""), username))
//                            Text("Welcome \(TokenManager.shared.firstName) \(TokenManager.shared.lastName)")
                            Text(String(format: NSLocalizedString("welcome_text", comment: "Welcome message with user's name"), TokenManager.shared.firstName, TokenManager.shared.lastName))

                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)

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
//                            RoundedRectangle(cornerRadius: 20)
//                                .fill(Color.white)
//                                .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.55)
//                                .overlay(
//                                    VStack(spacing: 15) {
//                                        accountTabsView
//                                        accountCardView
//                                    }
//                                )
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.55)
                                .overlay(
                                    Group {
                                        if isLoading {
                                            VStack {
                                                Spacer()
                                                //ProgressView("Loading Accounts...")
                                                ProgressView(NSLocalizedString("loading_accounts", comment: "Shown while accounts are loading"))

                                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                                    .scaleEffect(1.2)
                                                    .padding()
                                                Spacer()
                                            }
                                        } else {
                                            VStack(spacing: 15) {
                                                accountTabsView
                                                accountCardView
                                            }
                                        }
                                    }
                                )

                        }
                        .padding(.top, 20)
                        .animation(.easeInOut(duration: 0.3), value: selectedAccount)
                        
                        NavigationLink(
                            destination: HistoryView(account: selectedAccountForHistory),
                            isActive: $showHistory
                        ) {
                            EmptyView()
                        }
                        .hidden()
                        
                        Spacer()
                    }
                }
                .onAppear {
                    fetchAccounts()
                }
            }
        }
    }
    func getInitials(firstName: String, lastName: String) -> String {
        let firstInitial = firstName.first.map { String($0).uppercased() } ?? ""
        let lastInitial = lastName.first.map { String($0).uppercased() } ?? ""
        return firstInitial + lastInitial
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
                
                //store
//                if let encoded = try? JSONEncoder().encode(accounts) {
//                    KeychainHelper.save(data: encoded, forKey: "bankAccounts")
//                    print("Stored bank accounts in Keychain under key: 'bankAccounts'")
//                     //  }
//                }
                DispatchQueue.main.async {
                    self.bankAccounts = accounts
                    self.selectedAccount = accounts.first
                    self.isLoading = false 
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }

  

    struct KeychainHelper {
        static func save(data: Data, forKey key: String) {
            let query: [String: Any] = [
                kSecClass as String:            kSecClassGenericPassword,
                kSecAttrAccount as String:      key,
                kSecValueData as String:        data,
                kSecAttrAccessible as String:   kSecAttrAccessibleWhenUnlocked
            ]

            SecItemDelete(query as CFDictionary) // Delete existing
            SecItemAdd(query as CFDictionary, nil)
        }

        static func load(forKey key: String) -> Data? {
            let query: [String: Any] = [
                kSecClass as String:            kSecClassGenericPassword,
                kSecAttrAccount as String:      key,
                kSecReturnData as String:       true,
                kSecMatchLimit as String:       kSecMatchLimitOne
            ]

            var dataTypeRef: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

            if status == errSecSuccess {
                return dataTypeRef as? Data
            }
            return nil
        }
    }

    // MARK: - ViewBuilder Subviews

    var accountTabsView: some View {
        ScrollView(.horizontal, showsIndicators: false){
            //VStack(spacing:100){
                HStack(spacing: 10) {
                    ForEach(bankAccounts) { account in
                        AccountListView(
                            icon: "banknote.fill",
                            title: account.accountType,
                            //title: account.accountCategoryName,
                            
                            number: "(\(account.accountNumber))",
                            amount: account.balance,
                            //amount: "$ \(String(format: "%.2f", account.balance))",
                            
                            isSelected: selectedAccount?.id == account.id,
                            onViewDetails: {
                                selectedAccountForHistory = account
                                showHistory = true
                            }
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
            //}
            .padding(.horizontal, 20)
            //.frame(minWidth: 700)
        }
        
      
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        //.padding(.top, -50)
        //.zIndex(1)
        
        
    }

    @ViewBuilder
    var accountCardView: some View {
        //if selectedAccount?.accountType == "Spending (Chequing)" {
        //if selectedAccount?.accountCategoryName.contains("Chequing") == true {
        if selectedAccount?.accountType == NSLocalizedString("account_type_chequing", comment: "") {

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
        //} else if selectedAccount?.accountType == "Savings" {
        } else if selectedAccount?.accountType == NSLocalizedString("account_type_savings", comment: "") {

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
    var onViewDetails: () -> Void
    //for different icons
    
    //code without  chnage for languag
//    var resolvedIcon: String {
//        switch title.lowercased() {
//        case let text where text.contains("loan"):
//            return "dollarsign.circle"
//        case let text where text.contains("mortgage"):
//            return "house.fill"
//        case let text where text.contains("savings"):
//            return "banknote.fill"
//        case let text where text.contains("chequing"):
//            return "wallet.pass"
//        case let text where text.contains("term deposit"):
//            return "clock.arrow.circlepath" // Or "calendar" if better fit
//        default:
//            return icon
//        }
//    }
    // Localized resolved icon logic
       var resolvedIcon: String {
           let lowerTitle = title.lowercased()

           if lowerTitle.contains(NSLocalizedString("account_type_loan", comment: "").lowercased()) {
               return "dollarsign.circle"
           } else if lowerTitle.contains(NSLocalizedString("account_type_mortgage", comment: "").lowercased()) {
               return "house.fill"
           } else if lowerTitle.contains(NSLocalizedString("account_type_savings", comment: "").lowercased()) {
               return "banknote.fill"
           } else if lowerTitle.contains(NSLocalizedString("account_type_chequing", comment: "").lowercased()) {
               return "wallet.pass"
           } else if lowerTitle.contains(NSLocalizedString("account_type_term_deposit", comment: "").lowercased()) {
               return "clock.arrow.circlepath"
           }

           return icon // fallback
       }

    var localizedTitle: String {
        switch title.lowercased() {
        case let t where t.contains("chequing"):
            return NSLocalizedString("account_type_chequing", comment: "")
        case let t where t.contains("loan"):
            return NSLocalizedString("account_type_loan", comment: "")
        case let t where t.contains("savings"):
            return NSLocalizedString("account_type_savings", comment: "")
        case let t where t.contains("mortgage"):
            return NSLocalizedString("account_type_mortgage", comment: "")
        case let t where t.contains("term deposit"):
            return NSLocalizedString("account_type_term_deposit", comment: "")
        default:
            return title // fallback to API title if no match
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
            //Text("\(title) \(number)")
            Text("\(localizedTitle) \(number)")

                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)

            // Balance
            Text(amount)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Button(action: {
                onViewDetails()

                            print("View Details tapped for \(title)")
                            // Add your navigation or action here
                        }) {
                            //Text("View Details")
                            Text(NSLocalizedString("view_details", comment: ""))

                                .font(.caption)
                                .foregroundColor(Color.colorBlue)
                                .underline()
                        }
                        .padding(.bottom, 20)
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
