import SwiftUI

struct UpcomingEventsView: View {
    @StateObject var viewModel = EventViewModel()
    @State private var selectedViewMode = ViewMode.list  // State for the selected view mode

    enum ViewMode {
        case list, calendar
    }

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color(hex: "#0D5474"))]
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                LoadingView()
            } else {
                // Picker for selecting the view mode
                Picker("View Mode", selection: $selectedViewMode) {
                    Text(NSLocalizedString("List", comment: "View mode option")).tag(ViewMode.list)
                    Text(NSLocalizedString("Calendar", comment: "View mode option")).tag(ViewMode.calendar)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                ScrollView {
                    VStack(spacing: 5) {
                        if selectedViewMode == .list {
                            ForEach(viewModel.events) { event in
                                EventItemView(event: event, displayMode: .eventTime)
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                
                                Divider()
                            }
                        } else {
                            CalendarView(events: viewModel.events)
                        }
                    }
                }
                .refreshable {
                    viewModel.fetchEvents()
                }
            }
        }
        .navigationTitle(NSLocalizedString("Next Events", comment: "Navigation title for upcoming events"))
        .onAppear {
            viewModel.fetchEvents()
        }
    }
}

struct UpcomingEventsView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingEventsView()
    }
}
