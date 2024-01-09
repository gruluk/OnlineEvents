//
//  NotificationManager.swift
//  OnlineEvents
//
//  Created by Luka Grujic on 01/01/2024.
//

import SwiftUI
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func scheduleNotification(for event: Event, at date: Date) {
        let localizedTitle = String(format: NSLocalizedString("Reminder for %@", comment: "Notification title"), event.title)
        let localizedBody = NSLocalizedString("Registration is starting soon!", comment: "Notification body")

        scheduleNotificationAtDate(
            title: localizedTitle,
            body: localizedBody,
            date: date
        )
    }
    
    func scheduleNotificationAtDate(title: String, body: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}
