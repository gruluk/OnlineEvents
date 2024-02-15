import SwiftUI

struct NotificationsView: View {
    @StateObject private var viewModel = NotificationViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.down")
                        .foregroundColor(Color.white)
                        .padding()
                        .font(.title3)
                }
            }

            Text(NSLocalizedString("Upcoming Reminders", comment: "Title for upcoming reminders"))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()

            List {
                if viewModel.notifications.isEmpty {
                    VStack {
                        Text(NSLocalizedString("You have no upcoming notifications", comment: ""))
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(hex: "#0D5474"))
                            .padding(.bottom, 10)

                        Text(NSLocalizedString("Go in to an event that has a registration and make a notification", comment: ""))
                            .font(.body)
                            .foregroundColor(Color(hex: "#0D5474"))
                            .multilineTextAlignment(.center)
                    }
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(viewModel.notifications, id: \.identifier) { request in
                        VStack(alignment: .leading) {
                            Text(request.content.title)
                                .font(.headline)
                            Text(request.content.body)
                            Text(String(format: NSLocalizedString("Scheduled for: %@", comment: "Scheduled date and time"), viewModel.formatTriggerDate(request)))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .onDelete(perform: deleteNotification)
                }
            }
        }
        .background(Color(hex: "#0D5474"))
        .onAppear {
            viewModel.fetchNotifications()
        }
    }
    
    private func deleteNotification(at offsets: IndexSet) {
        offsets.forEach { index in
            let notificationId = viewModel.notifications[index].identifier
            viewModel.cancelNotification(notificationId)
        }
    }
}
