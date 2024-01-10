import SwiftUI
import WebKit

struct BugReportWebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

struct BugReportView: View {
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
                HStack {
                    Image("Graf")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .padding()
                        .foregroundColor(.black)
                    
                    VStack{
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
                
                VStack {
                    
                    Text("OnlineEvents is the app to easily get an overview of Online events.\n\n-See details about events\n-Get reminders for upcoming registrations!\n-See upcoming career opportunities.")
                        .multilineTextAlignment(.leading)
                        .padding()
                        .foregroundColor(Color(hex: "#0D5474"))
                }
                .padding()
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Feedback Button
                Button(action: openFeedbackURL) {
                    HStack {
                        Text("Give some feedback or report a bug")
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                .background(Color(hex: "#0D5474"))
                .cornerRadius(12)

                // Author Section
                VStack {
                    Text("AUTHORS")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    HStack {
                        Image("Graf") // Replace with the actual image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))

                        VStack(alignment: .leading, spacing: 4) {
                            
                            Text("Luka Grujic")
                                .fontWeight(.medium)
                                .foregroundColor(Color(hex: "#0D5474"))
                            
                            Text("Hi there! 👋 I'm the author of OnlineEvents.\nI'm passionate for Online and making digital solutions that feel intuitive.")
                                .font(.caption)
                                .foregroundColor(Color(hex: "#0D5474").opacity(0.7))
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                Spacer()
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .imageScale(.large)
                        .foregroundColor(.black)
                }
            }
        }
    }
    func openFeedbackURL() {
        guard let url = URL(string: feedbackURLString) else { return }
        UIApplication.shared.open(url)
    }
}



struct BugReportView_Previews: PreviewProvider {
    static var previews: some View {
        BugReportView()
    }
}
