//
//  EventMapView.swift
//  VibeLink
//
//  Created by Zablon Charles on 1/12/25.
//

import SwiftUI
import MapKit

struct EventMapView: View {
    @AppStorage("hideTab") var hideTab = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060), // Example: New York City
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
    @State private var currentEventIndex = 0 // To track the currently selected event
    let fireEvents = [
        EventLocation(coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)), // NYC
        EventLocation(coordinate: CLLocationCoordinate2D(latitude: 40.7306, longitude: -73.9352)), // Queens
        EventLocation(coordinate: CLLocationCoordinate2D(latitude: 40.7580, longitude: -73.9855))  // Times Square
    ]
    @State private var markerColor = Color.red // Initial color for the marker
    @State var colors: [Color] = [.red, .blue, .yellow, .pink, .green, .orange]
    @State var events = sampleEvents
    @State var clickedData = sampleEvent
    @State var clickedEvent = false
    @State var searchText = ""
    @State var showFilters = false
    @FocusState var searching : Bool
    let locatiomImages = ["bg1","bg2","bg3","bg4","bg5","bg6","bg7","bg8"]
    @State var topbarPressed = false
    @ObservedObject var user: UserStore
    
    
    var body: some View {
        NavigationView {
            ZStack {
                // Map view
               
                    mainmap
                    .offset(y:-180)
               
                
                topbar
               
               showcard
              
                VStack {
                    VStack{
                       
                       searchbox
                           
                        searchfilter
                        
                       firstsuggestions
                            
                       searchingeventsuggestions
                        
                    }
                    Spacer()
                }.background{
                  
                        Rectangle()
                        .fill(Color.dynamic).edgesIgnoringSafeArea(.all)
                            .opacity(searching ? 1 : 0)
                            .animation(.linear, value: searching)
                            .onTapGesture {
                                searching = false
                                hideTab = false
                            }
                        
                    
                }
                
                //half modal view
                VStack{
                    Spacer()
                    VStack {
                        HStack(alignment: .center) {
                            NavigationLink(destination: FiltersView()) {
                                
                                HStack {
                                    Text("Filters")
                                        .foregroundStyle(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.blue, .purple]), // Define the gradient colors
                                                startPoint: .leading, // Starting point of the gradient
                                                endPoint: .trailing   // Ending point of the gradient
                                            )
                                        )
                                    
                                    Image(systemName:"slider.vertical.3")
                                        .foregroundStyle(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.blue, .purple]), // Define the gradient colors
                                                startPoint: .leading, // Starting point of the gradient
                                                endPoint: .trailing   // Ending point of the gradient
                                            )
                                        )
                                    
                                }.padding(.horizontal,9)
                                    .padding(.vertical,7)
                                    .cornerRadius(9)
                                    .foregroundColor(Color.invert)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 9)
                                            .stroke(Color.invert.opacity(0.30), lineWidth: 1)
                                        
                                    )
                                
                            }
                            Rectangle()
                                .fill(Color.invert)
                                .frame(width: 1, height: 10)
                            NavigationLink(destination: DateView()) {
                                Text("Date")
                                    .padding(.horizontal,9)
                                    .padding(.vertical,7)
                                    .cornerRadius(9)
                                    .foregroundColor(Color.invert)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 9)
                                            .stroke(Color.invert.opacity(0.30), lineWidth: 1)
                                        
                                    )
                            }
                            Rectangle()
                                .fill(Color.invert)
                                .frame(width: 1, height: 10)
                            NavigationLink(destination: PriceView()) {
                                Text("Price")
                                    .padding(.horizontal,9)
                                    .padding(.vertical,7)
                                    .cornerRadius(9)
                                    .foregroundColor(Color.invert)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 9)
                                            .stroke(Color.invert.opacity(0.30), lineWidth: 1)
                                        
                                    )
                            }
                            Rectangle()
                                .fill(Color.invert)
                                .frame(width: 1, height: 10)
                            NavigationLink(destination: CategoryView()) {
                                Text("Category")
                                    .padding(.horizontal,9)
                                    .padding(.vertical,7)
                                    .cornerRadius(9)
                                    .foregroundColor(Color.invert)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 9)
                                            .stroke(Color.invert.opacity(0.30), lineWidth: 1)
                                        
                                    )
                            }
                            Spacer()
                        }.padding(.leading)
                        
                        //suggested results
                        ScrollView {
                            ForEach(user.allEvents.prefix(3)) { event in
                                
                                HStack(alignment: .top) {
                                    Image(systemName: typeSymbols[event.type] ?? "")
                                        .padding(.top,5)
                                        .foregroundStyle(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.blue, .purple]), // Define the gradient colors
                                                startPoint: .leading, // Starting point of the gradient
                                                endPoint: .trailing   // Ending point of the gradient
                                            )
                                        )
                                    VStack(alignment: .leading) {
                                        Text(event.name)
                                            .font(.callout) // Set the font size for event titles
                                            .bold()          // Make the event name bold
                                            .foregroundStyle(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.blue, .purple]), // Define the gradient colors
                                                    startPoint: .leading, // Starting point of the gradient
                                                    endPoint: .trailing   // Ending point of the gradient
                                                )
                                            )
                                        
                                        Text(event.description)
                                            .font(.callout) // Set the font size for event titles
                                                            // Make the event name bold
                                            .lineLimit(2)
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.leading)
                                    } // Set primary text color (based on light/dark mode)
                                    Spacer()
                                }  .padding(.vertical, 7)
                                    .padding(.horizontal, 10)
                                // Add a background color to the event row
                                    .cornerRadius(9)
                                    .onTapGesture{
                                        //
                                        searching = false
                                        clickedData = event
                                        withAnimation(.spring()) {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                zoomToEvent(moveToEventC: event)
                                            }
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                            withAnimation(.spring()) {
                                                clickedEvent = true
                                            }
                                        }
                                        
                                        
                                    }
                                    .padding(.horizontal)
                                
                                
                                Divider()
                            }
                        }
                        Spacer()
                    }.frame(height:400)
                        .padding(.top,10)
                        .background(Color.dynamic)
                    
                        
                    
                }
                
            }.onAppear{
                user.fetchAllEvents()
                if clickedEvent {
                    hideTab = true
                } else {
                    hideTab = false
                }
        }
        }
    }
    var topbar: some View {
        VStack {
            if !searching {
                HStack {
                    VStack {
                       // URLImageView(urlString: user.avatar)
                        Image(systemName:"figure.walk.motion")
                            .font(.title)
                            .foregroundStyle(LinearGradient(
                                gradient: Gradient(colors: [Color.dynamic,Color.red, Color.blue,Color.dynamic]), // Colors for the gradient
                                startPoint: .leading, // Starting point of the gradient
                                endPoint: .trailing // Ending point of the gradient
                            ))
//                            .frame(width: 80, height: 80)
                            .cornerRadius(60)
                          
                        
                    }.frame(width: 40, height: 60)
                        .cornerRadius(70)
                        .padding(.leading, 4)
                    
                    VStack(alignment: .leading) {
                        Text("Explore by:")
                            .font(.callout)
                            .bold()
                            .foregroundColor(.blue)
                        
                        
                        Text(user.firstName.isEmpty ? "not logged in!" : user.firstName)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    if !searching && !clickedEvent  {
                        Image(systemName:"magnifyingglass")
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding(.horizontal,5)
                            .padding(.vertical,5)
                        
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    searching = true
                                }
                            }
                    }
                    
                    if !clickedEvent {
//                        NavigationLink(destination: FiltersView()) {
//                            Image(systemName:"slider.vertical.3")
//                                .font(.title)
//                                .foregroundColor(.blue)
//                                .padding(.horizontal,5)
//
//
//                        }
                    } else {
                        Image(systemName:"xmark")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.horizontal,5)
                            .background(
                                Circle()
                                    .fill(.red)
                                    .padding(-10)
                            )
                            .onTapGesture {
                                //cancel a location
                                withAnimation(.spring()) {
                                    clickedEvent = false
                                    hideTab = false
                                    
                                    triggerLightVibration()
                                }
                                
                                //zoom out when pressing x
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation(.spring()) {
                                        //call the zoom out function
                                        zoomOut()
                                    }
                                }
                            }
                    }
                    
                }.padding(.leading,2)
                    .padding(.trailing,10)
                    .padding(.vertical,5)
                    .background(Color.dynamic.opacity(0.90))
                    .background(.ultraThinMaterial
                    )
                    .cornerRadius(50)
                    .overlay(
                        Rectangle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.dynamic,Color.red, Color.blue,Color.dynamic]), // Colors for the gradient
                                    startPoint: .leading, // Starting point of the gradient
                                    endPoint: .trailing // Ending point of the gradient
                                ),
                                lineWidth: 2 // Set the width of the gradient stroke
                            )
                    )
                    .cornerRadius(50)
                    .onTapGesture {
                        //was pressed
                        withAnimation(.spring()) {
                            topbarPressed = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.spring()) {
                                topbarPressed = false
                            }
                        }
                    }
                    .scaleEffect(searching ? 0.97 : topbarPressed ? 0.97 : 1)
                    .padding(.top,20)
                    .padding(.horizontal)
                
            }
            Spacer()
        }
    }
    var searchbox: some View {
        HStack {
            
            
            
            
            TextField("Search event, party...", text: $searchText)
                .focused($searching)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.dynamic, lineWidth: 1)
                )
                .onChange(of: searching) { newValue in
                    if clickedEvent {
                        clickedEvent = false
                    }
                    
                    
                    if !searching {
                        hideTab = false
                    } else {
                        hideTab = true
                    }
                    
                    
                    
                }
                .opacity(searching ? 1:  0)
            
            
            
        }.padding(10)
            .padding(.top, 0)
    }
    var mainmap: some View {
        Map(coordinateRegion: $region, annotationItems: user.allEvents) { event in
            
            MapAnnotation(coordinate: event.coordinate) {
                ZStack {
                    // Lottie animation in the background
                    if clickedEvent && event.id == clickedData.id {
                        //                                LottieView(filename: "locationbubble", loop: true)
                        //                                    .frame(width: 140, height: 140)
                        //                                    .zIndex(0.90)
                        
                        PulsatingRingsView()
                            .frame(width: 10, height: 10) // Smaller frame
                            .opacity(event.id == clickedData.id && clickedEvent  ? 1 : clickedEvent ? 0 : 1)
                    }
                    Image(systemName: typeSymbols[event.type] ?? "")
                        .frame(width: 30, height: 30) // Adjust the size as needed
                        //.background(Int(event.views) ?? 0 > 10 ? Color.red : Color.blue)
                        .background(
                           
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.green, Int(event.views) ?? 0 > 10 ? Color.red : Color.blue]), // Colors for the gradient
                                        startPoint: .leading, // Starting point of the gradient
                                        endPoint: .trailing // Ending point of the gradient
                                    )
                                    
                                
                        )
                        .cornerRadius(60)
                        .zIndex(1)
                       
                        .scaleEffect(event.id == clickedData.id ? clickedEvent  ? 1.7 : 1  : 1)
                        .animation(.spring(), value: clickedEvent)
                    
                    
                    
                } .onTapGesture {
                    searching = false
                    clickedData = event
                    withAnimation(.spring()) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            zoomToEvent(moveToEventC: event)
                        }
                    }
                    
                    withAnimation(.spring()) {
                        clickedEvent = true
                    }
                }
                .onAppear {
                    
                }
            } // Detect tap anywhere else on the map
            
        }
        .ignoresSafeArea()
    }
    var showcard: some View {
        VStack{
            if clickedEvent && !searching {
                ZStack{
                    
                    VStack {
                        Spacer()
                        NavigationLink(destination: ViewEventDetail(event:clickedData) ) {
                            RegularEventCard(event: clickedData)
                                .frame(height: 200)
                                .padding(.horizontal)
                                .onAppear{
                                    hideTab = true
                                }
                            
                        }
                        
                        
                    }
                    
                }.onChange(of: hideTab, perform: { newValue in
                    if !hideTab {
                        clickedEvent = false
                    }
                }) .offset(y: !clickedEvent ? UIScreen.main.bounds.height  * 0.5 : 0)
                    .transition(.slide)
                
            }
        }
    }
    var firstsuggestions: some View {
        VStack{
            if searching && searchText.isEmpty {
                ForEach(user.allEvents.prefix(3)) { event in
                    
                    HStack(alignment: .top) {
                        Image(systemName: typeSymbols[event.type] ?? "")
                            .padding(.top,5)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .purple]), // Define the gradient colors
                                    startPoint: .leading, // Starting point of the gradient
                                    endPoint: .trailing   // Ending point of the gradient
                                )
                            )
                        VStack(alignment: .leading) {
                            Text(event.name)
                                .font(.callout) // Set the font size for event titles
                                .bold()          // Make the event name bold
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.blue, .purple]), // Define the gradient colors
                                        startPoint: .leading, // Starting point of the gradient
                                        endPoint: .trailing   // Ending point of the gradient
                                    )
                                )
                            
                            Text(event.description)
                                .font(.callout) // Set the font size for event titles
                                                // Make the event name bold
                                .lineLimit(2)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                        } // Set primary text color (based on light/dark mode)
                        Spacer()
                    }  .padding(.vertical, 7)
                        .padding(.horizontal, 10)
                    // Add a background color to the event row
                        .cornerRadius(9)
                        .onTapGesture{
                            //
                            searching = false
                            clickedData = event
                            withAnimation(.spring()) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    zoomToEvent(moveToEventC: event)
                                }
                            }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                    withAnimation(.spring()) {
                                        clickedEvent = true
                                    }
                                }
                            
                            
                        }
                        .padding(.horizontal)
                    
                    
                    Divider()
                }
            }
        }
    }
    var searchfilter: some View {
        VStack{
            if showFilters || searching {
                Divider()
                
                HStack(alignment: .center) {
                    NavigationLink(destination: FiltersView()) {
                        
                        HStack {
                            Text("Filters")
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.blue, .purple]), // Define the gradient colors
                                        startPoint: .leading, // Starting point of the gradient
                                        endPoint: .trailing   // Ending point of the gradient
                                    )
                                )
                            
                            Image(systemName:"slider.vertical.3")
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.blue, .purple]), // Define the gradient colors
                                        startPoint: .leading, // Starting point of the gradient
                                        endPoint: .trailing   // Ending point of the gradient
                                    )
                                )
                            
                        }.padding(.horizontal,9)
                            .padding(.vertical,7)
                            .cornerRadius(9)
                            .foregroundColor(Color.invert)
                            .overlay(
                                RoundedRectangle(cornerRadius: 9)
                                    .stroke(Color.invert.opacity(0.30), lineWidth: 1)
                                
                            )
                         
                    }
                    Rectangle()
                        .fill(Color.invert)
                        .frame(width: 1, height: 10)
                    NavigationLink(destination: DateView()) {
                        Text("Date")
                            .padding(.horizontal,9)
                            .padding(.vertical,7)
                            .cornerRadius(9)
                            .foregroundColor(Color.invert)
                            .overlay(
                                RoundedRectangle(cornerRadius: 9)
                                    .stroke(Color.invert.opacity(0.30), lineWidth: 1)
                                
                            )
                    }
                    Rectangle()
                        .fill(Color.invert)
                        .frame(width: 1, height: 10)
                    NavigationLink(destination: PriceView()) {
                        Text("Price")
                            .padding(.horizontal,9)
                            .padding(.vertical,7)
                            .cornerRadius(9)
                            .foregroundColor(Color.invert)
                            .overlay(
                                RoundedRectangle(cornerRadius: 9)
                                    .stroke(Color.invert.opacity(0.30), lineWidth: 1)
                                
                            )
                    }
                    Rectangle()
                        .fill(Color.invert)
                        .frame(width: 1, height: 10)
                    NavigationLink(destination: CategoryView()) {
                        Text("Category")
                            .padding(.horizontal,9)
                            .padding(.vertical,7)
                            .cornerRadius(9)
                            .foregroundColor(Color.invert)
                            .overlay(
                                RoundedRectangle(cornerRadius: 9)
                                    .stroke(Color.invert.opacity(0.30), lineWidth: 1)
                                
                            )
                    }
                    Spacer()
                }.padding(.leading)
                Divider()
            }
            
            
        }
    }
    var searchingeventsuggestions: some View {
        VStack{
            if !searchText.isEmpty && searching {
                
                VStack {
                    if !searchEvents(byTitle: searchText, events: user.allEvents).isEmpty {
                        ForEach(searchEvents(byTitle: searchText, events: user.allEvents).prefix(5)) { event in
                          
                                HStack(alignment: .top) {
                                    Image(systemName: typeSymbols[event.type] ?? "")
                                        .padding(.top,5)
                                        .foregroundStyle(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.blue, .purple]), // Define the gradient colors
                                                startPoint: .leading, // Starting point of the gradient
                                                endPoint: .trailing   // Ending point of the gradient
                                            )
                                        )
                                    VStack(alignment: .leading) {
                                        Text(event.name)
                                            .font(.callout) // Set the font size for event titles
                                            .bold()          // Make the event name bold
                                            .foregroundStyle(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.blue, .purple]), // Define the gradient colors
                                                    startPoint: .leading, // Starting point of the gradient
                                                    endPoint: .trailing   // Ending point of the gradient
                                                )
                                            )
                                        
                                        Text(event.description)
                                            .font(.callout) // Set the font size for event titles
                                                            // Make the event name bold
                                            .lineLimit(2)
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.leading)
                                    } // Set primary text color (based on light/dark mode)
                                    Spacer()
                                }  .padding(.vertical, 7)
                                    .padding(.horizontal, 10)
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        searching = false
                                        clickedData = event
                                        withAnimation(.spring()) {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                zoomToEvent(moveToEventC: event)
                                            }
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                            withAnimation(.spring()) {
                                                clickedEvent = true
                                            }
                                        }
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
        }
    }
    func stringToInt(_ input: String) -> Int {
        return Int(input) ?? 0
    }
    // Function to get user's current location
    func getUserLocation() {
        // Normally you'd use CLLocationManager to get the current location.
        // In this case, we're simulating with a fixed location.
        let locationManager = CLLocationManager()
        if let location = locationManager.location?.coordinate {
            userLocation = location
            region.center = location // Set the map's center to the user's current location
        }
    }
    func zoomOut() {
        // Calculate the next nearest event
        
        withAnimation(.spring()) {
            region.span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08) // Adjust for desired zoom level
        }
    }
    func zoomToEvent(moveToEventC: Event) {
        // Calculate the next nearest event
        
        withAnimation {
            region.center = moveToEventC.coordinate
            region.span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04) // Adjust for desired zoom level
        }
    }
    func moveToEvent(moveToEventC: Event) {
        // Calculate the next nearest event
        
        withAnimation {
            region.center = moveToEventC.coordinate
            region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // Adjust for desired zoom level
        }
    }
    func moveToNextEvent() {
        // Calculate the next nearest event
        let currentEvent = fireEvents[currentEventIndex]
        
        // Find the nearest event
        let nextEventIndex = findNearestEvent(from: currentEvent)
        
        // Update the current event index and center the map on the next event
        currentEventIndex = nextEventIndex
        let nextEvent = fireEvents[nextEventIndex]
        
        // Update the region to center the map on the next event's location
        withAnimation {
            region.center = nextEvent.coordinate
        }
    }
    func searchEvents(byTitle searchText: String, events: [Event]) -> [Event] {
        // Filter the events based on the searchText matching the title (case-insensitive)
        return events.filter { event in
            event.name.lowercased().contains(searchText.lowercased()) ||
            event.location.lowercased().contains(searchText.lowercased())
        }
    }
    func findNearestEvent(from event: EventLocation) -> Int {
        var nearestIndex = 0
        var nearestDistance = Double.infinity
        
        // Calculate the distance to all other events and find the nearest one
        for (index, otherEvent) in fireEvents.enumerated() where otherEvent.id != event.id {
            let distance = distanceBetween(event.coordinate, otherEvent.coordinate)
            if distance < nearestDistance {
                nearestDistance = distance
                nearestIndex = index
            }
        }
        
        return nearestIndex
    }
    
    func distanceBetween(_ coord1: CLLocationCoordinate2D, _ coord2: CLLocationCoordinate2D) -> Double {
        let loc1 = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
        let loc2 = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
        return loc1.distance(from: loc2) // Returns distance in meters
    }
}
extension CLLocationCoordinate2D: Identifiable {
    public var id: String {
        "\(latitude)-\(longitude)"
    }
}

struct EventLocation: Identifiable, Hashable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    
    // Manually implement `Hashable`
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }
    
    // Manually implement `Equatable` for completeness
    static func == (lhs: EventLocation, rhs: EventLocation) -> Bool {
        lhs.id == rhs.id &&
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

struct EventMapView_Previews: PreviewProvider {
    static var previews: some View {
        EventMapView( user: UserStore())
    }
}


struct PulsatingCircles: View {
   
    
    var body: some View {
        LottieView(filename: "locationbubble" ,loop: true)
            .frame(width: 200, height: 200)
           
    }
}


struct PulsatingRingsView: View {
    @State private var expand = false
    
    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .stroke(Color.orange.opacity(0.98), lineWidth: 2)
                    .frame(width: expand ? CGFloat(20 + index * 40) : 0,
                           height: expand ? CGFloat(20 + index * 40) : 0)
                    .opacity(expand ? (1 - CGFloat(index) * 0.3) : 0)
                    .animation(Animation.easeOut(duration: 3).repeatForever(autoreverses: false).delay(Double(index) * 0.5), value: expand)
            }
        }
        .onAppear {
            expand = true
        }
    }
}
