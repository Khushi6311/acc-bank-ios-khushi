//
//  ContactListScreen.swift
//  AcceBankDev
//
//  Created by MCT on 05/05/25.
//

import Foundation
import SwiftUI

struct ContactListScreen: View {
    @ObservedObject var contactManager = ContactManager()
    @State private var showAddContactSheet = false
    @Environment(\.dismiss) private var dismiss // To enable dismissing the view

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {

                // Back Button and Title
                HStack {
                    Button(action: {
                        dismiss() // Dismiss the view
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                            .font(.title2)
                    }
                    //Text("My Contacts")
                    Text(NSLocalizedString("My_Contacts_Title", comment: "Title for the user's contacts"))

                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // Add Contact Button
                Button(action: {
                    showAddContactSheet = true
                }) {
                    HStack {
                        Spacer()
                        HStack(spacing: 6) {
                            Image(systemName: "plus.circle.fill")
                            //Text("Add Contact")
                            Text(NSLocalizedString("Add_Contact_Button", comment: "Button to add contact"))

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

                // Scrollable Contact List
                ScrollView {
                    if contactManager.contacts.isEmpty {
                        //Text("No contacts found.")
//                        Text(NSLocalizedString("No_Contacts_Found", comment: "Empty state message"))
//
//                            .foregroundColor(.gray)
//                            .padding()
                        VStack(spacing: 12) {
                            Spacer()
        //                    Image(systemName: "tray")
        //                        .resizable()
        //                        .frame(width: 50, height: 50)
        //                        .foregroundColor(.gray.opacity(0.4))
                            //Text("No payees found.")
                            Text(NSLocalizedString("No_Contacts_Found", comment: "Empty state message"))

                                .foregroundColor(.gray)
                                .font(.body)
                                .padding(.top,250)

                            Spacer()
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        ForEach(contactManager.contacts, id: \.id) { contact in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(contact.name)
                                        .font(.headline)
                                        .foregroundColor(.black)

                                    Text(contact.email)
                                        .font(.caption)
                                        .foregroundColor(.gray)

                                    Text(contact.mobilePhone)
                                        .font(.caption2)
                                        .foregroundColor(.gray)
//                                    Text("Name: \(contact.name)")
//                                                        .font(.headline)
//                                                        .foregroundColor(.black)
//
//                                                    Text("Email: \(contact.email)")
//                                                        .font(.caption)
//                                                        .foregroundColor(.gray)
//
//                                                    Text("Phone: \(contact.mobilePhone)")
//                                                        .font(.caption2)
//                                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                if contact.sendByEmail {
                                    Image(systemName: "envelope.fill")
                                        .foregroundColor(.blue)
                                }
                                if contact.sendByMobile {
                                    Image(systemName: "phone.fill")
                                        .foregroundColor(.green)
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                            .shadow(color: .gray.opacity(0.1), radius: 1, x: 0, y: 1)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
            .sheet(isPresented: $showAddContactSheet, onDismiss: {
                contactManager.fetchContactsFromAPI()
            }) {
                AddContactFormView(isPresented: $showAddContactSheet, contactManager: contactManager) { newContact in
                    contactManager.contacts.append(newContact)
                }
            }
            .onAppear {
                contactManager.fetchContactsFromAPI()
            }
        }
    }
}

#if DEBUG
//struct ContactListScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        let mockManager = ContactManager()
//        mockManager.contacts = [
//            Contact(
//                id: UUID().uuidString,
//                name: "Alice Johnson",
//                email: "alice@example.com",
//                mobilePhone: "+11234567890",
//                sendByEmail: true,
//                sendByMobile: false,
//                nickname: "Ali",
//                language: "English"
//            ),
//            Contact(
//                id: UUID().uuidString,
//                name: "Bob Smith",
//                email: "bob@example.com",
//                mobilePhone: "+19876543210",
//                sendByEmail: false,
//                sendByMobile: true,
//                nickname: "Bobby",
//                language: "Français"
//            )
//        ]
//        return ContactListScreen(contactManager: mockManager)
//    }
//}
#if DEBUG
struct ContactListScreen_Previews: PreviewProvider {
    static var previews: some View {
        let mockManager = ContactManager()
        mockManager.contacts = [] // Simulate empty state
        
        return ContactListScreen(contactManager: mockManager)
            .previewDisplayName("Empty Contacts State")
    }
}
#endif

#endif
