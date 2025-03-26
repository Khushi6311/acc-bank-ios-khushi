//import SwiftUI
//
//struct HeaderView: View {
//    var body: some View {
//        ZStack {
//            Color.white
//                .frame(height: 90) // set fixed height
//                .frame(maxWidth: .infinity)
//                .ignoresSafeArea(edges: .top)
//
//            // Properly Scaled and Centered Logo
//            Image("AppLogo")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 140, height: 35) // Set fixed width & height for consistency
//        }
//    }
//}
//
//// MARK: - Preview
//struct HeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        HeaderView()
//    }
//}
import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack {
            ZStack {
                Color.white
                    .frame(height: 40) // Fixed header height
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea(edges: .top) // Fixes notch issues

                // Properly Scaled Logo
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.4, height: 40)
                    .padding(.top, 10) // Prevents overlap with the notch
                    .padding(.top,-19)
//                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? -15) // Prevents logo from overlapping with notch

            }
        }
        .frame(height: 40) // Ensures header takes up space
    }
}


struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
            //.previewDevice("iPhone 14 Pro") // Test on different devices
    }
}
