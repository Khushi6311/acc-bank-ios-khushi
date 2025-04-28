import SwiftUI

struct MainOptionsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showAddAccountSheet = false
    @State private var showAddContactSheet = false

    @State private var showAddPayeeSheet = false
    @State private var selectedPayees: [Payee] = []
    var body: some View {
        NavigationView {
            ZStack {
                Constants.backgroundGradient
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Top Header
                    HeaderView()
                        .frame(height: 25)
                        .background(Color.white)
                    
                    // Options Box
                    VStack(spacing: 10) {
                        // Add Account Button
                        Button(action: {
                            showAddAccountSheet = true
                        }) {
                            HStack {
                                Image(systemName: "building.columns.fill")
                                    .foregroundColor(.black)
                                    .font(.title2)
                                
                                Text("Add Contact")
                                    .foregroundColor(.black)
                                    .font(.headline)
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                        }
                        .sheet(isPresented: $showAddContactSheet) {
                            // Replace with your AddAccountFormView()
                            //Text("Add Account Form Placeholder")
                            //AddContactFormView(accountManager: AccountManager())
                            AddContactFormView(isPresented: .constant(false), contactManager: ContactManager())


                        }

                        Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)

                        // Add Payee Button
                        Button(action: {
                            showAddPayeeSheet = true
                        }) {
                            HStack {
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .foregroundColor(.black)
                                    .font(.title2)
                                
                                Text("Add Payee")
                                    .foregroundColor(.black)
                                    .font(.headline)
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                        }
                        .sheet(isPresented: $showAddPayeeSheet) {
                            // Replace with your AddPayeeFormView()
                            //Text("Add Payee Form Placeholder")
                            AddPayeeFormView { newPayee in
                                    // This is the onSave closure
                                    selectedPayees.append(newPayee)
                                    showAddPayeeSheet = false // Dismiss after save
                                    print("Payee saved: \(newPayee.name)")
                                //print("Payee saved: \(newPayee.payeeName)")

                                }                        }

                        Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)
                        Button(action: {
                            showAddAccountSheet = true
                        }) {
                            HStack {
                                Image(systemName: "building.columns.fill")
                                    .foregroundColor(.black)
                                    .font(.title2)
                                
                                Text("Add Account")
                                    .foregroundColor(.black)
                                    .font(.headline)
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                        }
                        .sheet(isPresented: $showAddAccountSheet) {
                            // Replace with your AddAccountFormView()
                            //Text("Add Account Form Placeholder")
                            //AddContactFormView(accountManager: AccountManager())
                            AddAccountFormView(accountManager: AccountManager())



                        }

                        Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 400)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(20)
                    .padding(.horizontal, 16)
                    .shadow(radius: 4)

                    Spacer()
                }
            }
        }
    }
}

#Preview {
    MainOptionsView()
}
