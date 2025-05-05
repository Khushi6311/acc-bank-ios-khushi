import SwiftUI

struct ContentView: View {
    //@EnvironmentObject var languageManager: LanguageManager
    var body: some View {
        //Text("hello")
        //PayBillScreen()
        LoginView() //  login screen
        //HomeView(username: "Danielle")
        //MoveMoneyView()
        //RegisterPageView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
           // .environmentObject(LanguageManager()) // create a new instance here

            
    }
}
