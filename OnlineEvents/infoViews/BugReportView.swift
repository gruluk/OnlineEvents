import SwiftUI
import WebKit

/// A view that displays a web view for submitting bug reports or feedback.
struct BugReportWebView: UIViewRepresentable {
    let urlString: String

    /// Creates the web view for displaying the bug report form.
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    /// Loads the bug report form when the view updates.
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

/// A view for displaying app information and providing a way to submit feedback or report bugs.
struct BugReportView: View {
    /// Retrieves the app version and build number from the bundle.
    var appVersion: String {
        let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown"
        return "Version \(versionNumber) (\(buildNumber))"
    }
    
    @Environment(\.presentationMode) var presentationMode
    let feedbackURLString = "https://docs.google.com/forms/d/e/1FAIpQLScrzxWeUUbFBTAB3a3ZSg0SNeybWhweXqLrnnDj0fVa61kfdQ/viewform?usp=sf_link"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // App icon and version information
                appInfoSection()

                // Description of the app's purpose and features
                appDescriptionSection()

                // Feedback button
                feedbackButton()

                // Developer information section
                developerInfoSection()
            }
            .padding()
        }
        .navigationTitle(NSLocalizedString("About", comment: "Navigation title for the About view"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                dismissButton()
            }
        }
    }

    /// Opens the feedback form URL in the browser.
    func openFeedbackURL() {
        guard let url = URL(string: feedbackURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    // MARK: - UI Component Functions

    /// Creates a button to dismiss the view.
    private func dismissButton() -> some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.down")
                .imageScale(.large)
                .foregroundColor(Color(hex: "#0D5474"))
        }
    }

    /// Section displaying the app information.
    private func appInfoSection() -> some View {
        HStack {
            Image("NewIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .padding()
                .foregroundColor(.black)

            VStack(alignment: .leading) {
                Text("OnlineEvents")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#0D5474"))

                Text(appVersion)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
            }
        }
        .padding(.top, 20)
    }

    /// Section displaying the app description.
    private func appDescriptionSection() -> some View {
        VStack {
            Text(NSLocalizedString("OnlineEvents is the app to easily get an overview of Online events.\n\nThe app is using the Online open API\n\n-See details about events\n-Get reminders for upcoming registrations!\n-See upcoming career opportunities.", comment: ""))
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }

    /// Button for submitting feedback or reporting bugs.
    private func feedbackButton() -> some View {
        Button(action: openFeedbackURL) {
            HStack {
                Text(NSLocalizedString("Give some feedback or report a bug", comment: ""))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
            .padding()
        }
        .background(Color(hex: "#0D5474"))
        .cornerRadius(12)
    }

    /// Section with information about the developer.
    private func developerInfoSection() -> some View {
        VStack(alignment: .leading) {
            Text(NSLocalizedString("Developers", comment: ""))
                .font(.headline)
                .foregroundColor(Color(hex: "#0D5474"))

            HStack {
                Image("ProfileLuka") // Ensure you have an image named 'ProfileLuka' in your assets.
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))

                VStack(alignment: .leading, spacing: 4) {
                    Text("Luka Grujic")
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "#0D5474"))

                    Text(NSLocalizedString("Hi there! 👋 I'm the author of OnlineEvents.\nYou can probably catch me A4", comment: ""))
                        .font(.caption)
                        .foregroundColor(Color(hex: "#0D5474").opacity(0.7))
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

struct BugReportView_Previews: PreviewProvider {
    static var previews: some View {
        BugReportView()
    }
}
