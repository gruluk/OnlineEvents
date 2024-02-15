//
//  EventViewModel.swift
//  OnlineEvents
//
//  Created by Luka Grujic on 31/12/2023.
//

import SwiftUI
import Foundation

class EventViewModel: ObservableObject {
    @Published var events = [Event]()
    @Published var isLoading = true

    func fetchEvents() {
        guard let url = URL(string: "https://old.online.ntnu.no/api/v1/events/?page_size=20") else {
            print("Invalid URL")
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Network request failed: \(error.localizedDescription)")
                    self.isLoading = false
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Server error: \(response.debugDescription)")
                    self.isLoading = false
                    return
                }

                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(EventResponse.self, from: data)
                        let currentDate = Date()
                        self.events = decodedResponse.results.filter { event in
                            if let eventStartDate = ISO8601DateFormatter().date(from: event.eventStart) {
                                return eventStartDate > currentDate
                            }
                            return false
                        }
                        .sorted(by: { $0.eventStart < $1.eventStart })
                    } catch {
                        print("Decoding failed: \(error.localizedDescription)")
                    }
                } else {
                    print("No data received from the server.")
                }
                self.isLoading = false
            }
        }.resume()
    }
    
    var nextThreeRegistrations: [Event] {
        let currentDate = Date()
        return events
            .filter { event in
                guard let registrationStartString = event.attendanceEvent?.registrationStart,
                      let registrationStartDate = ISO8601DateFormatter().date(from: registrationStartString) else {
                    return false
                }
                return registrationStartDate > currentDate
            }
            .prefix(3)
            .map { $0 }
    }

    var nextThreeEvents: [Event] {
        let currentDate = Date()
        return events
            .filter { event in
                guard let eventStartDate = ISO8601DateFormatter().date(from: event.eventStart) else {
                    return false
                }
                return eventStartDate > currentDate
            }
            .sorted(by: { $0.eventStart < $1.eventStart })
            .prefix(3)
            .map { $0 }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "#0D5474")))
                .scaleEffect(2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}
