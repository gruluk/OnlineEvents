import SwiftUI
import UserNotifications

/// ViewModel for managing and displaying scheduled notifications.
class NotificationViewModel: ObservableObject {
    @Published var notifications: [UNNotificationRequest] = [] // Holds the current list of scheduled notifications.

    /// Fetches the current list of pending notification requests.
    func fetchNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                self.notifications = requests // Update the published notifications list.
            }
        }
    }

    /// Formats the trigger date of a notification request for display.
    /// - Parameter request: The notification request to format the trigger date for.
    /// - Returns: A string representation of the trigger date.
    func formatTriggerDate(_ request: UNNotificationRequest) -> String {
        if let calendarTrigger = request.trigger as? UNCalendarNotificationTrigger,
           let nextTriggerDate = calendarTrigger.nextTriggerDate() {
            return formatDate(nextTriggerDate) // For calendar triggers, format the next trigger date.
        } else if let timeIntervalTrigger = request.trigger as? UNTimeIntervalNotificationTrigger {
            return formatDate(Date(timeIntervalSinceNow: timeIntervalTrigger.timeInterval)) // For time interval triggers, calculate and format the date.
        } else {
            return "Unknown" // If the trigger type is unrecognized, return "Unknown".
        }
    }
    
    /// Cancels a notification with the specified identifier.
    /// - Parameter id: The identifier of the notification to cancel.
    func cancelNotification(_ id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        fetchNotifications() // Refresh the notifications list after cancellation.
    }

    /// Formats a date into a readable string.
    /// - Parameter date: The date to format.
    /// - Returns: The formatted date string.
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date) // Convert the date to a string with medium date and short time styles.
    }
}
