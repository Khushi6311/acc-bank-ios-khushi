import SwiftUI

//below struct for showing multiple field of multiple payee
struct PayeePaymentDetails: Identifiable {
    let payee: Payee
    var amount: String
    var date: Date? = nil
    var id: String { payee.id }
    var startDate: Date? = nil    // for recurring
    var endDate: Date? = nil
    var frequency: String = "monthly"
    var showAmountError: Bool = false
     var showDateError: Bool = false
    var showCalendar: Bool = false
    
}
struct PayeeRecurringDetails: Identifiable {
    let id = UUID()
    let payee: Payee
    var amount: String
    var frequency: String
    var startDate: Date?
    var endDate: Date?

    var showAmountError = false
    var showStartDateError = false
    var showEndDateError = false
}


//common struct buttons and all
struct PayBillScreen: View {
    @State private var selectedDate = Date() // Date for the DatePicker
        @State private var showDatePicker = false // Toggle for DatePicker visibility
 

    //@Environment(\.presentationMode) var presentationMode // To dismiss the modal
    @StateObject private var accountManager = AccountManager()
    //@ObservedObject var accountManager: AccountManager

    @State private var selectedPaymentType: String? = "One-time Payment" //Track selected payment type
    @State private var showAccountSheet = false // Toggle for full-screen modal
    @State private var selectedContact: Contact?
    @State private var showContactSheet = false // Show Contact Selection Sheet
    @State private var showAddContactSheet = false // New state to show Add Contact form

    @State private var payFrom = ""
    @State private var payee = ""
    @State private var amount = ""
    @State private var date = Date()
    @State private var formattedDate: String? = nil
    @State private var selectedFrequency = "Weekly"
    // States required
    @State private var isSelectingStartDate = true
    @State private var selectedStartDate = Date()
    @State private var selectedEndDate = Date()
    @State private var formattedStartDate: String? = nil
    @State private var formattedEndDate: String? = nil
    @State private var isTransferFromSheetPresented = false
    @State private var showBillConfirmationSheet = false


    @State private var selectedFromAccount: BankAccount?
    @State private var showAccountError = false
    @State private var showContactError = false
    @State private var showAmountError = false
    @State private var showDateError = false
    @State private var showStartDateError = false
    @State private var showEndDateError = false
    @State private var startDate = Date()
    @State private var endDate = Date()
     // for payee
    @StateObject private var viewModel = PayeeViewModel()
    @State private var showPayeeSheet = false
    //@State private var selectedPayee: Payee?
    @State private var selectedPayees: [Payee] = []
    @State private var payeePaymentDetails: [PayeePaymentDetails] = []
    @State private var payeeRecurringDetails: [PayeeRecurringDetails] = []

    
    @Environment(\.dismiss)  var dismiss

    var body: some View {
        //ScrollView {
            VStack (spacing: 0){
                // Top Bar with Back Button
                HStack {
                    Button(action: {
                        //presentationMode.wrappedValue.dismiss()
                        dismiss()

                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text(NSLocalizedString("make_payment", comment: ""))
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding()
                HStack(spacing: 0)  {

                    HStack(spacing: 0) {
                            Button(action: { selectedPaymentType = "One-time Payment"
                                
                               
}) {
                                //Text("One-time ")
                    Text(NSLocalizedString("one_time_payment", comment: "Title for one_time_payment tab"))

                        //.font(.headline)
                            .font(.system(size: 14)) //  Set a smaller font size

                            .padding()
                            .frame(maxWidth: .infinity)
//                                    .background(selectedPaymentType == "My accounts" ? Constants.backgroundGradient : Color.clear)
                            .background(
                                selectedPaymentType == "One-time Payment"
                                            ? AnyView(Constants.backgroundGradient)
                                            : AnyView(Color.clear)
                                    )

                                    .foregroundColor(selectedPaymentType == "One-time Payment" ? .white : .gray)
                                    .cornerRadius(30)
                            }

                            Button(action: { selectedPaymentType = "Recurring Payment"
                                
}) {
                                //Text("Recurring")
    Text(NSLocalizedString("recurring_payment", comment: "Title for 'My accounts' tab"))

                                    //.font(.headline)
        .font(.system(size: 14)) // Set a smaller font size

                                    .padding()
                                    .frame(maxWidth: .infinity)
//                                    .background(selectedPaymentType == "Another member" ? Constants.backgroundGradient : Color.clear)
                                    .background(
                                        selectedPaymentType == "Recurring Payment"
                                            ? Constants.backgroundGradient
                                            : LinearGradient(gradient: Gradient(colors: [Color.clear, Color.clear]),
                                                             startPoint: .leading,
                                                             endPoint: .trailing)
                                    )

                                    .foregroundColor(selectedPaymentType == "Recurring Payment" ? .white : .gray)
                                    .cornerRadius(30)
                            }
                        }
                        .cornerRadius(30)
                    //}
                }
                //.padding(.horizontal)
                .padding(1)

                .background(Color(.systemGray5)) // this brings back the soft gray pill background
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.horizontal)
                // Spacer().frame(height: 30)

                ScrollView {
                    VStack{
                        if selectedPaymentType == "One-time Payment" {
                            
                            OneTimePaymentForm(
                                accountManager: accountManager,
                                selectedContact: $selectedContact,
                                               
                                               
                                               showAccountSheet: $showAccountSheet,
                                               showContactSheet: $showContactSheet,
                                               showAddContactSheet: $showAddContactSheet,
                                               amount: $amount,
                                               showDatePicker: $showDatePicker,
                                               selectedDate: $selectedDate,
                                               formattedDate: $formattedDate, //  Add this binding

                                               selectedFromAccount: $selectedFromAccount,
                                               isTransferFromSheetPresented:$isTransferFromSheetPresented,
                                               showBillConfirmationSheet: $showBillConfirmationSheet,
                                               showAccountError: $showAccountError,
                                               showContactError: $showContactError,
                                               showAmountError: $showAmountError,
                                               showDateError: $showDateError,
                                               viewModel: viewModel,                    // Pass PayeeViewModel
                                               selectedPayees: $selectedPayees,           // Pass selected payee
                                               showPayeeSheet: $showPayeeSheet,
                                               payeePaymentDetails: $payeePaymentDetails
                              
                                               
                                               
                            )
                            .padding(.top,15)
                            
                        } else if selectedPaymentType == "Recurring Payment" {
                            RecurringPaymentForm(
                                accountManager: accountManager,
                                selectedContact: $selectedContact,
                                showAccountSheet: $showAccountSheet,
                                showContactSheet: $showContactSheet,
                                showAddContactSheet: $showAddContactSheet,
                                amount: $amount,
                                showDatePicker: $showDatePicker,
                                selectedDate: $selectedDate,
                                selectedStartDate: $selectedStartDate,
                                selectedEndDate: $selectedEndDate,
                                formattedStartDate: $formattedStartDate,
                                formattedEndDate: $formattedEndDate,
                                isSelectingStartDate: $isSelectingStartDate,
                                selectedFrequency: $selectedFrequency,
                                selectedFromAccount: $selectedFromAccount,
                                isTransferFromSheetPresented: $isTransferFromSheetPresented,
                                showAccountError: $showBillConfirmationSheet,
                                showContactError: $showAccountError,
                                showAmountError: $showContactError,
                                showStartDateError: $showAmountError,
                                showEndDateError: $showStartDateError,
                                showBillConfirmationSheet: $showEndDateError,
                                showPayeeSheet: $showPayeeSheet, viewModel: viewModel,                    // Pass PayeeViewModel
                                selectedPayees: $selectedPayees,
                                payeeRecurringDetails:$payeeRecurringDetails
                                    
                            )
                            .padding(.top,30)

                            
                        }
                        
                    }
            }
                .onChange(of: selectedPaymentType) {
                    // Reset all form states when switching tabs
                    amount = ""
                    formattedDate = nil
                    showDatePicker = false
                    showAccountError = false
                    showContactError = false
                    showAmountError = false
                    showDateError = false
                    showStartDateError = false
                    showEndDateError = false
                    showBillConfirmationSheet = false
                    selectedPayees.removeAll()
                    payeePaymentDetails.removeAll()
                    payeeRecurringDetails.removeAll()
                    formattedStartDate = nil
                    formattedEndDate = nil
                    selectedStartDate = Date()
                    selectedEndDate = Date()
                    selectedFrequency = "Weekly"
                }


       }
    }
}
//one time payment form
struct OneTimePaymentForm: View {
    @ObservedObject var accountManager: AccountManager
    @Binding var selectedContact: Contact?
    @Binding var showAccountSheet: Bool
    @Binding var showContactSheet: Bool
    @Binding var showAddContactSheet: Bool
    @Binding var amount: String
    @Binding var showDatePicker: Bool
    @Binding var selectedDate: Date
    @Binding var formattedDate:String?
    @Binding var selectedFromAccount: BankAccount?
    @Binding var isTransferFromSheetPresented: Bool
    @Binding var showBillConfirmationSheet: Bool
    @Binding var showAccountError:Bool
    @Binding var showContactError:Bool
    @Binding var showAmountError:Bool
    @Binding var showDateError:Bool
    @ObservedObject var viewModel: PayeeViewModel
    @Binding var selectedPayees: [Payee]
    @Binding var showPayeeSheet: Bool
    @Binding var payeePaymentDetails: [PayeePaymentDetails]

    @State private var bannerErrorMessage: String?

    var body: some View {
        VStack(spacing: 15) {
            if let message = bannerErrorMessage {
                OnetimeErrorMessageView(text: message)
                    .transition(.opacity)
            }

            // Pay From
            Text(NSLocalizedString("pay_from", comment: ""))
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: { isTransferFromSheetPresented = true }) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(accountManager.selectedAccount?.accountName ?? NSLocalizedString("select_account", comment: ""))
                            .font(.headline)
                            .bold()
                            .foregroundColor(.black)

                        Text(accountManager.selectedAccount?.accountType ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Text(accountManager.selectedAccount?.accountNumber ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text(accountManager.selectedAccount?.balance ?? "")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)
                    Image(systemName: "chevron.down")
                        .foregroundColor(.black)
                }
                
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            

                .sheet(isPresented: $isTransferFromSheetPresented) {
                    BillAccountSelectionSheet(
                        accountManager: accountManager,  // Add this
                        //selectedAccount_from: $selectedFromAccount,
                        isPresented: $isTransferFromSheetPresented, selectedFromAccount: $selectedFromAccount  // Add this
                    )
                }
            }
//            FieldErrorView(message: "Please select an account", show: $showAccountError)

            // Payee
            Text(NSLocalizedString("payee", comment: ""))
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: {
                showPayeeSheet = true
                showContactError = false}) {
                HStack {
                    //Text(NSLocalizedString("payee", comment: ""))
                    //for payee
//                    Text(selectedPayee?.name ?? NSLocalizedString("payee", comment: "Placeholder for payee selection"))
//                            .foregroundColor(selectedPayee == nil ? .blue : .blue)
                    //for payees
//                    Text(selectedPayees.isEmpty ? "Select payee(s)" : selectedPayees.map { $0.name }.joined(separator: ", "))
                    Text(
                        selectedPayees.isEmpty
                            ? "Select payee(s)"
                            : selectedPayees.count == 1
                                ? selectedPayees.first?.name ?? ""
                                : "\(selectedPayees.count) Payees selected"
                    )

                        .foregroundColor(selectedPayees.isEmpty ? .blue : .black)

                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }

            .sheet(isPresented: $showPayeeSheet) {
                //PayeeListView()
                PayeeListView(
                    viewModel: PayeeViewModel(),
selectedPayees: $selectedPayees, showPayeeSheet: $showPayeeSheet)

            }
            FieldErrorView(message: NSLocalizedString("error_required_field", comment: "Payee is required"), show: $showContactError)


//            FieldErrorView(message: NSLocalizedString("error_required_field", comment: "Amount is required"), show: $showContactError)
            // Add Contact
            Button(action: { showAddContactSheet = true }) {
                HStack {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.colorBlue)
                        .clipShape(Circle())
                    Text(NSLocalizedString("add_payee", comment: ""))
                        .foregroundColor(.colorBlue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.vertical)
            //
            if selectedPayees.count > 1 {
                ForEach($payeePaymentDetails) { $detail in
                        MultiPayeeDetailView(detail: $detail)
                    }
               
            }
            else {
                // Fallback for one payee — original single amount/date fields
                TextField(NSLocalizedString("enter_transfer_amount", comment: ""), text: $amount)
                    //.keyboardType(.decimalPad)
                    .keyboardType(.numbersAndPunctuation)
                      .submitLabel(.done)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .onChange(of: amount) { oldValue,newValue in
                        amount = CurrencyFormatter.format(newValue)
                        if !newValue.trimmingCharacters(in: .whitespaces).isEmpty {
                            showAmountError = false
                        }
                    }
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                        showDatePicker = false
                    }
                FieldErrorView(message: NSLocalizedString("error_required_field", comment: "Amount is required"), show: $showAmountError)

                DateField(title: NSLocalizedString("date", comment: "date"),
                          dateText: $formattedDate) {
                    UIApplication.shared.endEditing()
                    showDatePicker=true
                }
                FieldErrorView(message: NSLocalizedString("error_required_field", comment: "Date is required"), show: $showDateError)

                if showDatePicker {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .onChange(of: selectedDate, initial: false) { oldValue, newValue in
                            let formatter = DateFormatter()
                            formatter.dateStyle = .medium
                            formattedDate = formatter.string(from: newValue)
                            showDatePicker = false
                            showDateError=false
                        }
                }
            }



                        Spacer()
                    }
//        .onTapGesture {
//                UIApplication.shared.endEditing()
//            }
                    .padding()

                    .onChange(of: selectedPayees) { oldValue, newValue in
                        let currentIDs = payeePaymentDetails.map { $0.payee.id }

                        for payee in newValue where !currentIDs.contains(payee.id) {
                            payeePaymentDetails.append(PayeePaymentDetails(payee: payee, amount: "", date: nil))
                        }
                            
                        payeePaymentDetails.removeAll { detail in
                            !newValue.contains(where: { $0.id == detail.payee.id })
                        }

                        // Optional: Reset single fields if switching to multiple payees
                        if newValue.count > 1 {
                            amount = ""
                            formattedDate = nil
                        }
                    }


        Button(action: {
            if selectedPayees.count > 1 {
                    let result = OneTimePaymentFormValidator.validateMultiplePayees(
                        selectedFromAccount: selectedFromAccount,
                        payeeDetails: payeePaymentDetails
                    )

                    showAccountError = result.showAccountError
                    payeePaymentDetails = result.updatedDetails

                    if result.balanceExceededError {
                        bannerErrorMessage = "Payment failed. The total payment amount exceeds your account balance."
                        return
                    }

                    if result.isFormValid {
                        bannerErrorMessage = nil
                        DispatchQueue.main.async {
                            showBillConfirmationSheet = true
                        }
                    }

                } else {
                    let result = OneTimePaymentFormValidator.validateSinglePayee(
                        selectedFromAccount: accountManager.selectedAccount,
                        amount: amount,
                        formattedDate: formattedDate,
                        selectedDate: selectedDate,
                        selectedPayees: selectedPayees
                    )

                    showAccountError = result.showAccountError
                    showAmountError = result.showAmountError
                    showDateError = result.showDateError
                    showContactError = result.showContactError

                    if result.balanceExceededError {
                        bannerErrorMessage = "Payment failed. This transfer amount exceeds your account balance."
                        return
                    }

                    if result.isFormValid {
                        bannerErrorMessage = nil
                        payeePaymentDetails = result.syncedSinglePayeeDetails
                        DispatchQueue.main.async {
                            showBillConfirmationSheet = true
                        }
                    }
                }
            })
        {
                //Text("Continue")
                Text(NSLocalizedString("continue",comment: ""))
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    //.background(Color.black)
                    .background(Constants.backgroundGradient)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            .sheet(isPresented: $showBillConfirmationSheet) {
                BillConfirmationSheet(
                    fromAccount: selectedFromAccount,
                    toContact: selectedContact,
                   
                    amount: amount,
                    date: formattedDate ?? "",
                    selectedPayees: selectedPayees,
                    payeeDetails: payeePaymentDetails

                    
                )
            }
            
        }
       
}



//}
//}




//8 april
struct OneTimePaymentFormValidator {
    static func validateSinglePayee(
        selectedFromAccount: BankAccount?,
        amount: String,
        formattedDate: String?,
        selectedDate: Date,
        selectedPayees: [Payee]
    ) -> (
        showAccountError: Bool,
        showAmountError: Bool,
        showDateError: Bool,
        showContactError: Bool,
        balanceExceededError: Bool,
        isFormValid: Bool,
        syncedSinglePayeeDetails: [PayeePaymentDetails]
    ) {
        let showAccountError = selectedFromAccount == nil
        let showContactError = selectedPayees.isEmpty
        let showAmountError = amount.trimmingCharacters(in: .whitespaces).isEmpty
        let showDateError = formattedDate?.trimmingCharacters(in: .whitespaces).isEmpty ?? true

        var balanceExceededError = false
        var syncedDetails: [PayeePaymentDetails] = []

        if let account = selectedFromAccount,
           let balance = Double(account.balance.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")),
           let enteredAmount = Double(amount.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")),
           !showAmountError {
            balanceExceededError = enteredAmount > balance
        }

        if let payee = selectedPayees.first {
            syncedDetails = [PayeePaymentDetails(payee: payee, amount: amount, date: selectedDate)]
        }

        let isFormValid = !showAccountError && !showAmountError && !showDateError && !showContactError && !balanceExceededError

        return (
            showAccountError,
            showAmountError,
            showDateError,
            showContactError,
            balanceExceededError,
            isFormValid,
            syncedDetails
        )
    }


    static func validateMultiplePayees(
        selectedFromAccount: BankAccount?,
        payeeDetails: [PayeePaymentDetails]
    ) -> (
        showAccountError: Bool,
        balanceExceededError: Bool,
        isFormValid: Bool,
        updatedDetails: [PayeePaymentDetails]
    ) {
        var isValid = true
        var totalAmount: Double = 0.0
        var updatedDetails: [PayeePaymentDetails] = []

        for var detail in payeeDetails {
            let amountStr = detail.amount.trimmingCharacters(in: .whitespaces)
            let date = detail.date

            detail.showAmountError = amountStr.isEmpty
            detail.showDateError = (date == nil)

            if amountStr.isEmpty || date == nil {
                isValid = false
            }

            if let value = Double(amountStr.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")) {
                totalAmount += value
            }

            updatedDetails.append(detail)
        }

        var balanceExceededError = false
        let showAccountError = selectedFromAccount == nil

        if let account = selectedFromAccount,
           let balance = Double(account.balance.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")) {
            balanceExceededError = totalAmount > balance
        }

        isValid = isValid && !showAccountError && !balanceExceededError

        return (
            showAccountError,
            balanceExceededError,
            isValid,
            updatedDetails
        )
    }
}

//error message code
struct OnetimeErrorMessageView: View {
    let text: String

    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill") //Alert icon
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

// if multiple payye are selcted in one time form then show using this
struct MultiPayeeDetailView: View {
    @Binding var detail: PayeePaymentDetails
    @FocusState private var focusedField: FieldFocus?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(detail.payee.name)
                .font(.headline)

            TextField("Amount", text: $detail.amount)
                //.keyboardType(.decimalPad)
                .keyboardType(.numbersAndPunctuation)
                  .submitLabel(.done)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                .onChange(of: detail.amount) { oldValue,newValue in
                    detail.amount = CurrencyFormatter.format(newValue)
                    if !newValue.trimmingCharacters(in: .whitespaces).isEmpty {
                        detail.showAmountError = false
                    }
                }
            FieldErrorView(
                message: NSLocalizedString("error_required_field", comment: "Amount is required"),
                show: $detail.showAmountError
            )
            .focused($focusedField, equals: .amount)
            .onTapGesture {
                focusedField = nil
            }
//            if detail.showCalendar {
//                let dateBinding = Binding<Date>(
//                    get: { detail.date ?? Date() },
//                    set: {
//                        detail.date = $0
//                        detail.showCalendar = false
//                    }
//                )
//
//                DatePicker("Select Date", selection: dateBinding,
//                           in: Date.distantPast...Date.distantFuture,displayedComponents: .date)
//                    .datePickerStyle(GraphicalDatePickerStyle())
//                    .padding()
//                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
            if detail.showCalendar {
                let dateBinding = Binding<Date>(
                    get: {
                        // Just return a fallback for DatePicker, don't set detail.date here
                        detail.date ?? Date()
                    },
                    set: { newDate in
                        // Set detail.date only when user actually picks a date
                        detail.date = newDate
                        detail.showCalendar = false
                        detail.showDateError = false
                        print("Selected Date for \(detail.payee.name): \(newDate)")
                    }
                )
                    

                DatePicker("Select Date", selection: dateBinding, in: Date.distantPast...Date.distantFuture, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
            

                
            } else {
                Button {
//                    if detail.date == nil {
//                                detail.date = Date() // Ensure today is set before opening calendar
//                            }
                    detail.showCalendar = true
                } label: {
                    HStack {
//                        Text(detail.date != nil ? formattedDate(detail.date!) : "Select date")
//                            .foregroundColor(.gray)
                        Text(detail.date != nil ? formattedDate(detail.date!) : "Select date")
                                       .foregroundColor(detail.date != nil ? .primary : .gray)

                       
                        Spacer()
                        
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                        
                    }
                    
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                    
                }
                FieldErrorView(
                    message: NSLocalizedString("error_required_field", comment: "Date is required"),
                    show: $detail.showDateError
                )
                
            }
        }
        .padding(.vertical)
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

//show list of payee from json from bottom sheet
struct PayeeListView: View {
    @ObservedObject var viewModel = PayeeViewModel()
    @Binding var selectedPayees: [Payee]
    @Binding var showPayeeSheet: Bool
    @State private var searchText = ""

    var filteredPayees: [Payee] {
        searchText.isEmpty
        ? viewModel.payees
        : viewModel.payees.filter {
            $0.name.lowercased().contains(searchText.lowercased()) ||
            $0.accountNumber.contains(searchText)
        }
    }

    var body: some View {
        VStack {
            HStack {
                //Text("Select Payee").font(.headline).bold()
                Text(NSLocalizedString("select_payee", comment: "Label for selecting payee"))
                    .font(.headline)
                    .bold()
                Spacer()
                Button(action: { showPayeeSheet = false }) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.top)

            //TextField("Search", text: $searchText)
            TextField(NSLocalizedString("search", comment: "Placeholder for search input"), text: $searchText)

                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(filteredPayees) { payee in
                        Button(action: {
                            if selectedPayees.contains(where: { $0.id == payee.id }) {
                                selectedPayees.removeAll { $0.id == payee.id }
                            } else {
                                selectedPayees.append(payee)
                            }
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(payee.name).font(.headline).bold().foregroundColor(.black)
                                    Text("Account: \(payee.accountNumber)").font(.subheadline).foregroundColor(.gray)
                                    Text("Bank: \(payee.bank)").font(.subheadline).foregroundColor(.gray)
                                }
                                Spacer()
                                if selectedPayees.contains(where: { $0.id == payee.id }) {
                                    Image(systemName: "checkmark.square.fill").foregroundColor(.blue)
                                } else {
                                    Image(systemName: "square").foregroundColor(.gray)
                                }
                            }
                            .padding()
//                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.systemGray6)))
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedPayees.contains(where: { $0.id == payee.id }) ? Color.blue.opacity(0.2) : Color(UIColor.systemGray6))
                            )

                        }
                    }
                }
                .padding()
            }
        }
        .presentationDetents([.medium, .large])
    }
}





//error msg shows design
struct FieldErrorView: View {
    let message: String
    @Binding var show: Bool

    var body: some View {
        if show {
            Text(message)
                .font(.caption)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}


// recurring payment paymernt code
struct RecurringPaymentForm: View {
    @ObservedObject var accountManager: AccountManager
    @Binding var selectedContact: Contact?
    @Binding var showAccountSheet: Bool
    @Binding var showContactSheet: Bool
    @Binding var showAddContactSheet: Bool
    @Binding var amount: String
    @Binding var showDatePicker: Bool
    @Binding var selectedDate: Date
    @Binding var selectedStartDate: Date
    @Binding var selectedEndDate: Date
    @Binding var formattedStartDate: String?
    @Binding var formattedEndDate: String?
    @Binding var isSelectingStartDate: Bool
    @Binding var selectedFrequency: String
    @Binding var selectedFromAccount: BankAccount?
    @Binding var isTransferFromSheetPresented: Bool
    @Binding var showAccountError: Bool
    @Binding var showContactError: Bool
    @Binding var showAmountError: Bool
    @Binding var showStartDateError: Bool
    @Binding var showEndDateError: Bool
    @Binding var showBillConfirmationSheet: Bool
    @Binding var showPayeeSheet: Bool
    @ObservedObject var viewModel: PayeeViewModel
    @Binding var selectedPayees: [Payee]
    @Binding var payeeRecurringDetails: [PayeeRecurringDetails]
    @FocusState private var focusedField: FieldFocus?
    @State private var bannerErrorMessage: String?

    var body: some View {
        VStack(spacing: 15) {
            if let message = bannerErrorMessage {
                OnetimeErrorMessageView(text: message)
                    .transition(.opacity)
            }

            //Text("Pay from")
            Text(NSLocalizedString("pay_from", comment: ""))

                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: { isTransferFromSheetPresented = true }) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(accountManager.selectedAccount?.accountName ?? "Select account")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.black)
                        Text(accountManager.selectedAccount?.accountType ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(accountManager.selectedAccount?.accountNumber ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text(accountManager.selectedAccount?.balance ?? "")
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
            .sheet(isPresented: $isTransferFromSheetPresented) {
                BillAccountSelectionSheet(accountManager: accountManager, isPresented: $isTransferFromSheetPresented, selectedFromAccount: $selectedFromAccount)
            }

            Button(action: { showPayeeSheet = true }) {
                HStack {
//                    Text(selectedPayees.isEmpty ? "Select payee(s)" : selectedPayees.map { $0.name }.joined(separator: ", "))
                    Text(
                        selectedPayees.isEmpty
                            //? "Select payee(s)"
                        ? NSLocalizedString("select_payees_placeholder", comment: "")
                            : selectedPayees.count == 1
                                ? selectedPayees.first?.name ?? ""
                                : "\(selectedPayees.count) Payees selected"
                    )
                        .foregroundColor(selectedPayees.isEmpty ? .blue : .black)
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .sheet(isPresented: $showPayeeSheet) {
                PayeeListView(viewModel: PayeeViewModel(), selectedPayees: $selectedPayees, showPayeeSheet: $showPayeeSheet)
            }
            //9
            FieldErrorView(message: NSLocalizedString("error_required_field", comment: "Payee is required"), show: $showContactError)

            Button(action: { showAddContactSheet = true
            }) {
                HStack {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.colorBlue)
                        .clipShape(Circle())
                    //Text("Add payee")//add_payee
                    Text(NSLocalizedString("add_payee", comment: ""))

                        .foregroundColor(.colorBlue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.vertical)

            if selectedPayees.count > 1 {
                ForEach($payeeRecurringDetails) { $detail in
                    MultiRecurringPayeeDetailView(detail: $detail)
                }
            } else {
                
                //TextField("Enter amount", text: $amount)
                TextField(NSLocalizedString("enter_transfer_amount", comment: ""), text: $amount)
                    //.keyboardType(.decimalPad)
                    .keyboardType(.numbersAndPunctuation)
                      .submitLabel(.done)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .onChange(of: amount) { oldValue, newValue in
                        amount = CurrencyFormatter.format(newValue)
                        if !newValue.trimmingCharacters(in: .whitespaces).isEmpty {
                            showAmountError = false
                        }
                    }
                    .focused($focusedField, equals: .amount)
                    .onTapGesture {
                        focusedField = nil
                    }
                FieldErrorView(message: NSLocalizedString("error_required_field", comment: "Amount is required"), show: $showAmountError)

                //Text("Select frequency")
                Text(NSLocalizedString("select_frequency", comment: ""))

                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)

//                Picker("Frequency", selection: $selectedFrequency) {
//                    Text("Weekly").tag("weekly")
//                    Text("Monthly").tag("monthly")
//                    Text("Yearly").tag("yearly")
//                }
                Picker(NSLocalizedString("frequency", comment: "Frequency picker label"), selection: $selectedFrequency) {
                    Text(NSLocalizedString("weekly", comment: "Frequency option")).tag("weekly")
                    Text(NSLocalizedString("monthly", comment: "Frequency option")).tag("monthly")
                    Text(NSLocalizedString("yearly", comment: "Frequency option")).tag("yearly")
                }
                .pickerStyle(SegmentedPickerStyle())

//                DateField(title: "Start Date", dateText: $formattedStartDate)
                DateField(title: String(localized: "start_date"), dateText: $formattedStartDate)
{
                    isSelectingStartDate = true
                    
                    showDatePicker.toggle()
                }
                FieldErrorView(message: NSLocalizedString("error_required_field", comment: "Amount is required"), show: $showStartDateError)

//                DateField(title: "End Date", dateText: $formattedEndDate)
                DateField(title: String(localized: "end_date"), dateText: $formattedEndDate){
                    isSelectingStartDate = false
                    showDatePicker.toggle()
                }
                FieldErrorView(message: NSLocalizedString("error_required_field", comment: "Amount is required"), show: $showEndDateError)
            }

            if showDatePicker {
                DatePicker("Select Date", selection: isSelectingStartDate ? $selectedStartDate : $selectedEndDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .onChange(of: isSelectingStartDate ? selectedStartDate : selectedEndDate, initial: false) { _, newValue in
                        let formatter = DateFormatter()
                        formatter.dateStyle = .medium
                        if isSelectingStartDate {
                            formattedStartDate = formatter.string(from: newValue)
                            showStartDateError=false
                            
                        } else {
                            formattedEndDate = formatter.string(from: newValue)
                            showEndDateError=false
                        }
                        withAnimation {
                                        showDatePicker = false
                                    }
                    }
            }

            Button(action: {
                
                if selectedPayees.count > 1 {
                    let result = RecurringPaymentFormValidator.validateMultiplePayees(
                        selectedFromAccount: selectedFromAccount,
                        payeeDetails: payeeRecurringDetails
                    )

                    showAccountError = result.showAccountError
                    payeeRecurringDetails = result.updatedDetails

                    if result.balanceExceededError {
                        bannerErrorMessage = "Payment failed. The total amount exceeds your account balance."
                        return
                    }

                    if result.isFormValid {
                        bannerErrorMessage = nil
                        showBillConfirmationSheet = true
                    }
                } else {
                    let result = RecurringPaymentFormValidator.validateSinglePayee(
                        selectedFromAccount: selectedFromAccount,
                        amount: amount,
                        startDate: formattedStartDate,
                        endDate: formattedEndDate,
                        selectedPayees: selectedPayees,
                        selectedStartDate: selectedStartDate,
                        selectedEndDate: selectedEndDate,
                        frequency: selectedFrequency
                    )

                    showAccountError = result.showAccountError
                    showContactError = result.showContactError
                    showAmountError = result.showAmountError
                    showStartDateError = result.showStartDateError
                    showEndDateError = result.showEndDateError

//                    if result.balanceExceededError {
//                        bannerErrorMessage = "Payment failed. This transfer amount exceeds your account balance."
//                        return
//                    }
                    if result.balanceExceededError {
                        bannerErrorMessage = NSLocalizedString("error_transaction_limit", comment: "")
                        return
                    }


                    if result.isFormValid {
                        bannerErrorMessage = nil
                        showBillConfirmationSheet = true
                    }
                }

            }) {
               // Text("Continue")
                Text(NSLocalizedString("continue", comment: ""))

                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Constants.backgroundGradient)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            .padding(.horizontal, 5)

            .sheet(isPresented: $showBillConfirmationSheet) {
                RecurringBillConfirmationSheet(
                    fromAccount: selectedFromAccount,
                    selectedPayees: selectedPayees,
                    payeeDetails: selectedPayees.count == 1
                        ? [
                            PayeePaymentDetails(
                                payee: selectedPayees[0],
                                amount: amount,
                                date: selectedStartDate, // only used for display
                                startDate: selectedStartDate,
                                endDate: selectedEndDate,
                                frequency: selectedFrequency
                            )
                          ]
                        : payeeRecurringDetails.map {
                            PayeePaymentDetails(
                                payee: $0.payee,
                                amount: $0.amount,
                                date: $0.startDate,
                                startDate: $0.startDate,
                                endDate: $0.endDate,
                                frequency: $0.frequency
                            )
                          }
                )
            }


            
        }
        .padding(.horizontal, 20)
        .onChange(of: selectedPayees) { oldValue,newValue in
            let currentIDs = payeeRecurringDetails.map { $0.payee.id }
            for payee in newValue where !currentIDs.contains(payee.id) {
                payeeRecurringDetails.append(PayeeRecurringDetails(payee: payee, amount: "", frequency: "monthly", startDate: nil, endDate: nil))
            }
            payeeRecurringDetails.removeAll { detail in
                !newValue.contains(where: { $0.id == detail.payee.id })
            }
        }
    }
}

//in recurring payment multiple payee are selected then show feild using this code
struct MultiRecurringPayeeDetailView: View {
    @Binding var detail: PayeeRecurringDetails
    @State private var showStartPicker = false
    @State private var showEndPicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(detail.payee.name)
                .font(.headline)

            // Amount field
            TextField(NSLocalizedString("enter_transfer_amount", comment: ""), text: $detail.amount)

            //TextField("Enter amount", text: $detail.amount)
                //.keyboardType(.decimalPad)
                .keyboardType(.numbersAndPunctuation)
                  .submitLabel(.done)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .onChange(of: detail.amount) { oldValue, newValue in
                    detail.amount = CurrencyFormatter.format(newValue)
                    if !newValue.trimmingCharacters(in: .whitespaces).isEmpty {
                        detail.showAmountError = false
                    }
                }
            FieldErrorView(message: NSLocalizedString("error_required_field", comment: "Amount is required"), show: $detail.showAmountError)
            //Text("Select frequency")
            Text(NSLocalizedString("select_frequency", comment: ""))

                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            // Frequency Picker
//            Picker("Frequency", selection: $detail.frequency) {
//                Text("Weekly").tag("weekly")
//                Text("Monthly").tag("monthly")
//                Text("Yearly").tag("yearly")
//            }

               
            Picker(NSLocalizedString("frequency", comment: "Frequency picker label"), selection: $detail.frequency) {
                Text(NSLocalizedString("weekly", comment: "Frequency option")).tag("weekly")
                Text(NSLocalizedString("monthly", comment: "Frequency option")).tag("monthly")
                Text(NSLocalizedString("yearly", comment: "Frequency option")).tag("yearly")
            }
            .pickerStyle(SegmentedPickerStyle())

            // Start Date
            //DateField(title: "Start Date", dateText: Binding
            DateField(title: String(localized: "start_date"), dateText: Binding(
                get: {
                    if let date = detail.startDate {
                        let formatter = DateFormatter()
                        formatter.dateStyle = .medium
                        return formatter.string(from: date)
                    }
                    return nil
                },
                set: { _ in }
            )) {
                showStartPicker.toggle()
            }

            if showStartPicker {
                DatePicker("Start", selection: Binding(
                    get: { detail.startDate ?? Date() },
                    set: { newVal in
                        detail.startDate = newVal
                        detail.showStartDateError = false
                        withAnimation {
                            showStartPicker = false
                               }
                        //showStartPicker = false
                    }), displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                
                
            }
           

            FieldErrorView(message: NSLocalizedString("error_required_field", comment: "Amount is required"), show: $detail.showStartDateError)

            // End Date
            DateField(title: String(localized: "end_date"), dateText: Binding(
                get: {
                    if let date = detail.endDate {
                        let formatter = DateFormatter()
                        formatter.dateStyle = .medium
                        return formatter.string(from: date)
                    }
                    return nil
                },
                set: { _ in }
            )) {
                showEndPicker.toggle()
            }

            if showEndPicker {
                DatePicker("End", selection: Binding(
                    get: { detail.endDate ?? Date() },
                    set: { newVal in
                        detail.endDate = newVal
                        detail.showEndDateError = false
                        withAnimation {
                            showEndPicker = false
                               }
                        //showEndPicker = false
                    }), displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
            }
            FieldErrorView(message: NSLocalizedString("error_required_field", comment: "Amount is required"), show: $detail.showEndDateError)

            Divider()
        }
        .padding(.vertical, 10)
    }
}




//8 april 2 code
struct RecurringPaymentFormValidator {
    
    static func validateSinglePayee(
        selectedFromAccount: BankAccount?,
        amount: String,
        startDate: String?,
        endDate: String?,
        selectedPayees: [Payee],
        selectedStartDate: Date,
        selectedEndDate: Date,
        frequency: String
    ) -> (
        showAccountError: Bool,
        showContactError: Bool,
        showAmountError: Bool,
        showStartDateError: Bool,
        showEndDateError: Bool,
        balanceExceededError: Bool,
        isFormValid: Bool,
        syncedDetails: [PayeePaymentDetails]
    ) {
        let showAccountError = selectedFromAccount == nil
        let showContactError = selectedPayees.isEmpty
        let showAmountError = amount.trimmingCharacters(in: .whitespaces).isEmpty
        let showStartDateError = startDate?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let showEndDateError = endDate?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true

        var balanceExceededError = false
        var synced: [PayeePaymentDetails] = []

        if let account = selectedFromAccount,
           let balance = Double(account.balance.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")),
           let enteredAmount = Double(amount.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")),
           !showAmountError {
            balanceExceededError = enteredAmount > balance
        }

        if let payee = selectedPayees.first {
            synced = [
                PayeePaymentDetails(
                    payee: payee,
                    amount: amount,
                    date: selectedStartDate,
                    startDate: selectedStartDate,
                    endDate: selectedEndDate,
                    frequency: frequency
                )
            ]
        }

        let isFormValid = !showAccountError && !showContactError && !showAmountError && !showStartDateError && !showEndDateError && !balanceExceededError

        return (
            showAccountError,
            showContactError,
            showAmountError,
            showStartDateError,
            showEndDateError,
            balanceExceededError,
            isFormValid,
            synced
        )
    }

    static func validateMultiplePayees(
        selectedFromAccount: BankAccount?,
        payeeDetails: [PayeeRecurringDetails]
    ) -> (
        showAccountError: Bool,
        balanceExceededError: Bool,
        updatedDetails: [PayeeRecurringDetails],
        isFormValid: Bool
    ) {
        var isValid = true
        var totalAmount: Double = 0.0
        var updatedDetails: [PayeeRecurringDetails] = []

        for var detail in payeeDetails {
            let amountStr = detail.amount.trimmingCharacters(in: .whitespaces)
            let start = detail.startDate
            let end = detail.endDate

            detail.showAmountError = amountStr.isEmpty
            detail.showStartDateError = start == nil
            detail.showEndDateError = end == nil

            if detail.showAmountError || detail.showStartDateError || detail.showEndDateError {
                isValid = false
            }

            if let value = Double(amountStr.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")) {
                totalAmount += value
            }

            updatedDetails.append(detail)
        }

        var balanceExceededError = false
        let showAccountError = selectedFromAccount == nil

        if let account = selectedFromAccount,
           let balance = Double(account.balance.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")) {
            balanceExceededError = totalAmount > balance
        }

        let isFormValid = isValid && !showAccountError && !balanceExceededError

        return (
            showAccountError,
            balanceExceededError,
            updatedDetails,
            isFormValid
        )
    }
}


//select account sheet common for both the sheet
struct BillAccountSelectionSheet: View {
    @ObservedObject var accountManager: AccountManager
    @Binding var isPresented: Bool
    @Binding var selectedFromAccount: BankAccount?
    var body: some View {
        VStack {
            // Header
            HStack {
                //Text("Transfer from")
                Text(NSLocalizedString("transfer_from", comment: ""))
                
                    .font(.headline)
                    .bold()
                Spacer()
                Button(action: {
                    isPresented = false // Close sheet
                }) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            // Account List
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(accountManager.accounts) { account in
                        Button(action: {
//                            accountManager.selectedAccount = account
//                            isPresented = false // Close sheet
                            accountManager.selectedAccount = account
                            self.selectedFromAccount = account
                            isPresented = false

                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    // Account Name (Bold)
                                    Text(account.accountName)
                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(.black)
                                    
                                    // Account Type (New Line)
                                    Text(account.accountType)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    // Account Number (New Line)
                                    Text(account.accountNumber)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                
                                // Balance
                                Text(account.balance)
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.black)
                                
                                if account == accountManager.selectedAccount {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(account == accountManager.selectedAccount ? Color.blue.opacity(0.2) : Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
        }
        .padding(.horizontal)
        .presentationDetents([.medium, .large]) // Allows swipe-up bottom sheet
    }
}

//  confirmation for One time Payment Form
struct BillConfirmationSheet: View {
    var fromAccount: BankAccount?
    var toContact: Contact?
    var amount: String
    var date: String
    var selectedPayees: [Payee] = []
    var payeeDetails: [PayeePaymentDetails] = []

    @State private var navigateToSummary = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text(NSLocalizedString("confirmation", comment: ""))
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
            .padding([.top, .horizontal])

            ScrollView {
                VStack(spacing: 16) {
                    // From Account
                    BillDetailRow(
                        title: NSLocalizedString("pay_from", comment: ""),
                        value: "\(fromAccount?.accountName ?? "") - \(fromAccount?.accountNumber ?? "")"
                    )

                    // Conditional Display
                    if selectedPayees.count == 1 {
                        // Single Payee
                        BillDetailCard {
                            BillDetailRow(title: NSLocalizedString("pay_to", comment: ""),
                                          value: selectedPayees.first?.name ?? "-")

                            BillDetailRow(title: NSLocalizedString("amount", comment: ""),
                                          value: amount)

                            BillDetailRow(title: NSLocalizedString("date", comment: ""),
                                          value: date)
                        }

                    } else {
                        // Multiple Payees
                        ForEach(payeeDetails) { detail in
                            BillDetailCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(NSLocalizedString("pay_to", comment: ""))
                                        .font(.caption)
                                        .foregroundColor(.gray)

                                    Text("\(detail.payee.name) - \(detail.payee.accountNumber)")
                                        .font(.body)
                                        .bold()

                                    Text(NSLocalizedString("amount", comment: ""))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text(detail.amount)
                                        .font(.body)

                                    Text(NSLocalizedString("date", comment: ""))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text(formattedDate(detail.date))
                                        .font(.body)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            )
                            .padding(.vertical, 5)
                        }
                    }
                }
                .padding(.horizontal)
            }

            Spacer()

            Button(action: {
                navigateToSummary = true
            }) {
                Text(NSLocalizedString("pay_now", comment: ""))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .fullScreenCover(isPresented: $navigateToSummary) {
            BillSendSheet(
                fromAccount: fromAccount,
                toContact: toContact,
                amount: amount,
                date: date,
                selectedPayees: selectedPayees,
                payeeDetails: payeeDetails,
                isRecurring: false
            )
        }
    }

    func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "-" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

//confirmation sheet for recurring form
struct RecurringBillConfirmationSheet: View {
    var fromAccount: BankAccount?
    var selectedPayees: [Payee] = []
    var payeeDetails: [PayeePaymentDetails] = [] // contains amount, startDate, endDate, frequency

    @State private var navigateToSummary = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text(NSLocalizedString("confirmation", comment: ""))
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
            .padding([.top, .horizontal])

            ScrollView {
                VStack(spacing: 16) {
                    // From Account
                    BillDetailRow(
                        title: NSLocalizedString("pay_from", comment: ""),
                        value: "\(fromAccount?.accountName ?? "") - \(fromAccount?.accountNumber ?? "")"
                    )

                    // Each payee’s card
                    ForEach(payeeDetails) { detail in
                        BillDetailCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(NSLocalizedString("pay_to", comment: ""))
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                Text("\(detail.payee.name) - \(detail.payee.accountNumber)")
                                    .font(.body)
                                    .bold()

                                Text(NSLocalizedString("amount", comment: ""))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(detail.amount)
                                    .font(.body)

                                Text(NSLocalizedString("start_date", comment: ""))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(formattedDate(detail.startDate))
                                    .font(.body)

                                Text(NSLocalizedString("end_date", comment: ""))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(formattedDate(detail.endDate))
                                    .font(.body)

                                Text(NSLocalizedString("frequency", comment: ""))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                //Text(detail.frequency.capitalized)
                                Text(NSLocalizedString("frequency_\(detail.frequency.lowercased())", comment: ""))

                                    .font(.body)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        )
                        .padding(.vertical, 5)
                    }
                }
                .padding(.horizontal)
            }

            Spacer()

            Button(action: {
                navigateToSummary = true
            }) {
                Text(NSLocalizedString("pay_now", comment: ""))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .fullScreenCover(isPresented: $navigateToSummary) {
            BillSendSheet(
                fromAccount: fromAccount,
                toContact: nil, // Optional: you can pass nil or first payee
                amount: "", // Optional
                date: "",   // Optional
                selectedPayees: selectedPayees,
                payeeDetails: payeeDetails,
                isRecurring: true
            )
        }
    }

    func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "-" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}


//bill card to show selected account on summary and confirmation sheet
struct BillDetailCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            content
        }
        .padding()
        //.background(Color.white)
        //./cornerRadius(12)
        //.shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
//        )
    }
}

//final scrren summary


struct BillSendSheet: View {
    var fromAccount: BankAccount?
    var toContact: Contact?
    var amount: String
    var date: String
    var selectedPayees: [Payee] = []
    var payeeDetails: [PayeePaymentDetails] = []

    var isRecurring: Bool = false

    @State private var navigateToMainView = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // Top green bar
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.title3)
                    Text(NSLocalizedString("payment_sent", comment: ""))
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .cornerRadius(10)
                .padding()

                // Payment Summary
                VStack {
                    Text(NSLocalizedString("payment_summary", comment: ""))
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)

                    Divider()

                    BillDetailRow(
                        title: NSLocalizedString("pay_from", comment: ""),
                        value: "\(fromAccount?.accountName ?? "") - \(fromAccount?.accountNumber ?? "")"
                    )

                    // Modular: One-Time or Recurring summary block
                    if isRecurring {
                        RecurringPayeeSummaryView(selectedPayees: selectedPayees, payeeDetails: payeeDetails)
                    } else {
                        OneTimePayeeSummaryView(selectedPayees: selectedPayees, amount: amount, date: date, payeeDetails: payeeDetails)
                    }

                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
                .padding()

                Spacer()

                // Done button
                Button(action: {
                    navigateToMainView = true
                }) {
                    Text(NSLocalizedString("done", comment: ""))
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $navigateToMainView) {
                    MainView()
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .padding()
    }
}
private struct RecurringPayeeSummaryView: View {
    var selectedPayees: [Payee]
    var payeeDetails: [PayeePaymentDetails]

    var body: some View {
        if selectedPayees.count == 1, let detail = payeeDetails.first {
//            BillDetailRow(title: "Pay to", value: detail.payee.name, bold: true)
//            BillDetailRow(title: "Amount", value: detail.amount)
//            BillDetailRow(title: "Start Date", value: formatted(detail.startDate))
//            BillDetailRow(title: "End Date", value: formatted(detail.endDate))
//            BillDetailRow(title: "Frequency", value: detail.frequency.capitalized)
            BillDetailRow(title: NSLocalizedString("pay_to", comment: ""), value: detail.payee.name, bold: true)
            BillDetailRow(title: NSLocalizedString("amount", comment: ""), value: detail.amount)
            BillDetailRow(title: NSLocalizedString("start_date", comment: ""), value: formatted(detail.startDate))
            BillDetailRow(title: NSLocalizedString("end_date", comment: ""), value: formatted(detail.endDate))
            BillDetailRow(title: NSLocalizedString("frequency", comment: ""), value: detail.frequency.capitalized)

        } else {
            ForEach(payeeDetails) { detail in
                VStack(alignment: .leading, spacing: 8) {
//                    BillDetailRow(title: "Pay to", value: "\(detail.payee.name) - \(detail.payee.accountNumber)", bold: true)
//                    BillDetailRow(title: "Amount", value: detail.amount)
//                    BillDetailRow(title: "Start Date", value: formatted(detail.startDate))
//                    BillDetailRow(title: "End Date", value: formatted(detail.endDate))
//                    BillDetailRow(title: "Frequency", value: detail.frequency.capitalized)
                    BillDetailRow(
                        title: String(localized: "pay_to"),
                        value: "\(detail.payee.name) - \(detail.payee.accountNumber)",
                        bold: true
                    )
                    BillDetailRow(title: String(localized: "amount"), value: detail.amount)
                    BillDetailRow(title: String(localized: "start_date"), value: formatted(detail.startDate))
                    BillDetailRow(title: String(localized: "end_date"), value: formatted(detail.endDate))
//                    BillDetailRow(title: String(localized: "frequency"), value: detail.frequency.capitalized)
                    BillDetailRow(
                        title: NSLocalizedString("frequency", comment: ""),
                        value: NSLocalizedString("frequency_\(detail.frequency.lowercased())", comment: "")
                    )


                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                )
                .padding(.bottom, 8)
            }
        }
    }

    private func formatted(_ date: Date?) -> String {
        guard let date = date else { return "-" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

private struct OneTimePayeeSummaryView: View {
    var selectedPayees: [Payee]
    var amount: String
    var date: String
    var payeeDetails: [PayeePaymentDetails]

    var body: some View {
        if selectedPayees.count == 1, let payee = selectedPayees.first {
            BillDetailRow(title: "Pay to", value: payee.name, bold: true)
            BillDetailRow(title: "Amount", value: amount)
            BillDetailRow(title: "Date", value: date)
        } else {
            ForEach(payeeDetails) { detail in
                VStack(alignment: .leading, spacing: 8) {
                    BillDetailRow(title: "Pay to", value: "\(detail.payee.name) - \(detail.payee.accountNumber)", bold: true)
                    BillDetailRow(title: "Amount", value: detail.amount)
                    BillDetailRow(title: "Date", value: formatted(detail.date))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                )
                .padding(.bottom, 8)
            }
        }
    }

    private func formatted(_ date: Date?) -> String {
        guard let date = date else { return "-" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
//end

//for design purpose
struct BillDetailRow: View {
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
struct PayBillScreen_Previews: PreviewProvider {
    static var previews: some View {
        PayBillScreen()
       // PayBillScreen(accountManager: AccountManager())

    }
}
