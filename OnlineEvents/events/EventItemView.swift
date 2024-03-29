import SwiftUI

enum DisplayMode {
    case eventTime, registrationTime
}

struct EventItemView: View {
    var viewModel: EventViewModel?
    var event: Event
    var displayMode: DisplayMode
    @State private var isLoading: Bool = true
    
    private var eventTypeTextAndColor: (text: String, color: Color) {
        switch event.eventType {
        case 1:
            return (NSLocalizedString("Social", comment: "Event type"), Color(hex: "#43b171"))
        case 2:
            return (NSLocalizedString("Company event", comment: "Event type"), Color(hex: "#eb536e"))
        case 3:
            return (NSLocalizedString("Course", comment: "Event type"), Color(hex: "#127dbd"))
        default:
            return ("", Color.clear)
        }
    }

    private var dateTimeView: some View {
        switch displayMode {
        case .eventTime:
            return Text(String(format: NSLocalizedString("Start: %@", comment: "Event start time"), formatDate(event.eventStart)))
                .font(.subheadline)
        case .registrationTime:
            if let registrationStart = event.attendanceEvent?.registrationStart, !registrationStart.isEmpty {
                return Text(String(format: NSLocalizedString("Registration: %@", comment: "Registration start time"), formatDate(registrationStart)))
                    .font(.subheadline)
            } else {
                return Text(NSLocalizedString("Registration: No time yet", comment: "No registration time available"))
                    .font(.subheadline)
            }
        }
    }

    var body: some View {
        NavigationLink(destination: EventDetailView(event: event)) {
            if viewModel?.isLoading ?? false {
                LoadingView()
            } else {
                HStack {
                    eventImageView
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                    
                    Spacer(minLength: 20)
                    
                    VStack(alignment: .leading) {
                        Text(eventTypeTextAndColor.text)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(5) // Add padding around the text
                            .background(eventTypeTextAndColor.color)
                            .cornerRadius(10)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                        Text(event.title)
                            .modifier(DynamicFontSizeModifier(text: event.title))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading) // Align text to the leading edge
                            .lineLimit(nil)
                            .bold()

                        dateTimeView
                            .modifier(DynamicFontSizeModifier(text: event.title))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading) // Align text to the leading edge
                            .lineLimit(nil)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding()
                .cornerRadius(8)
            }
        }
    }

    @ViewBuilder
    private var eventImageView: some View {
        if let firstImage = event.image, let url = URL(string: firstImage.thumb) {
            AsyncImage(url: url) { image in
                image.resizable()
                     .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.gray
            }
        } else {
            Image("Graf")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }

    func openEventURL(_ relativeURL: String) {
        guard let url = URL(string: "https://online.ntnu.no\(relativeURL)") else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "nb_NO")
        outputFormatter.dateFormat = "d. MMMM HH:mm"

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return NSLocalizedString("Invalid Date", comment: "")
        }
    }
}

struct DynamicFontSizeModifier: ViewModifier {
    var text: String

    func body(content: Content) -> some View {
        let length = text.count
        let fontSize: CGFloat = length > 30 ? 14 : 18  // Adjust these values as needed

        return content.font(.system(size: fontSize))
    }
}
