//
//  CareerViewModel.swift
//  OnlineEvents
//
//  Created by Luka Grujic on 09/01/2024.
//

import SwiftUI
import Foundation

class CareerViewModel: ObservableObject {
    @Published var careerOpportunities = [CareerOpportunity]()
    @Published var isLoading = false

    func fetchCareerOpportunities() {
        guard let url = URL(string: "https://old.online.ntnu.no/api/v1/career/") else {
            print("Invalid URL")
            isLoading = false
            return
        }

        isLoading = true
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
                        let decodedResponse = try JSONDecoder().decode(CareerResponse.self, from: data)
                        self.careerOpportunities = decodedResponse.results
                    } catch {
                        print("Decoding failed: \(error)")
                    }
                }
                self.isLoading = false
            }
        }.resume()
    }
}
