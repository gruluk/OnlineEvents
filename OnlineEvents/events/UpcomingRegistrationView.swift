import SwiftUI

struct UpcomingRegistrationsView: View {
    @StateObject var viewModel = EventViewModel()

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color(hex: "#0D5474"))]
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                LoadingView()
            } else {
                ScrollView {
                    VStack(spacing: 5) {
                        ForEach(Array(viewModel.events.filter { shouldDisplayEvent($0) }.enumerated()), id: \.element.id) { (index, event) in
                            EventItemView(event: event, displayMode: .registrationTime)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            
                            if index < viewModel.events.filter { shouldDisplayEvent($0) }.count - 1 {
                                Divider()
                            }
                        }
                    }
                }
                .refreshable {
                    viewModel.fetchEvents()
                }
            }
        }
        .navigationTitle(NSLocalizedString("Next Registrations", comment: "Title for registration view"))
        .onAppear {
            viewModel.fetchEvents()
        }
    }

    func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: dateString)
    }
    
    private func shouldDisplayEvent(_ event: Event) -> Bool {
        guard let registrationStartString = event.attendanceEvent?.registrationStart,
              let registrationStartDate = dateFromString(registrationStartString) else {
            return false
        }
        return registrationStartDate > Date()
    }
}

struct UpcomingRegistrationsView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingRegistrationsView()
    }
}


/*
 
 4. Consider a Contributing Guide
 A CONTRIBUTING file can help others know how they can contribute to your project. It might include:

 Code of Conduct: Set expectations for behavior.
 Contribution Process: How to propose changes, how to submit pull requests, etc.
 5. Set Up Issue and Pull Request Templates
 GitHub allows you to set up templates for issues and pull requests. These templates guide contributors to provide necessary information when submitting issues or making pull requests, making the maintainers' jobs easier.

 6. Publish on GitHub
 Once your project is ready and you have considered the points above:

 Create a new repository on GitHub.
 Add your project files to this repository using Git.
 Write an initial commit message and push your changes to GitHub.
 7. Engage with Your Community
 After your project is public, be ready to engage with contributors. Respond to issues, review pull requests, and be active in discussions related to your project.

 Additional Considerations
 Security Vulnerabilities: Be aware that making your code public can expose security vulnerabilities. Regularly review your code for potential issues.
 Dependencies: Make sure all dependencies used by your project are compatible with your open-source license.
 Continuous Integration/Continuous Deployment (CI/CD): Setting up CI/CD workflows can help automate testing and ensure code quality.
 Open sourcing a project can be highly rewarding and is a significant contribution to the software community. By following these steps and considerations, you can ensure your project is ready for the wider world and set it up for success.
 
 */
