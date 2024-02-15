import SwiftUI

/// A view that displays information about the latest updates to the app.
struct UpdateInfoView: View {
    /// A closure to dismiss the view.
    var dismissAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Title for the update information section.
            Text(NSLocalizedString("What's New", comment: "Title for what's new section"))
                .font(.title)
                .bold()
                .padding(.top)
            
            Spacer()
            
            // Detailed description of the updates.
            Text(NSLocalizedString("We have a new app icon!\n\nOnline is making an official app! Please check it out on App Store and Play Store when it comes out. \n\nOnlineEvents was never supposed to be an official Online app, only a hobby project to make Online events easier for everyone!\n\nI appreciate the feedback and hope the app is useful <3 \n\n - Luka", comment: "Description of new updates"))
                .padding([.leading, .trailing, .bottom])
            
            // Display the new app icon or relevant image.
            Image("NewIcon")
                .resizable()
                .scaledToFit()
                .frame(height: 100) // Adjust the image size as needed.
            
            Spacer()
            
            // Button for users to acknowledge the update information.
            Button(NSLocalizedString("Got it!", comment: "Acknowledge button text")) {
                dismissAction() // Invoke the dismiss action when tapped.
            }
            .foregroundColor(.white)
            .padding()
            .background(Color(hex: "#0D5474")) // Use the app's theme color.
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity) // Ensure the view expands to the full width of its container.
    }
}

// MARK: - Preview

struct UpdateInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateInfoView(dismissAction: {})
            .previewLayout(.sizeThatFits)
            .padding() // Add padding to the preview for better visualization.
    }
}
