//
//  EditEventView.swift
//  VibeLink
//
//  Created by Zablon Charles on 1/25/25.
//

import SwiftUI
import Firebase

struct EditEventView: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .home
  @Binding var event: Event // Local state for the event being edited
  var originalEvent = Event(
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
    @State private var showConfirmationDialog = false
    @State private var showSuccessMessage = false
    @State private var isChargingMoney: Bool = false
    @State private var currentTab = 0 // Tracks the current tab
    @State var location = ""
    @FocusState private var focusedDescription
    @State var hideLottie = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    @State private var isSaving = false
    @State var showAlert = false
    @State var showDeleteError = "Delete"
    var dismissParent: () -> Void // Function to close ParentView
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(event.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.yellow, .blue, Color.invert]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                        )
                        Image(systemName: typeSymbols[event.type] ?? "info")
                        
                    }
                    Divider()
                    Text("Here are your tickets for your events. Explore and manage the tickets you've purchased.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 30) // Top padding of 30
                .padding([ .leading, .trailing])
                .padding(.bottom, 30)
                
               
                    
                        
                        HStack {
                            Text("Event Details")
                                .bold()
                            Spacer()
                        }.padding(.horizontal)
                
                
                VStack(spacing: 15.0){
                    NavigationLink(destination: namelink.background(Color.dynamic)) {
                        HStack {
                            Text("Event Name")
                            Spacer()
                            Text(event.name)
                                .foregroundColor(event.name != originalEvent.name ? Color.invert : .gray)
                               
                            Image(systemName: "chevron.right")
                        }
                    }
                    Divider()
                    NavigationLink(destination: description.background(Color.dynamic)) {
                        VStack(alignment: .leading, spacing: 10.0) {
                            HStack {
                                Text("Description")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            Text(event.description)
                                .foregroundColor(event.description != originalEvent.description ? Color.invert : .gray)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                        }
                    }
                    Divider()
                    NavigationLink(destination: eventtype.background(Color.dynamic)) {
                        HStack {
                            Text("Event Type")
                            Spacer()
                            Text(event.type)
                                .foregroundColor(event.type != originalEvent.type ? Color.invert : .gray)
                            Image(systemName: "chevron.right")
                        }
                    }
                    Divider()
                    NavigationLink(destination: eventlocation.background(Color.dynamic)) {
                        VStack(alignment: .leading, spacing: 10.0) {
                            HStack {
                                Text("Location")
                                Spacer()
                                Image(systemName: "chevron.right")
                                
                            }
                            Text(event.location)
                                .foregroundColor(event.location != originalEvent.location ? Color.invert : .gray)
                                .lineLimit(1)
                        }
                    }
                    Divider()
                    NavigationLink(destination: eventprice.background(Color.dynamic)) {
                        HStack {
                            Text("Price")
                            Spacer()
                            Text(event.price)
                                .foregroundColor(event.price != originalEvent.price ? Color.invert : .gray)
                            Image(systemName: "chevron.right")
                        }
                    }
                    
                    
                    
                        
                        
                    
                   
                    
                }.padding(.vertical,15)
                    .padding(.horizontal,10)
                    .background(Color.dynamic)
                    .background(.ultraThinMaterial)
                    .cornerRadius(13)
                    .overlay(
                        RoundedRectangle(cornerRadius: 13)
                            .stroke(Color.invert.opacity(0.09), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    
                   
                HStack {
                    Text("Event Date")
                        .bold()
                    Spacer()
                }.padding(.horizontal)
                    .padding(.top)
                VStack {
                    NavigationLink(destination: eventdate.background(Color.dynamic)) {
                        HStack {
                            Text("Start Date")
                            Spacer()
                            Text(event.startDate?.formatted(date: .abbreviated, time: .omitted) ?? "Select Date")
                                .foregroundColor(event.startDate?.formatted(date: .abbreviated, time: .omitted) != originalEvent.startDate?.formatted(date: .abbreviated, time: .omitted) ? Color.invert : .gray)
                            Image(systemName: "chevron.right")
                        }
                    }
                            
                        
                    
                    .onAppear{
                     //   event = passedEvent
                }
                }.padding(.vertical,15)
                    .padding(.horizontal,10)
                    .background(Color.dynamic)
                    .background(.ultraThinMaterial)
                    .cornerRadius(13)
                    .overlay(
                        RoundedRectangle(cornerRadius: 13)
                            .stroke(Color.invert.opacity(0.09), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .padding(.bottom,10)
               
            
                
                if event != originalEvent && showDeleteError == "Delete" {
                    Button(action: {
                        saveChanges()
                    }) {
                        Text("Save Changes")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                            .padding()
                            .padding(.horizontal,40)
                            
                }
                }
                Button(action: {
                    showAlert = true
                }) {
                    Text(showDeleteError)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                        .padding(.bottom)
                        .padding(event == originalEvent ? .top : .bottom)
                        .padding(.horizontal,60)
                        .animation(.spring(), value: showDeleteError)
                        .alert("Delete Event", isPresented: $showAlert) {
                            Button("Cancel", role: .cancel) { }
                            Button("Delete", role: .destructive) {
                               deleteEventFunc()
                            }
                        } message: {
                            Text("Are you sure you want to delete this event?")
                        }
                }
                    
                Spacer()
            }.background(Color.dynamic)
        }
    }
    var namelink : some View {
        // Title Input
        VStack {
            LottieView(filename: "telescope" ,loop: true)
                .frame(height: 200)
                .padding(.top, 30)
                .padding(.bottom,10)
            Text("Enter the Event Title")
                .font(.headline)
                .padding(.bottom,5)
            Text("Provide a clear and descriptive name for your event so participants can easily identify it.")                    .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal,25)
            
            
            TextField("Event title...", text: $event.name)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()
            
           Spacer()
        }
    }
    
    var description: some View {
        // Description Input
        VStack {
            if !hideLottie {
                LottieView(filename: "telescope" ,loop: false)
                    .frame(height: 200)
                    .padding(.top, 30)
                    .padding(.bottom,10)
            }
            Text("Add a Description for Your Event")
                .font(.headline)
                .padding(.bottom,5)
            Text("Include key details about your event, such as its purpose, activities, or any highlights participants should know about.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .padding(.horizontal,25)
            
            
            TextEditor(text: $event.description)
                .focused($focusedDescription)
                
                .frame(height: 140)
                .padding(2)
                
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()
            Spacer()
        }.onChange(of: focusedDescription) { newValue in
            
            if newValue{
                hideLottie = true}
        }
    }
    
    var eventtype: some View {
        VStack {
            LottieView(filename: "telescope" ,loop: false)
                .frame(height: 200)
                .padding(.top, 30)
                .padding(.bottom,10)
            Text("Create Your Event")
                .font(.headline)
                .padding(.bottom,5)
            Text("What type of event is this?")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal,25)
            
            
            Picker("Event Type", selection: $event.type) {
                ForEach(eventTypes, id: \.self) { type in
                    Text(type).tag(type)
                }
            }
            .pickerStyle(WheelPickerStyle())
            
            .padding()
          
            Spacer()
        }
    }
    var eventlocation: some View {
        LocationSelectView(selectedAddress: $location, currentTab: $currentTab)
            .onChange(of: currentTab) { newValue in
                event.location = location
            }
            
            
    }
    var eventprice: some View {
        // Date Selection
        VStack {
            LottieView(filename: "telescope" ,loop: false)
                .frame(height: 200)
                .padding(.top, 30)
                .padding(.bottom,10)
            
            Text("Are you charging money for this event?")
                .font(.headline)
                .padding(.bottom,5)
            Text("Let us know if your event requires a ticket or entry fee. This helps attendees understand any costs involved and ensures clear communication. If you're charging, you can set the ticket price to make it easier for guests to prepare.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal,25)
            
            Divider()
            Toggle("Charge an entry fee", isOn: $isChargingMoney)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .padding(.horizontal)
            Divider()
            
            
            if isChargingMoney {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                    ForEach(1...8, id: \.self) { index in
                        Text("$\(index * 5)")
                            .font(.system(size: 20))
                            .frame(width: 80, height: 40)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(5)
                            .onTapGesture {
                                event.price = String(index * 5)
                            }
                    }
                }.padding(.horizontal)
                
                TextField("Enter Ticket Price", text: $event.price) // Replace with binding to store  TextField("My first real event!", text: $event.name)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .padding()
            }
            
            Spacer()
            
        }.onAppear{
            // Initialize toggle based on the current price
            isChargingMoney = (Int(event.price) ?? 0) > 0
        }
    }
    var eventdate: some View {
        // Date Selection
        VStack {
            LottieView(filename: "telescope" ,loop: false)
                .frame(height: 200)
                .padding(.top, 30)
                .padding(.bottom,10)
            Text(event.isTimed == true ? "Set Start and End Dates" : "Set the Event Date and Time")
                .font(.headline)
                .padding(.bottom,5)
            Text(event.isTimed == true ?
                 "Define the start and end dates for your event. The event will run continuously from the start date until the end date, without a specific conclusion time on the same day." :
                    "Choose a specific date and time for your event to begin and end on the same day. This event will take place on the selected date and will be finished by the end of the day.")
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal,25)
            Text(event.isTimed == true ? "Set Start and End Dates" : "Set the Event Date and Time")
                .font(.headline)
                .padding()
            
            if event.isTimed == true {
                DatePicker(
                    "Start Date",
                    selection: Binding(
                        get: { event.startDate ?? Date() },
                        set: { event.startDate = $0 }
                    ),
                    displayedComponents: [.date, .hourAndMinute]
                )
                .padding()
                
                DatePicker(
                    "Start Date",
                    selection: Binding(
                        get: { event.endDate ?? Date() },
                        set: { event.endDate = $0 }
                    ),
                    displayedComponents: [.date, .hourAndMinute]
                )
                .padding()
            } else {
                DatePicker(
                    "Start Date",
                    selection: Binding(
                        get: { event.startDate ?? Date() },
                        set: { event.startDate = $0 }
                    ),
                    displayedComponents: [.date, .hourAndMinute]
                )
                .padding()
            }
            
            Spacer()
        }
    }
    
    func deleteEventFunc() {
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(event.id)
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showDeleteError = "Deleting.."
        }
       
        eventRef.delete { error in
            if let error = error {
                showDeleteError = "Error deleting event: \(error.localizedDescription)"
                print("Error deleting event: \(error.localizedDescription)")
            } else {
                print("Event successfully deleted!")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showDeleteError = "Success.."
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    dismiss()
                }
                

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                    dismissParent()

                }
            }
        }
    }
    
    private func saveChanges() {
        isSaving = true
        
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(event.id)
        
        // Compute the differences
        var updatedFields: [String: Any] = [:]
        
        if event.name != originalEvent.name {
            updatedFields["name"] = event.name
        }
        if event.description != originalEvent.description {
            updatedFields["description"] = event.description
        }
        if event.type != originalEvent.type {
            updatedFields["type"] = event.type
        }
        if event.location != originalEvent.location {
            updatedFields["location"] = event.location
        }
        if event.price != originalEvent.price {
            updatedFields["price"] = event.price
        }
        if event.startDate != originalEvent.startDate {
            updatedFields["startDate"] = event.startDate
        }
        if event.endDate != originalEvent.endDate {
            updatedFields["endDate"] = event.endDate
        }
        
        // Update only changed fields in Firestore
        eventRef.updateData(updatedFields) { error in
            isSaving = false
            if let error = error {
                print("Error updating event: \(error.localizedDescription)")
            } else {
                print("Event updated successfully!")
                // Update originalEvent to match the current event
                dismiss()
               
            }
        }
    }
    func fetchEvent(withId eventId: String, completion: @escaping (Event?) -> Void) {
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(eventId)
        
        eventRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching event: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists,
                    let data = snapshot.data() else {
                print("Event not found or data is empty.")
                completion(nil)
                return
            }
            
            // Map Firestore data to the Event model
            do {
                let event = try Event(
                    id: snapshot.documentID,
                    name: data["name"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    type: data["type"] as? String ?? "",
                    views: data["views"] as? String ?? "",
                    images: data["images"] as? [String] ?? [],
                    location: data["location"] as? String ?? "",
                    price: data["price"] as? String ?? "",
                    owner: data["owner"] as? String ?? "",
                    participants: data["participants"] as? [String] ?? [],
                    isTimed: data["isTimed"] as? Bool ?? false,
                    startDate: (data["startDate"] as? Timestamp)?.dateValue() ?? Date(),
                    endDate: (data["endDate"] as? Timestamp)?.dateValue() ?? Date(),
                    createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                )
                completion(event)
            } catch {
                print("Error mapping event data: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}

struct EditFieldView: View {
    let title: String
    @Binding var value: String
    
    var body: some View {
        Form {
            Section {
                TextField(title, text: $value)
            }
        }
        .navigationTitle(title)
    }
}



struct Previews_EditEventView_Previews: PreviewProvider {
    static var previews: some View {
        EditEventView(event: .constant(sampleEvent), dismissParent: { print("Parent Dismissed") })
    }
}
