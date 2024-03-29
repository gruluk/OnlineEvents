import SwiftUI

struct ReminderSheetView: View {
    var event: Event
    var isRegistrationStartInFuture: Bool
    var onReminderSet: (() -> Void)?
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTimeInterval = 15 * 60 // Default to 15 minutes
    @State private var showAlert = false

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .padding()
                        .font(.title3)
                        .foregroundStyle(Color.gray)
                }
            }

            if isRegistrationStartInFuture {
                Text(String(format: NSLocalizedString("Set a registration reminder for %@", comment: "Registration reminder title"), event.title))
                    .font(.headline)
                    .padding()
                
                Picker(NSLocalizedString("Reminder Time", comment: "Picker title for reminder time"), selection: $selectedTimeInterval) {
                    Text(NSLocalizedString("15 minutes before", comment: "15 minutes before")).tag(15 * 60)
                    Text(NSLocalizedString("30 minutes before", comment: "30 minutes before")).tag(30 * 60)
                    Text(NSLocalizedString("1 day before", comment: "1 day before")).tag(24 * 60 * 60)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Button(NSLocalizedString("Set Reminder", comment: "Button to set a reminder")) {
                    scheduleNotification()
                }
                .padding()
                .background(Color(hex: "#0D5474"))
                .foregroundColor(.white)
                .cornerRadius(10)
                
            } else {
                Text(NSLocalizedString("Registration start has already passed", comment: "Message for past registration"))
                    .font(.headline)
                    .padding()
            }
        }
        .frame(height: 500)
        .presentationDetents([.height(300)])
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(NSLocalizedString("Invalid Reminder Time", comment: "Alert title for invalid reminder")),
                message: Text(NSLocalizedString("The selected reminder time has already passed.", comment: "Alert message for past reminder time")),
                dismissButton: .default(Text(NSLocalizedString("OK", comment: "Dismiss button text")))
            )
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(NSLocalizedString("Enable Notifications", comment: "Alert title for enabling notifications")),
                message: Text(NSLocalizedString("Please enable notifications in settings to set a reminder.", comment: "Alert message for enabling notifications")),
                dismissButton: .default(Text(NSLocalizedString("OK", comment: "Dismiss button text")))
            )
        }
    }

    private func scheduleNotification() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus != .authorized {
                    // User has not granted notification permissions
                    showAlert = true
                } else {
                    // Proceed with scheduling the notification
                    guard let registrationStartStr = event.attendanceEvent?.registrationStart,
                          let registrationStartDate = ISO8601DateFormatter().date(from: registrationStartStr),
                          let reminderDate = calculateReminderDate(from: registrationStartDate, timeInterval: TimeInterval(selectedTimeInterval)),
                          reminderDate > Date() else {
                        showAlert = true
                        return
                    }
                    
                    NotificationManager.shared.scheduleNotification(for: event, at: reminderDate)
                    onReminderSet?()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }

    private func calculateReminderDate(from date: Date, timeInterval: TimeInterval) -> Date? {
        let reminderDate = date.addingTimeInterval(-timeInterval)
        return reminderDate > Date() ? reminderDate : nil
    }
}
