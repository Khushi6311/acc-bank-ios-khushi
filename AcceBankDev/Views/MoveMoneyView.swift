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
                    
                    Text("Move Money")
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
                                    MoveMoneyOptionRow(icon: "arrow.left.arrow.right", title: "Transfers", subtitle: "OWN BANK ACCOUNTS")
                                }
                                .buttonStyle(PlainButtonStyle())
                                Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)
                                
                                Button(action: {
                                    selectedSheet = .interac
                                    showBottomSheet = true
                                }) {
                                    MoveMoneyOptionRow(icon: "doc.text", title: "Interac e-Transfer", subtitle: "SEND OR REQUEST MONEY")
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)
                                
                                MoveMoneyOptionRow(icon: "building.columns.fill", title: "Payments", subtitle: "TRANSFER FUNDS BETWEEN CANADIAN BANK")
                                Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)
                                
                                MoveMoneyOptionRow(icon: "person.fill.checkmark", title: "Scheduled transfers & payments", subtitle: "SEND MONEY TO YOUR CLIENT")
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
                    Text("Transfers")
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
                        InteracOptionRow(icon: "arrow.left.arrow.right", title: "Transfer money")
                        InteracOptionRow(icon: "building.columns.fill", title: "To Another Bank")
                        //InteracOptionRow(icon: "clock.fill", title: "Scheduled Transfers")
                        InteracOptionRow(icon: "building.columns.fill", title: "Manage Contacts")
                        InteracOptionRow(icon: "clock.fill", title: "Manage Accounts")
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
                    Text("Interac e-Transfer®")
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
                        InteracOptionRow(icon: "paperplane.fill", title: "Send money")
                        InteracOptionRow(icon: "arrow.down.doc.fill", title: "Request money")
                        InteracOptionRow(icon: "person.crop.circle.fill", title: "Manage contacts")
                        InteracOptionRow(icon: "clock.fill", title: "Pending")
                        InteracOptionRow(icon: "list.bullet", title: "History")
                        InteracOptionRow(icon: "gearshape.fill", title: "Autodeposit settings")
                        InteracOptionRow(icon: "person.text.rectangle.fill", title: "Profile settings")
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
    
    // Interac Option Row
    struct InteracOptionRow: View {
        let icon: String
        let title: String
        
        @State private var isShowingSendMoney = false
        @State private var isShowingTransferMoney = false
        @State private var isShowingContactForm = false
        @State private var isShowingAccountForm = false


        var body: some View {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(Color.black)
                    .frame(width: 35, height: 35)
                
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .onTapGesture {
                if title == "Send money" {
                    isShowingSendMoney = true
                }
                else if title == "Transfer money" {
                    isShowingTransferMoney = true
                }
                else if title == "Manage Contacts" {
                    isShowingContactForm = true
                }
                else if title == "Manage Accounts" {
                    isShowingAccountForm = true
                }
                
            }
            .fullScreenCover(isPresented: $isShowingSendMoney) {
                SendMoneyView()
            }
            .fullScreenCover(isPresented: $isShowingTransferMoney) {
                //TransferMoneyScreen(showContactSheet: .constant(false))
                TransferMoneyScreen()

            }
            .fullScreenCover(isPresented: $isShowingContactForm) {
                AddContactFormView(isPresented: $isShowingContactForm, contactManager: ContactManager())
            }
            .fullScreenCover(isPresented: $isShowingAccountForm) {
                //TransferMoneyScreen()
                AddAccountFormView(accountManager: AccountManager())

            }
        }
    }
    
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
