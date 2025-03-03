//import SwiftUI
////
//struct BottomNavigationBar: View {
//    @Binding var selectedTab: Int // ✅ Binding to track selected tab
//    //
//    var body: some View {
//        NavigationStack{
//            VStack {
//                Spacer()
//                //
//                HStack {
//                    Spacer()
//                    //
//                    //                // ✅ Home Button
//                                    Button(action: {
//                                        selectedTab = 0 // Switch to Home
//                                    }) {
//                                        Image(systemName: "house.fill")
//                                            .font(.system(size: 28))
//                                            .foregroundColor(selectedTab == 0 ? .white : .gray)
//                                    }
////                    Button(action: {
////                        selectedTab = 0
////                    }) {
////                        NavigationLink(destination: HomeView()) {
////                            Image(systemName: "house.fill")
////                                .font(.system(size: 28))
////                                .foregroundColor(selectedTab == 0 ? .white : .gray)
////                        }
////                    }
//                    Spacer()
//                    //
//                    //                // ✅ Move Money Button
//                    Button(action: {
//                        selectedTab = 1 // Switch to MoveMoneyView
//                    }) {
//                        NavigationLink(destination: MoveMoneyView()){
//                            Image(systemName: "creditcard")
//                                .font(.system(size: 28))
//                                .foregroundColor(selectedTab == 1 ? .white : .gray)
//                        }
//                    }
//                    //
//                    Spacer()
//                    //
//                    Button(action: { selectedTab = 2 }) {
//                        ZStack {
//                            Circle()
//                                .fill(Color.deepTeal)
//                                .frame(width: 65, height: 65)
//                                .shadow(radius: 5)
//                            Image(systemName: "plus")
//                                .font(.system(size: 30, weight: .bold))
//                                .foregroundColor(.white)
//                        }
//                    }
//                    
//                    Spacer()
//                    
//                    Button(action: { selectedTab = 3 }) {
//                        Image(systemName: "dollarsign.bank.building")
//                            .font(.system(size: 28))
//                            .foregroundColor(selectedTab == 3 ? .white : .gray)
//                    }
//                    
//                    Spacer()
//                    
//                    Button(action: { selectedTab = 4 }) {
//                        Image(systemName: "house.fill")
//                            .font(.system(size: 28))
//                            .foregroundColor(selectedTab == 4 ? .white : .gray)
//                    }
//                    
//                    Spacer()
//                }
//                .frame(height: 90)
//                .background(
//                    RoundedRectangle(cornerRadius: 30, style: .continuous)
//                        .fill(Color.black.opacity(0.99))
//                        .ignoresSafeArea(.all, edges: .bottom)
//                )
//            }
//        }
//        //}
//        //}
//    }
//    //// ✅ Preview
//    struct BottomNavigationBar_Previews: PreviewProvider {
//        static var previews: some View {
//            BottomNavigationBar(selectedTab: .constant(0)) // ✅ Provide default binding
//        }
//    }
//    
//}
import SwiftUI

struct BottomNavigationBar: View {
    @Binding var selectedTab: Int // ✅ Binding to track selected tab

    var body: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                // ✅ Home Button
                Button(action: {
                    selectedTab = 0 // Switch to Home
                }) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 28))
                        .foregroundColor(selectedTab == 0 ? .white : .gray)
                }

                Spacer()

                // ✅ Move Money Button
                Button(action: {
                    selectedTab = 1 // Switch to MoveMoneyView
                }) {
                    Image(systemName: "creditcard")
                        .font(.system(size: 28))
                        .foregroundColor(selectedTab == 1 ? .white : .gray)
                }

                Spacer()

                Button(action: { selectedTab = 2 }) {
                    ZStack {
                        Circle()
                            .fill(Color.colorTeal)
                            .frame(width: 65, height: 65)
                            .shadow(radius: 5)
                        Image(systemName: "plus")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                    }
                }

                Spacer()

                Button(action: { selectedTab = 3 }) {
                    Image(systemName: "dollarsign.bank.building")
                        .font(.system(size: 28))
                        .foregroundColor(selectedTab == 3 ? .white : .gray)
                }

                Spacer()

                Button(action: { selectedTab = 4 }) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 28))
                        .foregroundColor(selectedTab == 4 ? .white : .gray)
                }

                Spacer()
            }
            .frame(height: 90)
            .background(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(Color.black.opacity(0.99))
                    .ignoresSafeArea(.all, edges: .bottom)
            )
        }
    }
}

// ✅ Preview
struct BottomNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavigationBar(selectedTab: .constant(0)) // ✅ Provide default binding
    }
}
