//
//  EventsView.swift
//  VibeLink
//
//  Created by Zablon Charles on 1/12/25.
//

import SwiftUI
import CoreLocation
import FirebaseFirestore
import FirebaseAuth

struct EventView: View {
    @AppStorage("hideTab") var hideTab = false
    @ObservedObject var user: UserStore
    @ObservedObject var fetch: EventFetcher
    @State private var eventName = ""
    @State private var eventDescription = ""
    @State private var eventLocation = ""
    @State private var isTimed = false
    @State private var showMenu = false
    @State private var eventDate: Date = Date()
    @State private var eventType: EventType = .ongoing
    @State private var events: [Event] = sampleEvents
    @State private var popularEvents: [Event] = []
    @State private var randomThreeEvents: [Event] = []
    let colors: [Color] = [.red, .blue, .green, .orange]
   
    @State var searchText = ""
    @State private var userLocation: CLLocation?
    @State private var pageAppeared = false
    @State private var startPoint: UnitPoint = .topLeading
    @State private var endPoint: UnitPoint = .bottomTrailing
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                NavigationView  {
                    
                    
                    ScrollView {
                        ScrollHideTabView(hideTab: $hideTab)
                        VStack {
                            
                            VStack(alignment: .leading) {
                                VStack {
                                    HStack {
                                        Text("LinkedUp Event Expectations.")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .padding(.top, 20)
                                            .foregroundStyle(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color.invert, .yellow, Color.invert]),
                                                    startPoint: startPoint,
                                                    endPoint: endPoint
                                                )
                                            )
                                            .onAppear {
                                                withAnimation(
                                                    .linear(duration: 2)
                                                ) {
                                                    startPoint = .trailing
                                                    endPoint = .leading
                                                }
                                            }
                                    
                                        Spacer()
                                        NavigationLink(destination: CreateEventDetailView()) {
                                            Image(systemName: "plus")
                                                .font(.system(size: 16, weight: .medium))
                                                .frame(width: 36, height: 36)
                                                .background(Color.dynamic)
                                                .cornerRadius(60)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 60)
                                                        .stroke(Color.gray, lineWidth: 1)
                                                )
                                               
                                        }
                                        
                                        
                                        NavigationLink(destination: CalendarView()) {
                                            Image(systemName: "calendar")
                                                .renderingMode(.original)
                                                .font(.system(size: 16, weight: .medium))
                                                .frame(width: 36, height: 36)
                                                .background(Color.dynamic)
                                                .cornerRadius(60)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 60)
                                                        .stroke(Color.gray, lineWidth: 1)
                                                )
                                               
                                        }
                                    }.padding(.horizontal)
                                    
                                    
                                    ZStack {
                                        
                                        Rectangle()
                                            .fill(.ultraThinMaterial)
                                            .blur(radius: 570)
                                        
                                            
                                        
                                        
                                        
                                        VStack {
                                            HStack {
                                                
                                                TextField("Search event, party...", text: $searchText)
                                                    .padding()
                                                    .background(Color(.systemGray6))
                                                    .cornerRadius(12)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .stroke(Color.dynamic, lineWidth: 2)
                                                    )
                                                
                                                
                                                
                                            }.padding(10)
                                                .padding(.top, 0)
                                                .onChange(of: searchText) { newValue in
                                                    
                                                }
                                            
                                            
                                            if searchText.isEmpty {
                                                ForEach(randomThreeEvents) { event in
                                                    NavigationLink {
                                                        ViewEventDetail(event: event)
                                                    } label: {
                                                        
                                                        
                                                        VStack {
                                                            Divider()
                                                            HStack {
                                                                Image(systemName: typeSymbols[event.type] ?? "person.and.background.dotted")
                                                                Text(event.name)
                                                                    .font(.callout) // Set the font size for event titles
                                                                                    // Make the event name bold
                                                                    .foregroundColor(.primary) // Set primary text color (based on light/dark mode)
                                                                Spacer()
                                                            }  .padding(.vertical, 7)
                                                                .padding(.horizontal, 10)
                                                            // Add a background color to the event row
                                                                .cornerRadius(9)
                                                            
                                                                .padding(.horizontal)
                                                        }.animation(.spring(), value: searchText.isEmpty)
                                                    }
                                                    
                                                    
                                                }
                                                
                                            }
                                            
                                            VStack {
                                                if !searchEvents(byTitle: searchText, events: events).isEmpty {
                                                    ForEach(searchEvents(byTitle: searchText, events: fetch.filteredCloseEvents).prefix(5)) { event in
                                                        NavigationLink {
                                                            ViewEventDetail(event: event)
                                                        } label: {
                                                            HStack {
                                                                Image(systemName: typeSymbols[event.type] ?? "")
                                                                Text(event.name)
                                                                    .font(.callout) // Set the font size for event titles
                                                                                    // Make the event name bold
                                                                    .foregroundColor(.primary) // Set primary text color (based on light/dark mode)
                                                                Spacer()
                                                            }  .padding(.vertical, 7)
                                                                .padding(.horizontal, 10)
                                                            // Add a background color to the event row
                                                                .cornerRadius(9)
                                                            
                                                                .padding(.horizontal)
                                                        }
                                                        Divider()
                                                    }
                                                } else if !searchText.isEmpty {
                                                    ProgressView()
                                                        .padding(.top,20)
                                                        .padding(.bottom,20)
                                                }
                                            }.padding(.bottom,5)
                                            
                                            
                                            
                                        }
                                        .cornerRadius(20)
                                    }.neoButtonOff(isToggle: false, cornerRadius: 20)
                                        .padding(.horizontal)
                                }.offset(y: !pageAppeared ? -UIScreen.main.bounds.height  * 0.5 : 0)
                                
                                
                                Spacer()
                                
                                VStack {
                                    
                                    
                                    
                                    
                                    
                                    HStack(alignment: .bottom) {
                                        VStack(alignment: .leading) {
                                            Text("Popular event")
                                                .font(.headline)
                                            Text("View and join popular plans!")
                                                .font(.callout)
                                        }
                                        
                                        .padding(.top, 30)
                                        Spacer()
                                        VStack(alignment: .center) {
                                            Image(systemName: "flame")
                                        }
                                        
                                        
                                    }.padding(.horizontal)
                                    
                                    Text(fetch.errorMessage ?? "")
                                    ScrollView(.horizontal, showsIndicators: false) { // Make the ScrollView horizontal
                                        LazyHStack(spacing: 10) { // Add some spacing between items
                                            ForEach(fetch.filteredClosePopularEvents.prefix(5)) { item in
                                                NavigationLink {
                                                    ViewEventDetail(event: item)
                                                } label: {
                                                    
                                                    
                                                        
                                                        PopularEventCard(event: item)
                                                                .frame(width: geometry.size.width - 40, height: 200) // Set fixed width and height for the cards
                                                              
                                                            .padding(.leading, 5)
                                                    
                                                    } // Add padding if needed
                                                
                                            }
                                        }.padding(.leading, 10)
                                            .padding(.trailing, 10)
                                        
                                    }
                                    
                                    
                                    VStack(alignment: .leading) {
                                        HStack(alignment: .bottom) {
                                            VStack(alignment: .leading) {
                                                Text("Plans near you")
                                                    .font(.headline)
                                                Text("View and join plans near your area!")
                                                    .font(.callout)
                                            }
                                            
                                            .padding(.top, 30)
                                            Spacer()
                                            VStack(alignment: .center) {
                                                Image(systemName: "figure.dance")
                                            }
                                            
                                            
                                        }
                                        ScrollView(.vertical, showsIndicators: false) { // Make the ScrollView horizontal
                                            LazyVStack {
                                                ForEach(fetch.filteredCloseEvents.prefix(5)) { item in
                                                    NavigationLink {
                                                        ViewEventDetail(event: item)
                                                    } label: {
                                                        RegularEventCard(event: item)
                                                           
                                                    }
                                                }
                                            }
                                            .padding(.bottom,70)
                                            
                                            
                                        }
                                    }.padding(.horizontal)
                                    
                                    
                                    Spacer()
                                }.offset(y: !pageAppeared ? UIScreen.main.bounds.height  * 0.5 : 0)
                            }
                        }
                    }
                        .scrollIndicators(.hidden) // Hides the scrollbar
                        
                    
                }.refreshable {
                  
                }
                
            }.onAppear{
               // user.fetchUserInformation()
                fetch.nearbyFutureEvents()
                fetch.filterPopularEvents()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.spring()) {
                        getThreeRandomEvents()
                    }
                }
                hideTab = false
                withAnimation(.spring()) {
                    pageAppeared = true
                }
            }
            .onDisappear{
                withAnimation(.spring()) {
                    pageAppeared = false
                }
        }
        }.refreshable {
            //
            fetch.nearbyFutureEvents()
            fetch.filterPopularEvents()
            
        }
    }
    
    func fetchUserLocation() {
        // Example: Use a hardcoded location for demonstration (New York City)
        // Replace this with a proper location-fetching mechanism
        userLocation = CLLocation(latitude: 40.7128, longitude: -74.0060)
    }
    func searchEvents(byTitle searchText: String, events: [Event]) -> [Event] {
        // Filter the events based on the searchText matching the title (case-insensitive)
        return events.filter { event in
            event.name.lowercased().contains(searchText.lowercased()) ||
            event.location.lowercased().contains(searchText.lowercased())
        }
    }
    
    func getThreeRandomEvents() {
        
        let randomizedEvents = fetch.filteredCloseEvents.shuffled()
        randomThreeEvents = Array(randomizedEvents.prefix(3)) // Storing the first 3 randomized events
    }

    
    
    // Function to join an event
    private func joinEvent(event: Event) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("No user is logged in.")
            return
        }
        
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(event.id)
        
        eventRef.updateData([
            "participants": FieldValue.arrayUnion([userUID])
        ]) { error in
            if let error = error {
                print("Error joining event: \(error.localizedDescription)")
            } else {
                print("Joined event successfully!")
                // Optionally reload events or perform any additional actions
            }
        }
    }

    
    // Function to calculate time remaining until event
    private func getTimeRemaining(eventDate: Date) -> String {
        let now = Date()
        if now >= eventDate {
            return "Already Happened"
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute], from: now, to: eventDate)
        
        if let days = components.day, let hours = components.hour, let minutes = components.minute {
            return "\(days) Days, \(hours) Hours, \(minutes) Minutes"
        }
        return "Calculating..."
    }
}






struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(user: UserStore(), fetch: EventFetcher())
    }
}


