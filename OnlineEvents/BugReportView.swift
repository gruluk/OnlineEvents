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
        @Environment(\.presentationMode) var presentationMode
        let formURLString = "https://docs.google.com/forms/d/e/1FAIpQLScrzxWeUUbFBTAB3a3ZSg0SNeybWhweXqLrnnDj0fVa61kfdQ/viewform?usp=sf_link"

        var body: some View {
            
            HStack {
                Image(systemName: "xmark")
                    .foregroundColor(.clear)
                    .padding()
                    .font(.title3)

                Spacer()

                Text("Version: 1.0.0")
                    .foregroundColor(.white)

                Spacer()

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .padding()
                        .font(.title3)
                }
            }
            .background(Color(hex: "#0D5474"))
            
            BugReportWebView(urlString: formURLString)
                .navigationBarTitle("Bug Report", displayMode: .inline)
        }
    }


struct BugReportView_Previews: PreviewProvider {
    static var previews: some View {
        BugReportView()
    }
}
