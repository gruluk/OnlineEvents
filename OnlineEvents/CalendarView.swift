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
        let firstWeekday = Calendar.current.component(.weekday, from: firstDayOfMonth)

        var month = Array(repeating: "", count: firstWeekday - 1)
        month += (1...daysInMonth).map { String($0) }
        return month
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: { self.changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
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
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(NSLocalizedString(day, comment: "Day of the week")).fontWeight(.bold)
                }
            }

            // Dates grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
                ForEach(month, id: \.self) { day in
                    if day.isEmpty {
                        Text("")
                            .frame(width: 40, height: 40)
                    } else {
                        VStack {
                            Spacer()
                            Text(day)
                            Circle()
                                .frame(width: 5, height: 5)
                                .foregroundColor(dayHasEvent(day: day) ? .red : .clear)
                            Spacer()
                        }
                        .frame(width: 40, height: 40)
                        .background(day == selectedDay ? Color(hex: "#F9B759") : (isToday(day: day) ? Color(hex: "#0D5474") : Color.gray.opacity(0.3)))
                        .cornerRadius(5)
                        .foregroundColor(isToday(day: day) ? .white : .black)
                        .onTapGesture {
                            if day != "" {
                                self.selectedDay = day
                            }
                        }
                    }
                }
            }
            .onAppear {
                print("Month array: \(month)")
            }
            
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
        if let newDate = Calendar.current.date(byAdding: .month, value: amount, to: currentDate) {
            currentDate = newDate
        }
    }
}
