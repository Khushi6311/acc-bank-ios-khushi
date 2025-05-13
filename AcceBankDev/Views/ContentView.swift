import SwiftUI

//struct ContentView: View {
//    //@EnvironmentObject var languageManager: LanguageManager
//    @EnvironmentObject var appState: AppState
//
//    var body: some View {
////        Group {
////                    if appState.isLoggedIn {
////                        MainView()
////                    } else {
////                        LoginView()
////                    }
////                }
////        if appState.isLoggedIn {
////                    MainView() // Your actual HomePageView
////                } else {
////                    LoginView()
////                }
//        //Text("hello")
//        //PayBillScreen()
//        LoginView() //login screen
//        //HomeView(username: "Danielle")
//        //MoveMoneyView()
//        //RegisterPageView()
//        
//    }
//}
    struct ContentView: View {
        @EnvironmentObject var appState: AppState
        @EnvironmentObject var languageManager: LanguageManager
        var body: some View {
            NavigationStack {
                if appState.isLoggedIn {
                    MainView()
                        .environmentObject(appState)
                } else {
                    LoginView()
                        .environmentObject(appState)
                }
            }
        }
//        var body: some View {
//               NavigationStack {
//                   if appState.isLoggedIn {
//                       // Example: Show RootViewLauncher ONLY if starting on Cheque Deposit screen
//                       if appState.startOnChequeDeposit {
//                           RootViewLauncher()
//                       } else {
//                           MainView()
//                               .environmentObject(appState)
//                       }
//                   } else {
//                       LoginView()
//                           .environmentObject(appState)
//                   }
//               }
//           }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
               // .environmentObject(LanguageManager()) // create a new instance here
               .environmentObject(AppState())
                
        }
    }
