import SwiftUI

// Define a model for each onboarding step.
struct OnBoardingStep {
    let image: String
    let title: String
    let description: String
}

// Define the content for each step of the onboarding process.
private let onBoardingSteps = [
    OnBoardingStep(image: "1024", title: NSLocalizedString("Welcome to OnlineEvents!", comment: "Onboarding welcome title"), description: NSLocalizedString("The place to see all Online events", comment: "Onboarding welcome description")),
    OnBoardingStep(image: "Registration", title: NSLocalizedString("Registrations", comment: "Onboarding registrations title"), description: NSLocalizedString("See upcoming registrations!", comment: "Onboarding registrations description")),
    OnBoardingStep(image: "Events", title: NSLocalizedString("Events", comment: "Onboarding events title"), description: NSLocalizedString("See upcoming events!", comment: "Onboarding events description")),
    OnBoardingStep(image: "DetailedEvents", title: NSLocalizedString("Details", comment: "Onboarding details title"), description: NSLocalizedString("See details about an event!", comment: "Onboarding details description")),
    OnBoardingStep(image: "MakeNotification", title: NSLocalizedString("Reminders", comment: "Onboarding reminders title"), description: NSLocalizedString("Click the bell to get reminded about the registration!", comment: "Onboarding reminders description")),
    OnBoardingStep(image: "SeeNotifications", title: NSLocalizedString("Manage Reminders", comment: "Onboarding manage reminders title"), description: NSLocalizedString("Click on the top bell to see your planned reminders and to delete them", comment: "Onboarding manage reminders description"))
]

// Main view for displaying the onboarding steps.
struct OnboardingView: View {
    @State private var currentStep = 0 // Tracks the current step in the onboarding process.
    @Binding var onboardingCompleted: Bool // Binding to track if onboarding is completed.
    var onDone: () -> Void // Closure to be called when onboarding is completed.
    
    // Store whether the welcome screen has been shown to avoid repeating the onboarding process.
    @AppStorage("welcomeScreenShown") var welcomeScreenShown: Bool = false
    
    init(onboardingCompleted: Binding<Bool>, onDone: @escaping () -> Void) {
        self._onboardingCompleted = onboardingCompleted
        self.onDone = onDone
        UIScrollView.appearance().bounces = false // Disable bouncing for the onboarding UIScrollView.
    }

    var body: some View {
        VStack {
            Spacer(minLength: 50) // Add some space at the top.
            
            // Tab view for swiping through the onboarding steps.
            TabView(selection: $currentStep) {
                ForEach(0..<onBoardingSteps.count, id: \.self) { index in
                    VStack {
                        // Display the image for the current onboarding step.
                        Image(onBoardingSteps[index].image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 250)
                        
                        // Title for the current step.
                        Text(onBoardingSteps[index].title)
                            .font(.title)
                            .bold()
                            .padding(.top, 30)
                        
                        // Description for the current step.
                        Text(onBoardingSteps[index].description)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            .padding(.top, 10)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Use page style without index display.
            
            // Indicator for the current step.
            HStack {
                ForEach(0..<onBoardingSteps.count, id: \.self) { index in
                    if index == currentStep {
                        Rectangle()
                            .frame(width: 20, height: 10)
                            .cornerRadius(10)
                            .foregroundColor(Color(hex: "#0D5474"))
                    } else {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.bottom, 10)
            
            // Button to go to the next step or complete the onboarding process.
            Button(action: {
                if self.currentStep < onBoardingSteps.count - 1 {
                    self.currentStep += 1
                } else {
                    UserDefaults.standard.welcomeScreenShown = true
                    onboardingCompleted = true
                    onDone() // Call the closure here
                }
            }) {
                Text(currentStep < onBoardingSteps.count - 1
                     ? NSLocalizedString("Next", comment: "")
                     : NSLocalizedString("Get Started", comment: ""))
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#0D5474"))
                    .padding(.horizontal, 16)
                    .foregroundColor(.white)
                    .cornerRadius(16)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 10)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onboardingCompleted: .constant(false), onDone: {})
    }
}
