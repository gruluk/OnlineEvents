import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = EventViewModel()
    @StateObject var careerViewModel = CareerViewModel()
    @StateObject var notificationViewModel = NotificationViewModel()
    @State private var showingNotificationsSheet = false
    @State private var showingBugReportSheet = false
    @State private var showSpeechBubble = false
    @State private var currentBubbleText = ""
    
    init() {
        // Apply to all navigation bars in the app
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color(hex: "#0D5474"))]
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
    }
    
    // Badge count for upcoming registrations
    var upcomingRegistrationsCount: Int {
        viewModel.nextThreeRegistrations.count
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.isLoading {
                        LoadingView()
                    } else {
                        // Upcoming Registrations
                        HStack {
                            Text(NSLocalizedString("Registrations", comment: "Section title for registrations"))
                                .font(.title3)
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

                        // Upcoming Events
                        HStack {
                            Text(NSLocalizedString("Events", comment: "Section title for events"))
                                .font(.title3)
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
                        
                        ForEach(Array(viewModel.nextThreeEvents.enumerated()), id: \.element.id) { (index, event) in
                            EventItemView(event: event, displayMode: .eventTime)
                                .padding(.horizontal)
                            
                            if index < viewModel.nextThreeEvents.count - 1 {
                                Divider()
                                    .padding(.horizontal)
                            }
                        }
                        
                        // Career carousel
                        HStack {
                            Text(NSLocalizedString("Career", comment: "Section title for career opportunities"))
                                .font(.title3)
                                .foregroundColor(Color(hex: "#0D5474"))
                                .bold()

                            Spacer()

                        }
                        .padding(.horizontal)

                        if !careerViewModel.careerOpportunities.isEmpty {
                            CareerCarouselView(careerOpportunities: careerViewModel.careerOpportunities)
                        }
                        
                        
                        
                        
                        // Online logo
                        
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
                            .padding(.trailing, 20)
                            .padding(.bottom, 60)
                        }
                    }
                }
                .padding(.top, 20)
                .sheet(isPresented: $showingNotificationsSheet, onDismiss: refreshNotifications) {
                    NotificationsView()
                }
            }
            .navigationTitle(NSLocalizedString("Home", comment: "Title for the Home view"))
            .toolbar {
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

                            // Badge view
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
            .sheet(isPresented: $showingBugReportSheet) {
                BugReportView()
            }
            .onAppear {
                viewModel.fetchEvents()
                careerViewModel.fetchCareerOpportunities()
                notificationViewModel.fetchNotifications()
            }
        }
        .accentColor(Color(hex: "#0D5474"))
    }
    
    private func refreshNotifications() {
        notificationViewModel.fetchNotifications()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
