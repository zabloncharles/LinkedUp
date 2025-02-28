//
//  CalendarView.swift
//  Soul25
//
//  Created by Zablon Charles on 1/6/25.
//
import SwiftUI

struct CalendarView: View {
    @AppStorage("hideTab") var hideTab = false
    @State private var selectedDate = Date()
    let events: [Event] = sampleEvents// Array of events
    
    var body: some View {
     
            ScrollView {
                VStack(alignment: .leading) {
                    
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                       
                            ForEach(DayOfWeek.allCases, id: \.self) { day in
                                Text(day.abbreviation)
                                    .font(.callout)
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(colors: [day.abbreviation == "S" ? Color.purple : Color.white]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .fontWeight(.bold)
                                   
                                    .frame(maxWidth: .infinity)
                            }.overlay {
                                Rectangle()
                                    .fill(.gray)
                                    .frame(width: 550, height: 1)
                                    .offset(y:15)
                            }
                        
                        
                        
                        ForEach(datesForCurrentMonth(), id: \.self) { date in
                            if let date = date {
                                let hasEvent = events.contains { Calendar.current.isDate($0.startDate ?? Date(), inSameDayAs: date) }
                                CalendarDayView(date: date, isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate), hasEvent: hasEvent)
                                    .onTapGesture {
                                        selectedDate = date
                                    }
                            } else {
                                Spacer() // Placeholder for empty slots
                                    .frame(width: 40, height: 40)
                            }
                        }
                    }.padding(10).padding(.vertical)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .neoButtonOff(isToggle: false, cornerRadius: 15)
                        
                    
                   
                    
                    //Text("Events on \(selectedDate.formatted(.dateTime.day().month().year()))")
                    Text("Today")
                        .font(.title)
                        .bold()
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple, Color.red]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .padding(.top, 10)
                    
                  
                    
                    let eventsForSelectedDate = events.filter { Calendar.current.isDate($0.startDate ?? Date(), inSameDayAs: selectedDate) }
                    
                    if !eventsForSelectedDate.isEmpty {
                        ForEach(eventsForSelectedDate, id: \.id) { event in
                            NavigationLink(destination: ViewEventDetail(event: event)) {
                                //EventCardView(event: event)
                                PopularEventCard(event: event)
                            }
                        }
                    } else {
                        HStack {
                            Image(systemName: "sparkles")
                                .font(.title)
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.purple, Color.red]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            VStack(alignment: .leading) {
                                
                                Text("No events on this date.")
                                    .font(.callout)
                                    .bold()
                                Divider()
                                Text("There are currently no events scheduled for today.")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }.multilineTextAlignment(.leading)
                            Spacer()
                        }.padding()
                            
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.40), lineWidth: 1)
                            )
//                        Text("Ongoing Event")
//                            .font(.subheadline)
                    }
                    Spacer()
                }
                .padding()
            
            }.scrollIndicators(.hidden)
            .background(Color.dynamic)
                .navigationTitle(formattedDate)
                .onAppear{
                    hideTab = true
                }
                .onDisappear{
                    hideTab = false
                }
        
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: Date())
    }
    
    private func datesForCurrentMonth() -> [Date?] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: Date())
        let startDate = calendar.date(from: components)!
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        let firstWeekday = calendar.component(.weekday, from: startDate) // 1 = Sunday, 2 = Monday, etc.
        
        var dates: [Date?] = Array(repeating: nil, count: firstWeekday - 1) // Empty slots for leading days
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startDate) {
                dates.append(date)
            }
        }
        return dates
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasEvent: Bool
    
    var body: some View {
        VStack {
      
            Text(date.formatted(.dateTime.day()))
                .font(.body)
                .fontWeight(isSelected ? .bold : .regular)
//                .foregroundStyle(
//                    LinearGradient(
//                        gradient: Gradient(colors: [isSelected ? Color.purple : (date < Date() ? .gray : .primary), isSelected ?  Color.red : (date < Date() ? .gray : .primary)]),
//                        startPoint: .leading,
//                        endPoint: .trailing
//                    )
//                )
                .foregroundColor(isSelected ? .blue : (date < Date() ? .gray : .primary))
                
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.yellow, lineWidth: 1)
                        .padding(-5)
                        .opacity(hasEvent ? 1 : 0)
                )
                .overlay(
                     Circle()
                        .fill(Color.red.opacity(hasEvent ? 1 : 0))
                     .frame(width: 5, height: 5)
                     .offset(y:15)
                )
            
            
        }
        .frame(width: 40, height: 40)
        .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
        .cornerRadius(5)
    }
}

struct EventCardView: View {
    let event: Event
    let colors: [Color] = [.red, .yellow, .purple, .blue, .green, .orange]
    
    var body: some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundColor(.accentColor)
            VStack(alignment: .leading) {
                Text(event.name)
                    .font(.headline)
                Text(event.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                Text(
                    (event.startDate?.formatted(.dateTime.day().month().year()) ?? "No date available") +
                    (event.startDate?.formatted(.dateTime.hour()) ?? "")
                )
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(colors.randomElement().opacity(0.4))
        .cornerRadius(19)
    }
}



enum DayOfWeek: String, CaseIterable {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    
    var abbreviation: String {
        String(self.rawValue.prefix(1).uppercased())
    }
}

struct EventCalendar_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}



