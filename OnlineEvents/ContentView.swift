import SwiftUI
import UserNotifications

// Extension to simplify UserDefaults usage for showing the welcome screen.
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
    @StateObject var viewModel = EventViewModel() // ViewModel for managing event data.
    @State private var selectedTab: Int = 0 // Tracks the currently selected tab.
    
    // Tracks whether the onboarding process has been completed to decide which view to show.
    @State private var onboardingCompleted: Bool = UserDefaults.standard.welcomeScreenShown

    // Request permission for notifications when the app is first launched.
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Permission granted for notifications.")
            } else if let error = error {
                print("Error requesting notifications permission: \(error.localizedDescription)")
            }
        }
    }
    
    init() {
        // Customize the appearance of the tab bar.
        UITabBar.appearance().tintColor = UIColor(Color(hex: "#0D5474"))
    }

    var body: some View {
        if !onboardingCompleted {
            // Show the onboarding view if the onboarding process has not been completed.
            OnboardingView(onboardingCompleted: $onboardingCompleted, onDone: requestNotificationPermission)
        } else {
            // Main content view with a tab bar interface.
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label(NSLocalizedString("Home", comment: "Tab title for home"), systemImage: "house")
                    }
                    .tag(0)
                
                KioskView()
                    .tabItem {
                        Label("Kiosk", systemImage: "fork.knife")
                    }
                    .tag(3)
            }
            .accentColor(Color(hex: "#0D5474")) // Sets the accent color for the TabView.
        }
    }
}

// Extension to provide a convenient initializer for Colors using hex values.
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
        ContentView().accentColor(Color(hex: "#0D5474")) // Preview the ContentView with a specific accent color.
    }
}
