import SwiftUI
import UserNotifications

/// Manages scheduling and handling of local notifications for events.
class NotificationManager {
    static let shared = NotificationManager() // Singleton instance for global access.

    private init() {} // Private initializer to enforce singleton usage.

    /// Schedules a local notification for an event at a specified date.
    /// - Parameters:
    ///   - event: The event for which to schedule the notification.
    ///   - date: The date and time when the notification should be triggered.
    func scheduleNotification(for event: Event, at date: Date) {
        let localizedTitle = String(format: NSLocalizedString("Reminder for %@", comment: "Notification title"), event.title)
        let localizedBody = NSLocalizedString("Registration is starting soon!", comment: "Notification body")

        // Delegate to a more generic function to handle the scheduling.
        scheduleNotificationAtDate(
            title: localizedTitle,
            body: localizedBody,
            date: date
        )
    }
    
    /// Schedules a notification with given title, body, and date.
    /// - Parameters:
    ///   - title: The title of the notification.
    ///   - body: The body text of the notification.
    ///   - date: The date and time when the notification should be triggered.
    private func scheduleNotificationAtDate(title: String, body: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default // Use the default notification sound.

        // Create a date components trigger for the specified date.
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        // Create the notification request and add it to the system.
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}
