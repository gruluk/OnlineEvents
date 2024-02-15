import SwiftUI

/// Displays a horizontally scrolling carousel of career opportunities.
struct CareerCarouselView: View {
    var careerOpportunities: [CareerOpportunity]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(careerOpportunities, id: \.self) { opportunity in
                    CareerOpportunityView(opportunity: opportunity)
                        .frame(width: 150, height: 250)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

/// A view representing a single career opportunity in the carousel.
struct CareerOpportunityView: View {
    var opportunity: CareerOpportunity
    @State private var uiImage: UIImage?

    var body: some View {
        Button(action: {
            // Action to open the career opportunity link.
            openLink(opportunityId: opportunity.id)
        }) {
            VStack(alignment: .leading) {
                // Display the company's logo or a placeholder image.
                companyLogoView()
                
                // Display the title of the career opportunity.
                Text(opportunity.title)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.top, 5)
                    .foregroundColor(.black)

                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            .padding(.vertical, 5)
        }
    }
    
    /// Loads the company's logo image from a URL string.
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL for company image")
            return
        }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.uiImage = image
                }
            }
        }
    }

    /// Opens the specific career opportunity link.
    private func openLink(opportunityId: Int) {
        guard let url = URL(string: "https://online.ntnu.no/career/\(opportunityId)") else { return }
        UIApplication.shared.open(url)
    }

    /// Returns a view for the company's logo, either loaded from the URL or a placeholder.
    private func companyLogoView() -> some View {
        Group {
            if let uiImage = self.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .foregroundColor(.gray)
                    .onAppear {
                        loadImage(from: opportunity.company.image.xs)
                    }
            }
        }
    }
}
