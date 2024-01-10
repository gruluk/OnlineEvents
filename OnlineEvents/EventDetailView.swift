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
                    
                    VStack(spacing: 15) {
                        Text(formatDate(event.eventStart))
                            .font(.subheadline)
                            .foregroundColor(.black)
                        
                        Image(systemName: "arrow.down")
                            .foregroundColor(.gray)
                        
                        Text(formatDate(event.eventEnd))
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    if let attendance = event.attendanceEvent, let maxCapacity = attendance.maxCapacity, let numberOfSeatsTaken = attendance.numberOfSeatsTaken {
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.gray)
                                .padding(.trailing, 5)
                            
                            Text("\(numberOfSeatsTaken)/\(maxCapacity)")
                                .font(.subheadline)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)
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

    func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "E, d MMM yyyy HH:mm"

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
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
