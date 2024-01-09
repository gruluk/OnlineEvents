//
//  EventResponse.swift
//  OnlineEvents
//
//  Created by Luka Grujic on 31/12/2023.
//

import SwiftUI
import Foundation

struct EventResponse: Codable {
    let results: [Event]
    let next: String?
}

struct Event: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let eventStart: String
    let eventEnd: String
    let location: String
    let image: EventImage?
    let slug: String
    let attendanceEvent: AttendanceEvent?
    let eventType: Int

    enum CodingKeys: String, CodingKey {
        case id, title, description, location, image, slug, eventType = "event_type"
        case eventStart = "event_start", eventEnd = "event_end"
        case attendanceEvent = "attendance_event"
    }
}

struct AttendanceEvent: Codable {
    let registrationStart: String?
    let registrationEnd: String?
    let maxCapacity: Int?
    let numberOfSeatsTaken: Int?
    
    enum CodingKeys: String, CodingKey {
        case registrationStart = "registration_start"
        case registrationEnd = "registration_end"
        case maxCapacity = "max_capacity"
        case numberOfSeatsTaken = "number_of_seats_taken"
    }
}

struct EventImage: Codable {
    let thumb: String
    let original: String
}
