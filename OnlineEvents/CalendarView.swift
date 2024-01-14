import SwiftUI

struct CalendarView: View {
    @State private var currentDate = Date()
    @State private var selectedDay: String?
    let events: [Event]
    
    private func dayHasEvent(day: String) -> Bool {
        guard let dayInt = Int(day) else {
            return false
        }

        var components = Calendar.current.dateComponents([.year, .month], from: currentDate)
        components.day = dayInt
        guard let date = Calendar.current.date(from: components) else {
            return false
        }

        let dateFormatter = ISO8601DateFormatter()
        return events.contains(where: { event in
            if let eventDate = dateFormatter.date(from: event.eventStart) {
                return Calendar.current.isDate(eventDate, inSameDayAs: date)
            }
            return false
        })
    }

    private var month: [String] {
        let daysInMonth = Calendar.current.range(of: .day, in: .month, for: currentDate)!.count
        let firstDayOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: currentDate))!
        
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Set Monday as the first day of the week
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        var offset = firstWeekday - calendar.firstWeekday
        if offset < 0 {
            offset += 7 // Adjust for when the first day of the month is before Monday in the current locale
        }

        var month = Array(repeating: "", count: offset)
        month += (1...daysInMonth).map { String($0) }
        return month
    }

    var body: some View {
        VStack {
            HStack {
                if canGoBackToPreviousMonth() {
                    Button(action: { self.changeMonth(by: -1) }) {
                        Image(systemName: "chevron.left")
                    }
                }

                Spacer()

                Text(currentDate, format: .dateTime.year().month())
                    .font(.title)

                Spacer()

                Button(action: { self.changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            
            // Days of the week
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
                ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) { day in
                    Text(NSLocalizedString(day, comment: "Day of the week")).fontWeight(.bold)
                }
            }

            // Dates grid
            // Dates grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
                ForEach(month, id: \.self) { day in
                    if day.isEmpty {
                        Text("")
                            .frame(width: 40, height: 40)
                    } else {
                        VStack(spacing: 4) { // Adjust the spacing as needed
                            Spacer()
                            Text(day)
                                .frame(maxWidth: .infinity, alignment: .center)
                            if dayHasEvent(day: day) {
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(Color(hex: "#0D5474"))
                            } else {
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(.clear)
                            }
                            Spacer()
                        }
                        .frame(width: 40, height: 40)
                        .background(colorForDay(day: day))
                        .cornerRadius(5)
                        .foregroundColor(isToday(day: day) ? .white : .black)
                        .onTapGesture {
                            if day != "" && !isDateInPast(day: day) {
                                self.selectedDay = day
                            }
                        }
                    }
                }
            }
            .onAppear {
                print("Month array: \(month)")
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        self.handleSwipe(translation: value.translation.width)
                    }
            )
            
            if let day = selectedDay, let dayInt = Int(day), let eventsForDay = eventsForDay(dayInt) {
                VStack {
                    ForEach(eventsForDay, id: \.id) { event in
                        EventItemView(event: event, displayMode: .eventTime)
                    }
                }
            }
        }
        .padding()
    }
    
    private func eventsForDay(_ day: Int) -> [Event]? {
        var components = Calendar.current.dateComponents([.year, .month], from: currentDate)
        components.day = day
        guard let date = Calendar.current.date(from: components) else {
            return nil
        }

        let dateFormatter = ISO8601DateFormatter()
        return events.filter { event in
            if let eventDate = dateFormatter.date(from: event.eventStart) {
                return Calendar.current.isDate(eventDate, inSameDayAs: date)
            }
            return false
        }
    }

    private func isToday(day: String) -> Bool {
        guard let dayInt = Int(day), let date = Calendar.current.date(bySetting: .day, value: dayInt, of: currentDate) else {
            return false
        }
        return Calendar.current.isDateInToday(date)
    }

    private func changeMonth(by amount: Int) {
        let newDate = Calendar.current.date(byAdding: .month, value: amount, to: currentDate)
        let now = Date()

        // Check if newDate is in the past compared to the current system month and year
        if let newDate = newDate, Calendar.current.compare(newDate, to: now, toGranularity: .month) != .orderedAscending {
            currentDate = newDate
        }
    }
    
    private func canGoBackToPreviousMonth() -> Bool {
        let now = Date()
        return Calendar.current.compare(currentDate, to: now, toGranularity: .month) == .orderedDescending
    }
    
    private func isDateInPast(day: String) -> Bool {
        guard let dayInt = Int(day) else { return false }

        // Get the date components for the current date
        var currentComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        // Reset the hour, minute, second components to ensure we're comparing only dates
        currentComponents.hour = 0
        currentComponents.minute = 0
        currentComponents.second = 0
        currentComponents.nanosecond = 0

        // Get the current date with time reset
        guard let today = Calendar.current.date(from: currentComponents) else { return false }

        // Get the date for the given day
        var dayComponents = Calendar.current.dateComponents([.year, .month], from: currentDate)
        dayComponents.day = dayInt
        guard let dayDate = Calendar.current.date(from: dayComponents) else { return false }

        // Compare the day date with today's date
        return dayDate < today
    }

    private func colorForDay(day: String) -> Color {
        if day == selectedDay {
            return Color(hex: "#F9B759")
        } else if isToday(day: day) {
            return Color(hex: "#0D5474")
        } else if isDateInPast(day: day) {
            return Color.gray.opacity(0.8) // Darker gray for past dates
        } else {
            return Color.gray.opacity(0.3)
        }
    }
    
    private func handleSwipe(translation: CGFloat) {
        if translation > 100 {
            changeMonth(by: -1) // Swipe Right (Previous Month)
        } else if translation < -100 {
            changeMonth(by: 1) // Swipe Left (Next Month)
        }
    }
}
