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
        .navigationTitle(NSLocalizedString("Upcoming Registrations", comment: "Title for registration view"))
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
