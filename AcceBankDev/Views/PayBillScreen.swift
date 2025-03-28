

import SwiftUI

struct PayBillScreen: View {
    @State private var selectedDate = Date() // Date for the DatePicker
        @State private var showDatePicker = false // Toggle for DatePicker visibility

    @Environment(\.presentationMode) var presentationMode // To dismiss the modal
    @StateObject private var accountManager = AccountManager()

    @State private var selectedPaymentType: String? = "One-time Payment" // Track selected payment type
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

    var body: some View {
        ScrollView {
            VStack {
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
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.3)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .cornerRadius(30)

                        HStack(spacing: 0) {
                            Button(action: { selectedPaymentType = "One-time Payment"
                               
}) {
                                Text("One-time Payment")
    //Text(NSLocalizedString("my_accounts", comment: "Title for 'My accounts' tab"))

        .font(.headline)
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
                                Text("Recurring Payment")
    //Text(NSLocalizedString("another_member", comment: "Title for 'My accounts' tab"))

                                    .font(.headline)
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
                    }
                }
                .padding(.horizontal)
                
                
                
                if selectedPaymentType == "One-time Payment" {

                    OneTimePaymentForm(accountManager: accountManager, selectedContact: $selectedContact,
                                      

                        showAccountSheet: $showAccountSheet,
                        showContactSheet: $showContactSheet,
                    showAddContactSheet: $showAddContactSheet,
                            amount: $amount,
                        showDatePicker: $showDatePicker,
                        selectedDate: $selectedDate,
                                       selectedFromAccount: $selectedFromAccount,
                                       isTransferFromSheetPresented: $isTransferFromSheetPresented, showBillConfirmationSheet: $showBillConfirmationSheet
                        
                    )

                } else if selectedPaymentType == "Recurring Payment" {
                    RecuuringPaymentForm(accountManager: accountManager, selectedContact: $selectedContact,
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
// ← Add this
                        selectedFrequency: $selectedFrequency,
                                         selectedFromAccount: $selectedFromAccount,
                                         isTransferFromSheetPresented: $isTransferFromSheetPresented
                        //selectedDate: $selectedDate
                   
                    )
                }
//^^^^^^^^^^^^^
                
            }
        }
    }
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
    @State private var formattedDate: String? = nil
    @Binding var selectedFromAccount: BankAccount?
    @Binding var isTransferFromSheetPresented: Bool
    @Binding var showBillConfirmationSheet: Bool


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
                    TransferAccountSheet(
                        accountManager: accountManager,  // Add this
                        selectedAccount_from: $selectedFromAccount,
                        isPresented: $isTransferFromSheetPresented  // Add this
                    )
                }
            }

            // Payee
            Button(action: { showContactSheet = true }) {
                HStack {
                    Text(selectedContact?.name ?? NSLocalizedString("payee", comment: ""))
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
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
            TextField("enter_transfer_amount", text: $amount)
                .keyboardType(.decimalPad)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))

            // Date Picker with Icon
//            HStack {
//                DateField("Date", datetext:$formatteddate)
//                    .padding()
//                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
//                    .padding(.leading, 10)
//
//                Button(action: {
//                    showDatePicker.toggle()
//                }) {
//                    Image(systemName: "calendar")
//                        .foregroundColor(.gray)
//                        .padding(.trailing, 10)
//                }
//            }
//
//            if showDatePicker {
//                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
//                    .datePickerStyle(GraphicalDatePickerStyle())
//                    .padding()
//                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
//                    .padding(.top, 10)
//            }
            DateField(title: "Date", dateText: $formattedDate) {
                            showDatePicker.toggle()
                        }

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

                                }
                        }

                        Spacer()
                    }
                    .padding()

            // Continue
            Button(action: {
                print("Continue tapped")
                showBillConfirmationSheet = true

            }) {
                Text("Continue")
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
                    date: formattedDate ?? ""
                )
            }

        }
       
    }
//}
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
                    TransferAccountSheet(
                        accountManager: accountManager,  // Add this
                        selectedAccount_from: $selectedFromAccount,
                        isPresented: $isTransferFromSheetPresented  // Add this
                    )
                }
            }
            
            // Payee
            Button(action: { showContactSheet = true }) {
                HStack {
                    Text(selectedContact?.name ?? NSLocalizedString("payee", comment: ""))
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
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
            TextField("enter_transfer_amount", text: $amount)
                .keyboardType(.decimalPad)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            
            // Date Picker with Icon
            //            HStack {
            //                DateField("Date", datetext:$formatteddate)
            //                    .padding()
            //                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            //                    .padding(.leading, 10)
            //
            //                Button(action: {
            //                    showDatePicker.toggle()
            //                }) {
            //                    Image(systemName: "calendar")
            //                        .foregroundColor(.gray)
            //                        .padding(.trailing, 10)
            //                }
            //            }
            //
            //            if showDatePicker {
            //                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
            //                    .datePickerStyle(GraphicalDatePickerStyle())
            //                    .padding()
            //                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            //                    .padding(.top, 10)
            //            }
            
//            DateField(title: "Date", dateText: $formattedDate) {
//                showDatePicker.toggle()
//            }
//            
//            // Show DatePicker below when tapped
//            if showDatePicker {
//                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
//                    .datePickerStyle(GraphicalDatePickerStyle())
//                    .padding()
//                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
//                    .onChange(of: selectedDate) { newDate in
//                        let formatter = DateFormatter()
//                        formatter.dateStyle = .medium
//                        formattedDate = formatter.string(from: newDate)
//                    }
//            }
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
            DateField(title: "Start Date", dateText: $formattedStartDate) {
                isSelectingStartDate = true
                showDatePicker.toggle()
            }

            // End Date Field
            DateField(title: "End Date", dateText: $formattedEndDate) {
                isSelectingStartDate = false
                showDatePicker.toggle()
            }

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
            }) {
                Text("Continue")
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
        }
        .padding(.horizontal,20)
        
    }
    struct AccountSelectionSheet: View {
        @ObservedObject var accountManager: AccountManager
        @Binding var isPresented: Bool
        
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
                                accountManager.selectedAccount = account
                                isPresented = false // Close sheet
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
}
//for date
//for confirmation sheet
struct BillConfirmationSheet: View {
    var fromAccount: BankAccount?
    var toContact: Contact?
    var amount: String
    var date: String

    var body: some View {
        VStack(spacing: 16) {
            Text("Confirmation")
                .font(.headline)

//            Group {
//                BillDetailRow("Pay from")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                BillDetailRow("\(fromAccount?.accountName ?? "") - \(fromAccount?.accountNumber ?? "")")
//
//                BillDetailRow("Pay to")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                BillDetailRow(toContact?.name ?? "")
//
//                BillDetailRow("Amount")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                BillDetailRow(amount)
//
//                BillDetailRow("Date")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                BillDetailRow(date)
//            }
            Group {
                BillDetailRow(
                    title: "Pay from",
                    value: "\(fromAccount?.accountName ?? "") - \(fromAccount?.accountNumber ?? "")"
                )

                BillDetailRow(
                    title: "Pay to",
                    value: toContact?.name ?? ""
                )

                BillDetailRow(
                    title: "Amount",
                    value: "$\(amount)"
                )

                BillDetailRow(
                    title: "Date",
                    value: date
                )
            }


            Button(action: {
                // Handle final payment action
                print("Pay now tapped")
            }) {
                Text("Pay now")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
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
