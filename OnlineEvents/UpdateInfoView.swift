import SwiftUI

struct UpdateInfoView: View {
    var dismissAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text(NSLocalizedString("What's New", comment: "Title for what's new section"))
                .font(.title)
                .bold()
                .padding(.top)
            
            Spacer()
            
            Text(NSLocalizedString("We have a new app icon!\n\nOnline is making an official app! Please check it out on App Store and Play Store when it comes out. \n\nOnlineEvents was never supposed to be an official Online app, only a hobby project to make Online events easier for everyone!\n\nI appreciate the feedback and hope the app is useful <3 \n\n - Luka", comment: "Description of new updates"))
                .padding([.leading, .trailing, .bottom])
            
            Image("NewIcon")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
            
            Spacer()
            
            Button(NSLocalizedString("Got it!", comment: "Acknowledge button text")) {
                dismissAction()
            }
            .foregroundColor(.white)
            .padding()
            .background(Color(hex: "#0D5474"))
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

struct UpdateInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateInfoView(dismissAction: {})
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
