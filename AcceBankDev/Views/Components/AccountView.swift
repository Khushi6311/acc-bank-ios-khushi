//
//  AccountView.swift
//  AcceBankDev
//
//  Created by MCT on 18/02/25.
//



import SwiftUI

struct AccountView: View {
    var icon: String
    var title: String
    var number: String
    var amount: String
    var isSelected: Bool

    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .stroke(Color.gray, lineWidth: 1)
                    .frame(width: 50, height: 50)

                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    //.foregroundColor(isSelected ? Color.blue : Color.gray)//this change color on selelct 
                    .foregroundColor(.gray)

                if isSelected {
                    Circle()
//                        .fill(
//                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.teal]), startPoint: .top, endPoint: .bottom)
//                        )
                        .fill(Constants.backgroundGradient) // Use the predefined gradient variable

                        .frame(width: 20, height: 20)
                        .overlay(
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .font(.system(size: 10, weight: .bold))
                        )
                        .offset(x: 17, y: 17) // Move checkmark to the **bottom right**
                        .shadow(radius: 2) // Adds subtle shadow for visibility
                }
            }

            VStack(spacing: 0) {
                Text("\(title) \(number)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .multilineTextAlignment(.center)
                    .layoutPriority(1)
                    .frame(maxWidth: .infinity)

                Text(amount)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.gray)
            }
        }
        .frame(minWidth: 100, maxWidth: .infinity)
    }
}





//#Preview {
//    AccountView()
//}
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(
            icon: "house.fill",
            title: "Savings",
            number: "(1234)",
            amount: "$1245.45",
            isSelected: false
        )
        .previewLayout(.sizeThatFits) // Ensures proper preview size
        .padding() // Adds spacing for better visibility
    }
}
