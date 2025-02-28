//
//  ViewEventDetailView.swift
//  VibeLink
//
//  Created by Zablon Charles on 1/12/25.
//

//
//  ViewEventDetail.swift
//  Soul25
//
//  Created by Zablon Charles on 1/2/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import CoreImage.CIFilterBuiltins
import MapKit

struct ViewEventDetail: View {
    @AppStorage("hideTab") var hideTab = false
    @StateObject var user = UserStore()
    @Environment(\.dismiss) private var dismiss
    var event : Event = Event(
        id: UUID().uuidString,
        name: "",
        description: "",
        type: "",
        views: "",
        images: [""],
        location: "",
        price: "",
        owner: "",
        participants: [""],
        isTimed: true,
        startDate: Date(),
        endDate: Date(),
        createdAt: Date()
    )
    var previewing = false
    @State var passedEvent = sampleEvent
    @State private var selectedIndex = 0
    @State var joinedEvent = false
    let exampleLocation = EventLocation(coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)) // Example coordinates
    let images = ["Background 2", "Background 3", "Background 4"]
    let colors: [Color] = [.red, .blue, .green, .orange]
    @State var showQrCode = false
    @State var showBarCode = false
    @State var animateQrAppearing = false
    @State var eventCreated = false
    @State var views = 0
    @State var showMap = false
    @State var eventAddress = ""
    @State var eventOwnerAvatar = ""
    @State var firstName = ""
    @State var editEvent = false
    @State var bookmarked = false
    @State var updatedOwner = ""
    var body: some View {
        ZStack {
            ScrollView {
                    VStack(spacing: 16) {
                        // Image Section
                        pictures
                            
                       
                           
                        
                        // Title Section
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(passedEvent.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.linearGradient(colors: [.pink, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                                Spacer()
                               
                            }
                            
                            HStack {
                                Text(passedEvent.location.split(separator: ",")[0] + "," + passedEvent.location.split(separator: ",")[1])
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                HStack {
                                    Image(systemName: "eye.fill")
                                       
                                    Text(passedEvent.views + " views")
                                }.font(.callout)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                        .background(LinearGradient(colors: [Color.dynamic, Color.clear], startPoint: .bottom, endPoint: .top))
                       
                        
                        // Facilities Section
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                FacilityView(icon: typeSymbols[passedEvent.type] ?? "", label: passedEvent.type)
                                FacilityView(icon: "hand.raised.fill", label: "18+")
                                FacilityView(icon: "\(passedEvent.participants.count).circle.fill", label: "Joined")
//                                    .overlay(alignment: .topTrailing) { // Positions it at the top-right
//                                        ZStack {
//                                            Circle()
//                                                .fill(Color.red) // Red background
//                                                .frame(width: 20, height: 20) // Adjust size as needed
//
//                                            Text("\(passedEvent.participants.count)5") // Dynamic count
//                                                .font(.caption2)
//                                                .fontWeight(.bold)
//                                                .foregroundColor(.white) // White text
//                                        }
//                                        .offset(x: 10, y: -10) // Adjust position
//                                    }
                                FacilityView(icon: "figure.stairs", label: "1 Floor")
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        
                        Divider()
                        
                        // Description Section
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.headline)
                                Text(passedEvent.description)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            Spacer()
                        }
                        
                       
                        
                        
                        //Location
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Location")
                                .font(.headline)
                            showmap
                            
                        }
                        .padding(.horizontal)
                        // Agent Section
                        HStack {
                            Text("Organizer")
                                .font(.headline)
                            Spacer()
                        }.padding(.horizontal)
                        HStack {
                            
                            if !eventOwnerAvatar.isEmpty {
                                URLImageView(urlString: eventOwnerAvatar)
                                
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(60)
                            } else {
                                Image(systemName: "person")
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 60)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }
                            VStack(alignment: .leading) {
                                Text(firstName)
                                    .font(.headline)
                                Text("Event Facilitator")
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            HStack {
                                Button(action: {}) {
                                    Image(systemName: "message.fill")
                                }
                                Button(action: {}) {
                                    Image(systemName: "phone.fill")
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 105)
                        
                        
                        
                        Divider()
                    }
               
                
              
            }.scrollIndicators(.hidden)
               
                .overlay {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(showQrCode ? 1 : 0)
                    .animation(.easeInOut, value: showQrCode)
            }
            
           
            //the join,view ticket card
            bottomcard
            
            
            //seen only when creating a new event
            if eventCreated {
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        LottieView(filename: "confetti", loop: true)
                            .frame(height: 200)
                            .padding(.top, 30)
                            .padding(.bottom, 10)
                        
                        Text("Event created!")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                        
                        Text("Your \(passedEvent.type.lowercased()) event has been successfully created and is now live!")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        
                        Button(action: {
                            // Handle button action
                            dismiss()
                        }) {
                            Text("Dismiss")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding(.horizontal, 30)
                                .padding(.bottom)
                        }
                    }
                    .background(Color.black.opacity(0.6)) // Semi-transparent background
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding(20)
                }
            }
            
           //edit the event
          
            
        }.toolbarBackground(.black, for: .navigationBar) // Sets the background to black
            .toolbarColorScheme(.dark, for: .navigationBar) // Ensures text is readable
        .toolbar {
            if event.owner == updatedOwner  { // Check if the current user is the owner
                Button(action: {
                    editEvent = true
                }) {
                    Image(systemName: "slider.horizontal.3") // SF Symbol for the button
                        .font(.title2)
                }
                .accessibilityLabel("Edit Event")
            } else {
                Button(action: {
                    
                    toggleBookmarkEvent(event: event)
                }) {
                    Image(systemName: bookmarked ? "bookmark.fill" : "bookmark") // SF Symbol for the button
                        .font(.title2)
                        .foregroundStyle(.linearGradient(colors: [.pink, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .animation(.easeInOut, value: bookmarked)
                }
                .accessibilityLabel("Edit Event")
            }
        }
        .sheet(isPresented: $editEvent) {
            EditEventView(event: $passedEvent, originalEvent: event, dismissParent: { dismiss() })
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color.dynamic)
        // Inside your view or logic
        .onChange(of: user.bookmarkedEventsIds) { newBookmarkedIds in
            if newBookmarkedIds.contains(event.id) {
                bookmarked = true
            }
        }
            
            .onAppear{
                triggerLightVibration()
                
                if !event.name.isEmpty {
                    passedEvent = event
                }
                user.fetchUserInformation()
                
                
                hideTab = true
                getAvatarFromDocument(documentID: passedEvent.owner)
                incrementEventViewCount() //record view
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    updatedOwner = Auth.auth().currentUser?.uid ?? ""
                    
                    withAnimation() {
                          
                    }
                }
            }
            .onDisappear{
                hideTab = false
                
            }
        
        
        
    }
    var showmap: some View{
        //show map at bottom
        ZStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: exampleLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )), showsUserLocation: true, annotationItems: [exampleLocation]) { eventLocation in
                MapMarker(coordinate: eventLocation.coordinate, tint: .blue) // Pin for the location
            }.disabled(true) // Disables user interaction with the map
                .frame(height:200)
               
                
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(eventAddress)
                        .onAppear{
                           
                            getAddressFromLocationString(location:passedEvent.location) { address in
                                eventAddress = address
                            }
                        }
                    Spacer()
                }.padding(.horizontal)
                    .padding(.vertical,5).background(.ultraThinMaterial)
                   
            }
        } .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 9)
                    .stroke(Color.invert.opacity(0.05), lineWidth: 1)
            )
    }
    var pictures: some View {
        TabView(selection: $selectedIndex) {
            ForEach(0..<passedEvent.images.count, id: \.self) { index in
                Image(passedEvent.images[index])
                //Image("bg4")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: 350)
                    .overlay(content: {
                        VStack {
                            Spacer()
                            LinearGradient(
                                gradient: Gradient(colors: [Color.dynamic,Color.clear, Color.clear]), // Define your gradient colors
                                startPoint: .bottom, // Starting point of the gradient
                                endPoint: .top   // Ending point of the gradient
                            )
                        }
                    })
                    .tag(index) // Tag each image with an index
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .trailing), // Enter from the right
                            removal: .move(edge: .leading)    // Exit to the left
                        )
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                // Handle swipe gesture (change image on left or right swipe)
                                
                                if value.translation.width > 0 {
                                    // Swipe right
                                    if selectedIndex > 0 {
                                        selectedIndex -= 1
                                    }
                                } else {
                                    // Swipe left
                                    if selectedIndex < passedEvent.images.count - 1 {
                                        selectedIndex += 1
                                    }
                                }
                            }
                    )
            }
        }
        .overlay(content: {
            // Optionally, you can add buttons to simulate the swipe as well
            ZStack {
                
                
                VStack {
                    Spacer()
                    HStack{
                        ForEach(0..<passedEvent.images.count, id: \.self) { item in
                            Rectangle()
                                .fill(selectedIndex == item ? Color.red : Color.gray)
                                .background(.red)
                                .frame(width: 20,height: 3)
                        }
                    }.cornerRadius(10).padding(.bottom,10)
                }
                HStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.01))
                        .onTapGesture {
                            if selectedIndex > 0 {
                                selectedIndex -= 1
                            } else {
                                selectedIndex += 1
                            }
                        }
                    Rectangle()
                        .fill(Color.gray.opacity(0.02))
                        .onTapGesture {
                            if selectedIndex < passedEvent.images.count - 1 {
                                selectedIndex += 1
                            } else {
                                selectedIndex -= 1
                            }
                        }
                }.padding()
                
               
                   
            }.animation(.linear, value: selectedIndex)
        })
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide default page indicators
        .frame(width: UIScreen.main.bounds.width, height: 350)
    }
    var bottomcard: some View {
        VStack {
            Spacer()
            VStack {
                
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text(passedEvent.price == "0" || passedEvent.price.isEmpty ? "Free" : toDollarString(amount: passedEvent.price))
                            .font(.title)
                            .fontWeight(.bold)
                        
                        
                        Rectangle()
                            .frame(width:160, height: 2)
                            .padding(.vertical,-10)
                        Text(passedEvent.price == "0" || passedEvent.price.isEmpty ? "This event is free" : "This is a paid " + passedEvent.type.lowercased() + " event")
                            .font(.callout)
                        
                        
                        
                    }
                    .padding(.top,10)
                    Spacer()
                    
                    Button(action: {
                        if  previewing {
                            //create event
                            createEvent()
                        } else {
                            
                            if joinedEvent {
                                
                                     showQrCode.toggle()
                                
                            } else {
                                joinEvent(event: event)
                            }
                           
                        }
                    }) {
                        Text(previewing ? "Create" : joinedEvent ? showQrCode ? "Done" : "View Ticket" : "Join Event")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .padding(.horizontal,20)
                            .background(joinedEvent ? Color.green : Color.blue)
                            .cornerRadius(40)
                            .padding(.top, 20)
                            .padding(.leading,10)
                    }
                }.padding(.horizontal)
                    .padding(.vertical,showQrCode ? 1 : 0).padding(.bottom,0)
                    
                
                
                if showQrCode {
                    VStack(spacing: 5.0) {
                        Text("Scan Your QR Code")
                            .font(.title2)
                            .bold()
                        
                        Text("Scan Your QR Code to access your ticket!")
                            .font(.callout)
                            .multilineTextAlignment(.center)
                            
                        
                       // FakeBarcodeView(qrCodeData:passedEvent.id)
                        ZStack {
                            
                            Rectangle()
                                .fill(.clear)
                            .frame(width: 200, height: 200)
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    showBarCode = true
                                }
                            }
                            .onDisappear{
                                showBarCode = false
                            }
                            
                          
                            
                            
                            ZStack {
                                
                                FakeBarcodeView(qrCodeData:passedEvent.id)
                                    
                                    .animation(.easeIn(duration:3), value: showBarCode)
                                .opacity(showBarCode ? 1 : 0.03)
                            }
                           
                            Rectangle()
                                .fill(.white)
                                .frame(width: 200, height: showBarCode ? 0 : 200)
                                .animation(.linear(duration: 5), value: showBarCode)
                                .overlay {
                                    ProgressView()
                                        .opacity(showBarCode ? 0 : 1)
                                        .animation(.linear(duration: 4), value: showBarCode)
                                }
                        }
                           
                        
                        
                    }.padding(.bottom,20)
                        .offset(y: animateQrAppearing ? 0 : 800)
                        .animation(.spring(), value: animateQrAppearing)
                        .padding()
                    
                        .onAppear{
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) {
                                animateQrAppearing = true
                                
                            }
                        }
                        .onDisappear{
                            animateQrAppearing = false
                        }
                    
                }
                
            }
            .background(Color.dynamic.opacity(0.99))
            .background(.ultraThinMaterial)
        }.onAppear{
           
            hideTab = true
            if isUserPartOfEvent(event: event) {
                joinedEvent = true
            }
        }
    }
    // Function to create the event
    func createEvent() {
        
        // Logic to save event data to Firebase or local state
        
        // Save event to Firebase Firestore
        
        if areFieldsFilled() {
            saveEventToFirestore(event: event)
        }
        
        
    }
    
    // Check if all required fields are filled
    func areFieldsFilled() -> Bool {
        return !passedEvent.name.isEmpty && !passedEvent.description.isEmpty && !passedEvent.location.isEmpty && !passedEvent.price.isEmpty
    }
    
    func getAvatarFromDocument(documentID: String) {
        let db = Firestore.firestore()
        
        // Reference to the specific document in the "users" collection
        db.collection("users").document(documentID).getDocument { documentSnapshot, error in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                // Return nil if there was an error
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
                print("Document does not exist")
                 // Return nil if the document does not exist
                return
            }
            
            // Get the `avatar` field as a string
           
            eventOwnerAvatar = document.get("avatar") as? String ?? ""
            firstName = document.get("firstName") as? String ?? ""
           
        }
    }
//    // Function to generate a random password
//    func generateRandomPassword(length: Int = 12) -> String {
//        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()"
//        return String((0..<length).map { _ in characters.randomElement()! })
//    }
//    
//    // Function to add one user to Auth and Firestore
//    func addSingleUserToAuthAndFirestore(user: User) {
//        let db = Firestore.firestore()
//        let password = generateRandomPassword()
//        
//        // Create the user in Firebase Authentication
//        Auth.auth().createUser(withEmail: user.email, password: password) { authResult, error in
//            if let error = error {
//                print("Error creating user \(user.email): \(error.localizedDescription)")
//                return
//            }
//            
//            // Get the UID from Firebase Authentication
//            guard let uid = authResult?.user.uid else {
//                print("Failed to get UID for user \(user.email)")
//                return
//            }
//            
//            // Prepare the user data for Firestore
//            let userData: [String: Any] = [
//                "firstName": user.firstName,
//                "lastName": user.lastName,
//                "email": user.email,
//                "dateOfBirth": user.dateOfBirth,
//                "phoneNumber": user.phoneNumber,
//                "avatar": user.avatar,
//                "myEvents": user.myEvents,
//                "attendedEvents": user.attendedEvents
//            ]
//            
//            // Add the user to Firestore using the UID as the document ID
//            db.collection("users").document(uid).setData(userData) { error in
//                if let error = error {
//                    print("Error adding user \(user.firstName) to Firestore: \(error.localizedDescription)")
//                } else {
//                    print("Successfully added user \(user.firstName) to Firestore with UID: \(uid)")
//                }
//            }
//        }
//    }
    private func saveEventToFirestore(event: Event) {
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        let db = Firestore.firestore()
        var eventData: [String: Any] = [
            "name": passedEvent.name,
            "description": passedEvent.description,
            "type": passedEvent.type,
            "images": passedEvent.images,
            "location": passedEvent.location,
            "owner": userEmail,
            "cost": passedEvent.price,
            "participants": passedEvent.participants,
            "isTimed": passedEvent.isTimed,
            "startDate": passedEvent.startDate,
            "endDate": passedEvent.endDate,
            "createdAt": passedEvent.createdAt
        ]
        
        if let eventStartDate = passedEvent.startDate {
            eventData["startDate"] = eventStartDate
        }
        
        db.collection("events").addDocument(data: eventData) { error in
            if let error = error {
                print("Error saving event: \(error)")
            } else {
                eventCreated = true
                print("Event saved successfully!")
                //                passedEvent.name = ""
                //                passedEvent.eventDescription = ""
                //                passedEvent.eventLocation = ""
                //                passedEvent.eventType = .ongoing
                //                passedEvent.eventImages = [""]
                //                passedEvent.eventPrice = ""
                //                passedEvent.eventDate = Date()
                //fetchEvents() // Reload events after saving
            }
        }
    }
    // Function to add events to Firestore
    func addEventsToFirestore() {
        let db = Firestore.firestore()
        for event in sampleEvents {
            let eventData: [String: Any] = [
                "id": passedEvent.id,
                "name": passedEvent.name,
                "description": passedEvent.description,
                "type": passedEvent.type,
                "images": passedEvent.images,
                "location": passedEvent.location,
                "price": passedEvent.price,
                "owner": passedEvent.owner,
                "participants": passedEvent.participants,
                "isTimed": passedEvent.isTimed,
                "startDate": passedEvent.startDate,
                "endDate": passedEvent.endDate,
                "createdAt": passedEvent.createdAt
            ]
            
            // Add the event to a Firestore collection (e.g., "events")
            db.collection("events").addDocument(data: eventData) { error in
                if let error = error {
                    print("Error adding event: \(error.localizedDescription)")
                } else {
                    print("Event successfully added!")
                }
            }
        }
    }
    private func joinEvent(event: Event) {
        // Ensure the user is authenticated and fetch their UUID
        guard let userUUID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        // Check if the user is already part of the event
        if isUserPartOfEvent(event: event) {
            print("User is already part of this passedEvent.")
            joinedEvent = true
            return
        }
        
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(passedEvent.id)
        let userRef = db.collection("users").document(userUUID)
        
        // Update the event with the user's UUID in the participants array
        eventRef.updateData([
            "participants": FieldValue.arrayUnion([userUUID])
        ]) { error in
            if let error = error {
                print("Error joining event: \(error)")
            } else {
                // Update the user's attendedEvents field with the event ID
                userRef.updateData([
                    "attendedEvents": FieldValue.arrayUnion([passedEvent.id])
                ]) { error in
                    if let error = error {
                        print("Error updating user's attended events: \(error)")
                    } else {
                        print("User's attended events updated successfully!")
                        joinedEvent = true
                        // Reload events after joining
                    }
                }
            }
        }
    }
    //increase view count
    func incrementEventViewCount()  {
        // Ensure the user is authenticated and fetch their UUID
        guard let userUUID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(passedEvent.id)
        
        eventRef.getDocument { document, error in
            if let document = document, document.exists {
                if let currentViewsString = document.data()?["views"] as? String,
                   let currentViews = Int(currentViewsString) {
                    // Increment the value
                    let newViews = currentViews + 1
                    eventRef.updateData([
                        "views": "\(newViews)" // Convert back to string
                    ]) { error in
                        if let error = error {
                            print("Error updating view count: \(error.localizedDescription)")
                        } else {
                            print("View count successfully updated to \(newViews)")
                        }
                    }
                } else {
                    // If "views" doesn't exist or isn't a valid number, initialize it
                    eventRef.setData(["views": "1"], merge: true) { error in
                        if let error = error {
                            print("Error initializing view count: \(error.localizedDescription)")
                        } else {
                            print("View count initialized to 1")
                        }
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    private func toggleBookmarkEvent(event: Event) {
        // Ensure the user is authenticated and fetch their UUID
        guard let userUUID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userUUID)
        
        // Fetch the current user's data
        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching user document: \(error)")
                return
            }
            
            guard let document = document, document.exists,
                  var bookmarkArray = document.data()?["bookmark"] as? [String] else {
                print("No bookmarks found or user document doesn't exist")
                return
            }
            
            if bookmarkArray.contains(event.id) {
                // Remove the event ID from bookmarks
                userRef.updateData([
                    "bookmark": FieldValue.arrayRemove([event.id])
                ]) { error in
                    if let error = error {
                        
                        print("Error removing bookmark: \(error)")
                    } else {
                        bookmarked = false
                        print("Bookmark removed successfully!")
                    }
                }
            } else {
                // Add the event ID to bookmarks
                userRef.updateData([
                    "bookmark": FieldValue.arrayUnion([event.id])
                ]) { error in
                    if let error = error {
                        print("Error adding bookmark: \(error)")
                    } else {
                        
                        print("Bookmark added successfully!")
                    }
                }
            }
            user.fetchUserInformation()
        }
    }

    // Function to check if the current user is part of the event
    private func isUserPartOfEvent(event: Event) -> Bool {
       // guard let userEmail = Auth.auth().currentUser?.email else { return false }
       // Ensure the user is authenticated and fetch their UUID
        guard let userUUID = Auth.auth().currentUser?.uid else { return false }
        return passedEvent.participants.contains(userUUID)
    }
    
    func toDollarString(amount: String) -> String {
        // Try to convert the string to a Double
        if let doubleAmount = Double(amount) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "USD" // Set currency to USD
            
            if let formattedAmount = formatter.string(from: NSNumber(value: doubleAmount)) {
                return formattedAmount
            }
        }
        return "$0.00" // Default value if conversion or formatting fails
    }
    
    func calculateDrivingTime(from userLocation: CLLocation, to destination: CLLocation, completion: @escaping (String?) -> Void) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination.coordinate))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print("Error calculating directions: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let travelTime = response?.routes.first?.expectedTravelTime else {
                completion(nil)
                return
            }
            
            // Convert travel time in seconds to hours and minutes
            let hours = Int(travelTime) / 3600
            let minutes = (Int(travelTime) % 3600) / 60
            
            if hours > 0 {
                completion("\(hours) hr \(minutes) min")
            } else {
                completion("\(minutes) min")
            }
        }
    }
    
    
}

struct ViewEventDetail_Previews: PreviewProvider {
    static var previews: some View {
        ViewEventDetail(event: sampleEvent)
    }
}





extension DateFormatter {
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

//find time til event
extension Date {
    func timeRemaining(until targetDate: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute], from: self, to: targetDate)
        
        // Check if event has already happened
        if let day = components.day, day < 0 {
            return "Event already happened"
        }
        
        // Show days if more than a day remaining
        if let day = components.day, day > 0 {
            return "\(day) day\(day == 1 ? "" : "s") left"
        }
        
        // Show hours if more than an hour remaining
        if let hour = components.hour, hour > 0 {
            return "\(hour) hour\(hour == 1 ? "" : "s") left"
        }
        
        // Show minutes if less than an hour remaining
        if let minute = components.minute, minute > 0 {
            return "\(minute) minute\(minute == 1 ? "" : "s") left"
        }
        
        return "Event is happening now"
    }
}





// Helper function to generate random barcode data
func generateBarcodeData() -> [CGFloat] {
    return (0..<50).map { _ in CGFloat.random(in: 30...50) }
}



func generateQRCode(from string: String) -> UIImage? {
    let filter = CIFilter.qrCodeGenerator()
    filter.message = Data(string.utf8) // Set the data for the QR code
    
    // Generate the QR code image
    if let outputImage = filter.outputImage {
        // Scale up the image to make it higher resolution
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = outputImage.transformed(by: transform)
        
        // Convert CIImage to UIImage
        let context = CIContext()
        if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
            return UIImage(cgImage: cgImage)
        }
    }
    return nil
}


struct FacilityView: View {
    let icon: String
    let label: String
    
    var body: some View {
        HStack(alignment: .center) {
           
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(Color.invert)
                    .frame(width: 30, height: 30) // Set a consistent size
                Text(label)
                    .font(.footnote)
            
            Spacer()
        }.padding(.horizontal,5)
         .padding(.vertical,5)
        
         .overlay(
            RoundedRectangle(cornerRadius: 9)
                .stroke(Color.invert.opacity(0.05), lineWidth: 1)
        )
    }
}


struct FakeBarcodeView: View {
    let barcodeData: [CGFloat] = generateBarcodeData()
    var qrCodeData = "https://www.example.com"
    @State var showQr = false
    var body: some View {
        VStack {
            VStack {
                if let qrCodeImage = generateQRCode(from: qrCodeData) {
                    VStack {
                        Image(uiImage: qrCodeImage)
                            .interpolation(.none) // Keep the sharpness of the QR code
                            .resizable()
                            .frame(width: 200, height: 200)
//
                        // Text(qrCodeData)
                    } // Adjust the size
                } else {
                    Text("Failed to generate QR Code")
                }
            }
            
        }
        
        .padding()
       
    }
}

struct ShowEventLocationView: View {
    let eventLocation: EventLocation
    
    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(
            center: eventLocation.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )), showsUserLocation: true, annotationItems: [eventLocation]) { eventLocation in
            MapPin(coordinate: eventLocation.coordinate, tint: .blue) // Pin for the location
        }
        .edgesIgnoringSafeArea(.all) // Optional: to make the map full screen
    }
}
