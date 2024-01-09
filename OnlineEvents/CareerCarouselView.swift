import SwiftUI

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

struct CareerOpportunityView: View {
    var opportunity: CareerOpportunity
    @State private var uiImage: UIImage?

    var body: some View {
        Button(action: {
            openLink(opportunityId: opportunity.id)
        }) {
            VStack(alignment: .leading) {
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
            .padding(.top, 5)
            .padding(.bottom, 5)
        }
    }

    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
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

    private func openLink(opportunityId: Int) {
        guard let url = URL(string: "https://online.ntnu.no/career/\(opportunityId)") else { return }
        UIApplication.shared.open(url)
    }
}
