import SwiftUI


struct PayeeListSection: View {
    @ObservedObject var payeeVM: PayeeViewModel
    @Binding var showAddPayeeSheet: Bool
    @State private var isPresentingAddPayeeForm = false
    @Environment(\.dismiss) private var dismiss // To enable dismissing the view

    var body: some View {
        VStack(spacing: 16) {
            // Header
//            HStack {
//                Text("Payees")
//                    .font(.headline)
//                Spacer()
//                Button(action: {
//                    isPresentingAddPayeeForm = true
//                }) {
//                    HStack(spacing: 4) {
//                        Image(systemName: "plus.circle.fill")
//                        Text("Add Payee")
//                    }
//                    .font(.subheadline)
//                    .foregroundColor(.black)
//                }
//            }
//            .padding(.horizontal)
            HStack {
                Button(action: {
                    dismiss() // Dismiss the view
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .font(.title2)
                }
                //Text("Payees")
                Text(NSLocalizedString("Payees_Title", comment: "Title for the user's payees"))

                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal)
            .padding(.top, 10)

            // Add Contact Button
            Button(action: {
                isPresentingAddPayeeForm = true
            }) {
                HStack {
                    Spacer()
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                        //Text("Add payee")
                        Text(NSLocalizedString("Add_Payee_Button", comment: "Button to add payee"))

                            .font(.headline)
                    }
                    .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.1), radius: 1, x: 0, y: 1)
                .padding(.horizontal)
            }

            if payeeVM.payees.isEmpty {
                VStack(spacing: 12) {
                    Spacer()
//                    Image(systemName: "tray")
//                        .resizable()
//                        .frame(width: 50, height: 50)
//                        .foregroundColor(.gray.opacity(0.4))
                    //Text("No payees found.")
                    Text(NSLocalizedString("No_Payees_Found", comment: "Empty state message"))

                        .foregroundColor(.gray)
                        .font(.body)
                    Spacer()
                }
                .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(payeeVM.payees, id: \.payeeId) { payee in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(payee.payeeName)
                                        .font(.headline)

                                    Text(payee.payeeNumber)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                Text(payee.payeeTypeName)
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 4)
                }
            }
        }
        .padding(.top)
        .onAppear {
            if payeeVM.payees.isEmpty {
                payeeVM.fetchPayeesFromAPI()
            }
        }
//        .fullScreenCover(isPresented:#imageLiteral(resourceName: "simulator_screenshot_2549A28A-8EF0-4205-BFA6-A27453A6E716.png") $isPresentingAddPayeeForm) {
//                    AddPayeeFormView { newPayee in
//                        // Optional: Refresh or manually append
//                        payeeVM.fetchPayeesFromAPI()
//                    }
//                }
        .sheet(isPresented: $isPresentingAddPayeeForm, onDismiss: {
                    payeeVM.fetchPayeesFromAPI()
                }) {
                    AddPayeeFormView { _ in
                        isPresentingAddPayeeForm = false
                    }
                    .presentationDetents([.height(800)]) // You can change height as needed
                    .presentationDragIndicator(.visible)
                }

    }
}

//#if DEBUG
//struct PayeeListSection_Previews: PreviewProvider {
//    @State static var dummySheet = false
//
//    static var previews: some View {
//        let mockViewModel = PayeeViewModel()
//        mockViewModel.payees = [
//            Payee(payeeId: UUID().uuidString, payeeName: "Hydro One", payeeNumber: "123456789", payeeTypeName: "Utility"),
//            Payee(payeeId: UUID().uuidString, payeeName: "Bell Canada", payeeNumber: "987654321", payeeTypeName: "Telecom")
//        ]
//        return PayeeListSection(payeeVM: mockViewModel, showAddPayeeSheet: $dummySheet)
//            .previewLayout(.sizeThatFits)
//    }
//}
//for empty screen
struct PayeeListSection_Previews: PreviewProvider {
    @State static var dummySheet = false

    static var previews: some View {
        let emptyViewModel = PayeeViewModel()
        emptyViewModel.payees = [] // Simulate no payees

        return PayeeListSection(payeeVM: emptyViewModel, showAddPayeeSheet: $dummySheet)
            .previewDisplayName("No Payees Found State")
            .previewLayout(.sizeThatFits)
    }
}

//#endif
