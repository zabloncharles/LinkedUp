//
//  CreateEventView.swift
//  VibeLink
//
//  Created by Zablon Charles on 1/12/25.
//



import SwiftUI

struct CreateEventDetailView: View {
    @AppStorage("hideTab") var hideTab = false
    @Environment(\.dismiss) private var dismiss
    
    //    @State private var title = ""
    //    @State private var description = ""
    //    @State private var selectedFile: String?
    //    @State private var dateTime = Date()
    //    @State private var startDate = Date()
    //    @State private var endDate = Date()
    //    @State private var isOngoingEvent: Bool? = nil // nil initially, to force user selection
    //    @State private var selectedType: String = "Corporate" // Default selected type
    @State private var eventDate = Date()
    @State private var isChargingMoney: Bool = false
    @State private var ticketPrice = ""
    @State private var currentTab = 0 // Tracks the current tab
    @State private var event = Event(
        id: UUID().uuidString,
        name: "",
        description: "",
        type: "Corporate",
        views: "",
        images: [""],
        location: "",
        price: "0",
        owner: "",
        participants: [""],
        isTimed: true,
        startDate: Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 45, to: Date()) ?? Date(),
        createdAt: Date()
    )
    let eventTypes = [
        "Corporate", "Marketing", "Health & Wellness", "Technology",
        "Art & Culture", "Charity", "Literature", "Lifestyle",
        "Environmental", "Entertainment"
    ]
    
    @State var alertText = "Next"
    @State var buttonBackground = Color.blue
    @State var clickedBackText = ""
    @State var clickedBackIcon = ""
    var body: some View {
        VStack {
            // Event Type Selection
            
            
            HStack {
                HStack(spacing: 1.0){
                    Image(systemName: clickedBackIcon)
                    Text(clickedBackText)
                } .font(.headline).foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple, .blue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ).opacity(0.50)
                ).fontWeight(.bold)
                    .onChange(of: currentTab, perform: { textchanged in
                        clickedBackTextFunc()
                    })
                .onTapGesture {
                    if currentTab == 4 {
                        currentTab -= 2
                    } else {
                        currentTab = currentTab - 1
                    }
                    
                    
            }
                Spacer()
            }.padding(.horizontal,25)
                .padding(.top,currentTab == 3 ? 45 : 0)
                .opacity(currentTab != 0 ? currentTab == 3 ? 0 :  1 : 0)
            
            if currentTab == 0 {
                VStack {
                    LottieView(filename: "telescope" ,loop: false)
                        .frame(height: 200)
                        .padding(.top, 30)
                        .padding(.bottom,10)
                    Text("Create Your Event")
                        .font(.headline)
                        .padding(.bottom,5)
                    Text("Your choices will help us refine your event and make your experience more tailored to your participants.")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal,25)
                    Text("What type of event is this?")
                        .font(.headline)
                        .padding(.top)
                    
                    Picker("Event Type", selection: $event.type) {
                        ForEach(eventTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .padding()
                    
                  
                }.transition(.move(edge: .top))
                
            } // Title Input
            else if currentTab == 1 {
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text("Enter the Event Title")
                            .font(.title3)
                           
                            
                        Image(systemName: "info.circle")
                    } .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple, .blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    ).fontWeight(.bold)
                        .padding(.bottom,5)
                    
                        
                        Text("Provide a clear and descriptive name for your event so participants can easily identify it.")                    .foregroundColor(.secondary)
                    
                        
                       
                    
                    
                    TextField("Event title...", text: $event.name)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white, lineWidth: 1)
                        )
                        
                    
                    
                    
                    Spacer()
                }.multilineTextAlignment(.leading)
                    .padding(.horizontal,25)
                    .transition(.move(edge: .top))
               
            }
            
            
            
            // Description Input
            else if currentTab == 2 {
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text("Add a Description for Your Event")
                            .font(.title3)
                        .padding(.bottom,3)
                        Image(systemName: "info.circle")
                    } .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple, .blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    ).fontWeight(.bold)
                        .padding(.bottom,5)
                    Text("Include key details about your event, such as its purpose, activities, or any highlights participants should know about.")
                        .foregroundColor(.secondary)
                        
                    
                    
                    TextEditor(text: $event.description)
                        .frame(height: 140)
                        .padding(8)
                        
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.50), lineWidth: 1)
                        )
                        
                    
                  Spacer()
                }.multilineTextAlignment(.leading)
                    .padding(.horizontal,25)
               
            }
            
            else if currentTab == 3{
                LocationSelectView(selectedAddress: $event.location, currentTab: $currentTab)
                    
            }
            
            // Timed or Ongoing Event Selection
            else if currentTab == 4 {
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text("Is this a timed or ongoing event?")
                            .font(.title3)
                            .padding(.bottom,3)
                        Image(systemName: "info.circle")
                    } .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple, .blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    ).fontWeight(.bold)
                        .padding(.bottom,5)
                    Text("Choose the right event type to set things up properly and meet your needs. **Timed events** happen on one specific date and have an end time. **Ongoing events** start on one date and continue until another date.")
                        .foregroundColor(.secondary)
                       
                    Spacer()
                    HStack {
                        Button(action: {
                            event.isTimed = false
                            nextButton()
                        }) {
                            Text("Timed Event")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(event.isTimed == false ? Color.blue : Color.gray.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            event.isTimed = true
                            nextButton()
                        }) {
                            Text("Ongoing Event")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(event.isTimed == true ? Color.blue : Color.gray.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(30)
                    
                }.multilineTextAlignment(.leading)
                    .padding(.horizontal,25)
                
            }
            // Date Selection
            else if currentTab == 5 {
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text(event.isTimed == true ? "Set Start and End Dates" : "Set the Event Date and Time")
                            .font(.title3)
                            .padding(.bottom,3)
                        Image(systemName: "info.circle")
                    } .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple, .blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    ).fontWeight(.bold)
                        .padding(.bottom,5)
                    Text(event.isTimed == true ?
                         "Define the start and end dates for your event. The event will run continuously from the start date until the end date, without a specific conclusion time on the same day." :
                            "Choose a specific date and time for your event to begin and end on the same day. This event will take place on the selected date and will be finished by the end of the day.")
                    .foregroundColor(.secondary)
                    .padding(.bottom, 5)
                    
                    Divider()
                    
                    if event.isTimed == true {
                        DatePicker(
                            "Start Date",
                            selection: Binding(
                                get: { event.startDate ?? Date() },
                                set: { event.startDate = $0 }
                            ),
                            displayedComponents: [.date, .hourAndMinute]
                        )
                       
                        
                        DatePicker(
                            "End Date",
                            selection: Binding(
                                get: { event.endDate ?? Date() },
                                set: { event.endDate = $0 }
                            ),
                            displayedComponents: [.date, .hourAndMinute]
                        )
                       
                    } else {
                        DatePicker(
                            "Date:",
                            selection: Binding(
                                get: { event.startDate ?? Date() },
                                set: { event.startDate = $0 }
                            ),
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        
                    }
                    Spacer()
                   
                }
                    .padding(.horizontal,25)
                
            }
            
            // Date Selection
            else if currentTab == 6 {
                VStack(alignment: .leading) {
                   
                    
                    HStack {
                    
                        Text("Are you charging money for this event?")
                            .font(.title3)
                            .padding(.bottom,3)
                        Image(systemName: "info.circle")
                    } .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple, .blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    ).fontWeight(.bold)
                        .padding(.bottom,5)
                    Text("Let us know if your event requires a ticket or entry fee. This helps attendees understand any costs involved and ensures clear communication. If you're charging, you can set the ticket price to make it easier for guests to prepare.")
                        .foregroundColor(.secondary)
                       
                    
                    Divider()
                    Toggle("Charge an entry fee", isOn: $isChargingMoney)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        
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
                        }
                        
                        TextField("Enter Ticket Price", text: $event.price) // Replace with binding to store  TextField("My first real event!", text: $event.name)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                           
                    }
                    
                    Spacer()
                    
                }.padding(.horizontal,25)
                
            }
            
            // Confirmation Screen
            else if currentTab == 7 {
                ViewEventDetail(event: event, previewing:true)
                    .overlay{
                        VStack {
                            HStack {
                                HStack(spacing: 1.0){
                                    Image(systemName: "chevron.left")
                                    Text("Edit")
                                }.fontWeight(.bold)
                                    .foregroundColor(.blue)
                                    .onChange(of: currentTab, perform: { textchanged in
                                        withAnimation() {
                                            clickedBackTextFunc()
                                        }
                                    })
                                    .onTapGesture {
                                        currentTab = currentTab - 1
                                    }
                                Spacer()
                            }.padding(.horizontal,25)
                                .padding(.top,26)
                            Spacer()
                        }
                            
                    }
                   
                
            }
            
            if  currentTab != 4 && currentTab != 7 && currentTab != 3{
                Button(alertText) {
                    nextButton()
                }
                .buttonStyle(NextButtonStyle(background: buttonBackground))
                .padding()
                .onChange(of: alertText) { changed in
                    //return the button to default
                    withAnimation(.easeIn){
                        buttonBackground = Color.red
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation(.easeOut){
                            buttonBackground = Color.blue
                            alertText = "Next"
                            
                        }
                    }
                }
            }
        }.padding(.top,10)
            .navigationBarTitle("Create Event")
            .background(currentTab != 7 ? Color.dynamic : Color.clear)
       
        .edgesIgnoringSafeArea( currentTab == 7 ? .top : [])
        .onAppear{
            hideTab = true
        }
        .onDisappear{
            hideTab = false
        }
    }
    
    func goBack(){
        
        currentTab = currentTab - 1
    }
    
    func clickedBackTextFunc(){
        if currentTab == 0 {
            clickedBackText = ""
        }
        if currentTab == 1 {
           clickedBackIcon = "menucard"
            clickedBackText = "Create Your Event"
        }
        if currentTab == 2 {
            clickedBackIcon = "t.square"
            clickedBackText = "Enter Event Title"
        }
        if currentTab == 3 {
            clickedBackIcon = "d.square"
            clickedBackText = "Description"
        }
        if currentTab == 4 {
            clickedBackIcon = "location"
            clickedBackText = "Address"
        }
        if currentTab == 5 {
            clickedBackIcon = "clock.arrow.2.circlepath"
            clickedBackText = "Timed or Ongoing"
        }
        if currentTab == 6 {
            clickedBackIcon = "calendar.badge.clock"
            clickedBackText = "Enter Date"
        }
        if currentTab == 7 {
            clickedBackIcon = "dollarsign.arrow.circlepath"
            clickedBackText = "Free or Paid"
        }
    }
    
    func nextButton(){
        withAnimation() {
            
            currentTab += 1
        }
       return
        if currentTab == 0 {
            
            if event.type.isEmpty {
                alertText = "Add event type!"
                return
            }
        } else if currentTab == 1 {
            if event.name.isEmpty {
                alertText = "Add event title!"
                return
            }
            if event.name.count < 5 {
                alertText = "That's too short!"
                return
            }
        } else if currentTab == 2 {
            if event.description.isEmpty {
                alertText = "Add event description!"
                return
            }
            if event.description.count < 10 {
                alertText = "That's too short!"
                return
            }
        } else if currentTab == 5 {
            if event.location.isEmpty {
                alertText = "You forgot the event location!"
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    currentTab = 3
                }
                return
            } else if event.startDate == nil {
                alertText = "You forgot the start date!"
                
                return
            }
        } else if currentTab == 6 {
            if event.type.isEmpty {
                alertText = "Add event information!"
                return
            }
        }
        
        currentTab += 1
        
    }
    
    func checkData(){
        
        
        if currentTab == 7 {
            dismiss()
        } else {
            currentTab += 1
        }
    }
    
}

// Custom Button Style for Consistent "Next" Button
struct NextButtonStyle: ButtonStyle {
    var color : Color = Color.white
    var background = Color.blue
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(configuration.isPressed ? .gray : color) // Change text color based on press state
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(background) // Invert background color on press
            .cornerRadius(12) // Optional: for rounded corners
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                   
                    .stroke(configuration.isPressed ? Color.black.opacity(0.70) : Color.gray.opacity(0.20), lineWidth: 1) // Stroke with conditional color
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
//            .padding(40)
            .opacity(configuration.isPressed ? 0.7 : 1) // Adjust opacity when pressed
            
    }
}

// Custom Button Style for Consistent "Next" Button
struct GrayButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(Color.gray.cornerRadius(10))
            .padding()
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}
struct CreateEventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventDetailView()
    }
}

