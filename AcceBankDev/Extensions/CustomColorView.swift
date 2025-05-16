//import SwiftUI
//
//extension Color {
//    static let colorTeal = Color(red: 0x00 / 255, green: 0x4D / 255, blue: 0x6E / 255) // #004D6E//deepTeal
//    static let colorBlue = Color(red: 0x1E / 255, green: 0x90 / 255, blue: 0xFF / 255) // #1E90FF//dodgerBlue
//    static let backgroundGradient = LinearGradient(
//            gradient: Gradient(colors: [Color.colorTeal, Color.colorBlue]),
//            startPoint: .leading,
//            endPoint: .trailing
//        )
//    
//   
//}
import SwiftUI

// Color Extension (Common Colors)
extension Color {
    static let colorTeal = Color(red: 0x00 / 255, green: 0x4D / 255, blue: 0x6E / 255) // #004D6E // deepTeal
    static let colorBlue = Color(red: 0x1E / 255, green: 0x90 / 255, blue: 0xFF / 255) // #1E90FF // dodgerBlue
}

// Global Constants
struct Constants {
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color.colorTeal, Color.colorBlue]),
        startPoint: .leading,
        endPoint: .trailing
    )
}

