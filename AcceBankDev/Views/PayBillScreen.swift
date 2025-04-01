

import SwiftUI

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
                                               showPayeeSheet: $showPayeeSheet
                                               
                                               
                            )
                            .padding(.top,15)
                            
                        } else if selectedPaymentType == "Recurring Payment" {
                            RecuuringPaymentForm(
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
                                selectedPayees: $selectedPayees
                            )
                            .padding(.top,30)

                            
                        }
                        
                    }
            }
       }
    }
}
struct PayeePaymentDetail: Identifiable {
    let payee: Payee
    var amount: String
    var date: Date
    var id: String { payee.id }
}


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
                    Text(selectedPayees.isEmpty ? "Select payee(s)" : selectedPayees.map { $0.name }.joined(separator: ", "))
                        .foregroundColor(selectedPayees.isEmpty ? .blue : .black)

                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
//            .sheet(isPresented: $showPayeeSheet) {
//                PayeeSelectionSheet(viewModel: viewModel,
//                                    selectedPayee: $selectedPayee,
//                                    showPayeeSheet: $showPayeeSheet)
//            }
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
         

            // Amount Field
            //TextField("enter_transfer_amount", text: $amount)
            TextField(NSLocalizedString("enter_transfer_amount", comment: ""), text: $amount)

                .keyboardType(.decimalPad)
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
                    showDatePicker = false

                        }
            FieldErrorView(message: NSLocalizedString("error_required_field", comment: "Amount is required"), show: $showAmountError)
//error_required_field
            
            DateField(title: NSLocalizedString("date", comment: "date"),
                      dateText: $formattedDate) {
                UIApplication.shared.endEditing()

                showDatePicker=true
            }

            FieldErrorView(message: NSLocalizedString("error_required_field", comment: "Amount is required"), show: $showDateError)

                        // Show DatePicker below when tapped
                        if showDatePicker {
                            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                .onChange(of: selectedDate,initial:false) {oldValue, newValue in
                                    let formatter = DateFormatter()
                                    formatter.dateStyle = .medium
                                    //formattedDate = formatter.string(from: newDate)
                                    formattedDate = formatter.string(from: newValue)
                                    showDatePicker=false

                                }
                        }

                        Spacer()
                    }
                    .padding()

            // Continue
            Button(action: {
//                print("Continue tapped")
//                showBillConfirmationSheet = true
                let result = OneTimePaymentFormValidator.validate(
                 //selectedFromAccount: selectedFromAccount,
                    selectedFromAccount: accountManager.selectedAccount,

                        //selectedContact: selectedContact,
                        amount: amount,
                        formattedDate: formattedDate
                    )

                    showAccountError = result.showAccountError
                    //showContactError = result.showContactError
                    showAmountError = result.showAmountError
                    showDateError = result.showDateError

                    if result.isFormValid {
                       selectedFromAccount = accountManager.selectedAccount // <-- add this

                        showBillConfirmationSheet = true
                    }

            }) {
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
                    selectedPayees: selectedPayees
                    
                )
            }
            
        }
       
    }
//}
//}


//struct PayeeListView: View {
//    @ObservedObject var viewModel = PayeeViewModel()
//    @Binding var selectedPayee: Payee?
//    @Binding var showPayeeSheet: Bool
//
//    var body: some View {
//        VStack {
//            // Header
//            HStack {
//                Text("Select Payee")
//                    .font(.headline)
//                    .bold()
//                Spacer()
////                Button("Close") {
////                    showPayeeSheet = false
////                }
////                .foregroundColor(.blue)
////            }
//                Button(action: {
//                showPayeeSheet = false
//
//                }) {
//                    Image(systemName: "xmark")
//                        .font(.title3)
//                        .foregroundColor(.gray)
//                }
//            }
//            .padding()
//
//            ScrollView {
//                VStack(spacing: 10) {
//                    ForEach(viewModel.payees) { payee in
//                        Button(action: {
//                            selectedPayee = payee
//                            showPayeeSheet = false
//                        }) {
//                            HStack {
//                                VStack(alignment: .leading, spacing: 2) {
//                                    Text(payee.name)
//                                        .font(.headline)
//                                        .bold()
//                                        .foregroundColor(.black)
//
//                                    Text("Account: \(payee.accountNumber)")
//                                        .font(.subheadline)
//                                        .foregroundColor(.gray)
//
//                                    Text("Bank: \(payee.bank)")
//                                        .font(.subheadline)
//                                        .foregroundColor(.gray)
//                                }
//                                Spacer()
//
//                                if selectedPayee?.id == payee.id {
//                                    Image(systemName: "checkmark.circle.fill")
//                                        .foregroundColor(.blue)
//                                }
//                            }
//                            .padding()
//                            .background(
//                                RoundedRectangle(cornerRadius: 12)
//                                    //.fill(Color(UIColor.systemGray6))
//                                    .fill(selectedPayee?.id == payee.id ? Color.blue.opacity(0.2) : Color(UIColor.systemGray6))
//
//                            )
////                            .overlay(
////                                RoundedRectangle(cornerRadius: 12)
////                                    .stroke(selectedPayee?.id == payee.id ? Color.blue : Color.clear, lineWidth: 2)
////                            )
//                        }
//                    }
//                }
//                .padding()
//            }
//        }
//        .padding(.horizontal)
//        .presentationDetents([.medium, .large])
//    }
//}
//
//

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

//date field
struct PaymentDateField: View {
    var title: String
    @Binding var dateText: String?
    var action: () -> Void

    var body: some View {
        ZStack {
            HStack {
                Text(dateText?.isEmpty == false ? dateText! : title)
                    .foregroundColor(dateText?.isEmpty == false ? .black : .gray)
                Spacer()
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                    .padding(.trailing, 10)
            }
            .padding()
            .frame(height: 50)
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
        }
        .contentShape(Rectangle()) // Make the full area tappable
        .onTapGesture {
            action()
        }
    }
    private var dateTextValue: String {
            if let text = dateText, !text.isEmpty {
                return text
            } else {
                return title
            }
        }
}


    
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


//error msg
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

struct RecuuringPaymentForm: View {
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
    
    @Binding var showAccountError:Bool
    @Binding var showContactError:Bool
    @Binding var showAmountError:Bool
    @Binding var showStartDateError:Bool
    @Binding var showEndDateError:Bool

    @Binding var showBillConfirmationSheet: Bool
    @Binding var showPayeeSheet: Bool
    @ObservedObject var viewModel: PayeeViewModel
    @Binding var selectedPayees: [Payee]


    @FocusState private var focusedField: FieldFocus?

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
//            FieldErrorView(message: NSLocalizedString("error_required_field", comment: "Amount is required"), show: $showAccountError)
            // Payee
            Button(action: { showPayeeSheet = true }) {
                HStack {
                    //Text(selectedContact?.name ?? NSLocalizedString("payee", comment: ""))
                    Text(selectedPayees.isEmpty ? "Select payee(s)" : selectedPayees.map { $0.name }.joined(separator: ", "))
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
                    selectedPayees: $selectedPayees,
                    showPayeeSheet: $showPayeeSheet)

            }
            
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
            
            // Amount Field
            //TextField("enter_transfer_amount", text: $amount)
            TextField(NSLocalizedString("enter_transfer_amount", comment: ""), text: $amount)

                .keyboardType(.decimalPad)
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
            FieldErrorView(message: NSLocalizedString("error_required_field", comment: "Amount is required"), show: $showAmountError)
           
            VStack(alignment: .leading, spacing: 10) {
                Text(NSLocalizedString("select_frequency", comment: ""))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 5)

                Picker(NSLocalizedString("frequency", comment: "Frequency picker label"), selection: $selectedFrequency) {
                    Text(NSLocalizedString("weekly", comment: "Frequency option")).tag("weekly")
                    Text(NSLocalizedString("monthly", comment: "Frequency option")).tag("monthly")
                    Text(NSLocalizedString("yearly", comment: "Frequency option")).tag("yearly")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.vertical, 5)

                //Spacer()
            }
            // Start Date Field
            //DateField(title: "Start Date", dateText: $formattedStartDate)
            DateField(title: NSLocalizedString("start_date", comment: "date"), dateText: $formattedStartDate){
                isSelectingStartDate = true
                showDatePicker.toggle()
            }
            
            FieldErrorView(message: NSLocalizedString("error_required_field", comment: "Amount is required"), show: $showStartDateError)

            // End Date Field
            //DateField(title: "End Date", dateText: $formattedEndDate)
            DateField(title: NSLocalizedString("end_date", comment: "date"), dateText: $formattedEndDate)
            {
                isSelectingStartDate = false
                showDatePicker.toggle()
            }
            FieldErrorView(message: NSLocalizedString("error_required_field", comment: "Amount is required"), show: $showEndDateError)
            // Shared DatePicker for both fields
            if showDatePicker {
                DatePicker("Select Date",
                           selection: isSelectingStartDate ? $selectedStartDate : $selectedEndDate,
                           displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
//                    .onChange(of: isSelectingStartDate ? selectedStartDate : selectedEndDate) { newDate in
                    .onChange(of: isSelectingStartDate ? selectedStartDate : selectedEndDate, initial: false) { _, newDate in

                        let formatter = DateFormatter()
                        formatter.dateStyle = .medium
                        if isSelectingStartDate {
                            formattedStartDate = formatter.string(from: newDate)
                        } else {
                            formattedEndDate = formatter.string(from: newDate)
                        }
                    }
            }

//            VStack(alignment: .leading, spacing: 10) {
//                Text(NSLocalizedString("select_frequency", comment: ""))
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.top, 5)
//
//                Picker(NSLocalizedString("frequency", comment: "Frequency picker label"), selection: $selectedFrequency) {
//                    Text(NSLocalizedString("weekly", comment: "Frequency option")).tag("weekly")
//                    Text(NSLocalizedString("monthly", comment: "Frequency option")).tag("monthly")
//                    Text(NSLocalizedString("yearly", comment: "Frequency option")).tag("yearly")
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding(.vertical, 5)
//
//                //Spacer()
//            }
            //.padding()

            //            Text(NSLocalizedString("select_frequency", comment: ""))
            //
            //                .font(.subheadline)
            //                .foregroundColor(.gray)
            //                .frame(maxWidth: .infinity, alignment: .leading)
            //                .padding(.top, 5)
            //
            //
            //                        Spacer()
            //                    }
            //                    .padding()
            
            // Continue
            Button(action: {
                print("Continue tapped")
                let result = RecurringPaymentFormValidator.validate(
                    selectedFromAccount: selectedFromAccount,
                    selectedContact: selectedContact,
                    amount: amount,
                    startDate: formattedStartDate,
                    endDate: formattedEndDate
                )

                //showAccountError = result.showAccountError
                //showContactError = result.showContactError
                showAmountError = result.showAmountError
                showStartDateError = result.showStartDateError
                showEndDateError = result.showEndDateError

                if result.isFormValid {
                    showBillConfirmationSheet = true
                }

            }) {
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
            .padding(.horizontal, 5)
            .sheet(isPresented: $showBillConfirmationSheet) {
                BillConfirmationSheet(
                    fromAccount: selectedFromAccount,
                    toContact: selectedContact,
                    amount: amount,
                    date: formattedStartDate ?? "",
                    selectedPayees: selectedPayees,
// This is the first payment date
                    isRecurring: true,
                    frequency: selectedFrequency,
                    startDate: formattedStartDate,
                    endDate: formattedEndDate
                )
            }
            
        }
        .padding(.horizontal,20)
        
    }
    
    

}

//required feild
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

//select account
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


struct BillConfirmationSheet: View {
    var fromAccount: BankAccount?
    var toContact: Contact?
    var amount: String
    var date: String
    var selectedPayees: [Payee] = []  // <-- Add this line
    // New for recurring
    var isRecurring: Bool = false
    var frequency: String? = nil
    var startDate: String? = nil
    var endDate: String? = nil
    @State private var navigateToSummary = false  // Controls navigation

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 16) {
//            Text("Confirmation")
//                .font(.headline)
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
            VStack{
                Group {
                    BillDetailRow(
                        //title: "Pay from",
                        title: NSLocalizedString("pay_from", comment: "Label for transfer amount"),
                        value: "\(fromAccount?.accountName ?? "") - \(fromAccount?.accountNumber ?? "")"
                    )
                    
//                    BillDetailRow(
//                        //title: "Pay to",
//                        title: NSLocalizedString("pay_to", comment: "Label for transfer amount"),
//                        value: toContact?.name ?? ""
//                    )
                    BillDetailRow(
                        title: NSLocalizedString("pay_to", comment: "Label for transfer amount"),
                        value: selectedPayees.map { $0.name }.joined(separator: ", ")
                    )

                    
                    BillDetailRow(
                        //title: "Amount",
                        title: NSLocalizedString("amount", comment: "Label for transfer amount"),
                        value: "\(amount)"
                    )
                    
                    BillDetailRow(
//                        title: isRecurring ? "First Payment Date" : "Date",
                        title: NSLocalizedString("date", comment: "Label for transfer amount"),
                        value: date
                    )
                }
                
                // Recurring specific fields
                if isRecurring {
                    Group {
                        BillDetailRow(
                            //title: "Frequency",
                            title: NSLocalizedString("frequency", comment: "Label for transfer amount"),
                            value: frequency?.capitalized ?? "-"
                        )
                        BillDetailRow(
                            //title: "Start Date",
                            title: NSLocalizedString("start_date", comment: "Label for transfer amount"),
                            value: startDate ?? "-"
                        )
                        BillDetailRow(
                            //title: "End Date",
                            title: NSLocalizedString("end_date", comment: "Label for transfer amount"),
                            value: endDate ?? "-"
                        )
                    }
                }
                
            }
            .padding(.horizontal)
            Spacer()

            Button(action: {
                print("Pay now tapped")
                navigateToSummary = true // Show summary screen

            }) {
                //Text("Pay now")
                Text(NSLocalizedString("pay_now", comment: ""))

                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .fullScreenCover(isPresented: $navigateToSummary) {
            BillSendSheet(
                        fromAccount: fromAccount,
                        toContact: toContact,
                        amount: amount, date:date,
                        isRecurring: isRecurring,
                        frequency: frequency,
                        startDate: startDate,
                        endDate: endDate
                        
                    )
                }
    }
        
}

struct BillSendSheet: View {
    var fromAccount: BankAccount?
    var toContact: Contact?
    var amount: String
    var date: String
    //var selectedPayees: [Payee] = [] // <-- Add this line

    // New for recurring
    var isRecurring: Bool = false
    var frequency: String? = nil
    var startDate: String? = nil
    var endDate: String? = nil
    @State private var navigateToMainView = false

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 16) {
//            Text("Confirmation")
//                .font(.headline)
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
            VStack{
                Text(NSLocalizedString("payment_summary", comment: "Message shown when a payment is successfully sent"))
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)

                Divider()
//25 march
                Group {
                    BillDetailRow(
                        //title: "Pay from",
                        title: NSLocalizedString("pay_from", comment: "Label for transfer amount"),
                        value: "\(fromAccount?.accountName ?? "") - \(fromAccount?.accountNumber ?? "")"
                    )
                    
                    BillDetailRow(
                                            //title: "Pay to",
                                            title: NSLocalizedString("pay_to", comment: "Label for transfer amount"),
                                            value: toContact?.name ?? ""
                                        )

                    
                    BillDetailRow(
                        //title: "Amount",
                        title: NSLocalizedString("amount", comment: "Label for transfer amount"),
                        value: "\(amount)"
                    )
                    
                    BillDetailRow(
//                        title: isRecurring ? "First Payment Date" : "Date",
                        title: NSLocalizedString("date", comment: "Label for transfer amount"),
                        value: date
                    )
                }
                
                // Recurring specific fields
                if isRecurring {
                    Group {
                        BillDetailRow(
                            //title: "Frequency",
                            title: NSLocalizedString("frequency", comment: "Label for transfer amount"),
                            value: frequency?.capitalized ?? "-"
                        )
                        BillDetailRow(
                            //title: "Start Date",
                            title: NSLocalizedString("start_date", comment: "Label for transfer amount"),
                            value: startDate ?? "-"
                        )
                        BillDetailRow(
                            //title: "End Date",
                            title: NSLocalizedString("end_date", comment: "Label for transfer amount"),
                            value: endDate ?? "-"
                        )
                    }
                }
                
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
            .padding()

            Spacer()

            Button(action: {
                print("Pay now tapped")
                navigateToMainView = true

            }) {
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
