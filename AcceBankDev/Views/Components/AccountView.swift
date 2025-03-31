//
//  AccountView.swift
//  AcceBankDev
//
//  Created by MCT on 18/02/25.
//


//import SwiftUI
//
//struct AccountView: View {
//    var icon: String
//    var title: String
//    var number: String
//    var amount: String
//    var isSelected: Bool
//
//    var body: some View {
//        VStack(spacing: 5) { // Vertical stack with spacing
//            ZStack {
//                Circle()
//                    .stroke(Color.gray, lineWidth: 1) // Always gray, even when selected
//                    .frame(width: 50, height: 50)
//
//                Image(systemName: icon)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 24, height: 24) // Ensures icon does not shrink
//                    .foregroundColor(.gray)
//                
//                if isSelected {
//                    Circle()
////                        .fill(
////                            LinearGradient(gradient: Gradient(colors: [Color.colorBlue, Color.colorTeal]), startPoint: .top, endPoint: .bottom)
////                        )
//                        Color.backgroundGradient.edgesIgnoringSafeArea(.all)
//                        .frame(width: 22, height: 22)
//                        .overlay(
//                            Image(systemName: "checkmark")
//                                .foregroundColor(.white)
//                                .font(.system(size: 12, weight: .bold))
//                        )
//                        .offset(x: 15, y: -15) // Positioned at the top-right of the icon
//                }
//            }
//            
//            VStack(spacing: 0) { // Stack title & number closer
//                Text("\(title) \(number)")
//                    .font(.system(size: 14, weight: .medium))
//                    .foregroundColor(.black)
//                    .fixedSize(horizontal: false, vertical: true) // Prevents text from shrinking
//
//                Text(amount)
//                    .font(.system(size: 12, weight: .bold))
//                    .foregroundColor(.gray)
//            }
//            .frame(maxWidth: .infinity) // Ensures text does not compress
//        }
//        .frame(maxWidth: .infinity)
//    }
//}
//###################
//import SwiftUI
//
//struct AccountView: View {
//    var icon: String
//    var title: String
//    var number: String
//    var amount: String
//    var isSelected: Bool
//
//    var body: some View {
//        VStack(spacing: 5) {
//            ZStack {
//                Circle()
//                    .stroke(Color.gray, lineWidth: 1)
//                    .frame(width: 50, height: 50)
//
//                Image(systemName: icon)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 24, height: 24)
//                    .foregroundColor(isSelected ? Color.blue : Color.gray)
//
//                if isSelected {
//                    Circle()
//                        .fill(Color.blue)
//                        .frame(width: 18, height: 18)
//                        .overlay(
//                            Image(systemName: "checkmark")
//                                .foregroundColor(.white)
//                                .font(.system(size: 10, weight: .bold))
//                        )
//                        .offset(x: 15, y: -15)
//                }
//            }
//
//            VStack(spacing: 0) {
//                Text("\(title) \(number)")
//                    .font(.system(size: 14, weight: .medium))
//                    .foregroundColor(.black)
//                    .lineLimit(1)
//                    .fixedSize(horizontal: true, vertical: false)
//                    .multilineTextAlignment(.center) // Ensures text is centered
//                    .layoutPriority(1) // Prevents compression
//                    .frame(maxWidth: .infinity) // Ensures uniform width
//
//                Text(amount)
//                    .font(.system(size: 12, weight: .bold))
//                    .foregroundColor(.gray)
//            }
//        }
//        .frame(minWidth: 100, maxWidth: .infinity) // Ensures equal space across items
//    }
//}
//#############
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
