import SwiftUI

struct MoveMoneyView: View {
    @State private var showBottomSheet = false
    @State private var selectedSheet: BottomSheetType? // Track which sheet to show
    
    enum BottomSheetType {
        case transferOptions
        case interac
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Constants.backgroundGradient
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 0) {
                    HeaderView()
                        .zIndex(1)
                        .frame(height: 25)
                        .background(Color.white)
                    
                    Spacer().frame(height: 10)
                    
                    //Text("Move Money")
                    Text(NSLocalizedString("move_money_title", comment: "Title for move money screen or section"))

                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom, 15)
                    
                    VStack {
                        ScrollView {
                            VStack(spacing: 15) {
                                
                                Button(action: {
                                    selectedSheet = .transferOptions
                                    showBottomSheet = true
                                }) {
//                                    MoveMoneyOptionRow(icon: "arrow.left.arrow.right", title: "Transfers", subtitle: "OWN BANK ACCOUNTS")
                                    
                                    MoveMoneyOptionRow(
                                        icon: "arrow.left.arrow.right",
                                        title: NSLocalizedString("transfers_option", comment: "Title for transfer between own accounts"),
                                        subtitle: NSLocalizedString("transfers_options_subtitle", comment: "Subtitle for own bank account transfers")
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)
                                
                                Button(action: {
                                    selectedSheet = .interac
                                    showBottomSheet = true
                                }) {
//                                    MoveMoneyOptionRow(icon: "doc.text", title: "Interac e-Transfer", subtitle: "SEND OR REQUEST MONEY")
                                    MoveMoneyOptionRow(
                                        icon: "doc.text",
                                        title: NSLocalizedString("interac_transfer", comment: "Title for Interac e-Transfer option"),
                                        subtitle: NSLocalizedString("interac_transfer_subtitle", comment: "Subtitle for Interac e-Transfer")
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)
                                
//                                MoveMoneyOptionRow(icon: "building.columns.fill", title: "Payments", subtitle: "TRANSFER FUNDS BETWEEN CANADIAN BANK")
                                
                                MoveMoneyOptionRow(
                                    icon: "building.columns.fill",
                                    title: NSLocalizedString("payments_option", comment: "Title for payments between banks"),
                                    subtitle: NSLocalizedString("payments_option_subtitle", comment: "Subtitle for bank payments")
                                )

                                Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)
//                                
//                                MoveMoneyOptionRow(icon: "person.fill.checkmark", title: "Scheduled transfers & payments", subtitle: "SEND MONEY TO YOUR CLIENT")
                                MoveMoneyOptionRow(
                                    icon: "person.fill.checkmark",
                                    title: NSLocalizedString("scheduled_transfers", comment: "Title for scheduled transfers and payments"),
                                    subtitle: NSLocalizedString("scheduled_transfers_option", comment: "Subtitle for scheduled client payments")
                                )
                                Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)
                            }
                            .padding(.horizontal, 5)
                            .padding(.vertical, 1)
                        }
                    }
                    .padding(20)
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 550)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .onChange(of: selectedSheet) { _ in
                // Trigger the sheet when selectedSheet changes
                showBottomSheet = true
            }
            .sheet(isPresented: $showBottomSheet) {
                Group {
                    if let selectedSheet = selectedSheet {
                        switch selectedSheet {
                        case .transferOptions:
                            TransferOptionsSheet()
                                .presentationDetents([.fraction(0.5)])
                                .edgesIgnoringSafeArea(.bottom)
                            
                        case .interac:
                            InteracETransferSheet()
                                .presentationDetents([.fraction(0.5)])
                                .edgesIgnoringSafeArea(.bottom)
                        }
                    } else {
                        EmptyView() // Prevents empty sheet
                    }
                }
            }
        }
    }
    
    // Transfers sheet
    struct TransferOptionsSheet: View {
        @Environment(\.presentationMode) var presentationMode
        
        var body: some View {
            VStack {
                HStack {
                    //Text("Transfers")
                    Text(NSLocalizedString("transfers_option", comment: "Title for transfers section"))

                        .font(.headline)
                        .bold()
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
                
                Divider()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
//                        InteracOptionRow(icon: "arrow.left.arrow.right", title: "Transfer money")
//                        InteracOptionRow(
//                            icon: "arrow.left.arrow.right",
//                            title: NSLocalizedString("transfer_money", comment: "Option to transfer money")
//                        )
                        InteracOptionRow(option: .transferMoney)
                        InteracOptionRow(option: .manageContacts)
                        InteracOptionRow(option: .manageAccounts)

//                        InteracOptionRow(icon: "building.columns.fill", title: "To Another Bank")
//                        InteracOptionRow(
//                            icon: "building.columns.fill",
//                            title: NSLocalizedString("to_another_bank", comment: "Option to transfer money to another bank")
//                        )

                        //InteracOptionRow(icon: "clock.fill", title: "Scheduled Transfers")
//                        InteracOptionRow(icon: "building.columns.fill", title: "Manage Contacts")
//                        InteracOptionRow(
//                            icon: "building.columns.fill",
//                            title: NSLocalizedString("manage_contacts", comment: "Option to manage transfer contacts")
//                        )
//                        InteracOptionRow(icon: "clock.fill", title: "Manage Accounts")
//                        InteracOptionRow(
//                            icon: "clock.fill",
//                            title: NSLocalizedString("manage_accounts", comment: "Option to manage transfer accounts")
//                        )
                    }
                    .padding()
                }
                
                Spacer()
            }
            .background(Color(UIColor.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            //.presentationDetents([.fraction(0.3)])  // Set bottom sheet height to 30% of the screen height

        }
    }
    
    // Interac e-Transfer sheet
    struct InteracETransferSheet: View {
        @Environment(\.presentationMode) var presentationMode
        
        var body: some View {
            VStack {
                HStack {
                    //Text("Interac e-Transfer®")
                    Text(NSLocalizedString("interac_transfer", comment: "Title for transfers section"))
                        .font(.headline)
                        .bold()
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
                
                Divider()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
//                        InteracOptionRow(icon: "paperplane.fill", title: "Send money")
                        
                        InteracOptionRow(option: .sendMoney)
                        InteracOptionRow(option: .requestMoney)
                        InteracOptionRow(option: .manageContacts)
                        InteracOptionRow(option: .pending)
                        InteracOptionRow(option: .profileSettings)

                        
//                        InteracOptionRow(
//                            icon: "paperplane.fill",
//                            title: NSLocalizedString("send_money", comment: "Option to send money")
//                        )
//                        InteracOptionRow(icon: "arrow.down.doc.fill", title: "Request money")
//                        InteracOptionRow(
//                            icon: "arrow.down.doc.fill",
//                            title: NSLocalizedString("request_money", comment: "Option to request money")
//                        )
//                        InteracOptionRow(icon: "person.crop.circle.fill", title: "Manage contacts")
//                        InteracOptionRow(
//                            icon: "person.crop.circle.fill",
//                            title: NSLocalizedString("manage_contacts", comment: "Option to manage contacts")
//                        )
                        //InteracOptionRow(icon: "clock.fill", title: "Pending")
//                        InteracOptionRow(
//                            icon: "clock.fill",
//                            title: NSLocalizedString("pending", comment: "Option to view pending transfers or requests")
//                        )
//                        InteracOptionRow(icon: "list.bullet", title: "History")
//                        InteracOptionRow(icon: "gearshape.fill", title: "Autodeposit settings")
//                        InteracOptionRow(icon: "person.text.rectangle.fill", title: "Profile settings")
//                        InteracOptionRow(
//                            icon: "person.text.rectangle.fill",
//                            title: NSLocalizedString("profile_setting", comment: "Option to configure user profile settings")
//                        )
                    }
                    .padding()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemGray6))
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    //25 march
    enum InteracOptionType {
        case sendMoney
        case transferMoney
        case manageContacts
        case manageAccounts
        case requestMoney
        case pending
        case profileSettings
        // Add more as needed

        var icon: String {
            switch self {
            case .sendMoney: return "paperplane.fill"
            case .transferMoney: return "arrow.left.arrow.right"
            case .manageContacts: return "building.columns.fill"
            case .manageAccounts: return "clock.fill"
            case .requestMoney: return "arrow.down.doc.fill"
            case .pending: return "clock.fill"
            case .profileSettings: return "person.text.rectangle.fill"
            }
        }

        var localizedTitle: String {
            switch self {
            case .sendMoney:
                return NSLocalizedString("send_money", comment: "")
            case .transferMoney:
                return NSLocalizedString("transfer_money", comment: "")
            case .manageContacts:
                return NSLocalizedString("manage_contacts", comment: "")
            case .manageAccounts:
                return NSLocalizedString("manage_accounts", comment: "")
            case .requestMoney:
                return NSLocalizedString("request_money", comment: "")
            case .pending:
                return NSLocalizedString("pending", comment: "")
            case .profileSettings:
                return NSLocalizedString("profile_setting", comment: "")
            }
        }
    }
    struct InteracOptionRow: View {
        let option: InteracOptionType

        @State private var isShowingSendMoney = false
        @State private var isShowingTransferMoney = false
        @State private var isShowingContactForm = false
        @State private var isShowingAccountForm = false

        var body: some View {
            HStack {
                Image(systemName: option.icon)
                    .font(.title2)
                    .foregroundColor(.black)
                    .frame(width: 35, height: 35)

                Text(option.localizedTitle)
                    .font(.headline)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .onTapGesture {
                switch option {
                case .sendMoney:
                    isShowingSendMoney = true
                case .transferMoney:
                    isShowingTransferMoney = true
                case .manageContacts:
                    isShowingContactForm = true
                case .manageAccounts:
                    isShowingAccountForm = true
                default:
                    break
                }
            }
            .fullScreenCover(isPresented: $isShowingSendMoney) {
                SendMoneyView()
            }
            .fullScreenCover(isPresented: $isShowingTransferMoney) {
                TransferMoneyScreen()
            }
            .fullScreenCover(isPresented: $isShowingContactForm) {
                AddContactFormView(isPresented: $isShowingContactForm, contactManager: ContactManager())
            }
            .fullScreenCover(isPresented: $isShowingAccountForm) {
                AddAccountFormView(accountManager: AccountManager())
            }
        }
    }

    // Interac Option Row
//    struct InteracOptionRow: View {
//        let icon: String
//        let title: String
//        
//        @State private var isShowingSendMoney = false
//        @State private var isShowingTransferMoney = false
//        @State private var isShowingContactForm = false
//        @State private var isShowingAccountForm = false
//
//
//        var body: some View {
//            HStack {
//                Image(systemName: icon)
//                    .font(.title2)
//                    .foregroundColor(Color.black)
//                    .frame(width: 35, height: 35)
//                
//                Text(title)
//                    .font(.headline)
//                
//                Spacer()
//                
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.gray)
//            }
//            .padding(.vertical, 10)
//            .padding(.horizontal, 20)
//            .onTapGesture {
//                if title == "Send money" {
//                    isShowingSendMoney = true
//                }
//                else if title == "Transfer money" {
//                    isShowingTransferMoney = true
//                }
//                else if title == "Manage Contacts" {
//                    isShowingContactForm = true
//                }
//                else if title == "Manage Accounts" {
//                    isShowingAccountForm = true
//                }
//                
//            }
//            .fullScreenCover(isPresented: $isShowingSendMoney) {
//                SendMoneyView()
//            }
//            .fullScreenCover(isPresented: $isShowingTransferMoney) {
//                //TransferMoneyScreen(showContactSheet: .constant(false))
//                TransferMoneyScreen()
//
//            }
//            .fullScreenCover(isPresented: $isShowingContactForm) {
//                AddContactFormView(isPresented: $isShowingContactForm, contactManager: ContactManager())
//            }
//            .fullScreenCover(isPresented: $isShowingAccountForm) {
//                //TransferMoneyScreen()
//                AddAccountFormView(accountManager: AccountManager())
//
//            }
//        }
//    }
    //25 march
    
    // Move Money Row View
    struct MoveMoneyOptionRow: View {
        let icon: String
        let title: String
        let subtitle: String
        
        var body: some View {
            HStack(spacing: 19) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 45, height: 45)
                        .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 0)
        }
    }
}

struct MoveMoneyView_Previews: PreviewProvider {
    static var previews: some View {
        MoveMoneyView()
    }
}
