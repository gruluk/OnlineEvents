import SwiftUI

struct EventDetailView: View {
    var event: Event
    @State private var showingReminderSheet = false
    @State private var showingNotificationsSheet = false
    @State private var showSuccessToast = false
    
    init(event: Event) {
        self.event = event
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    // Event Image View
                    if let firstImageUrl = event.image?.original, let url = URL(string: firstImageUrl) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .aspectRatio(contentMode: .fit)
                    }
                    
                    // Circles with Start and End Times
                    VStack {
                        HStack {
                            VStack{
                                Circle()
                                    .fill(Color(hex: "#0D5474"))
                                    .frame(width: 20, height: 20)
                                Text(formatTime(event.eventStart))
                                    .font(.headline) // Larger font for the time
                                    .foregroundColor(Color(hex: "#0D5474"))
                                Text(formatDate(event.eventStart))
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                            
                            DottedLine()
                            
                            Spacer()
                            
                            VStack {
                                Circle()
                                    .fill(Color(hex: "#0D5474"))
                                    .frame(width: 20, height: 20)
                                
                                Text(formatTime(event.eventEnd))
                                    .font(.headline)
                                    .foregroundColor(Color(hex: "#0D5474"))
                                
                                Text(formatDate(event.eventEnd))
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    HStack(spacing: 20) { // Add spacing between the two VStacks

                        // Attendance View
                        VStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(Color(hex: "#0D5474"))

                            if let attendance = event.attendanceEvent, let maxCapacity = attendance.maxCapacity, let numberOfSeatsTaken = attendance.numberOfSeatsTaken {
                                Text("\(numberOfSeatsTaken)/\(maxCapacity)")
                                    .font(.subheadline)
                            } else {
                                Text("?")
                                    .font(.subheadline)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)

                        Divider().frame(height: 50)

                        // Location View
                        VStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(Color(hex: "#0D5474"))
                            
                            if !event.location.isEmpty {
                                Text(event.location)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.center) // Ensure text is centered if it wraps
                            } else {
                                Text("?")
                                    .font(.subheadline)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    // Registration Start Date
                    if let registrationStart = event.attendanceEvent?.registrationStart, !registrationStart.isEmpty {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(NSLocalizedString("Registration Starts", comment: "When the registration starts"))
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }
                            
                            if isRegistrationStartInFuture(registrationStart) {
                                Text(formatDate(registrationStart))
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            } else {
                                Text(NSLocalizedString("Registration has passed", comment: ""))
                                    .font(.subheadline)
                                    .foregroundColor(Color(hex: "#F9B759"))
                            }
                        }
                        .padding()
                        .background(Color(hex: "#0D5474"))
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onTapGesture {
                            if isRegistrationStartInFuture(registrationStart) {
                                self.showingReminderSheet = true
                            }
                        }
                        .sheet(isPresented: $showingReminderSheet) {
                            ReminderSheetView(event: event, isRegistrationStartInFuture: isRegistrationStartInFuture(registrationStart)) {
                                // This closure is called after the reminder is set successfully
                                self.showSuccessToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    self.showSuccessToast = false
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Event description
                    Text(event.description)
                        .font(.body)
                    
                    // Webpage
                    if let url = URL(string: "https://online.ntnu.no/events/\(event.id)") {
                        Button(action: {
                            UIApplication.shared.open(url)
                        }) {
                            Text(NSLocalizedString("Event page", comment: "Button to event page"))
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: "#0D5474"))
                                .cornerRadius(10)
                        }
                        .padding(.top)
                    }
                }
                .padding()
            }
            .navigationTitle(event.title)
            .zIndex(0)
            
            // Toast message
            if showSuccessToast {
                toastView
                    .zIndex(1)
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity)) // Add asymmetric transition for insertion and removal
                    .padding(.top, 20) // Position from the top of the screen
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showSuccessToast = false
                            }
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    private var toastView: some View {
        Text(NSLocalizedString("Reminder has been successfully set", comment: ""))
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .opacity(showSuccessToast ? 1 : 0) // Animate opacity based on showSuccessToast state
            .animation(.easeInOut(duration: 0.5), value: showSuccessToast) // Animate opacity change
    }

    func formatTime(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        } else {
            return NSLocalizedString("Unknown Time", comment: "")
        }
    }

    func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "E, d. MMM" // Adjusted format
            return formatter.string(from: date)
        } else {
            return NSLocalizedString("Unknown Date", comment: "")
        }
    }
    
    func isRegistrationStartInFuture(_ registrationStartStr: String?) -> Bool {
        guard let registrationStartStr = registrationStartStr,
              let registrationStartDate = ISO8601DateFormatter().date(from: registrationStartStr) else {
            return false
        }
        return registrationStartDate > Date()
    }
}


// Custom Dotted Line View
struct DottedLine: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                // Adjust the y value to account for the circle's radius and stroke width
                let centerY = height / 2 - 25 // Assuming the circle's radius plus the circle's stroke width is 10
                path.move(to: CGPoint(x: 0, y: centerY))
                path.addLine(to: CGPoint(x: width, y: centerY))
            }
            .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round, dash: [5]))
            .foregroundColor(.gray)
        }
        .frame(height: 20) // Set the frame height equal to the circle diameter plus any stroke width
    }
}

