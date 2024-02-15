import SwiftUI

/// The main view of the app showing upcoming events, registrations, and career opportunities.
struct HomeView: View {
    // MARK: - State Objects for ViewModel
    @StateObject var viewModel = EventViewModel() // Manages event data
    @StateObject var careerViewModel = CareerViewModel() // Manages career opportunities data
    @StateObject var notificationViewModel = NotificationViewModel() // Manages notification data
    
    // MARK: - UI State
    @State private var showingNotificationsSheet = false // Controls the presentation of the notifications sheet
    @State private var showingBugReportSheet = false // Controls the presentation of the bug report sheet
    @State private var showSpeechBubble = false // Controls the visibility of a speech bubble
    @State private var currentBubbleText = "" // Text content for the speech bubble
    @State private var showingUpdateInfo = false // Controls the presentation of the update info sheet
    
    private let currentAppVersion = "1.2.0" // Current version of the app, used to determine if the update info should be shown
    
    init() {
        // Customization of navigation bar appearance for the entire app
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color(hex: "#0D5474"))]
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
    }
    
    // Computed property to count the number of upcoming registrations
    var upcomingRegistrationsCount: Int {
        viewModel.nextThreeRegistrations.count
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Loading indicator or content based on the loading state
                    if viewModel.isLoading {
                        LoadingView() // Placeholder for actual loading view
                    } else {
                        // Section for upcoming registrations
                        upcomingRegistrationsSection()
                        
                        // Section for upcoming events
                        upcomingEventsSection()
                        
                        // Section for career opportunities
                        careerSection()
                        
                        // Optional speech bubble for additional user interaction
                        speechBubbleSection()
                    }
                }
                .padding(.top, 20)
                .sheet(isPresented: $showingNotificationsSheet, onDismiss: refreshNotifications) {
                    NotificationsView()
                }
                .sheet(isPresented: $showingBugReportSheet) {
                    NavigationView {
                        BugReportView()
                    }
                }            }
            .sheet(isPresented: $showingUpdateInfo) {
                UpdateInfoView(dismissAction: {
                    self.showingUpdateInfo = false
                })
            }
            .navigationTitle(NSLocalizedString("Home", comment: "Title for the Home view"))
            .toolbar {
                navigationBarTrailingItems()
            }
            .onAppear {
                // Fetch data and check for updates upon view appearance
                viewModel.fetchEvents()
                careerViewModel.fetchCareerOpportunities()
                notificationViewModel.fetchNotifications()
                checkForUpdates()
            }
        }
        .accentColor(Color(hex: "#0D5474"))
    }
    
    // MARK: - Private Functions
    
    /// Refreshes the list of notifications.
    private func refreshNotifications() {
        notificationViewModel.fetchNotifications()
    }
    
    /// Checks if there's a new update to the app and presents update info if necessary.
    private func checkForUpdates() {
        let viewedVersion = UserDefaults.standard.string(forKey: "viewedUpdateVersion")
        if viewedVersion != currentAppVersion {
            showingUpdateInfo = true
            UserDefaults.standard.set(currentAppVersion, forKey: "viewedUpdateVersion")
        }
    }
    
    // MARK: - UI Components
    
    /// Returns a section for upcoming registrations.
    private func upcomingRegistrationsSection() -> some View {
        VStack(spacing: 20) {
            HStack {
                Text(NSLocalizedString("Next Registrations", comment: "Section title for registrations"))
                    .font(.title2)
                    .foregroundColor(Color(hex: "#0D5474"))
                    .bold()
                
                Spacer()
                
                NavigationLink(destination: UpcomingRegistrationsView()) {
                    Text(NSLocalizedString("Show More", comment: "Link to show more registrations"))
                        .foregroundColor(Color(hex: "#0D5474"))
                        .bold()
                }
            }
            .padding(.horizontal)
            
            VStack {
                if viewModel.nextThreeRegistrations.isEmpty {
                    Text(NSLocalizedString("No Upcoming Registrations", comment: ""))
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    ForEach(Array(viewModel.nextThreeRegistrations.enumerated()), id: \.element.id) { (index, event) in
                        EventItemView(event: event, displayMode: .registrationTime)
                            .padding(.horizontal)
                        
                        if index < viewModel.nextThreeRegistrations.count - 1 {
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .padding([.leading, .trailing], 10)
        }
    }
    
    /// Returns a section for upcoming events.
    private func upcomingEventsSection() -> some View {
        VStack {
            HStack {
                Text(NSLocalizedString("Next Events", comment: "Section title for events"))
                    .font(.title2)
                    .foregroundColor(Color(hex: "#0D5474"))
                    .bold()
                
                Spacer()
                
                NavigationLink(destination: UpcomingEventsView()) {
                    Text(NSLocalizedString("Show More", comment: "Link to show more events"))
                        .foregroundColor(Color(hex: "#0D5474"))
                        .bold()
                }
            }
            .padding(.horizontal)
            
            VStack {
                ForEach(Array(viewModel.nextThreeEvents.enumerated()), id: \.element.id) { (index, event) in
                    EventItemView(event: event, displayMode: .eventTime)
                        .padding(.horizontal)
                    
                    if index < viewModel.nextThreeEvents.count - 1 {
                        Divider()
                            .padding(.horizontal)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .padding([.leading, .trailing], 10)
        }
    }
    
    /// Returns a section for career opportunities.
    private func careerSection() -> some View {
        VStack {
            HStack {
                Text(NSLocalizedString("Career", comment: "Section title for career opportunities"))
                    .font(.title2)
                    .foregroundColor(Color(hex: "#0D5474"))
                    .bold()
                
                Spacer()
            }
            .padding(.horizontal)
            
            if !careerViewModel.careerOpportunities.isEmpty {
                CareerCarouselView(careerOpportunities: careerViewModel.careerOpportunities)
            }
        }
    }
    
    /// Returns a section for the optional speech bubble.
    private func speechBubbleSection() -> some View {
        VStack {
            if showSpeechBubble {
                SpeechBubbleView(text: currentBubbleText)
                    .transition(.scale) // Add a transition effect
            }
            
            Button(action: {
                withAnimation {
                    showSpeechBubble.toggle()
                    if showSpeechBubble {
                        currentBubbleText = SpeechTexts.phrases.randomElement() ?? "Hello!"
                    }
                }
            }) {
                Image("Graf")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            .padding(.bottom, 60)
        }
    }
    
    /// Returns the navigation bar items for the trailing side.
    private func navigationBarTrailingItems() -> some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button(action: {
                self.showingBugReportSheet = true
            }) {
                Image(systemName: "info.circle")
                    .foregroundColor(Color(hex: "#0D5474"))
            }
            Button(action: {
                self.showingNotificationsSheet = true
            }) {
                ZStack {
                    Image(systemName: "bell")
                        .foregroundColor(Color(hex: "#0D5474"))
                    
                    // Badge view for notifications
                    if notificationViewModel.notifications.count > 0 {
                        Text("\(notificationViewModel.notifications.count)")
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color(hex: "#0D5474"))
                            .clipShape(Circle())
                            .offset(x: 10, y: -10)
                    }
                }
            }
        }
    }
}
    

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
