import SwiftUI
//in this file add logic that open icon wise on home click open home 
struct MainView: View {
    @State private var selectedTab = 0 // Tracks the selected tab
    //var username: String // Accept username from LoginView
    @State private var username: String = UserDefaults.standard.string(forKey: "SavedUsername") ?? "Guest" // Load username from storage



    var body: some View {
        ZStack {
            selectedView //  Calls the selected view dynamically

            VStack {
                Spacer()
                BottomNavigationBar(selectedTab: $selectedTab) // Pass binding
                    .frame(height:70)
                    .padding(.bottom,0)//added
            }
        }
    }

    //Returns the view based on selectedTab
    private var selectedView: some View {
        Group {
            switch selectedTab {
            case 0:
                //HomePageView(username: "Danielle")
                HomePageView(username: username)

                //HomeView()
            case 1:
                MoveMoneyView()
            case 4:
           MoreOptionsView()
                
            default:
                HomeView()
            }
        }
    }
}

// Preview
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
