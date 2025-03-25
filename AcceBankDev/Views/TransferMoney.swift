import SwiftUI

enum FieldFocus: Hashable {
    case amount
    case date
    case memo
}

struct TransferMoneyScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedPaymentType: String? = "My accounts"

    // Shared States
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
    //@State private var date = Date()//

    @State private var dateText: String? = nil
    @State private var showAmountError = false
    @State private var showTransferToError = false
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


    var body: some View {
        ScrollView {
            VStack {
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
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.3)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .cornerRadius(30)

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
}) {
                                Text("My accounts")
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
}) {
                                Text("Another member")
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
                    }
                }
                .padding(.horizontal)

                // **Dynamic Form Based on Selected Payment Type**
                if selectedPaymentType == "My accounts" {

                    MyAccountsTransferForm(
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
                        showMemoError: $showMemoError,
                        showInsufficientFundsError: $showInsufficientFundsError,
                     isSelectingStartDate: $isSelectingStartDate,
                       isSelectingEndDate: $isSelectingEndDate,
                     startDate: $startDate,
                        endDate: $endDate,
                        startDateText: $startDateText,
                 endDateText: $endDateText
                    )

                } else if selectedPaymentType == "Another member" {
                    AnotherMemberTransferForm(
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
                        showDateError:$showDateError,
                            showMemoError: $showMemoError,
                            showInsufficientFundsError: $showInsufficientFundsError,
                            isSelectingStartDate: $isSelectingStartDate,
                            isSelectingEndDate: $isSelectingEndDate,
                            startDate: $startDate,
                            endDate: $endDate,
                            startDateText: $startDateText,
                            endDateText: $endDateText,
                            isContactSheetPresented: $isContactSheetPresented
                    )
                }

                // **Continue Button**
                Button(action: {
                    
                    validateFields()
//                    if showInsufficientFundsError {
//                            return
//                        }
//                    if !showAmountError && !showTransferToError && !showMemoError {
//                           showConfirmationSheet = true
//                       }
//                    showConfirmationSheet = true
                    DispatchQueue.main.async {
                        print("Selected Contact: \(selectedContact?.name ?? "nil")")
                        print("Is Another Member Selected: \(isAnotherMemberSelected)")
                            
                        
                        if !showInsufficientFundsError && !showAmountError && !showTransferToError && !showMemoError {
                            showConfirmationSheet = true
                        }
                    }

                }) {
                    //Text("Continue")
                    Text(NSLocalizedString("continue", comment: "Button label for continue"))

                        .font(.headline)
                        .frame(width: 330)
                        .padding()
                        .background(Constants.backgroundGradient)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 5)
                
                

                .sheet(isPresented: $showConfirmationSheet) {
                    ConfirmationSheet(
                        fromAccount: $selectedFromAccount,
                        toAccount: $selectedToAccount,
                        amount: $amount,
                        dateText: $dateText,
//                        dateText: Binding(get: { dateText ?? "N/A" }, set: { dateText = $0 }), // Fix for optional binding
//                        dateText: Binding(get: { dateText ?? "" }, set: { dateText = $0 }),

                        memo: $memo,
                        isRecurring: $recurring,
                        //selectedFrequency: $selectedFrequency,
                        selectedFrequency: Binding(get: { selectedFrequency ?? "Weekly" }, set: { selectedFrequency = $0! }), // Fix for optional binding

                        startDateText: $startDateText,
                        endDateText: $endDateText,
                        isAnotherMemberSelected: $isAnotherMemberSelected,
                        selectedContact: $selectedContact // Add this

                        
                    )
//                    .presentationDetents([.medium, .fraction(2)]) // Makes the sheet smaller
//                        .presentationDragIndicator(.visible)
                }


                



            }
            .padding(.horizontal, 10)
        }
    }

//    private func validateFields() {
//        showTransferToError = selectedToAccount == nil && selectedContact == nil
//        showAmountError = amount.trimmingCharacters(in: .whitespaces).isEmpty
//        showMemoError = memo.trimmingCharacters(in: .whitespaces).isEmpty
//    }
    private func validateFields() {
        // Convert amount string to a double after removing currency symbols
        let enteredAmount = Double(amount.replacingOccurrences(of: "$", with: "").trimmingCharacters(in: .whitespaces)) ?? 0.0
        let availableBalance = Double(selectedFromAccount?.balance.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "").trimmingCharacters(in: .whitespaces) ?? "0") ?? 0.0

        print("Entered Amount: \(enteredAmount)")
        print("Available Balance: \(availableBalance)")
        
        print("Opening Confirmation Sheet")
           print("From Account: \(selectedFromAccount?.accountName ?? "No Account") - \(selectedFromAccount?.accountNumber ?? "")")
           print("To Account: \(selectedToAccount?.accountName ?? "No Account") - \(selectedToAccount?.accountNumber ?? "")")
           print("Selected Contact: \(selectedContact?.name ?? "No Contact Selected")")
           print("Is Another Member Selected: \(isAnotherMemberSelected)")
           print("Amount: \(amount)")
           print("Date: \(dateText ?? "No Date")")
           print("Memo: \(memo)")
        print("Final dateText before confirmation: \(dateText ?? "nil")") // Debug

        showDateError = !recurring && (dateText?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        showRecurringDateError = (startDateText?.isEmpty ?? true) || (endDateText?.isEmpty ?? true)
//showStartDateError = startDateText?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
//       showEndDateError = endDateText?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true


        // Validate required fields
        showTransferToError = selectedToAccount == nil
        showAmountError = amount.trimmingCharacters(in: .whitespaces).isEmpty
        showMemoError = memo.trimmingCharacters(in: .whitespaces).isEmpty
        // Validate Date (One-Time vs Recurring)
//        showDateError = recurring
//            ? (startDateText?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
//            : (dateText?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        // Check for insufficient funds
        showInsufficientFundsError = enteredAmount > availableBalance

        // Only show confirmation sheet if all validations pass and no insufficient funds error
        showConfirmationSheet = !showTransferToError &&
                                !showAmountError &&
                                !showMemoError &&
                                !showInsufficientFundsError &&
                                !showDateError &&
            !showRecurringDateError
    }

    

}



struct MyAccountsTransferForm: View {
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
    @Binding var showMemoError: Bool
    @Binding var showInsufficientFundsError: Bool
    @Binding var isSelectingStartDate: Bool
    @Binding var isSelectingEndDate: Bool
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var startDateText: String?
    @Binding var endDateText: String?
    @FocusState private var focusedField: FieldFocus?

    
    @StateObject private var accountManager = AccountManager()

    var body: some View {
        
        VStack(spacing: 15) {
            // Error message for insufficient funds
            if showInsufficientFundsError {
//                ErrorMessageView(text: "Payment failed. This transfer amount exceeds your transaction limit.")//transaction_limit_exceeded
                ErrorMessageView(text: NSLocalizedString("error_transaction_limit", comment: "Shown when transfer amount exceeds allowed limit"))

            }
                
            // **Transfer From Account Selection**
//            AccountSelectionButton(title: "Transfer From", account: $selectedFromAccount)
            AccountSelectionButton(title: NSLocalizedString("transfer_from", comment: ""), account: $selectedFromAccount)

            {
                isTransferFromSheetPresented.toggle()
            }
//            .sheet(isPresented: $isTransferFromSheetPresented) {
//                TransferAccountSheet(selectedAccount_from: $selectedFromAccount)
//            }
            .sheet(isPresented: $isTransferFromSheetPresented) {
                TransferAccountSheet(
                    accountManager: accountManager,  // Add this
                    selectedAccount_from: $selectedFromAccount,
                    isPresented: $isTransferFromSheetPresented  // Add this
                )
            }


            // **Transfer To Account Selection**
//            AccountSelectionButton(title: "Transfer To", account: $selectedToAccount)
            AccountSelectionButton(title: NSLocalizedString("transfer_to", comment: ""), account: $selectedToAccount)
            {
                isSendToSheetPresented.toggle()
                showTransferToError = false
            }
//            .sheet(isPresented: $isSendToSheetPresented) {
//                SendToSheet(selectedAccount_to: $selectedToAccount)
//            }
//            .sheet(isPresented: $isSendToSheetPresented) {
//                SendToSheet(
//                    accountManager_to: accountManager,  // Add this
//                    selectedAccount_to: $selectedToAccount,
//                    isPresented_to: $isSendToSheetPresented,  // Add this
//                    excludeAccount: selectedFromAccount // pass the selected from account
//
//                )
//            }
            .sheet(item: Binding(
                get: {
                    isSendToSheetPresented ? selectedFromAccount : nil
                },
                set: { _ in
                    isSendToSheetPresented = false
                }
            )) { fromAccount in
                SendToSheet(
                    accountManager_to: accountManager,
                    selectedAccount_to: $selectedToAccount,
                    isPresented_to: $isSendToSheetPresented,
                    excludeAccount: fromAccount
                )
            }
            
            if showTransferToError {
                //ErrorMessage(text: "This field is required")
                ErrorMessage(text: NSLocalizedString("error_required_field", comment: "Validation error for empty field"))

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
                            showInsufficientFundsError = false                        }
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

                .keyboardType(.decimalPad)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                //.focused($focusedField, equals: .amount)
                .focused($focusedField, equals: .amount)
                .onTapGesture {
                    focusedField = nil
                }

                .onChange(of: amount) { newValue in
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
                ErrorMessage(text: NSLocalizedString("error_required_field", comment: "Validation error for empty field"))
            }

            // **Date Selection**
            if !recurring {
//                DateField(title: "Select Date", dateText: $dateText, action: { showDatePicker.toggle() })
                DateField(
                    title: NSLocalizedString("select_date", comment: "Label for selecting a single date"),
                    dateText: $dateText,
                    action: { showDatePicker.toggle() }
                )

                if showDateError {
//                    ErrorMessage(text: "This field is required")
                    ErrorMessage(text: NSLocalizedString("error_required_field", comment: "Validation error for empty field"))
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
//                        ErrorMessage(text: "This field is required")
                        ErrorMessage(text: NSLocalizedString("error_required_field", comment: "Validation error for empty field"))
                    }
                }
            }
           


            // **Date Picker Modal**
            if showDatePicker {
                VStack {
                    DatePicker("Select Date", selection: Binding(
                        get: {
                            if !recurring { return startDate }
                            return isSelectingStartDate ? startDate : endDate
                        },
                        set: { newValue in
                            if !recurring {
                                startDate = newValue
                                dateText = formatDate(newValue)
                                if let date = dateText, !date.isEmpty {
                                            showDateError = false
                                        }
                            } else {
                                if isSelectingStartDate {
                                    startDate = newValue
                                    startDateText = formatDate(newValue)
                                } else {
                                    endDate = newValue
                                    endDateText = formatDate(newValue)
                                }
                                if let start = startDateText, !start.isEmpty,
                                           let end = endDateText, !end.isEmpty {
                                            showRecurringDateError = false
                                        }
                            }
                            showDatePicker = false
                        }
                    ), displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
                }
            }
            
            // **Memo Field**
            //TextField("Memo", text: $memo)
            TextField(NSLocalizedString("memo", comment: "Placeholder for memo field"), text: $memo)

                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .onChange(of: memo) { newValue in
                    if !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        showMemoError = false
                    }
                }
            if showMemoError {
               // ErrorMessage(text: "This field is required")
                ErrorMessage(text: NSLocalizedString("error_required_field", comment: "Validation error for empty field"))
            }
        }
        .padding()
    }

}
//end

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


struct AnotherMemberTransferForm: View {
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

    @StateObject private var contactManager = ContactManager()
       
    var body: some View {
        VStack(spacing: 15) {
            // Error message for insufficient funds
            if showInsufficientFundsError {
//                ErrorMessageView(text: "Payment failed. This transfer amount exceeds your transaction limit.")
                ErrorMessageView(text: NSLocalizedString("error_transaction_limit", comment: "Shown when transfer amount exceeds allowed limit"))

            }

            // **Transfer From Account Selection**
//            AccountSelectionButton(title: "Transfer From", account: $selectedFromAccount) {
//                isTransferFromSheetPresented.toggle()
//            }
            AccountSelectionButton(
                title: NSLocalizedString("transfer_from", comment: "Label for selecting the source account"),
                account: $selectedFromAccount
            ) {
                isTransferFromSheetPresented.toggle()
            }

            .sheet(isPresented: $isTransferFromSheetPresented) {
                TransferAccountSheet(
                    accountManager: accountManager,  // Add this
                    selectedAccount_from: $selectedFromAccount,
                    isPresented: $isTransferFromSheetPresented  // Add this
                )
            }


            // **Transfer To Contact Selection**
//            ContactSelectionButton(title: "Select Contact", contact: selectedContact)
            ContactSelectionButton(
                title: NSLocalizedString("select_contact", comment: "Label for selecting a contact"),
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
                ErrorMessage(text: NSLocalizedString("error_required_field", comment: "Validation error for empty field"))
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
                .keyboardType(.decimalPad)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .onChange(of: amount) { newValue in
                    //amount = formatCurrencyInput(newValue)
                    amount = CurrencyFormatter.format(newValue)
                    if !newValue.trimmingCharacters(in: .whitespaces).isEmpty {
                            showAmountError = false // Hide error as soon as user types
                        }
                }

            if showAmountError {
                //ErrorMessage(text: "This field is required")
                ErrorMessage(text: NSLocalizedString("error_required_field", comment: "Validation error for empty field"))
            }

            // **Date Selection**
            if !recurring {
//                DateField(title: "Select Date", dateText: $dateText, action: { showDatePicker.toggle() })
                DateField(
                    title: NSLocalizedString("select_date", comment: "Label for selecting a single date"),
                    dateText: $dateText,
                    action: { showDatePicker.toggle() }
                )
                if showDateError {
                    //ErrorMessage(text: "This field is required")
                    ErrorMessage(text: NSLocalizedString("error_required_field", comment: "Validation error for empty field"))
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
                        ErrorMessage(text: NSLocalizedString("error_required_field", comment: "Validation error for empty field"))
                    }
                }
            }

            // **Date Picker Modal**
            if showDatePicker {
                VStack {
                    DatePicker("Select Date", selection: Binding(
                        get: {
                            if !recurring { return startDate }
                            return isSelectingStartDate ? startDate : endDate
                        },
                        set: { newValue in
                            if !recurring {
                                startDate = newValue
                                dateText = formatDate(newValue)
                                
                                if let date = dateText, !date.isEmpty {
                                            showDateError = false
                                        }
                            } else {
                                if isSelectingStartDate {
                                    startDate = newValue
                                    startDateText = formatDate(newValue)
                                } else {
                                    endDate = newValue
                                    endDateText = formatDate(newValue)
                                }
                                if let start = startDateText, !start.isEmpty,
                                           let end = endDateText, !end.isEmpty {
                                            showRecurringDateError = false
                                        }
                                    
                            }
                            showDatePicker = false
                        }
                    ), displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
                    
                }
                
            }

            // **Memo Field**
            //TextField("Memo", text: $memo)
            TextField(NSLocalizedString("memo", comment: "Placeholder for memo field"), text: $memo)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .onChange(of: memo) { newValue in
                        if !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            showMemoError = false
                        }
                    }


            if showMemoError {
                //ErrorMessage(text: "This field is required")
                ErrorMessage(text: NSLocalizedString("error_required_field", comment: "Validation error for empty field"))
            }
        }
        .padding()
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
    @Binding var selectedContact: Contact?


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
                        isAnotherMemberSelected: isAnotherMemberSelected,   //
                        selectedContact: selectedContact,
                        isRecurring: isRecurring,                          //
                                selectedFrequency: selectedFrequency,              //
                                startDateText: startDateText,                      //
                                endDateText: endDateText
                    )
                }
    }
}

struct SummarySheet: View { //SummarySheet
    var fromAccount: BankAccount?
    var toAccount: BankAccount?
    var amount: String
    var dateText: String
    var memo: String
    
    var isAnotherMemberSelected: Bool //  Add this
     var selectedContact: Contact?
    
    var isRecurring: Bool                          // New
        var selectedFrequency: String?                 // New
        var startDateText: String?                     // New
        var endDateText: String?
    @State private var navigateToMainView = false

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            // Payment Sent Message
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.white)
                    .font(.title3)
                Text("Payment Sent")
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
                Text("Payment Summary")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)

                Divider()
//25 march
                PaymentDetailRow(
                    title: NSLocalizedString("transfer_from", comment: "Label for the source account in transfer details"),
                    value: "\(fromAccount?.accountName ?? NSLocalizedString("no_account", comment: "Fallback when no account")) - \(fromAccount?.accountNumber ?? "")",
                    bold: true
                )


//                PaymentDetailRow(title: "Transfer from",
//                    value: "\(fromAccount?.accountName ?? "No Account") - \(fromAccount?.accountNumber ?? "")", bold: true)

//                PaymentDetailRow(title: "Transfer to",
//                    value: "\(toAccount?.accountName ?? "No Account") - \(toAccount?.accountNumber ?? "")", bold: true)
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
//                PaymentDetailRow(title: "Amount", value: "\(amount)", bold: true)
                PaymentDetailRow(
                    title: NSLocalizedString("amount", comment: "Label for transfer amount"),
                    value: "\(amount)",
                    bold: true
                )


                //PaymentDetailRow(title: "Date", value: dateText, bold: false)
                // Recurring vs One-Time logic here
//                if isRecurring {
//                       PaymentDetailRow(
//                           title: "Payment Type",
//                           value: "Recurring",
//                           bold: true
//                       )
//
//                       PaymentDetailRow(
//                           title: "Frequency",
//                           value: selectedFrequency ?? "N/A",
//                           bold: false
//                       )
//
//                       PaymentDetailRow(
//                           title: "Start Date",
//                           value: startDateText ?? "N/A",
//                           bold: false
//                       )
//
//                       PaymentDetailRow(
//                           title: "End Date",
//                           value: endDateText ?? "N/A",
//                           bold: false
//                       )
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
                           value: dateText ?? NSLocalizedString("na", comment: "Not available fallback"),
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
                //Text("Select Contact")
                Text(NSLocalizedString("select_account", comment: ""))

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
            
            // Search Bar
            //TextField("Search", text: $searchText)
            TextField(NSLocalizedString("search", comment: ""), text: $searchText)
                .padding(10)
                .background(Color(.white))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10) // Border shape
                        .stroke(Color.black, lineWidth: 1) // Border color & width
                )
                .padding(.horizontal)
            
            
            
            // Contact List (Filtered)
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(filteredContacts) { contact in
                        Button(action: {
                            selectedContact = contact
                            isPresented = false
                        }) {
                            HStack {
                                //  Show only name
                                Text(contact.name)
                                    .font(.headline)
                                    .bold()
                                    .bold()
                                    .foregroundColor(.black)
                                
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
            //.frame(maxHeight: .infinity) // Ensures ScrollView expands fully
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal)
        .presentationDetents([.medium, .large])
    }
}






struct TransferAccountSheet: View {
    @ObservedObject var accountManager: AccountManager
    @Binding var selectedAccount_from: BankAccount? // Unique variable for "Transfer From"
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            headerView
            accountListView
        }
        .padding(.horizontal)
        .presentationDetents([.medium, .large]) // Allows swipe-up bottom sheet
    }

    /// Extracted Header
    private var headerView: some View {
        HStack {
            Text(NSLocalizedString("transfer_from", comment: ""))
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
    }

    /// Extracted Account List
    private var accountListView: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(accountManager.accounts) { account in
                    accountButton(for: account)
                }
            }
            .padding()
        }
    }

    /// Extracted Button Component
    private func accountButton(for account: BankAccount) -> some View {
        Button(action: {
            selectedAccount_from = account
            isPresented = false
            print("Selected Account From: \(account.accountName)")
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
                if let selected = selectedAccount_from, selected.id == account.id {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }

            }
            .padding()
            .background {
                if let selected = selectedAccount_from, selected.id == account.id {
                    Color.blue.opacity(0.2)
                } else {
                    Color(.systemGray6)
                }
            }


            .cornerRadius(10)
        }
    }
}


struct SendToSheet: View {
    @ObservedObject var accountManager_to: AccountManager
    @Binding var selectedAccount_to: BankAccount? // Unique variable for "Send To"
    @Binding var isPresented_to: Bool
    var excludeAccount: BankAccount? // Add this//

    @State private var filteredAccounts: [BankAccount] = []
    var body: some View {
        VStack {
            headerView
            accountListView
        }
        .padding(.horizontal)
        .presentationDetents([.medium, .large]) // Allows swipe-up bottom sheet
    }

    /// Extracted Header
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

    /// Extracted Account List.
    private var accountListView: some View {
        ScrollView {
            VStack(spacing: 10) {
                let filteredAccounts = accountManager_to.accounts.filter {
                    $0.id != excludeAccount?.id
                }

                ForEach(filteredAccounts) { account in
                                       accountButton(for: account)
                                   
              

                }
            }
            .padding()
        }
        .onAppear {
                    filteredAccounts = accountManager_to.accounts.filter { $0.id != excludeAccount?.id }
                }
    }

    /// Extracted Button Component
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
                if let selected = selectedAccount_to, selected.id == account.id
                {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }

            }
            .padding()
            .background {
                if let selected = selectedAccount_to, selected.id == account.id {
                    Color.blue.opacity(0.2)
                } else {
                    Color(.systemGray6)
                }
            }


            .cornerRadius(10)
        }
    }
}
private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }




struct TransferMoneyScreen_Previews: PreviewProvider {
    static var previews: some View {
        //TransferMoneyScreen(showContactSheet: .constant(false))
        TransferMoneyScreen()
    }
}
