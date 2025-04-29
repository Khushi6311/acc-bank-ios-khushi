import SwiftUI
import Foundation

enum FieldFocus: Hashable {
    case amount
    case date
    case memo
}


struct TransferMoneyScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedPaymentType: String? = "My accounts"

    // Shared States.
    @State private var selectedFromAccount: BankAccount?
    @State private var selectedToAccount: BankAccount?
    @State private var selectedContact: Contact?
    @State private var isTransferFromSheetPresented = false
    @State private var isSendToSheetPresented = false
    @State private var isContactSheetPresented = false
    @State private var showDatePicker = false
    @State private var recurring = false
    @State private var selectedFrequency = "Weekly"
    @State private var amount = ""
    @State private var memo = ""

    @State private var dateText: String? = nil
    @State private var showAmountError = false
    @State private var showTransferToError = false
    @State private var showTransferFromError = false

    
    @State private var showMemoError = false
    @State private var showInsufficientFundsError = false
    
  @State private var isSelectingStartDate = true // Track which field is being edited
    @State private var isSelectingEndDate = true // Track which field is being edited
    @State private var startDate = Date()
 
   @State private var endDate = Date()
   @State private var startDateText: String? = nil
   @State private var endDateText: String? = nil
    @State private var showContactSheet = false // Show Contact Selection Sheet
    @State private var showConfirmationSheet = false // Add this state variable
    @State private var isAnotherMemberSelected: Bool = false
    @State private var confirmedFromAccount: BankAccount?
    @State private var confirmedToAccount: BankAccount?
    @State private var showDateError: Bool = false
    @State private var showRecurringDateError: Bool = false
    
    @FocusState private var focusedField: FieldFocus?
    @State private var transactionId: String = ""

    @State private var bankAccounts: [BankAccount] = []
    @StateObject private var contactManager = ContactManager() // Declare here one time
    var body: some View {
        //ScrollView {
            VStack (spacing: 0){
                // **Navigation Bar**
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    //Text("Transfer Money")
                    Text(NSLocalizedString("transfer_money", comment: "Title for transfer money screen"))

                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding()

                // **Payment Type Selector**
                HStack(spacing: 0) {
//

                        HStack(spacing: 0) {
                            Button(action: { selectedPaymentType = "My accounts"
                                
                                isAnotherMemberSelected = false
                                selectedFromAccount = nil
                                 selectedToAccount = nil
                                selectedContact = nil
                                   amount = ""
                                   memo = ""
                                   dateText = nil
                                   startDateText = nil
                                   endDateText = nil
                                
                                showAmountError = false
                                showMemoError = false
                                showTransferToError = false
                                showDateError = false
                                showRecurringDateError = false
                                showInsufficientFundsError = false
                                showTransferFromError=false
                                
                                

}) {
                                //Text("My accounts")
    Text(NSLocalizedString("my_accounts", comment: "Title for 'My accounts' tab"))

        .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
//                                    .background(selectedPaymentType == "My accounts" ? Constants.backgroundGradient : Color.clear)
                                    .background(
                                        selectedPaymentType == "My accounts"
                                            ? AnyView(Constants.backgroundGradient)
                                            : AnyView(Color.clear)
                                    )

                                    .foregroundColor(selectedPaymentType == "My accounts" ? .white : .gray)
                                    .cornerRadius(30)
                            }

                            Button(action: { selectedPaymentType = "Another member"
                                isAnotherMemberSelected = true //  Set this
                                selectedFromAccount = nil
                                 selectedToAccount = nil
                                selectedContact = nil
                                   amount = ""
                                   memo = ""
                                   dateText = nil
                                   startDateText = nil
                                   endDateText = nil
                                
                                showAmountError = false
                                showMemoError = false
                                showTransferToError = false
                                showDateError = false
                                showRecurringDateError = false
                                showInsufficientFundsError = false
                                showTransferFromError=false
                                
                                

                                
}) {
                                //Text("Another member")
    Text(NSLocalizedString("another_member", comment: "Title for 'My accounts' tab"))

                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
//                                    .background(selectedPaymentType == "Another member" ? Constants.backgroundGradient : Color.clear)
                                    .background(
                                        selectedPaymentType == "Another member"
                                            ? Constants.backgroundGradient
                                            : LinearGradient(gradient: Gradient(colors: [Color.clear, Color.clear]),
                                                             startPoint: .leading,
                                                             endPoint: .trailing)
                                    )

                                    .foregroundColor(selectedPaymentType == "Another member" ? .white : .gray)
                                    .cornerRadius(30)
                            }
                        }
                        .cornerRadius(30)
                    //}
                }
                .padding(1)

                .background(Color(.systemGray5)) // this brings back the soft gray pill background
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.horizontal)
                Spacer().frame(height: 20)//space bet button and form

                // **Dynamic Form Based on Selected Payment Type**
                ScrollView{//scrrolview and vstack add to remove button scroll 
                    VStack{
                    if selectedPaymentType == "My accounts"
                        {
                        
                        MyAccountsTransferForm(
                            allAccounts: $bankAccounts,
                            selectedFromAccount: $selectedFromAccount,
                            selectedToAccount: $selectedToAccount,
                            isTransferFromSheetPresented: $isTransferFromSheetPresented,
                            isSendToSheetPresented: $isSendToSheetPresented,
                            showDatePicker: $showDatePicker,
                            recurring: $recurring,
                            selectedFrequency: $selectedFrequency,
                            amount: $amount,
                            memo: $memo,
                            dateText: $dateText,
                            showAmountError: $showAmountError,
                            showDateError:$showDateError,
                            showRecurringDateError:$showRecurringDateError,
                            showTransferToError: $showTransferToError,
                            showTransferFromError:$showTransferFromError,
                            showMemoError: $showMemoError,
                            showInsufficientFundsError: $showInsufficientFundsError,
                            isSelectingStartDate: $isSelectingStartDate,
                            isSelectingEndDate: $isSelectingEndDate,
                            startDate: $startDate,
                            endDate: $endDate,
                            startDateText: $startDateText,
                            endDateText: $endDateText,
                            isAnotherMemberSelected: $isAnotherMemberSelected,
                            //isAnotherMemberSelected: $showConfirmationSheet, // new
                            selectedContact: $selectedContact,             // new
                            //showConfirmationSheet: $isAnotherMemberSelected
                            showConfirmationSheet: $showConfirmationSheet, transactionId: $transactionId
                            
                            
                        )
                        
                        
                    } else if selectedPaymentType == "Another member" {
                        AnotherMemberTransferForm(
                            allAccounts: $bankAccounts,
                            selectedFromAccount: $selectedFromAccount,
                            selectedContact: $selectedContact,
                            isTransferFromSheetPresented: $isTransferFromSheetPresented,
                            showContactSheet: $showContactSheet,
                            showDatePicker: $showDatePicker,
                            recurring: $recurring,
                            selectedFrequency: $selectedFrequency,
                            amount: $amount,
                            memo: $memo,
                            dateText: $dateText,
                            showAmountError: $showAmountError,
                            showTransferToError: $showTransferToError,
                            
                            showRecurringDateError:$showRecurringDateError,
                            showDateError:$showDateError, showTransferFromError: $showTransferFromError,
                            showMemoError: $showMemoError,
                            showInsufficientFundsError: $showInsufficientFundsError,
                            isSelectingStartDate: $isSelectingStartDate,
                            isSelectingEndDate: $isSelectingEndDate,
                            startDate: $startDate,
                            endDate: $endDate,
                            startDateText: $startDateText,
                            endDateText: $endDateText,
                            isContactSheetPresented: $isContactSheetPresented,
                            showConfirmationSheet: $showConfirmationSheet,
                            isAnotherMemberSelected: $isAnotherMemberSelected, transactionId:$transactionId,
                            contactManager: contactManager
                            
                        )
                    }
                    
                }
                }
            }
            .padding(.horizontal, 10)
            .onAppear {
                fetchAccounts()
            }
        //}
            

    }

    
    
    func fetchAccounts() {
        guard let contactId = TokenManager.shared.getContactId() else {
            print("No Contact ID")
            return
        }

        guard let token = TokenManager.shared.getToken() else {
            print("No Auth Token")
            return
        }

        let urlString = AppConfig.GetAccountsURL(for: contactId)

        guard let url = URL(string: urlString) else {
            print("Invalid API URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("API Error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                print("invalid Response or Empty Data")
                return
            }

            do {
                let decoded = try JSONDecoder().decode(BankAccountAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    self.bankAccounts = decoded.data
                    print("Loaded \(decoded.data.count) accounts")
                    
                    for account in decoded.data {
                        print("""
                              -------------------------------
                              Account Name: \(account.accountName)
                              Type: \(account.accountType)
                              Number: \(account.accountNumber)
                              Balance: \(account.balance)
                              ID: \(account.accountId)
                              -------------------------------
                              """)
                    }
                }
            } catch {
                print("JSON Decoding Error: \(error)")
            }
        }.resume()
    }

        
}
   
func sendTransferAPI(
        fromAccount: BankAccount?,
        toAccount: BankAccount?,
        selectedContact: Contact?,
        amount: String,
        memo: String,
        isRecurring: Bool,
        startDate: Date?,
        endDate: Date?,
        selectedFrequency: String?,
        isAnotherMemberSelected: Bool,
        completion: @escaping (String?) -> Void
    ) {
        guard let from = fromAccount else {
            print("Missing from account")
            return
        }

        // Safely extract `toId` based on transfer type
//        guard let toId = isAnotherMemberSelected
//            ? selectedContact?.id.uuidString // Use .id here
//            : toAccount?.accountId else {
        guard let toId = isAnotherMemberSelected
            ? selectedContact?.id
            : toAccount?.accountId else {

            print("Missing to account or contact")
            return
        }


        let fromId = from.accountId

        // Clean the entered amount string
        let cleanAmount = Double(
            amount
                .replacingOccurrences(of: "$", with: "")
                .replacingOccurrences(of: ",", with: "")
                .trimmingCharacters(in: .whitespaces)
        ) ?? 0.0

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        // Create request body
        var requestBody: [String: Any] = [
            "Note": memo,
            "IsSelfTransfer": true,
            "AccountNumberFrom": fromId,
            "AccountNumberTo": toId,
            "Amount": cleanAmount,
            "Currency": "CAD",
            "TransactionType": "Fund Transfer" 
        ]

        if isRecurring {
            if let start = startDate, let end = endDate, let frequency = selectedFrequency {
                requestBody["StartDate"] = dateFormatter.string(from: start)
                requestBody["EndDate"] = dateFormatter.string(from: end)
                requestBody["Frequency"] = frequency.capitalized
            }
        } else {
            if let start = startDate {
                requestBody["StartDate"] = dateFormatter.string(from: start)
            }
        }

        // Prepare URL and headers
        guard let url = URL(string:AppConfig.TransferMoneyURL),
              let token = TokenManager.shared.getToken() else {
            print("Invalid URL or missing token")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = jsonData

            print("Transfer API Request:")
            print(String(data: jsonData, encoding: .utf8) ?? "")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("API Error: \(error.localizedDescription)")
                    return
                }

                if let response = response as? HTTPURLResponse {
                    print("Response Code: \(response.statusCode)")
                }

                if let data = data, let body = String(data: data, encoding: .utf8) {
                    print("Response Body:\n\(body)")
                }
                if let data = data {
                               do {
                                   let decodedResponse = try JSONDecoder().decode(TransferResponse.self, from: data)
                                   if decodedResponse.status == "Success" {
                                                   DispatchQueue.main.async {
                                                       completion(decodedResponse.data.transactionNumber)

                                                      /* completion(decodedResponse.data.transactionId) */ // send TransactionId back!
                                                   }
                                   } else {
                                       print("Transfer failed with status: \(decodedResponse.status)")
                                   }
                               } catch {
                                   print("JSON Decoding Error: \(error)")
                               }
                           }
            }.resume()

        } catch {
            print("JSON Encoding Error: \(error.localizedDescription)")
        }
    }
let minimumDate: Date = {
    var components = DateComponents()
    components.year = 2025
    components.month = 4
    components.day = 11
    return Calendar.current.date(from: components)!
}()

struct DateDefaults {
    static let minimumDate: Date = {
        return Calendar.current.startOfDay(for: Date()) // today's date automatically
    }()

//    static let minimumDate: Date = {
//            var components = DateComponents()
//            components.year = 2025
//            components.month = 4
//            components.day = 11
//            return Calendar.current.date(from: components)!
//        }()
    
    static func endDateRange(from start: Date) -> ClosedRange<Date> {
        let validStart = max(start, minimumDate)
        let maxEnd = Calendar.current.date(byAdding: .year, value: 2, to: validStart)!
        return validStart...maxEnd
    }


    static func startDateRange() -> ClosedRange<Date> {
        return minimumDate...Date.distantFuture
    }

    static func initializeDefaultDates(
        isRecurring: Bool,
        dateText: inout String?,
        startDateText: inout String?,
        endDateText: inout String?,
        startDate: inout Date,
        endDate: inout Date
    ) {
        let today = Date()
        
        if !isRecurring {
            if dateText == nil || dateText?.isEmpty == true {
                startDate = today
                dateText = formatDate(today)
                print("One-time default date set to: \(dateText ?? "nil")")
            }
        } else {
            if startDateText == nil || startDateText?.isEmpty == true {
                startDate = today
                startDateText = formatDate(today)
                print("Recurring start date set to: \(startDateText ?? "nil")")
            }

//            if endDateText == nil || endDateText?.isEmpty == true {
//                endDate = Calendar.current.date(byAdding: .month, value: 1, to: today) ?? today
//                endDateText = formatDate(endDate)
//                print("Recurring end date set to: \(endDateText ?? "nil")")
//            }
        }
    }

    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}


struct MyAccountsTransferForm: View {
    
    @Binding var allAccounts: [BankAccount]

    @Binding var selectedFromAccount: BankAccount?
    @Binding var selectedToAccount: BankAccount?
    @Binding var isTransferFromSheetPresented: Bool
    @Binding var isSendToSheetPresented: Bool
    @Binding var showDatePicker: Bool
    @Binding var recurring: Bool
    @Binding var selectedFrequency: String
    @Binding var amount: String
    @Binding var memo: String
    @Binding var dateText: String?
    @Binding var showAmountError: Bool
    @Binding var showDateError: Bool
    @Binding var showRecurringDateError: Bool
    @Binding var showTransferToError: Bool
    @Binding var showTransferFromError: Bool

    @Binding var showMemoError: Bool
    @Binding var showInsufficientFundsError: Bool
    @Binding var isSelectingStartDate: Bool
    @Binding var isSelectingEndDate: Bool
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var startDateText: String?
    @Binding var endDateText: String?
    @FocusState private var focusedField: FieldFocus?
    @Binding var isAnotherMemberSelected: Bool           // Add this
    @Binding var selectedContact: Contact?                // Add this
    @Binding var showConfirmationSheet: Bool
    //@StateObject private var accountManager = AccountManager()
    @State private var transferToSheetKey = UUID()
    @Binding var transactionId: String
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                
                VStack(spacing: 15) {
                    // Error message for insufficient funds
                    // Only show red error if transfer from account is selected properly
//                  if showInsufficientFundsError {
//                    ErrorMessageView(text: NSLocalizedString("error_transaction_limit", comment: ""))
//                }

                    if showInsufficientFundsError && selectedFromAccount != nil {
                        ErrorMessageView(text: NSLocalizedString("error_transaction_limit", comment: ""))
                    }

                    Text(NSLocalizedString("transfer_from", comment: ""))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    // **Transfer From Account Selection**
                    //            AccountSelectionButton(title: "Transfer From", account: $selectedFromAccount)
//                    AccountSelectionButton(title: NSLocalizedString("transfer_from", comment: ""), account: $selectedFromAccount){
//
//                        isTransferFromSheetPresented.toggle()
//                        showTransferFromError = false
//
//                    }
                    AccountSelectionButton(title: NSLocalizedString("transfer_from", comment: ""), account: $selectedFromAccount) {
                        if allAccounts.isEmpty {
                            print("Accounts still loading... Try again in a moment.")
                            return
                        }
                        isTransferFromSheetPresented = true
                        showTransferFromError = false
                        showInsufficientFundsError = false
                    }

                    //            .sheet(isPresented: $isTransferFromSheetPresented) {
                    //                TransferAccountSheet(selectedAccount_from: $selectedFromAccount)
                    //            }
                    .sheet(isPresented: $isTransferFromSheetPresented) {
                        TransferAccountSheet(
                            //accountManager: accountManager,  // Add this
                            allAccounts: allAccounts,
                            selectedAccount_from: $selectedFromAccount,
                            isPresented: $isTransferFromSheetPresented  // Add this
                        )
                    }
                    .id(allAccounts.count)
                    if showTransferFromError {
                        //ErrorMessage(text: "This field is required")
                        ErrorMessage(text: NSLocalizedString("error_required_transfer_from_field", comment: "Validation error for empty field"))
                        
                    }
                    Text(NSLocalizedString("transfer_to", comment: ""))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    // **Transfer To Account Selection**
                    //            AccountSelectionButton(title: "Transfer To", account: $selectedToAccount)
                    AccountSelectionButton(title: NSLocalizedString("transfer_to", comment: ""), account: $selectedToAccount)
                    {
                        isSendToSheetPresented.toggle()
                        showTransferToError = false
                    }

            


                                .sheet(isPresented: $isSendToSheetPresented) {
                                    SendToSheet(
                                        //accountManager_to: accountManager,  // Add this
                                        allAccounts: allAccounts,
                                        selectedAccount_to: $selectedToAccount,
                                        isPresented_to: $isSendToSheetPresented, // Add this
                                        excludeAccount: $selectedFromAccount // pass the selected from account
                    
                                    )
                                    //.id(selectedFromAccount?.id ?? "default")
                                    .id(selectedFromAccount?.id ?? UUID())

                                    
                                }
                 
                    
                    if showTransferToError {
                        //ErrorMessage(text: "This field is required")
                        ErrorMessage(text: NSLocalizedString("error_required_transfer_to_field", comment: "Validation error for empty field"))
                        
                    }
                    
                    // **One-Time or Recurring Toggle**
                    HStack(spacing: 20) {
                        VStack {
                            Toggle(NSLocalizedString("one_time_payment", comment: ""), isOn: Binding(
                                get: { !recurring },
                                set: { newValue in
                                    recurring = !newValue
                                    
                                    showAmountError = false
                                    showMemoError = false
                                    showTransferToError = false
                                    showDateError = false
                                    showRecurringDateError = false
                                    showInsufficientFundsError = false
                                    
//                                    let today = Date()
//                                            startDate = today
//                                            startDateText = formatDate(today)
                                }
                            ))
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                            .scaleEffect(0.8)
                            .lineLimit(1)
                            .padding(.horizontal, 10)
                        }
                        .frame(width: 160, height: 60)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        
                        VStack {
                            Toggle(NSLocalizedString("recurring_payment", comment: ""), isOn: Binding(
                                get: { recurring },
                                set: { newValue in
                                    recurring = newValue
                                    showAmountError = false
                                    showMemoError = false
                                    showTransferToError = false
                                    showDateError = false
                                    showRecurringDateError = false
                                    showInsufficientFundsError = false
//                                    
//                                    let today = Date()
//                                            startDate = today
//                                            startDateText = formatDate(today)
                                }
                            ))
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                            .scaleEffect(0.8)
                            .lineLimit(1)
                            .padding(.horizontal, 10)
                        }
                        .frame(width: 160, height: 60)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 10)
                    
                    // **Recurring Payment Frequency Selection**
                    if recurring {
                        VStack {
                            //Text("Select Frequency")
                            Text(NSLocalizedString("select_frequency", comment: ""))
                            
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 5)
                            
                            //                    Picker("Frequency", selection: $selectedFrequency) {
                            //                        Text("Weekly").tag("Weekly")
                            //                        Text("Monthly").tag("Monthly")
                            //                        Text("Yearly").tag("Yearly")
                            //                    }
                            Picker(NSLocalizedString("frequency", comment: "Frequency picker label"), selection: $selectedFrequency) {
                                Text(NSLocalizedString("weekly", comment: "Frequency option")).tag("weekly")
                                Text(NSLocalizedString("monthly", comment: "Frequency option")).tag("monthly")
                                Text(NSLocalizedString("yearly", comment: "Frequency option")).tag("yearly")
                            }
                            
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                        }
                        .transition(.opacity)
                    }
                    
                    
                    // **Amount Input**
                    //            TextField("Enter Transfer Amount", text: $amount)
                    TextField(NSLocalizedString("enter_transfer_amount", comment: "Placeholder for transfer amount input"), text: $amount)
                    
                        //.keyboardType(.decimalPad)
                        .keyboardType(.numbersAndPunctuation)
                          .submitLabel(.done)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    //.focused($focusedField, equals: .amount)
                        .focused($focusedField, equals: .amount)
                        .onTapGesture {
                            focusedField = nil
                        }
                    
                        .onChange(of: amount) {oldValue, newValue in
                            amount = CurrencyFormatter.format(newValue)
                            
                            if !newValue.trimmingCharacters(in: .whitespaces).isEmpty {
                                showAmountError = false // Hide error as soon as user types
                            }
                            
                            //                    if !newValue.trimmingCharacters(in: .whitespaces).isEmpty {
                            //                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            //                                    focusedField = .date
                            //                                }
                            //                            }
                        }
                    
                    if showAmountError {
                        //ErrorMessage(text: "This field is required")
                        ErrorMessage(text: NSLocalizedString("error_required_payee_amount_field", comment: "Validation error for empty field"))
                    }
                    
                    // **Date Selection**
                    if !recurring {
                        //                DateField(title: "Select Date", dateText: $dateText, action: { showDatePicker.toggle() })
                        DateField(
                            title: NSLocalizedString("select_date", comment: "Label for selecting a single date"),
                            dateText: $dateText,
                            action: {
                                UIApplication.shared.endEditing()//added for calender
                                
                                //showDatePicker.toggle()
                                showDatePicker = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation {
                                        proxy.scrollTo("calendarSection", anchor: .top)
                                    }
                                }
                                
                            }
                        )
                        
                        if showDateError {
                            //                    ErrorMessage(text: "This field is required")
                            ErrorMessage(text: NSLocalizedString("error_required_end_date_field", comment: "Validation error for empty field"))
                        }
                        
                    }
                    
                    if recurring {
                        VStack {
                            //                    DateField(title: "Start Date", dateText: $startDateText, action: {
                            //                        isSelectingStartDate = true
                            //                        isSelectingEndDate = false
                            //                        showDatePicker.toggle()
                            //
                            //
                            //                    })
                            DateField(
                                title: NSLocalizedString("start_date", comment: "Label for selecting the start date"),
                                dateText: $startDateText,
                                action: {
                                    isSelectingStartDate = true
                                    isSelectingEndDate = false
                                    //showDatePicker.toggle()
                                    showDatePicker = true
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        withAnimation {
                                            proxy.scrollTo("calendarSection", anchor: .top)
                                        }
                                    }
                                }
                            )
                            
                            
                            //                    DateField(title: "End Date", dateText: $endDateText, action: {
                            //                        isSelectingStartDate = false
                            //                        isSelectingEndDate = true
                            //                        showDatePicker.toggle()
                            //                    })
                            DateField(
                                title: NSLocalizedString("end_date", comment: "Label for selecting the end date"),
                                dateText: $endDateText,
                                action: {
                                    isSelectingStartDate = false
                                    isSelectingEndDate = true
                                    //showDatePicker.toggle()
                                    showDatePicker = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        withAnimation {
                                            proxy.scrollTo("calendarSection", anchor: .top)
                                        }
                                    }
                                }
                            )
                            
                            if showRecurringDateError {
                                //                        ErrorMessage(text: "This field is required")
                                ErrorMessage(text: NSLocalizedString("error_required_end_date_field", comment: "Validation error for empty field"))
                            }
                        }
                    }
                    
                    
                    
                    // **Date Picker Modal**
                    if showDatePicker {
                        Color.black.opacity(0.001)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                showDatePicker = false
                            }

                        VStack {
                            if !recurring {
                                DatePicker(
                                    "Select Date",
                                    selection: Binding(
                                        get: { startDate },
                                        set: { newValue in
                                            startDate = newValue
                                            dateText = DateDefaults.formatDate(newValue)
                                            showDateError = false
                                            showDatePicker = false
                                        }
                                    ),
                                    in: DateDefaults.startDateRange(),
                                    displayedComponents: .date
                                )
                                .datePickerStyle(GraphicalDatePickerStyle()) // apply here
                                .labelsHidden()
                            } else {
                                if isSelectingStartDate {
                                    DatePicker(
                                        "Start Date",
                                        selection: Binding(
                                            get: { startDate },
                                            set: { newValue in
                                                startDate = newValue
                                                startDateText = DateDefaults.formatDate(newValue)
                                                showRecurringDateError = false
                                                showDatePicker = false
                                            }
                                        ),
                                        in: DateDefaults.startDateRange(),
                                        displayedComponents: .date
                                    )
                                    .datePickerStyle(GraphicalDatePickerStyle()) //  apply here
                                    .labelsHidden()
                                }

                                if isSelectingEndDate {
                                    DatePicker(
                                        "End Date",
                                        selection: Binding(
                                            get: { endDate },
                                            set: { newValue in
                                                endDate = newValue
                                                endDateText = DateDefaults.formatDate(newValue)
                                                showRecurringDateError = false
                                                showDatePicker = false
                                            }
                                        ),
                                        in: DateDefaults.endDateRange(from: startDate),
                                        displayedComponents: .date
                                    )
                                    .datePickerStyle(GraphicalDatePickerStyle()) // apply here
                                    .labelsHidden()
                                }
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
                        .id("calendarSection")
                    }


                    // **Memo Field**
                    //TextField("Memo", text: $memo)
                    TextField(NSLocalizedString("memo", comment: "Placeholder for memo field"), text: $memo)
                    
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .onChange(of: memo) { oldValue,newValue in
                            if !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                showMemoError = false
                            }
                        }
                    if showMemoError {
                        // ErrorMessage(text: "This field is required")
                        ErrorMessage(text: NSLocalizedString("error_required_transfer_memo_field", comment: "Validation error for empty field"))
                    }
                    
                    Button(action: {
                        //validateFields()
                        showInsufficientFundsError = false

                        let result = TransferFormValidator.validate(
                            
                               selectedFromAccount: selectedFromAccount,
                               selectedToAccount: selectedToAccount,
                               amount: amount,
                               //memo: memo,
                               dateText: dateText,
                               startDateText: startDateText,
                               endDateText: endDateText,
                               recurring: recurring
                           )

                           showTransferFromError = result.showTransferFromError
                           showTransferToError = result.showTransferToError
                           showAmountError = result.showAmountError
                           //showMemoError = result.showMemoError
                           showDateError = result.showDateError
                           showRecurringDateError = result.showRecurringDateError
                           showInsufficientFundsError = result.showInsufficientFundsError
                           showConfirmationSheet = result.isFormValid
                    }) {
                        Text(NSLocalizedString("continue", comment: "Button label for continue"))
                            .font(.headline)
                            .frame(width: 330)
                            .padding()
                            .background(Constants.backgroundGradient)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)
                    .sheet(isPresented: $showConfirmationSheet) {
                        ConfirmationSheet(
                            fromAccount: $selectedFromAccount,
                            toAccount: $selectedToAccount,
                            amount: $amount,
                            dateText: $dateText,

                            memo: $memo,
                            isRecurring: $recurring,
                            //selectedFrequency: $selectedFrequency,
                            selectedFrequency: Binding(get: { selectedFrequency }, set: { selectedFrequency = $0! }), // Fix for optional binding
    //                        selectedFrequency: Binding(get: { selectedFrequency ?? "Weekly" }, set: { selectedFrequency = $0! })
                            startDateText: $startDateText,
                            endDateText: $endDateText,
                            isAnotherMemberSelected: $isAnotherMemberSelected,
                            transactionId: $transactionId, selectedContact: $selectedContact,
                            onConfirm: {
                                        sendTransferAPI(
                                            fromAccount: selectedFromAccount,
                                            toAccount: selectedToAccount,
                                            selectedContact: selectedContact,
                                            amount: amount,
                                            memo: memo,
                                            isRecurring: recurring,
                                            startDate: startDate,
                                            endDate: endDate,
                                            selectedFrequency: selectedFrequency,
                                            isAnotherMemberSelected: isAnotherMemberSelected
                                        ){ transactionId in
                                            if let transactionId = transactionId {
                                                self.transactionId = transactionId  // Save it
                                                //navigateToSummary = true
                                            } else {
                                                print("❌ Failed to get transactionId")
                                            }
                                        }
                                    }
                        )
    //
                    }


                }
                .padding()
                .onAppear {
                    var tempDateText = dateText
                    var tempStartDateText = startDateText
                    var tempEndDateText = endDateText
                    var tempStartDate = startDate
                    var tempEndDate = endDate

                    DateDefaults.initializeDefaultDates(
                        isRecurring: recurring,
                        dateText: &tempDateText,
                        startDateText: &tempStartDateText,
                        endDateText: &tempEndDateText,
                        startDate: &tempStartDate,
                        endDate: &tempEndDate
                    )

                    dateText = tempDateText
                    startDateText = tempStartDateText
                    endDateText = tempEndDateText
                    startDate = tempStartDate
                    endDate = tempEndDate
                }
                .onChange(of: recurring) { oldValue,_ in
                    var tempDateText = dateText
                    var tempStartDateText = startDateText
                    var tempEndDateText = endDateText
                    var tempStartDate = startDate
                    var tempEndDate = endDate

                    DateDefaults.initializeDefaultDates(
                        isRecurring: recurring,
                        dateText: &tempDateText,
                        startDateText: &tempStartDateText,
                        endDateText: &tempEndDateText,
                        startDate: &tempStartDate,
                        endDate: &tempEndDate
                    )

                    dateText = tempDateText
                    startDateText = tempStartDateText
                    endDateText = tempEndDateText
                    startDate = tempStartDate
                    endDate = tempEndDate
                }


//                .onAppear {
//                    let today = Date()
//
//                    if !recurring && (dateText == nil || dateText?.isEmpty == true) {
//                        startDate = today
//                        dateText = formatDate(today)
//                    }
//
//                    if recurring && (startDateText == nil || startDateText?.isEmpty == true) {
//                        startDate = today
//                        startDateText = formatDate(today)
//                    }
//                }

                
                
            }
        }
    }
}
//end

struct TransferFormValidator {
    static func validate(
        selectedFromAccount: BankAccount?,
        selectedToAccount: BankAccount?=nil,
        selectedContact: Contact? = nil, // <-- Add this line

        amount: String,
        //memo: String,
        dateText: String?,
        startDateText: String?,
        endDateText: String?,
        recurring: Bool
    ) -> (
        showTransferFromError: Bool,
        showTransferToError: Bool,
        showAmountError: Bool,
        //showMemoError: Bool,
        showDateError: Bool,
        showRecurringDateError: Bool,
        showInsufficientFundsError: Bool,
        isFormValid: Bool
    ) {
        let enteredAmount = Double(amount.replacingOccurrences(of: "$", with: "").trimmingCharacters(in: .whitespaces)) ?? 0.0
        let availableBalance = Double(selectedFromAccount?.balance.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "").trimmingCharacters(in: .whitespaces) ?? "0") ?? 0.0
        
        let showDateError = !recurring && (dateText?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let showRecurringDateError = recurring && ((startDateText?.isEmpty ?? true) || (endDateText?.isEmpty ?? true))
        let showTransferFromError = selectedFromAccount == nil
        //let showTransferToError = selectedToAccount == nil
        let showTransferToError = selectedToAccount == nil && selectedContact == nil

        let showAmountError = amount.trimmingCharacters(in: .whitespaces).isEmpty
        //let showMemoError = memo.trimmingCharacters(in: .whitespaces).isEmpty
        let showInsufficientFundsError = enteredAmount > availableBalance
        
        let isFormValid = !showTransferToError &&
                          !showAmountError &&
                          //!showMemoError &&
                          !showInsufficientFundsError &&
                          !showDateError &&
                          !showRecurringDateError &&
                          !showTransferFromError
        
        return (
            showTransferFromError,
            showTransferToError,
            showAmountError,
            //showMemoError,
            showDateError,
            showRecurringDateError,
            showInsufficientFundsError,
            isFormValid
        )
    }
}

struct CurrencyFormatter {
    static func format(_ input: String) -> String {
        let filtered = input.filter { "0123456789.".contains($0) }

        if filtered.isEmpty {
            return ""
        }

        let components = filtered.split(separator: ".")
        if components.count > 2 {
            return "$" + String(components[0]) + "." + String(components[1].prefix(2))
        }
        return "$" + filtered
    }
}

// **Reusable Date Field View**
struct DateField: View {
    var title: String
    @Binding var dateText: String?
    var action: () -> Void

    var body: some View {
        TextField(title, text: Binding(
            get: { dateText ?? "" },
            set: { _ in }
        ))
        .disabled(true)
        .padding()
        .frame(height: 50)
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
        .overlay(
            HStack {
                Spacer()
                Button(action: action) {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }
            }
        )
        .onTapGesture(perform: action)
    }
}

// **Reusable Error Message View**
struct ErrorMessage: View {
    var text: String
    var body: some View {
        Text(text)
            .foregroundColor(.red)
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 2)
    }
}



struct AccountSelectionButton: View {
    var title: String
    @Binding var account: BankAccount?
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(account?.accountName ?? title)
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)

                    Text(account?.accountType ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text(account?.accountNumber ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()

                Text(account?.balance ?? "")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.black)

                Image(systemName: "chevron.down")
                    .foregroundColor(.black)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct AnotherMemberTransferForm: View {
    @Binding var allAccounts: [BankAccount]

    @Binding var selectedFromAccount: BankAccount?
    @Binding var selectedContact: Contact?
    @Binding var isTransferFromSheetPresented: Bool
    @Binding var showContactSheet: Bool
    @Binding var showDatePicker: Bool
    @Binding var recurring: Bool
    @Binding var selectedFrequency: String
    @Binding var amount: String
    @Binding var memo: String
    @Binding var dateText: String?
    @Binding var showAmountError: Bool
    @Binding var showTransferToError: Bool
    @Binding var showRecurringDateError: Bool
    @Binding var showDateError: Bool
    @Binding var showTransferFromError: Bool

    @Binding var showMemoError: Bool
    @Binding var showInsufficientFundsError: Bool
    @Binding var isSelectingStartDate: Bool
    @Binding var isSelectingEndDate: Bool
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var startDateText: String?
    @Binding var endDateText: String?
    @StateObject private var accountManager = AccountManager()
    @Binding var isContactSheetPresented: Bool // Ensure this exists
    @Binding var showConfirmationSheet: Bool
    @Binding var isAnotherMemberSelected: Bool
    @Binding var transactionId: String

    @ObservedObject var contactManager: ContactManager
// At the top
 // Use same ContactManager

    var body: some View {
        
        VStack(spacing: 15) {
            // Error message for insufficient funds
//            if showInsufficientFundsError {
////                ErrorMessageView(text: "Payment failed. This transfer amount exceeds your transaction limit.")
//                ErrorMessageView(text: NSLocalizedString("error_transaction_limit", comment: "Shown when transfer amount exceeds allowed limit"))
//
//            }
            if showInsufficientFundsError && selectedFromAccount != nil {
                ErrorMessageView(text: NSLocalizedString("error_transaction_limit", comment: ""))
            }
            // **Transfer From Account Selection**
//            AccountSelectionButton(title: "Transfer From", account: $selectedFromAccount) {
//                isTransferFromSheetPresented.toggle()
//            }
            Text(NSLocalizedString("transfer_from", comment: ""))
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            AccountSelectionButton(
                title: NSLocalizedString("transfer_from", comment: "Label for selecting the source account"),
                account: $selectedFromAccount
            ) {
                isTransferFromSheetPresented.toggle()
                showTransferFromError = false
                showInsufficientFundsError = false

            }

            .sheet(isPresented: $isTransferFromSheetPresented) {
                TransferAccountSheet(
                    //accountManager: accountManager,  // Add this
                    allAccounts: allAccounts,
                    selectedAccount_from: $selectedFromAccount,
                    isPresented: $isTransferFromSheetPresented  // Add this
                )
            }

            if showTransferFromError {
                //ErrorMessage(text: "This field is required")
                ErrorMessage(text: NSLocalizedString("error_required_transfer_from_field", comment: "Validation error for empty field"))
                
            }
            Text(NSLocalizedString("select_recipient", comment: ""))
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            // **Transfer To Contact Selection**
//            ContactSelectionButton(title: "Select Contact", contact: selectedContact)
            ContactSelectionButton(
                title: NSLocalizedString("select_recipient", comment: "Label for selecting a contact"),
                contact: selectedContact
            ){
                showContactSheet.toggle()
                showTransferToError = false // Hide error when user taps to select contact

            }
            .sheet(isPresented: $showContactSheet) {
                ContactSelectionSheet(contactManager: contactManager, selectedContact: $selectedContact, isPresented: $showContactSheet)
            }

            if showTransferToError {
                //ErrorMessage(text: "This field is required")
                ErrorMessage(text: NSLocalizedString("error_required_transfer_contact_field", comment: "Validation error for empty field"))
            }

            // **One-Time or Recurring Toggle**
            HStack(spacing: 20) {
                VStack {
                    Toggle(NSLocalizedString("one_time_payment", comment: ""), isOn: Binding(
                        get: { !recurring },
                        set: { newValue in
                            recurring = !newValue
                            showAmountError = false
                            showMemoError = false
                            showTransferToError = false
                            showDateError = false
                            showRecurringDateError = false
                            showInsufficientFundsError = false
                            
//                            let today = Date()
//                                   startDate = today
//                                   startDateText = formatDate(today)
                        }
                    ))
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    .scaleEffect(0.8)
                    .lineLimit(1)
                    .padding(.horizontal, 10)
                }
                .frame(width: 160, height: 60)
                .background(Color(.systemGray6))
                .cornerRadius(10)

                VStack {
                    Toggle(NSLocalizedString("recurring_payment", comment: ""), isOn: Binding(
                        get: { recurring },
                        set: { newValue in
                            recurring = newValue
                            showAmountError = false
                            showMemoError = false
                            showTransferToError = false
                            showDateError = false
                            showRecurringDateError = false
                            showInsufficientFundsError = false
                            
//                            let today = Date()
//                                   startDate = today
//                                   startDateText = formatDate(today)
                        }
                    ))
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    .scaleEffect(0.8)
                    .lineLimit(1)
                    .padding(.horizontal, 10)
                }
                .frame(width: 160, height: 60)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .padding(.horizontal, 10)

            // **Recurring Payment Frequency Selection**
            if recurring {
                VStack {
                    //Text("Select Frequency")
                    Text(NSLocalizedString("select_frequency", comment: ""))

                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 5)

//                    Picker("Frequency", selection: $selectedFrequency) {
//                        Text("Weekly").tag("Weekly")
//                        Text("Monthly").tag("Monthly")
//                        Text("Yearly").tag("Yearly")
//                    }
                    Picker(NSLocalizedString("frequency", comment: "Frequency picker label"), selection: $selectedFrequency) {
                        Text(NSLocalizedString("weekly", comment: "Frequency option")).tag("weekly")
                        Text(NSLocalizedString("monthly", comment: "Frequency option")).tag("monthly")
                        Text(NSLocalizedString("yearly", comment: "Frequency option")).tag("yearly")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
                .transition(.opacity)
            }

            // **Amount Input**
            //TextField("Enter Transfer Amount", text: $amount)
            TextField(NSLocalizedString("enter_transfer_amount", comment: "Placeholder for transfer amount input"), text: $amount)
                //.keyboardType(.decimalPad)
                .keyboardType(.numbersAndPunctuation)
                  .submitLabel(.done)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .onChange(of: amount) { oldValue,newValue in
                    //amount = formatCurrencyInput(newValue)
                    amount = CurrencyFormatter.format(newValue)
                    if !newValue.trimmingCharacters(in: .whitespaces).isEmpty {
                            showAmountError = false // Hide error as soon as user types
                        }
                }
                .onTapGesture {
                            UIApplication.shared.endEditing()
                        }

            if showAmountError {
                //ErrorMessage(text: "This field is required")
                ErrorMessage(text: NSLocalizedString("error_required_payee_amount_field", comment: "Validation error for empty field"))
            }

            // **Date Selection**
            if !recurring {
//                DateField(title: "Select Date", dateText: $dateText, action: { showDatePicker.toggle() })
                DateField(
                    title: NSLocalizedString("select_date", comment: "Label for selecting a single date"),
                    dateText: $dateText,
                    action: {
                        UIApplication.shared.endEditing() // Dismiss keyboard

                        showDatePicker.toggle() }
                )
                if showDateError {
                    //ErrorMessage(text: "This field is required")
                    ErrorMessage(text: NSLocalizedString("error_required_end_date_field", comment: "Validation error for empty field"))
                }
            }

            if recurring {
                VStack(){
//                    DateField(title: "Start Date", dateText: $startDateText, action: {
//                        isSelectingStartDate = true
//                        isSelectingEndDate = false
//                        showDatePicker.toggle()
//                    })
                    DateField(
                        title: NSLocalizedString("start_date", comment: "Label for selecting the start date"),
                        dateText: $startDateText,
                        action: {
                            isSelectingStartDate = true
                            isSelectingEndDate = false
                            showDatePicker.toggle()
                        }
                    )

//                    DateField(title: "End Date", dateText: $endDateText, action: {
//                        isSelectingStartDate = false
//                        isSelectingEndDate = true
//                        showDatePicker.toggle()
//                    })
                    DateField(
                        title: NSLocalizedString("end_date", comment: "Label for selecting the end date"),
                        dateText: $endDateText,
                        action: {
                            isSelectingStartDate = false
                            isSelectingEndDate = true
                            showDatePicker.toggle()
                        }
                    )
                    if showRecurringDateError {
                        //ErrorMessage(text: "This field is required")
                        ErrorMessage(text: NSLocalizedString("error_required_end_date_field", comment: "Validation error for empty field"))
                    }
                }
            }

            // **Date Picker Modal**
            if showDatePicker {
                Color.black.opacity(0.001)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showDatePicker = false
                    }

                VStack {
                    if !recurring {
                        DatePicker(
                            "Select Date",
                            selection: Binding(
                                get: { startDate },
                                set: { newValue in
                                    startDate = newValue
                                    dateText = DateDefaults.formatDate(newValue)
                                    showDateError = false
                                    showDatePicker = false
                                }
                            ),
                            in: DateDefaults.startDateRange(),
                            displayedComponents: .date
                        )
                        .datePickerStyle(GraphicalDatePickerStyle()) // apply here
                        .labelsHidden()
                    } else {
                        if isSelectingStartDate {
                            DatePicker(
                                "Start Date",
                                selection: Binding(
                                    get: { startDate },
                                    set: { newValue in
                                        startDate = newValue
                                        startDateText = DateDefaults.formatDate(newValue)
                                        showRecurringDateError = false
                                        showDatePicker = false
                                    }
                                ),
                                in: DateDefaults.startDateRange(),
                                displayedComponents: .date
                            )
                            .datePickerStyle(GraphicalDatePickerStyle()) // apply here
                            .labelsHidden()
                        }

                        if isSelectingEndDate {
                            DatePicker(
                                "End Date",
                                selection: Binding(
                                    get: { endDate },
                                    set: { newValue in
                                        endDate = newValue
                                        endDateText = DateDefaults.formatDate(newValue)
                                        showRecurringDateError = false
                                        showDatePicker = false
                                    }
                                ),
                                in: DateDefaults.endDateRange(from: startDate),
                                displayedComponents: .date
                            )
                            .datePickerStyle(GraphicalDatePickerStyle()) // apply here
                            .labelsHidden()
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
                .id("calendarSection")
            }


            // **Memo Field**
            //TextField("Memo", text: $memo)
            TextField(NSLocalizedString("memo", comment: "Placeholder for memo field"), text: $memo)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .onChange(of: memo) { oldValue,newValue in
                        if !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            showMemoError = false
                        }
                    }


//            if showMemoError {
//                //ErrorMessage(text: "This field is required")
//                ErrorMessage(text: NSLocalizedString("error_required_transfer_memo_field", comment: "Validation error for empty field"))
//            }
            Button(action: {
                //validateFields()
                
                let result = TransferFormValidator.validate(
                       selectedFromAccount: selectedFromAccount,
                       selectedContact: selectedContact, // Now accepted

                       //selectedToAccount: selectedToAccount,
                       amount: amount,
                       //memo: memo,
                       dateText: dateText,
                       startDateText: startDateText,
                       endDateText: endDateText,
                       recurring: recurring
                   )

                   showTransferFromError = result.showTransferFromError
                   showTransferToError = result.showTransferToError
                   showAmountError = result.showAmountError
                   //showMemoError = result.showMemoError
                   showDateError = result.showDateError
                   showRecurringDateError = result.showRecurringDateError
                   showInsufficientFundsError = result.showInsufficientFundsError
                   showConfirmationSheet = result.isFormValid
            }) {
                Text(NSLocalizedString("continue", comment: "Button label for continue"))
                    .font(.headline)
                    .frame(width: 330)
                    .padding()
                    .background(Constants.backgroundGradient)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 10)
            .sheet(isPresented: $showConfirmationSheet) {
                ConfirmationSheet(
                    fromAccount: $selectedFromAccount,
                   // toAccount: $selectedToAccount,
                    toAccount: .constant(nil), // <-- explicitly pass nil if not used

                    amount: $amount,
                    dateText: $dateText,

                    memo: $memo,
                    isRecurring: $recurring,
                    //selectedFrequency: $selectedFrequency,
                    selectedFrequency: Binding(get: { selectedFrequency }, set: { selectedFrequency = $0! }), // Fix for optional binding
//                        selectedFrequency: Binding(get: { selectedFrequency ?? "Weekly" }, set: { selectedFrequency = $0! })
                    startDateText: $startDateText,
                    endDateText: $endDateText,
                    isAnotherMemberSelected: $isAnotherMemberSelected,
                    transactionId: $transactionId,
                    selectedContact: $selectedContact,
                    onConfirm: {
                                sendTransferAPI(
                                    fromAccount: selectedFromAccount,
                                    toAccount: nil,
                                    selectedContact: selectedContact,
                                    amount: amount,
                                    memo: memo,
                                    isRecurring: recurring,
                                    startDate: startDate,
                                    endDate: endDate,
                                    selectedFrequency: selectedFrequency,
                                    isAnotherMemberSelected: isAnotherMemberSelected
                                ) { transactionId in
                                    if let transactionId = transactionId {
                                        self.transactionId = transactionId  // ✅ update your @State transactionId
                                        //navigateToSummary = true            // Navigate to Summary sheet
                                    } else {
                                        print("❌ Failed to get transaction ID")
                                    }
                                }
                            }// Add this

                    
                )
//                    .presentationDetents([.medium, .fraction(2)]) // Makes the sheet smaller
//                        .presentationDragIndicator(.visible)
            }


        }
        .padding()
        .onAppear {
            var tempDateText = dateText
            var tempStartDateText = startDateText
            var tempEndDateText = endDateText
            var tempStartDate = startDate
            var tempEndDate = endDate

            DateDefaults.initializeDefaultDates(
                isRecurring: recurring,
                dateText: &tempDateText,
                startDateText: &tempStartDateText,
                endDateText: &tempEndDateText,
                startDate: &tempStartDate,
                endDate: &tempEndDate
            )

            dateText = tempDateText
            startDateText = tempStartDateText
            endDateText = tempEndDateText
            startDate = tempStartDate
            endDate = tempEndDate
        }
        .onChange(of: recurring) { oldValue,_ in
            var tempDateText = dateText
            var tempStartDateText = startDateText
            var tempEndDateText = endDateText
            var tempStartDate = startDate
            var tempEndDate = endDate

            DateDefaults.initializeDefaultDates(
                isRecurring: recurring,
                dateText: &tempDateText,
                startDateText: &tempStartDateText,
                endDateText: &tempEndDateText,
                startDate: &tempStartDate,
                endDate: &tempEndDate
            )

            dateText = tempDateText
            startDateText = tempStartDateText
            endDateText = tempEndDateText
            startDate = tempStartDate
            endDate = tempEndDate
        }
//        .onAppear {
//            let today = Date()
//
//            if !recurring && (dateText == nil || dateText?.isEmpty == true) {
//                startDate = today
//                dateText = formatDate(today)
//            }
//
//            if recurring && (startDateText == nil || startDateText?.isEmpty == true) {
//                startDate = today
//                startDateText = formatDate(today)
//            }
//        }

    }

   
}

// **Reusable Contact Selection Button**
struct ContactSelectionButton: View {
    var title: String
    var contact: Contact?
    var action: () -> Void
    @State private var showContactSheet = false // Show Contact Selection Sheet


    var body: some View {
        Button(action: {
          print("Button Clicked - Opening Contact Selection Sheet") // Debug log
            action()
            showContactSheet=true

        }) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(contact?.name ?? title)
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)
                }
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.black)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}
struct ErrorMessageView: View {
    let text: String

    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill") // Alert icon
                .foregroundColor(.white)
                .padding(.leading, 10)

            Text(text)
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .padding(.trailing, 10)

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.red) // Red background for error
        .cornerRadius(8)
        .padding(.horizontal)
    }
}



struct ConfirmationSheet: View {

    @Binding var fromAccount: BankAccount?
        @Binding var toAccount: BankAccount?
        @Binding var amount: String
       @Binding var dateText: String?
        @Binding var memo: String
        @Binding var isRecurring: Bool
        @Binding var selectedFrequency: String?
        @Binding var startDateText: String?
        @Binding var endDateText: String?
        @Binding var isAnotherMemberSelected: Bool
    @Binding var transactionId: String
    @Binding var selectedContact: Contact?
    var onConfirm: () -> Void

    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToSummary = false  // Controls navigation

    var body: some View {
        VStack(spacing: 15) {
            // Close button
            HStack {
                //Text("Confirmation")
                Text(NSLocalizedString("confirmation", comment: "Title for confirmation screen"))

                    .font(.title3)
                    .bold()
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            .padding()
            
            VStack(alignment: .leading, spacing: 10) {
//                PaymentDetailRow(
//                    title: "Transfer from",
//                    value: "\(fromAccount?.accountName ?? "No Account") - \(fromAccount?.accountNumber ?? "")",
//                    bold: true
//                )
                PaymentDetailRow(
                    title: NSLocalizedString("transfer_from", comment: "Label for the source account in transfer details"),
                    value: "\(fromAccount?.accountName ?? NSLocalizedString("no_account", comment: "Fallback when no account")) - \(fromAccount?.accountNumber ?? "")",
                    bold: true
                )


//                PaymentDetailRow(
//                    title: isAnotherMemberSelected ? "Send To" : "Transfer To",
//                    value: isAnotherMemberSelected ?
//                        (selectedContact?.name ?? "No Contact Selected") :
//                        "\(toAccount?.accountName ?? "No Account") - \(toAccount?.accountNumber ?? "")",
//                    bold: true
//                )
                PaymentDetailRow(
                    title: isAnotherMemberSelected
                        ? NSLocalizedString("send_to", comment: "Title for sending to a contact")
                        : NSLocalizedString("transfer_to", comment: "Title for transferring to own account"),

                    value: isAnotherMemberSelected
                        ? (selectedContact?.name ?? NSLocalizedString("no_contact_selected", comment: "Fallback when no contact selected"))
                        : "\(toAccount?.accountName ?? NSLocalizedString("no_account", comment: "Fallback when no account")) - \(toAccount?.accountNumber ?? "")",

                    bold: true
                )

//
//                PaymentDetailRow(
//                    title: "Amount",
//                    value: "\(amount)",
//                    bold: true
//                )
                PaymentDetailRow(
                    title: NSLocalizedString("amount", comment: "Label for transfer amount"),
                    value: "\(amount)",
                    bold: true
                )


//                if isRecurring {
//                    PaymentDetailRow(
//                        title: "Payment Type",
//                        value: "Recurring",
//                        bold: true
//                    )
//
//                    PaymentDetailRow(
//                        title: "Frequency",
//                        value: selectedFrequency ?? "N/A",
//                        bold: false
//                    )
//
//                    PaymentDetailRow(
//                        title: "Start Date",
//                        value: startDateText ?? "N/A",
//                        bold: false
//                    )
//
//                    PaymentDetailRow(
//                        title: "End Date",
//                        value: endDateText ?? "N/A",
//                        bold: false
//                    )
                if isRecurring {
                    PaymentDetailRow(
                        title: NSLocalizedString("payment_type", comment: "Label for payment type"),
                        value: NSLocalizedString("recurring_payment", comment: "Recurring payment value"),
                        bold: true
                    )

                    PaymentDetailRow(
                        title: NSLocalizedString("frequency", comment: "Label for frequency of recurring payment"),
                        value: selectedFrequency ?? NSLocalizedString("na", comment: "Not available fallback"),
                        bold: false
                    )

                    PaymentDetailRow(
                        title: NSLocalizedString("start_date", comment: "Label for start date of recurring payment"),
                        value: startDateText ?? NSLocalizedString("na", comment: "Not available fallback"),
                        bold: false
                    )

                    PaymentDetailRow(
                        title: NSLocalizedString("end_date", comment: "Label for end date of recurring payment"),
                        value: endDateText ?? NSLocalizedString("na", comment: "Not available fallback"),
                        bold: false
                    )
                } else {
//                    PaymentDetailRow(
//                        title: "Payment Type",
//                        value: "One-Time",
//                        bold: true
//                    )
//
//                    PaymentDetailRow(
//                        title: "Date",
//                        value: dateText ?? "N/A",
//                        //value: dateText.isEmpty ? "N/A" : dateText,
//
//                        bold: false
//                    )
                    PaymentDetailRow(
                        title: NSLocalizedString("payment_type", comment: "Label for payment type"),
                        value: NSLocalizedString("one_time_payment", comment: "One-time payment value"),
                        bold: true
                    )

                    PaymentDetailRow(
                        title: NSLocalizedString("date", comment: "Label for payment date"),
                        value: dateText ?? NSLocalizedString("na", comment: "Not available fallback"),
                        bold: false
                    )

                }

//                PaymentDetailRow(
//                    title: "Memo",
//                    value: memo.isEmpty ? "N/A" : memo,
//                    bold: false
//                )
                PaymentDetailRow(
                    title: NSLocalizedString("memo", comment: "Label for memo field"),
                    value: memo.isEmpty ? NSLocalizedString("na", comment: "Fallback when no value is available") : memo,
                    bold: false
                )

            }
            .padding(.horizontal)

            Spacer()

            // Confirm Button
            Button(action: {
                print("Transaction confirmed")
                //sendTransferAPI()
                onConfirm()
                //presentationMode.wrappedValue.dismiss()
                navigateToSummary = true // Show summary screen

            }) {
                //Text("Confirm")
                Text(NSLocalizedString("confirm", comment: "Button or title to confirm an action"))

                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .padding(.vertical)
        //.frame(maxHeight:500)
        .fullScreenCover(isPresented: $navigateToSummary) {
                    SummarySheet(
                        fromAccount: fromAccount,
                            toAccount: toAccount,
                            amount: amount,
                            dateText: dateText ?? "N/A",
                            memo: memo,
                            transactionId: transactionId, // Correct binding
                            isAnotherMemberSelected: isAnotherMemberSelected, // Correct
                            selectedContact: selectedContact, // Correct
                            isRecurring: isRecurring,
                            selectedFrequency: selectedFrequency,
                            startDateText: startDateText,
                            endDateText: endDateText
                    )
                }
    }

}
struct TransferRequest: Codable {
    let AccountNumberFrom: String
    let AccountNumberTo: String
    let Amount: Double
    let Currency: String
    let IsSelfTransfer: Bool
    let Frequency: String?
    let Note: String
    let StartDate: String
    let EndDate: String
}

struct SummarySheet: View { //SummarySheet
//    var fromAccount: BankAccount?
//    var toAccount: BankAccount?
//    var amount: String
//    var dateText: String
//    var memo: String
    //var transactionId: String
    
    //var isAnotherMemberSelected: Bool //  Add this
     //var selectedContact: Contact?
    
    //var isRecurring: Bool                          // New
//        var selectedFrequency: String?                 // New
//        var startDateText: String?                     // New
//        var endDateText: String?
    @State private var navigateToMainView = false
    @State private var navigateToTransferMoney = false
    //var transactionId: String
    var fromAccount: BankAccount?
       var toAccount: BankAccount?
       var amount: String
       var dateText: String
       var memo: String
       var transactionId: String // <- required
       var isAnotherMemberSelected: Bool
       var selectedContact: Contact?
       var isRecurring: Bool
       var selectedFrequency: String?
       var startDateText: String?
       var endDateText: String?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            // Payment Sent Message
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.white)
                    .font(.title3)
                //Text("Payment Sent")
                Text(NSLocalizedString("payment_sent", comment: "Message shown when a payment is successfully sent"))

                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .cornerRadius(10)
            .padding()

            // Payment Summary Card
            VStack(alignment: .leading, spacing: 10) {
                //Text("Payment Summary")
                Text(NSLocalizedString("payment_summary", comment: "Message shown when a payment is successfully sent"))
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)

                Divider()
                
                
                PaymentDetailRow(
                        title: "Transaction ID",
                        value: transactionId,  // Show transaction id
                        bold: true
                    )

                    Divider()
//25 march
                PaymentDetailRow(
                    title: NSLocalizedString("transfer_from", comment: "Label for the source account in transfer details"),
                    value: "\(fromAccount?.accountName ?? NSLocalizedString("no_account", comment: "Fallback when no account")) - \(fromAccount?.accountNumber ?? "")",
                    bold: true
                )


                PaymentDetailRow(
                    title: isAnotherMemberSelected
                        ? NSLocalizedString("send_to", comment: "Title for sending to a contact")
                        : NSLocalizedString("transfer_to", comment: "Title for transferring to own account"),

                    value: isAnotherMemberSelected
                        ? (selectedContact?.name ?? NSLocalizedString("no_contact_selected", comment: "Fallback when no contact selected"))
                        : "\(toAccount?.accountName ?? NSLocalizedString("no_account", comment: "Fallback when no account")) - \(toAccount?.accountNumber ?? "")",

                    bold: true
                )
               
//
//                PaymentDetailRow(title: "Amount", value: "\(amount)", bold: true)
                PaymentDetailRow(
                    title: NSLocalizedString("amount", comment: "Label for transfer amount"),
                    value: "\(amount)",
                    bold: true
                )



                if isRecurring {
                    PaymentDetailRow(
                        title: NSLocalizedString("payment_type", comment: "Label for payment type"),
                        value: NSLocalizedString("recurring_payment", comment: "Recurring payment value"),
                        bold: true
                    )

                    PaymentDetailRow(
                        title: NSLocalizedString("frequency", comment: "Label for frequency of recurring payment"),
                        value: selectedFrequency ?? NSLocalizedString("na", comment: "Not available fallback"),
                        bold: false
                    )

                    PaymentDetailRow(
                        title: NSLocalizedString("start_date", comment: "Label for start date of recurring payment"),
                        value: startDateText ?? NSLocalizedString("na", comment: "Not available fallback"),
                        bold: false
                    )

                    PaymentDetailRow(
                        title: NSLocalizedString("end_date", comment: "Label for end date of recurring payment"),
                        value: endDateText ?? NSLocalizedString("na", comment: "Not available fallback"),
                        bold: false
                    )
                   } else {
//                       PaymentDetailRow(
//                           title: "Payment Type",
//                           value: "One-Time",
//                           bold: true
//                       )
//
//                       PaymentDetailRow(
//                           title: "Date",
//                           value: dateText,
//                           bold: false
//                       )
                       PaymentDetailRow(
                           title: NSLocalizedString("payment_type", comment: "Label for payment type"),
                           value: NSLocalizedString("one_time_payment", comment: "One-time payment value"),
                           bold: true
                       )

                       PaymentDetailRow(
                           title: NSLocalizedString("date", comment: "Label for payment date"),
                           value: dateText,
                           bold: false
                       )
                   }

//                PaymentDetailRow(title: "Memo", value: memo.isEmpty ? "N/A" : memo, bold: false)
                PaymentDetailRow(
                    title: NSLocalizedString("memo", comment: "Label for memo field"),
                    value: memo.isEmpty ? NSLocalizedString("na", comment: "Fallback when no value is available") : memo,
                    bold: false
                )
            }
       

            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
            .padding()

            Spacer()

            // Done Button: Redirects back to main page
            Button(action: {
                //presentationMode.wrappedValue.dismiss()
                navigateToMainView = true
            }) {
                //Text("Done")
                Text(NSLocalizedString("done", comment: "Done button label"))

                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .fullScreenCover(isPresented: $navigateToMainView) {
                MainView() // Opens MainView when button is clicked
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            
            //added new button
            Button(action: {
                navigateToTransferMoney = true
            }) {
                Text(NSLocalizedString("continue_with_new_transfer", comment: "Continue with new transfer button"))
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    //.background(Color.colorBlue) // or .blue
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Constants.backgroundGradient)
                    )

                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .fullScreenCover(isPresented: $navigateToTransferMoney) {
                TransferMoneyScreen() // Your Transfer Money screen view
            }
            .padding(.horizontal)
            .padding(.bottom, 20) // consiste
        }
        .padding()
    }
}


struct PaymentDetailRow: View {
    var title: String
    var value: String
    var bold: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.footnote)
                .foregroundColor(.gray)

            Text(value)
                .font(.body)
                .fontWeight(bold ? .bold : .regular)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5) // Adds spacing above the line

            Divider() // This adds the bottom border effect
        }
    }
}


struct ContactSelectionSheet: View {
    @ObservedObject var contactManager: ContactManager
    @Binding var selectedContact: Contact?
    @Binding var isPresented: Bool
    @State private var searchText: String = "" // Search text state
    @State private var showAddContactForm = false

    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return contactManager.contacts
        } else {
            return contactManager.contacts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        VStack {
            // Header
            HStack {
                Text(NSLocalizedString("select_recipient", comment: ""))
                    .font(.headline)
                    .bold()
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
            }
            .padding()

            // Search Bar and Add Contact Button
            HStack(spacing: 10) {
                TextField(NSLocalizedString("search", comment: ""), text: $searchText)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )

                Button(action: {
                    showAddContactForm = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.colorBlue)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)

            // Check if filtered contacts are empty
            if filteredContacts.isEmpty {
                // Show "No contact found" message if there are no contacts
                VStack {
                    Spacer()
                    Text(NSLocalizedString("no_contact_found", comment: "Message displayed when no contacts are found"))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center) // Center the message
                    Spacer()
                }
            } else {
                // Contact List (Filtered)
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(filteredContacts) { contact in
                            Button(action: {
                                selectedContact = contact
                                isPresented = false
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        // Show only name
                                        Text(contact.name)
                                            .font(.headline)
                                            .bold()
                                            .foregroundColor(.black)
                                        if let accountNumber = contact.accountNumber, !accountNumber.isEmpty {
                                            Text("Account Number: \(accountNumber)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    Spacer()

                                    // Show checkmark if selected
                                    if selectedContact?.id == contact.id {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding()
                                .background(selectedContact?.id == contact.id ? Color.blue.opacity(0.2) : Color(.systemGray6))
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .fullScreenCover(isPresented: $showAddContactForm) {
            AddContactFormView(
                isPresented: $showAddContactForm,
                contactManager: contactManager,
                onContactCreated: { _ in
                    contactManager.fetchContactsFromAPI {
                        searchText = "" // Clear search text if you want
                    }
                }
            )
        }

//        .onAppear {
//            contactManager.fetchContactsFromAPI()
//        }
//        .onAppear {
//            if contactManager.contacts.isEmpty {
//                contactManager.fetchContactsFromAPI()
//            }
//        }
        .onAppear {
            if contactManager.contacts.isEmpty {
                contactManager.fetchContactsFromAPI {
                    if let selected = selectedContact,
                       !contactManager.contacts.contains(where: { $0.id == selected.id }) {
                        selectedContact = nil // If not found in refreshed list, clear it
                    }
                }
            }
        }


        .padding(.horizontal)
        .presentationDetents([.medium, .large])
    }
}






struct TransferAccountSheet: View {
    var allAccounts: [BankAccount]                   // Passed in from parent
    @Binding var selectedAccount_from: BankAccount?  // For selection
    @Binding var isPresented: Bool                   // To close sheet
    @State private var filteredAccounts: [BankAccount] = []
    var body: some View {
        VStack {
            headerView

            ScrollView {
                          VStack(spacing: 10) {
                              if filteredAccounts.isEmpty {
                                  ProgressView("Loading accounts...")
                              } else {
                                  ForEach(filteredAccounts) { account in
                                      accountButton(for: account)
                                  }
                              }
                          }
                          .padding()
                      }
                  }
                  .onAppear {
                      filteredAccounts = allAccounts
                      print("TransferAccountSheet loaded \(filteredAccounts.count) accounts")
                  }
                  .presentationDetents([.medium, .large])
              }
    private var headerView: some View {
        HStack {
            Text(NSLocalizedString("transfer_from", comment: ""))
                .font(.headline)
                .foregroundColor(.black)
                .bold()
            Spacer()
            Button(action: { isPresented = false }) {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }

    private func accountButton(for account: BankAccount) -> some View {
        Button(action: {
            selectedAccount_from = account
            isPresented = false
            print("Selected From Account: \(account.accountName)")
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(account.accountName)
                        .font(.headline)
                        .foregroundColor(.black)
                        .bold()
                    Text(account.accountType)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(account.accountNumber)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(account.balance)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.black)

                if let selected = selectedAccount_from, selected.id == account.id {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(selectedAccount_from?.id == account.id ? Color.blue.opacity(0.2) : Color(.systemGray6))
            )
        }
    }
}

struct SendToSheet: View {
    var allAccounts: [BankAccount]

    @Binding var selectedAccount_to: BankAccount?
    @Binding var isPresented_to: Bool
    @Binding var excludeAccount: BankAccount?
    
    @State private var filteredAccounts: [BankAccount] = []

    var body: some View {
        VStack {
            headerView
            if filteredAccounts.isEmpty {
                ProgressView("Loading accounts...")
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(filteredAccounts) { account in
                            accountButton(for: account)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            print("SendToSheet received \(allAccounts.count) accounts")
            filteredAccounts = allAccounts.filter { $0.id != excludeAccount?.id }
        }
        .padding(.horizontal)
        .presentationDetents([.medium, .large])
    }

    private var headerView: some View {
        HStack {
            Text(NSLocalizedString("transfer_to", comment: ""))
                .font(.headline)
                .bold()
            Spacer()
            Button(action: { isPresented_to = false }) {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }

    private func accountButton(for account: BankAccount) -> some View {
        Button(action: {
            selectedAccount_to = account
            isPresented_to = false
            print("Selected Account To: \(account.accountName)")
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(account.accountName)
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)
                    Text(account.accountType)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(account.accountNumber)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(account.balance)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.black)
                if selectedAccount_to?.id == account.id {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(selectedAccount_to?.id == account.id ? Color.blue.opacity(0.2) : Color(.systemGray6))
            )
        }
    }
}

private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }


struct TransferResponse: Codable {
    let status: String
    let data: TransferData
}

struct TransferData: Codable {
    let transactionId: String
    let transactionNumber: String
    enum CodingKeys: String, CodingKey {
            case transactionId = "TransactionId"
        case transactionNumber = "TransactionNumber"

        }
}


struct TransferMoneyScreen_Previews: PreviewProvider {
    static var previews: some View {
        //TransferMoneyScreen(showContactSheet: .constant(false))
        TransferMoneyScreen()
    }
}
