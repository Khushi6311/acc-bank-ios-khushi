//
//  AddPayeeForm.swift
//  AcceBankDev
//
//  Created by MCT on 05/05/25.
//

import Foundation
import SwiftUI
struct AddPayeeFormView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var payeeManager = PayeeManager()

    @State private var accountNumber = ""
    @State private var selectedPayee = ""
    @State private var showPayeeList = false
    @State private var searchText = ""

    @State private var showPayeeError = false
    @State private var showAccountError = false
    @State private var payeeName = ""
    @State private var showPayeeNameError = false
    @State private var showPayeeTypeError = false
    @State private var showSuccessMessage = false
    @State private var showSuccessScreen = false

    let payeeTypes = [
        "CRA – GST/HST", "CRA – Payroll",
        "Hydro One", "Enbridge Gas", "Toronto Hydro",
        "Bell Canada", "Rogers Cable", "Telus Mobility",
        "City of Toronto Property Tax", "City of Ottawa Taxes",
        "National Student Loan Service", "RBC Loan Payments",
        "Manulife", "Sun Life Financial", "Desjardins"
    ]

    var onSave: (Payee) -> Void

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                //Text("Add New Payee")
                Text(NSLocalizedString("add_new_payee", comment: "Header title for add payee screen"))

                    .font(.headline)
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                }
            }
            .padding()
            VStack(alignment: .leading, spacing: 5) {
//                   Text("Payee Name")
//                       .font(.caption)
//                       .foregroundColor(.gray)
                   //TextField("Enter Payee Name", text: $payeeName)
                TextField(NSLocalizedString("enter_payee_name", comment: "Placeholder for payee name"), text: $payeeName)

                       .padding()
                       .background(Color(.systemGray6))
                       .cornerRadius(10)
                //for remove error msg
                       //.onChange(of: payeeName) { _ in
                       .onChange(of: payeeName) { oldValue, newValue in

                               showPayeeNameError = false
                           }
                if showPayeeNameError {
                    Text(NSLocalizedString("error_payee_name_required", comment: "Payee name required"))
                            .foregroundColor(.red)
                            .font(.caption)
                    }
               }
               .padding(.horizontal)
            // Payee Dropdown with Search
            VStack(alignment: .leading, spacing: 0) {
                
                // Payee Name Field
                

                Button(action: {
                    withAnimation {
                        showPayeeList.toggle()
                    }
                    //for remove error msg

                    showPayeeTypeError = false
                }) {
                    HStack {
                        //Text(selectedPayee.isEmpty ? "Select Payee" : selectedPayee)
                        Text(selectedPayee.isEmpty ? NSLocalizedString("select_payee", comment: "Dropdown placeholder") : selectedPayee)

                            .foregroundColor(selectedPayee.isEmpty ? .gray : .black)
                        Spacer()
                        Image(systemName: showPayeeList ? "chevron.up" : "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }

                if showPayeeList {
                    VStack(spacing: 0) {
                        // Search bar
                        

                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(payeeManager.payeeTypes.filter {
                                    searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)
                                }) { payee in
                                    Button(action: {
                                        selectedPayee = payee.name
                                        showPayeeList = false
                                        searchText = ""
                                    }) {
                                        Text(payee.name)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding()
                                    }
                                    Divider()
                                }

                            }
                        }
                        .frame(maxHeight: 400)
                    }
                    .foregroundColor(Color.black)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
                }
                if showPayeeTypeError {
                    Text(NSLocalizedString("error_payee_type_required", comment: "Payee type required"))
                            .foregroundColor(.red)
                            .font(.caption)
                    }
            }
            .padding(.horizontal)

            
            VStack(alignment: .leading,spacing:4){
                // Account Number Field
                //TextField("Account Number", text: $accountNumber)
                TextField(NSLocalizedString("account_number", comment: "Placeholder for account number"), text: $accountNumber)

                    //.keyboardType(.numberPad)
                    .keyboardType(.numbersAndPunctuation)
                      .submitLabel(.done)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    //.padding(.horizontal)
                //for remove error msg
                    //.onChange(of: accountNumber) { _ in
                    .onChange(of: accountNumber) { oldValue, newValue in

                            showAccountError = false
                        }
                if showAccountError {
                    Text(NSLocalizedString("error_account_number_required", comment: "Account number required"))
                        .foregroundColor(.red)
                        .font(.caption)
                        
                    
                }
                    
            }.padding(.horizontal)

            // Save Button
            Button(action: {
                validateAndSave()
                
            }) {
                //Text("Save Account")
                Text(NSLocalizedString("save_account", comment: "Save button label"))

                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
//            if showSuccessMessage {
//                Text("Payee Added Successfully!")
//                    .font(.headline)
//                    .foregroundColor(.black)
//                    .padding()
//                    .transition(.slide)
//                    .zIndex(1)
//            }
            .fullScreenCover(isPresented: $showSuccessScreen) {
                PayeeSuccessView {
                    dismiss()  // This will dismiss AddPayeeFormView and return to MainOptions
                }
            }

            Spacer()
        }
        .onAppear {
            payeeManager.fetchPayeeTypes()
        }

        .background(Color.white.ignoresSafeArea())
    }
    
    //API
    private func savePayeeToAPI() {
        guard let token = TokenManager.shared.getToken() else {
            print("No token found")
            return
        }

        guard let selectedType = payeeManager.payeeTypes.first(where: { $0.name == selectedPayee }) else {
            print("Payee type not selected or not found")
            return
        }

        let requestData = AddPayeeRequest(
            PayeeName: !payeeName.isEmpty ? payeeName : selectedPayee,
                PayeeNumber: accountNumber,
                PayeeType: selectedType.payeeTypeId
        )

        guard let url = URL(string: AppConfig.AddPayeeURL) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let jsonData = try JSONEncoder().encode(requestData)

            // Print request body as JSON string
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Request JSON:\n\(jsonString)")
            }

            request.httpBody = jsonData
        } catch {
            print("JSON Encoding error: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("API Error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                    print("Payee added successfully")
                    DispatchQueue.main.async {
                        //dismiss()
                        //showSuccessMessage = true
                        showSuccessScreen = true

                    }
                } else {
                    print("Server responded with status code: \(httpResponse.statusCode)")
                    if let data = data, let message = String(data: data, encoding: .utf8) {
                        print("Server message: \(message)")
                    }
                }
            }
        }.resume()
    }



    private func validateAndSave() {
        // Reset previous errors
        showPayeeNameError = false
        showPayeeTypeError = false
        showAccountError = false

        var isValid = true

        if payeeName.trimmingCharacters(in: .whitespaces).isEmpty {
            showPayeeNameError = true
            isValid = false
        }

        if selectedPayee.isEmpty {
            showPayeeTypeError = true
            isValid = false
        }

        if accountNumber.trimmingCharacters(in: .whitespaces).isEmpty {
            showAccountError = true
            isValid = false
        }

        guard isValid else { return }

        // Save logic
        savePayeeToAPI()

        let finalPayeeName = !payeeName.isEmpty ? payeeName : selectedPayee
        let newPayee = Payee(
            payeeId: UUID().uuidString,
            payeeName: finalPayeeName,
            payeeNumber: accountNumber,
            payeeTypeName: selectedPayee,
            accountId: accountNumber

        )
        //onSave(newPayee)
        //dismiss()
        //showSuccessMessage = true
        showSuccessScreen = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            dismiss()
        }

            // Then dismiss after a delay
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                dismiss()
//            }
    }


}
struct PayeeSuccessView: View {
    var onDone: () -> Void

    var body: some View {
        VStack {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)

            Text("Payee Added Successfully!")
                .font(.title2)
                .bold()
                .padding()

            Spacer()

            Button(action: onDone) {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.black)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
        .background(Color.white.ignoresSafeArea())
    }
}

    
//struct PayeeType: Identifiable, Codable, Equatable {
//    var id: String
//    var name: String
//
//}
struct AddPayeeRequest: Codable {
    let PayeeName: String
    let PayeeNumber: String
    let PayeeType: String
}


struct PayeeTypeResponse: Codable {
    let status: String
    let data: [PayeeType]
    let message: String
    let statusCode: Int
}

struct PayeeType: Codable, Identifiable {
    var id: String { payeeTypeId } // computed id for SwiftUI
    let name: String
    let payeeTypeId: String
}

class PayeeManager: ObservableObject {
    @Published var payeeTypes: [PayeeType] = []

    func fetchPayeeTypes() {
        guard let token = TokenManager.shared.getToken() else {
            print("No token found")
            return
        }

        guard let url = URL(string: AppConfig.GetPayeeCategoryURL) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("API Error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }

            if let data = data, let raw = String(data: data, encoding: .utf8) {
                print("Raw Response Body:\n\(raw)")
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(PayeeTypeResponse.self, from: data)
                DispatchQueue.main.async {
                    self.payeeTypes = decodedResponse.data
                }
            } catch {
                print("Decoding failed: \(error)")
            }

        }.resume()
    }

}
#if DEBUG
struct AddPayeeFormView_Previews: PreviewProvider {
    static var previews: some View {
        AddPayeeFormView { _ in
            print("Mock payee saved")
        }
    }
}
#endif
