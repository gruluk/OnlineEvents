//
//  NotificationViewModel.swift
//  OnlineEvents
//
//  Created by Luka Grujic on 01/01/2024.
//

import SwiftUI
import UserNotifications

class NotificationViewModel: ObservableObject {
    @Published var notifications: [UNNotificationRequest] = []

    func fetchNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                self.notifications = requests
            }
        }
    }

    func formatTriggerDate(_ request: UNNotificationRequest) -> String {
        if let calendarTrigger = request.trigger as? UNCalendarNotificationTrigger,
           let nextTriggerDate = calendarTrigger.nextTriggerDate() {
            return formatDate(nextTriggerDate)
        } else if let timeIntervalTrigger = request.trigger as? UNTimeIntervalNotificationTrigger {
            return formatDate(Date(timeIntervalSinceNow: timeIntervalTrigger.timeInterval))
        } else {
            return "Unknown"
        }
    }
    
    func cancelNotification(_ id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        fetchNotifications()
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
