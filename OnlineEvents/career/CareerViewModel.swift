import SwiftUI
import Foundation

/// ViewModel responsible for fetching and managing the career opportunities data.
class CareerViewModel: ObservableObject {
    // MARK: Published Properties
    
    /// The list of career opportunities fetched from the API.
    @Published var careerOpportunities = [CareerOpportunity]()
    
    /// Indicates whether the network request is in progress.
    @Published var isLoading = false

    /// Fetches career opportunities from the specified API endpoint.
    func fetchCareerOpportunities() {
        // The URL for the career opportunities API.
        guard let url = URL(string: "https://old.online.ntnu.no/api/v1/career/") else {
            print("Invalid URL")
            isLoading = false
            return
        }

        isLoading = true // Indicate that loading has started.
        
        // Create a data task to fetch career opportunities.
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return } // Ensure self is available.
                
                if let error = error {
                    // Handle and print network request failures.
                    print("Network request failed: \(error.localizedDescription)")
                    self.isLoading = false
                    return
                }

                // Check for HTTP status code indicating success.
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Server error: \(response.debugDescription)")
                    self.isLoading = false
                    return
                }

                // Attempt to decode the JSON response into `CareerResponse`.
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(CareerResponse.self, from: data)
                        self.careerOpportunities = decodedResponse.results // Store the fetched career opportunities.
                    } catch {
                        // Handle decoding errors.
                        print("Decoding failed: \(error)")
                    }
                }
                self.isLoading = false // Indicate that loading has finished.
            }
        }.resume() // Start the data task.
    }
}
