import SwiftUI

/// A view that displays a list of scheduled notifications and allows users to delete them.
struct NotificationsView: View {
    @StateObject private var viewModel = NotificationViewModel() // ViewModel to manage notification data.
    @Environment(\.presentationMode) var presentationMode // Used to dismiss the view.

    var body: some View {
        VStack {
            // Header with dismiss button
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Dismiss the view when button is tapped.
                }) {
                    Image(systemName: "arrow.down") // Use a system image for the button.
                        .foregroundColor(Color.white)
                        .padding()
                        .font(.title3)
                }
            }

            // Title for the notifications view
            Text(NSLocalizedString("Upcoming Reminders", comment: "Title for upcoming reminders"))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()

            // List of notifications
            List {
                // Display a message if there are no notifications
                if viewModel.notifications.isEmpty {
                    VStack {
                        Text(NSLocalizedString("You have no upcoming notifications", comment: "No notifications message"))
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(hex: "#0D5474"))
                            .padding(.bottom, 10)

                        Text(NSLocalizedString("Go in to an event that has a registration and make a notification", comment: "Instructions for creating notifications"))
                            .font(.body)
                            .foregroundColor(Color(hex: "#0D5474"))
                            .multilineTextAlignment(.center)
                    }
                    .listRowBackground(Color.clear) // Make the list row background transparent.
                } else {
                    // Display each notification with options to delete
                    ForEach(viewModel.notifications, id: \.identifier) { request in
                        VStack(alignment: .leading) {
                            Text(request.content.title) // Notification title
                                .font(.headline)
                            Text(request.content.body) // Notification body
                            // Scheduled date and time for the notification
                            Text(String(format: NSLocalizedString("Scheduled for: %@", comment: "Scheduled date and time"), viewModel.formatTriggerDate(request)))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .onDelete(perform: deleteNotification) // Enable swipe to delete functionality.
                }
            }
        }
        .background(Color(hex: "#0D5474")) // Set the background color of the view.
        .onAppear {
            viewModel.fetchNotifications() // Fetch notifications when the view appears.
        }
    }
    
    /// Deletes the notification at the specified index set.
    /// - Parameter offsets: The set of indexes of the notifications to be deleted.
    private func deleteNotification(at offsets: IndexSet) {
        offsets.forEach { index in
            let notificationId = viewModel.notifications[index].identifier // Get the notification ID.
            viewModel.cancelNotification(notificationId) // Request the viewModel to cancel the notification.
        }
    }
}
