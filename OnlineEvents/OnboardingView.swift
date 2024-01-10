import SwiftUI

struct OnBoardingStep {
    let image: String
    let title: String
    let description: String
}

private let onBoardingSteps = [
    OnBoardingStep(image : "1024", title: NSLocalizedString("Welcome to OnlineEvents!", comment: ""), description: NSLocalizedString("The place to see all Online events", comment: "")),
    OnBoardingStep(image : "Registration", title: NSLocalizedString("Registrations", comment: ""), description: NSLocalizedString("See upcoming registrations!", comment: "")),
    OnBoardingStep(image : "Events", title: NSLocalizedString("Events", comment: ""), description: NSLocalizedString("See upcoming events!", comment: "")),
    OnBoardingStep(image : "DetailedEvents", title: NSLocalizedString("Details", comment: ""), description: NSLocalizedString("See details about an event!", comment: "")),
    OnBoardingStep(image : "MakeNotification", title: NSLocalizedString("Reminders", comment: ""), description: NSLocalizedString("Click the bell to get reminded about the registration!", comment: "")),
    OnBoardingStep(
        image: "SeeNotifications",
        title: NSLocalizedString("Manage Reminders", comment: ""),
        description: NSLocalizedString("Click on the top bell to see your planned reminders and to delete them", comment: "")
    )
]

struct OnboardingView: View {
    @State private var currentStep = 0
    @Binding var onboardingCompleted: Bool
    var onDone: () -> Void
    
    @AppStorage("welcomScreenShown")
    var welcomeScreenShown: Bool = false
    
    init(onboardingCompleted: Binding<Bool>, onDone: @escaping () -> Void) {
        self._onboardingCompleted = onboardingCompleted
        self.onDone = onDone
        UIScrollView.appearance().bounces = false
    }

    var body: some View {
        
        VStack {
            Spacer(minLength: 50)
            Button(action: {
                self.currentStep = onBoardingSteps.count - 1
            }){
            }
        
            TabView(selection: $currentStep) {
                ForEach(0..<onBoardingSteps.count) { it in
                    VStack {
                        
                        Image(onBoardingSteps[it].image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 250)
                        
                        Text(onBoardingSteps[it].title)
                            .font(.title)
                            .bold()
                            .padding(.top, 30)
                        
                        Text(onBoardingSteps[it].description)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            .padding(.top, 10)
                    }
                    .tag(it)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack {
                ForEach(0..<onBoardingSteps.count) { it in
                    if it == currentStep {
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
        .onAppear(perform: {
            UserDefaults.standard.welcomeScreenShown = true
        })
    }
}

struct OnboardingView_Preview: PreviewProvider {
    static var previews: some View {
        OnboardingView(onboardingCompleted: .constant(false), onDone: {})
    }
}
