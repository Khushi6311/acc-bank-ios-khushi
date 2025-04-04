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

    @Environment(\.presentationMode) var presentationMode // To dismiss the modal
    @StateObject private var accountManager = AccountManager()

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

    


    var body: some View {
        //ScrollView {
            VStack (spacing: 0){
                // Top Bar with Back Button
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
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
//                    ZStack {
//                        LinearGradient(
//                            gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.3)]),
//                            startPoint: .leading,
//                            endPoint: .trailing
//                        )
//                        .cornerRadius(30)

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
                            
                            OneTimePaymentForm(accountManager: accountManager, selectedContact: $selectedContact,
                                               
                                               
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

    
    var body: some View {
        VStack(spacing: 15) {
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
                    AccountSelectionSheet(
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
            Button(action: { showPayeeSheet = true }) {
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
                    .keyboardType(.decimalPad)
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
                        }
                }
            }



                        Spacer()
                    }
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
               if selectedPayees.isEmpty {
                   showAmountError = true
                   showDateError = true
                   print("No payee selected")
                   return
               }

            if selectedPayees.count == 1 {
                // Single payee validation
                let result = OneTimePaymentFormValidator.validate(
                    selectedFromAccount: accountManager.selectedAccount,
                    amount: amount,
                    formattedDate: formattedDate
                )

                showAccountError = result.showAccountError
                showAmountError = result.showAmountError
                showDateError = result.showDateError

                if result.isFormValid {
                    // Sync payeePaymentDetails for single payee
                    if let firstPayee = selectedPayees.first {
                        payeePaymentDetails = [
                            PayeePaymentDetails(payee: firstPayee, amount: amount, date: selectedDate)
                        ]
                    }

                    DispatchQueue.main.async {
                        showBillConfirmationSheet = true
                    }
                }

            } else {
                // Multiple payees — validate each payee's amount and date
                var isValid = true

                    for i in payeePaymentDetails.indices {
                        let amount = payeePaymentDetails[i].amount.trimmingCharacters(in: .whitespaces)
                        let date = payeePaymentDetails[i].date

                        // Set flags to trigger red error messages in UI
                        payeePaymentDetails[i].showAmountError = amount.isEmpty
                        payeePaymentDetails[i].showDateError = (date == nil)

                        // Prevent continue if anything is empty
                        if amount.isEmpty || date == nil {
                            isValid = false
                        }
                    }

                    if selectedFromAccount == nil {
                        showAccountError = true
                        isValid = false
                    }
                    
                    if isValid {
                        DispatchQueue.main.async {
                            showBillConfirmationSheet = true
                        }                } else {
                    print("Validation failed for multi-payee form")
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



//validation of one time
struct OneTimePaymentFormValidator {
        static func validate(
            selectedFromAccount: BankAccount?,
            //selectedContact: Contact?,
            amount: String,
            formattedDate: String?
        ) -> (
           showAccountError: Bool,
           //showContactError: Bool,
            showAmountError: Bool,
            showDateError: Bool,
            isFormValid: Bool
        ) {
            let showAccountError = selectedFromAccount == nil
           //let showContactError = selectedContact == nil
            let showAmountError = amount.trimmingCharacters(in: .whitespaces).isEmpty
            let showDateError = formattedDate?.trimmingCharacters(in: .whitespaces).isEmpty ?? true

           //let isFormValid = !showAccountError && !showContactError && !showAmountError && !showDateError
            let isFormValid = !showAccountError &&  !showAmountError && !showDateError
            return (
                showAccountError,
                //showContactError,
                showAmountError,
                showDateError,
                isFormValid
            )
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
                .keyboardType(.decimalPad)
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
            if detail.showCalendar {
                let dateBinding = Binding<Date>(
                    get: { detail.date ?? Date() },
                    set: {
                        detail.date = $0
                        detail.showCalendar = false
                    }
                )

                DatePicker("Select Date", selection: dateBinding, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                
            } else {
                Button {
                    detail.showCalendar = true
                } label: {
                    HStack {
                        Text(detail.date != nil ? formattedDate(detail.date!) : "Select date")
                            .foregroundColor(.gray)
                       
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
                Text("Select Payee").font(.headline).bold()
                Spacer()
                Button(action: { showPayeeSheet = false }) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.top)

            TextField("Search", text: $searchText)
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

    var body: some View {
        VStack(spacing: 15) {
            Text("Pay from")
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
                AccountSelectionSheet(accountManager: accountManager, isPresented: $isTransferFromSheetPresented, selectedFromAccount: $selectedFromAccount)
            }

            Button(action: { showPayeeSheet = true }) {
                HStack {
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
                PayeeListView(viewModel: PayeeViewModel(), selectedPayees: $selectedPayees, showPayeeSheet: $showPayeeSheet)
            }

            Button(action: { showAddContactSheet = true }) {
                HStack {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.colorBlue)
                        .clipShape(Circle())
                    Text("Add payee")
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
                
                TextField("Enter amount", text: $amount)
                    .keyboardType(.decimalPad)
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
                FieldErrorView(message: "Amount is required", show: $showAmountError)

                Text("Select frequency")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Picker("Frequency", selection: $selectedFrequency) {
                    Text("Weekly").tag("weekly")
                    Text("Monthly").tag("monthly")
                    Text("Yearly").tag("yearly")
                }
                .pickerStyle(SegmentedPickerStyle())

                DateField(title: "Start Date", dateText: $formattedStartDate) {
                    isSelectingStartDate = true
                    
                    showDatePicker.toggle()
                }
                
                FieldErrorView(message: "Start date is required", show: $showStartDateError)

                DateField(title: "End Date", dateText: $formattedEndDate) {
                    isSelectingStartDate = false
                    showDatePicker.toggle()
                }
                FieldErrorView(message: "End date is required", show: $showEndDateError)
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
                            
                        } else {
                            formattedEndDate = formatter.string(from: newValue)
                        }
                    }
            }

            Button(action: {
                if selectedPayees.count > 1 {
                    var isValid = true
                    for i in payeeRecurringDetails.indices {
                        let amount = payeeRecurringDetails[i].amount.trimmingCharacters(in: .whitespaces)
                        let start = payeeRecurringDetails[i].startDate
                        let end = payeeRecurringDetails[i].endDate

                        payeeRecurringDetails[i].showAmountError = amount.isEmpty
                        payeeRecurringDetails[i].showStartDateError = start == nil
                        payeeRecurringDetails[i].showEndDateError = end == nil

                        if amount.isEmpty || start == nil || end == nil {
                            isValid = false
                        }
                    }
                    if selectedFromAccount == nil {
                        showAccountError = true
                        isValid = false
                    }
                    if isValid {
                        showBillConfirmationSheet = true
                    }
                } else {
                    let result = RecurringPaymentFormValidator.validate(
                        selectedFromAccount: selectedFromAccount,
                        selectedContact: selectedContact,
                        amount: amount,
                        startDate: formattedStartDate,
                        endDate: formattedEndDate
                    )
                    showAmountError = result.showAmountError
                    showStartDateError = result.showStartDateError
                    showEndDateError = result.showEndDateError

                    if result.isFormValid {
                        showBillConfirmationSheet = true
                    }
                }
            }) {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Constants.backgroundGradient)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
//            .sheet(isPresented: $showBillConfirmationSheet) {
//                BillConfirmationSheet(
//                    fromAccount: selectedFromAccount,
//                    toContact: selectedContact,
//                    amount: amount,
//                    date: formattedStartDate ?? "",
//                    selectedPayees: selectedPayees,
//                    payeeDetails: payeeRecurringDetails.map {
//                        PayeePaymentDetails(payee: $0.payee, amount: $0.amount, date: $0.startDate)
//                    },
//                    isRecurring: true,
//                    frequency: selectedFrequency,
//                    startDate: formattedStartDate,
//                    endDate: formattedEndDate
//                )
//            }
            //4 april
//            .sheet(isPresented: $showBillConfirmationSheet) {
//                RecurringBillConfirmationSheet(
//                    fromAccount: selectedFromAccount,
//                    selectedPayees: selectedPayees,
//                    payeeDetails: payeeRecurringDetails.map {
//                        PayeePaymentDetails(
//                            payee: $0.payee,
//                            amount: $0.amount,
//                            date: $0.startDate, // used just for display
//                            startDate: $0.startDate,
//                            endDate: $0.endDate,
//                            frequency: $0.frequency
//                                
//                        )
//                    }
//                )
//            }
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

//in recurring payment multiple payee are selected then show frild using this code
struct MultiRecurringPayeeDetailView: View {
    @Binding var detail: PayeeRecurringDetails
    @State private var showStartPicker = false
    @State private var showEndPicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(detail.payee.name)
                .font(.headline)

            // Amount field
            TextField("Enter amount", text: $detail.amount)
                .keyboardType(.decimalPad)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .onChange(of: detail.amount) { oldValue, newValue in
                    detail.amount = CurrencyFormatter.format(newValue)
                    if !newValue.trimmingCharacters(in: .whitespaces).isEmpty {
                        detail.showAmountError = false
                    }
                }

            FieldErrorView(message: "Amount is required", show: $detail.showAmountError)
            Text("Select frequency")
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            // Frequency Picker
            Picker("Frequency", selection: $detail.frequency) {
                Text("Weekly").tag("weekly")
                Text("Monthly").tag("monthly")
                Text("Yearly").tag("yearly")
            }
            .pickerStyle(SegmentedPickerStyle())

            // Start Date
            DateField(title: "Start Date", dateText: Binding(
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
                        showStartPicker = false
                    }), displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
            }

            FieldErrorView(message: "Start date is required", show: $detail.showStartDateError)

            // End Date
            DateField(title: "End Date", dateText: Binding(
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
                        showEndPicker = false
                    }), displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
            }

            FieldErrorView(message: "End date is required", show: $detail.showEndDateError)

            Divider()
        }
        .padding(.vertical, 10)
    }
}


//required feild validation of recurring form
struct RecurringPaymentFormValidator {
    static func validate(
        selectedFromAccount: BankAccount?,
        selectedContact: Contact?,
        amount: String,
        startDate: String?,
        endDate: String?
    ) -> (
        //showAccountError: Bool,
        //showContactError: Bool,
        showAmountError: Bool,
        showStartDateError: Bool,
        showEndDateError: Bool,
        isFormValid: Bool
    ) {
        // Validate From Account and Payee
        //let showAccountError = selectedFromAccount == nil
        //let showContactError = selectedContact == nil

        // Validate Amount
        let showAmountError = amount.trimmingCharacters(in: .whitespaces).isEmpty

        // Validate Start and End Dates
        let showStartDateError = startDate?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let showEndDateError = endDate?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true

        // Overall form validity
        let isFormValid = //!showAccountError &&
                          //!showContactError &&
                          !showAmountError &&
                          !showStartDateError &&
                          !showEndDateError

        return (
            //showAccountError,
            //showContactError,
            showAmountError,
            showStartDateError,
            showEndDateError,
            isFormValid
        )
    }
}

//select account sheet common for both the sheet
struct AccountSelectionSheet: View {
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
                                Text(detail.frequency.capitalized)
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
    var payeeDetails: [PayeePaymentDetails] = [] // <-- Required

    var isRecurring: Bool = false
    var frequency: String? = nil
    var startDate: String? = nil
    var endDate: String? = nil

    @State private var navigateToMainView = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView(){
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
                
//                if selectedPayees.count == 1 {
//                    BillDetailRow(title: NSLocalizedString("pay_to", comment: ""),
//                                  value: selectedPayees.first?.name ?? toContact?.name ?? "-")
//                    
//                    BillDetailRow(title: NSLocalizedString("amount", comment: ""),
//                                  value: amount)
//                    
//                    BillDetailRow(title: NSLocalizedString("date", comment: ""),
//                                  value: date)
//                }
                if selectedPayees.count == 1, let detail = payeeDetails.first {
                    BillDetailRow(title: NSLocalizedString("pay_to", comment: ""),
                                  value: detail.payee.name)

                    BillDetailRow(title: NSLocalizedString("amount", comment: ""),
                                  value: detail.amount)

                    if isRecurring {
                        BillDetailRow(title: NSLocalizedString("start_date", comment: ""),
                                      value: formattedDate(detail.startDate))
                        BillDetailRow(title: NSLocalizedString("end_date", comment: ""),
                                      value: formattedDate(detail.endDate))
                        BillDetailRow(title: NSLocalizedString("frequency", comment: ""),
                                      value: detail.frequency.capitalized)
                    } else {
                        BillDetailRow(title: NSLocalizedString("date", comment: ""),
                                      value: formattedDate(detail.date))
                    }
                }

                else {
                    ForEach(payeeDetails) { detail in
                        VStack(alignment: .leading, spacing: 6) {
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
                            
//                            Text(NSLocalizedString("date", comment: ""))
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                            
//                            Text(formattedDate(detail.date))
//                                .font(.body)
                            if isRecurring {
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
                                            Text(detail.frequency.capitalized)
                                                .font(.body)
                                        } else {
                                            Text(NSLocalizedString("date", comment: ""))
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                            Text(formattedDate(detail.date))
                                                .font(.body)
                                        }
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
                
                // Recurring Info
//                if isRecurring {
//                    Group {
//                        BillDetailRow(title: NSLocalizedString("frequency", comment: ""),
//                                      value: frequency?.capitalized ?? "-")
//                        BillDetailRow(title: NSLocalizedString("start_date", comment: ""),
//                                      value: startDate ?? "-")
//                        BillDetailRow(title: NSLocalizedString("end_date", comment: ""),
//                                      value: endDate ?? "-")
//                    }
//                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
            .padding()
            
            Spacer()
            
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

    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "-" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
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
    }
}
