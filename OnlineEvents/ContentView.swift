import SwiftUI
import UserNotifications

extension UserDefaults {
    var welcomeScreenShown: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "welcomeScreenShown") as? Bool) ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "welcomeScreenShown")
        }
    }
}

struct ContentView: View {
    @StateObject var viewModel = EventViewModel()
    @State private var selectedTab: Int = 0
    @State private var onboardingCompleted: Bool = UserDefaults.standard.welcomeScreenShown

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Permission granted")
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    init() {
        // Apply the color to the tab items
        UITabBar.appearance().tintColor = UIColor(Color(hex: "#0D5474"))
    }

    var body: some View {
        if !onboardingCompleted {
            OnboardingView(onboardingCompleted: $onboardingCompleted, onDone: requestNotificationPermission)
        } else {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label(NSLocalizedString("Home", comment: "Tab title for registrations"), systemImage: "house")
                    }
                    .tag(0)
                
                KioskView()
                    .tabItem {
                        Label("Kiosk", systemImage: "fork.knife")
                    }
                    .tag(3)
            }
            .accentColor(Color(hex: "#0D5474"))
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().accentColor(Color(hex: "#0D5474"))
    }
}
