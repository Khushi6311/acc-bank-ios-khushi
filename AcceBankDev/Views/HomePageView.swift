
import SwiftUI

struct HomePageView: View {
    var username: String
    @State private var selectedAccount: String = "Chequing" // Default selected account
    let cardImages = ["Card", "Card2", "Card3"] // Replace with actual image names

    var body: some View {
        GeometryReader { geometry in // Use GeometryReader for dynamic layouts
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.colorTeal,
                        Color.colorBlue
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing:0){
                    // Use Reusable Header
                    HeaderView()
                        .zIndex(1) // Brings it forward
                        .frame(height: 25)
                        .background(Color.white) // Ensures visibility

                    Spacer().frame(height: 60)
//                    HeaderView()
//                        .padding(.top, -42)
                     //Header Section
                  //  VStack(spacing: 0) {
//                        HeaderView()
//                            .padding(.bottom, 20)

//                        ZStack {
//                            Color.white
//                                .frame(height: geometry.size.height * 0.12) // Adjust header height dynamically
//                                .frame(maxWidth: .infinity)
//                                .ignoresSafeArea(edges: .top)
//
//                            // Logo placed centrally below the notch
//                            Image("AppLogo")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.05) // Adjust logo size dynamically
////                                .padding(.top, geometry.safeAreaInsets.top * 0.3) // Adds some space below the notch
//                                .padding(.top, geometry.safeAreaInsets.top * -0.9) // Adds some space below the notch, while keeping logo inside white box
//                            
//                        }
                    //.padding(.bottom, 30)
 // }

                    // Profile Image
                    Image("profilePic")
                        .resizable()
                        .frame(width: geometry.size.width * 0.18, height: geometry.size.width * 0.18) // Dynamically scale the profile pic
                        .clipShape(Circle())
                        .padding(.top, -geometry.size.height * 0.05) // Adjust top padding dynamically

                    // Welcome Text Section
                    VStack(spacing: 1) {
                        Text(String(format: NSLocalizedString("welcome_text", comment: ""), username))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)

                        Text(NSLocalizedString("bank_name", comment: ""))
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)

                        Text(getGreeting())
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                    }

                    // Account Summary Section
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.55) // Make the account summary section dynamic
                        .overlay(
                            VStack(spacing: 15) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        AccountView(icon: "dollarsign.circle.fill",title:  NSLocalizedString("balance", comment: ""), number: "(6982)", amount: "$ 9006.23", isSelected: selectedAccount == "Balance")
                                            .onTapGesture {
                                                withAnimation { selectedAccount = "Balance" }
                                            }
                                        Divider()
                                            .frame(width: 1, height: 40)
                                            .background(Color.black.opacity(0.5))

                                        AccountView(icon: "banknote.fill", title: NSLocalizedString("savings", comment: ""), number: "(1234)", amount: "$ 1245.45", isSelected: selectedAccount == "Savings")
                                            .onTapGesture {
                                                withAnimation { selectedAccount = "Savings" }
                                            }

                                        Divider()
                                            .frame(width: 1, height: 40)
                                            .background(Color.black.opacity(0.5))

                                        AccountView(icon: "wallet.pass", title: NSLocalizedString("chequing", comment: ""), number: "(3456)", amount: "$ 2000.45", isSelected: selectedAccount == "Chequing")
                                            .onTapGesture {
                                                withAnimation { selectedAccount = "Chequing" }
                                            }

                                        Divider()
                                            .frame(width: 1, height: 40)
                                            .background(Color.black.opacity(0.5))

                                        AccountView(icon: "dollarsign.circle.fill", title: NSLocalizedString("loan", comment: ""), number: "(9999)", amount: "$ 5555.45", isSelected: selectedAccount == "Loan")
                                            .onTapGesture {
                                                withAnimation { selectedAccount = "Loan" }
                                            }
                                    }
                                    .padding(.horizontal, 20)
                                    .frame(minWidth: 700)
                                }
                                .frame(height: geometry.size.height * 0.12) // Adjust height based on screen size
                                .frame(maxWidth: .infinity)
                                .padding(.top, -50)

                                // Show cards if Chequing is selected
                                if selectedAccount == "Chequing" {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 15) {
//                                            ForEach(cardImages, id: \.self) { card in
//                                                CreditCardView(imageName: card)
//                                            }
                                            ForEach(Array(cardImages.enumerated()), id: \.offset) { index, card in
                                                CreditCardView(imageName: card)
                                            }

                                        }
                                        .padding(.horizontal)
                                    }
                                    .frame(height: 190)
                                    .transition(.opacity)
                                    .padding(.bottom, 20)
                                }
                                else if selectedAccount == "Savings" {
                                    HStack {
                                        if cardImages.indices.contains(1) {
                                                    CreditCardView(imageName: cardImages[1]) // Use second image
                                                }
                                    }
                                    .frame(height: 190)
                                    .padding(.horizontal)
                                    .transition(.opacity)
                                    .padding(.bottom, 20)
                                }else {
                                    Spacer()
                                        .frame(height: 190) // Keeps space for consistency
                                        .padding(.bottom, 20)
                                }
                            }
                        )
                        .animation(.easeInOut(duration: 0.3), value: selectedAccount)

                    Spacer()
                }
            }
        }
    }

    
    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12:
            //return "Good Morning"
            return NSLocalizedString("greeting_text", comment: "")

        case 12..<17:
            //return "Good Afternoon"
            return NSLocalizedString("good_afternoon", comment: "")

        default:
            //return "Good Evening"
            return NSLocalizedString("good_evening", comment: "")

        }
    }
}
struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
// Credit Card View
struct CreditCardView: View {
    var imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 350, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(username: "Danielle")
    }
}
