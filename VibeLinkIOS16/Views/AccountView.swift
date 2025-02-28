import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileView: View {
    @AppStorage("signedIn") var signedIn: Bool = false
    @AppStorage("hideTab") var hideTab: Bool = false
    @State private var isBackgroundPlayEnabled = true
    @State private var isWiFiOnlyDownloadEnabled = false
    @State private var isAutoplayEnabled = true
    @ObservedObject var user: UserStore
    @State var logOut = true
    @State var showSignOutButton = false
    @State var signOutAlert = "Sign Out"
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Section
                    VStack(spacing: 8) {
                        URLImageView(urlString: "https://images.unsplash.com/photo-1631913290783-490324506193?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")
                            
                            .frame(width: 80, height: 80)
                            .cornerRadius(60)
                        
                        Text(user.firstName)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(user.getCurrentUserEmail() ?? "not signed in!")
                            .font(.body)
                            .foregroundColor(.gray)
                        
                        NavigationLink(destination: ProfileEditView()) {
                            Text("Edit profile")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Color.blue)
                                .cornerRadius(20)
                        }
                    }
                    
                    // Content and Preferences Sections
                    
                    HStack {
                        Text("Content")
                            .bold()
                        Spacer()
                    }.padding(.horizontal)
                    VStack {
                        NavigationLink(destination: FavoritesView( user: user)) {
                            SettingsRow(icon: "plus", title: "My Events")
                        }
                        Divider()
                        NavigationLink(destination: BookmarkedView(user: user)) {
                            SettingsRow(icon: "bookmark", title: "Bookmarked")
                        }
                        Divider()
                        NavigationLink(destination: DownloadsView(user: user)) {
                            SettingsRow(icon: "qrcode", title: "Tickets")
                        }
                    }.padding(.vertical,5)
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
                        Text("Preferences")
                            .bold()
                        Spacer()
                    }.padding(.horizontal)
                    VStack {
                        
                    NavigationLink(destination: LanguageSettingsView()) {
                        SettingsRow(icon: "globe", title: "Language", detail: "English")
                    }
                        Divider()
                    NavigationLink(destination: NotificationSettingsView()) {
                        SettingsRow(icon: "bell", title: "Notifications", detail: "Enabled")
                    }
                        Divider()
                    NavigationLink(destination: ThemeSettingsView()) {
                        SettingsRow(icon: "paintpalette", title: "Theme", detail: "Light")
                    }
                        Divider()
                    ToggleRow(icon: "play.circle", title: "Background play", isOn: $isBackgroundPlayEnabled)
                    ToggleRow(icon: "wifi", title: "Download via WiFi only", isOn: $isWiFiOnlyDownloadEnabled)
                    ToggleRow(icon: "arrow.triangle.2.circlepath", title: "Autoplay", isOn: $isAutoplayEnabled)
                    }.padding(.vertical,5)
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
                        Text("Account Options")
                            .bold()
                        Spacer()
                    }.padding(.horizontal)
                    VStack{
                        HStack {
                            Image(systemName: signOutAlert == "Signing Out.." ? "circle.slash" : "power")
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                                .rotationEffect(.degrees(signOutAlert == "Signing Out.." ? 360 : 0))
                                .animation(Animation.linear(duration: 3).repeatForever(autoreverses: false), value: signOutAlert)
                            Text("Signed in")
                                .font(.body)
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .padding(.vertical, 8)
                        .onTapGesture {
                            //showSignoutButton
                            showSignOutButton.toggle()
                            hideTab.toggle()
                        }
                        if showSignOutButton {
                            Button(signOutAlert) {
                                //signedIn = false
                                signOut()
                            }
                            .buttonStyle(NextButtonStyle(background: .red))
                            .padding(.bottom,10)
                        }
                        
                    }.padding(.vertical,5)
                        .padding(.horizontal,10)
                        .background(Color.dynamic)
                        .background(.ultraThinMaterial)
                        .cornerRadius(13)
                        .overlay(
                            RoundedRectangle(cornerRadius: 13)
                                .stroke(Color.invert.opacity(0.09), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    
                    Spacer()
                } .padding(.bottom, showSignOutButton ? 10 : 64)
                    .navigationTitle("Account")
               
                    .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button(action: {
                        // Back button action
                    }) {
                        
                    },
                    trailing: Button(action: {
                        // Logout action
                    }) {
                       
                    }
            )
            }
               
        }.onAppear{
            user.fetchUserInformation()
        }
    }
    
    func signOut(){
        signOutAlert = "Signing Out.."
        
     
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            signOutAlert = "Success.."
        }
        
        if signOutAlert ==  "Success.." {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                signedIn = false
            }
        }
    }
        
}

struct SettingsRow: View {
    let icon: String
    let title: String
    var detail: String? = nil
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24, height: 24)
                .foregroundColor(.blue)
            Text(title)
                .font(.body)
            Spacer()
            if let detail = detail {
                Text(detail)
                    .font(.body)
                    .foregroundColor(.gray)
            }
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

struct ToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24, height: 24)
                .foregroundColor(.blue)
            Text(title)
                .font(.body)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.vertical, 8)
       
    }
}
//Bokmarked events
struct BookmarkedView : View {
        @State private var event: Event = sampleEvent
        @State var events : [Event] = sampleEvents
        @State private var errorMessage: String? = nil
        @ObservedObject var user: UserStore
        @State var showNoEvents = false
        var body: some View {
            ZStack {
                VStack {
                    ScrollView(.vertical, showsIndicators: false) { // Make the ScrollView horizontal
                        LazyVStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Bookmarked")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        
                                    Image(systemName: "bookmark")
                                }.foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.green, .orange, Color.blue]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                
                                Text("Here are your bookmarked events. Explore and manage the events you've bookmarked.")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                
                                Divider()
                                
                            }
                            VStack(alignment: .leading, spacing: 20) {
                                if user.bookmarkedEvents.isEmpty{
                                    if !showNoEvents {
                                        ProgressView()
                                            .padding(.top,50)
                                            .onAppear{
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                                    withAnimation(.easeOut) {
                                                        if user.bookmarkedEvents.isEmpty {
                                                            showNoEvents = true
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                    } else {
                                        //Show details that user has no tickets
                                        VStack{
                                            LottieView(filename: "telescope" ,loop: true)
                                                .frame(height: 200)
                                                .padding(.top, 30)
                                                .padding(.bottom,10)
                                            
                                            Text("No Bookmarks Yet!")
                                                .font(.headline)
                                                .padding(.bottom,5)
                                            Text("Don't miss out on the chance to experience them live! Book your ticket now and be part of an unforgettable event.")
                                                .foregroundColor(.secondary)
                                                .multilineTextAlignment(.center)
                                                .padding(.horizontal,25)
                                            
                                            
                                        }
                                    }
                                }
                                // Future Events Section
                                if let futureEvents = user.bookmarkedEvents.filter({ ($0.startDate ?? Date()) >= Calendar.current.startOfDay(for: Date()) }).sorted(by: { $0.startDate ?? Date() < $1.startDate ?? Date() }), !futureEvents.isEmpty {
                                    
                                    Text("Upcoming Events")
                                        .font(.title2)
                                        .bold()
                                        .padding(.bottom, 10)
                                    
                                    ForEach(futureEvents.prefix(5)) { item in
                                        NavigationLink {
                                            ViewEventDetail(event: item)
                                        } label: {
                                            RegularEventCard(event: item)
                                        }
                                    }
                                }
                                
                                // Today’s Events Section
                                if let todayEvents = user.bookmarkedEvents.filter({ Calendar.current.isDateInToday($0.startDate ?? Date()) }), !todayEvents.isEmpty {
                                    
                                    Text("Today’s Events")
                                        .font(.title2)
                                        .bold()
                                        .padding(.vertical, 10)
                                    
                                    ForEach(todayEvents) { item in
                                        NavigationLink {
                                            ViewEventDetail(event: item)
                                        } label: {
                                            RegularEventCard(event: item)
                                        }
                                    }
                                }
                                
                                // Past Events Section
                                if let pastEvents = user.bookmarkedEvents.filter({ ($0.startDate ?? Date()) < Calendar.current.startOfDay(for: Date()) }).sorted(by: { $0.startDate ?? Date() > $1.startDate ?? Date() }), !pastEvents.isEmpty {
                                    
                                    Text("Past Events")
                                        .font(.title2)
                                        .bold()
                                        .padding(.vertical, 10)
                                    
                                    ForEach(pastEvents.prefix(5)) { item in
                                        NavigationLink {
                                            ViewEventDetail(event: item)
                                        } label: {
                                            RegularEventCard(event: item)
                                        }
                                    }
                                }
                            }
                            
                        }
                        .padding(.bottom,70)
                        
                        
                    }
                }.padding(.horizontal)
                
                
                
            }.onAppear {
                user.fetchUserInformation()
                user.fetchBookMarkedEvents()
            }
            
        }
        
        // Function to add a user to Firestore using UID as the document ID
        //    func addUserToFirestore(user: User) {
        //        guard let currentUser = Auth.auth().currentUser else {
        //            print("No user is logged in.")
        //            return
        //        }
        //
        //        let db = Firestore.firestore()
        //
        //        // Use the current user's UID as the document ID in Firestore
        //        let userRef = db.collection("users").document(currentUser.uid)
        //
        //        // Create the dictionary for the user data
        //        let userData: [String: Any] = [
        //            "firstName": user.firstName,
        //            "lastName": user.lastName,
        //            "email": user.email,
        //            "dateOfBirth": user.dateOfBirth,
        //            "phoneNumber": user.phoneNumber,
        //            "avatar": user.avatar,
        //            "myEvents": user.myEvents,
        //            "attendedEvents": user.attendedEvents
        //        ]
        //
        //        // Add the user to Firestore
        //        userRef.setData(userData) { error in
        //            if let error = error {
        //                print("Error adding user: \(error.localizedDescription)")
        //            } else {
        //                print("User successfully added to Firestore with UID: \(currentUser.uid)")
        //            }
        //        }
        //    }
        
        
        
    }


// Placeholder Views
struct FavoritesView: View {
    @State private var event: Event = sampleEvent
    @State var events : [Event] = sampleEvents
    @State private var errorMessage: String? = nil
    @ObservedObject var user: UserStore
    var body: some View {
        ZStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) { // Make the ScrollView horizontal
                    LazyVStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("My Events")
                                    .font(.title)
                                    .fontWeight(.bold)
                                   
                                Image(systemName: "plus")
                            }.foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.purple, .red, Color.blue]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                               
                            Text("Here are your events. Explore and manage the events you've created.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                               
                            
                            Divider()
                           
                        }
                        VStack(alignment: .leading, spacing: 20) {
                            // Future Events Section
                            if let futureEvents = user.createdEvents.filter({ ($0.startDate ?? Date()) >= Calendar.current.startOfDay(for: Date()) }).sorted(by: { $0.startDate ?? Date() < $1.startDate ?? Date() }), !futureEvents.isEmpty {
                                
                                Text("Upcoming Events")
                                    .font(.title2)
                                    .bold()
                                    .padding(.bottom, 10)
                                
                                ForEach(futureEvents.prefix(5)) { item in
                                    NavigationLink {
                                        ViewEventDetail(event: item)
                                    } label: {
                                        RegularEventCard(event: item)
                                    }
                                }
                            }
                            
                            // Today’s Events Section
                            if let todayEvents = user.createdEvents.filter({ Calendar.current.isDateInToday($0.startDate ?? Date()) }), !todayEvents.isEmpty {
                                
                                Text("Today’s Events")
                                    .font(.title2)
                                    .bold()
                                    .padding(.vertical, 10)
                                
                                ForEach(todayEvents) { item in
                                    NavigationLink {
                                        ViewEventDetail(event: item)
                                    } label: {
                                        RegularEventCard(event: item)
                                    }
                                }
                            }
                            
                            // Past Events Section
                            if let pastEvents = user.createdEvents.filter({ ($0.startDate ?? Date()) < Calendar.current.startOfDay(for: Date()) }).sorted(by: { $0.startDate ?? Date() > $1.startDate ?? Date() }), !pastEvents.isEmpty {
                                
                                Text("Expired")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.gray)
                                    .padding(.vertical, 5)
                                
                                ForEach(pastEvents.prefix(5)) { item in
                                    NavigationLink {
                                        ViewEventDetail(event: item)
                                    } label: {
                                        RegularEventCard(event: item)
                                    }
                                }
                            }
                        }

                    }
                    .padding(.bottom,70)
                    
                    
                }
            }.padding(.horizontal)
            
            
            
        }.onAppear {
            user.fetchUserInformation()
            user.fetchCreatedEvents()
        }
        
    }
  
    // Function to add a user to Firestore using UID as the document ID
//    func addUserToFirestore(user: User) {
//        guard let currentUser = Auth.auth().currentUser else {
//            print("No user is logged in.")
//            return
//        }
//
//        let db = Firestore.firestore()
//
//        // Use the current user's UID as the document ID in Firestore
//        let userRef = db.collection("users").document(currentUser.uid)
//
//        // Create the dictionary for the user data
//        let userData: [String: Any] = [
//            "firstName": user.firstName,
//            "lastName": user.lastName,
//            "email": user.email,
//            "dateOfBirth": user.dateOfBirth,
//            "phoneNumber": user.phoneNumber,
//            "avatar": user.avatar,
//            "myEvents": user.myEvents,
//            "attendedEvents": user.attendedEvents
//        ]
//
//        // Add the user to Firestore
//        userRef.setData(userData) { error in
//            if let error = error {
//                print("Error adding user: \(error.localizedDescription)")
//            } else {
//                print("User successfully added to Firestore with UID: \(currentUser.uid)")
//            }
//        }
//    }
    
   

}

struct DownloadsView: View {
    @State private var event: Event = sampleEvent
    @State var events : [Event] = sampleEvents
    @State private var errorMessage: String? = nil
    @ObservedObject var user: UserStore
    @State var showNoEvents = false
    var body: some View {
        
            VStack {
                ScrollView(.vertical, showsIndicators: false) { // Make the ScrollView horizontal
                    LazyVStack {
                        VStack(alignment: .leading) {
                            Text("My Tickets")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.invert, .red, Color.invert]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            Text("Here are your tickets for your events. Explore and manage the tickets you've purchased.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            
                            Divider()
                            
                        }.opacity(showNoEvents && user.attendedEvents.isEmpty ? 0 : 1)
                        VStack(alignment: .leading, spacing: 20) {
                            
                            if user.attendedEvents.isEmpty{
                                if !showNoEvents {
                                    ProgressView()
                                        .padding(.top,50)
                                        .onAppear{
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                                withAnimation(.easeOut) {
                                                    showNoEvents = true
                                                }
                                            }
                                    }
                                } else {
                                    //Show details that user has no tickets
                                    VStack{
                                        LottieView(filename: "telescope" ,loop: false)
                                            .frame(height: 200)
                                            .padding(.top, 30)
                                            .padding(.bottom,10)
                                        
                                        Text("Hmm! Looks like you have no tickets!")
                                            .font(.headline)
                                            .padding(.bottom,5)
                                        Text("Don't miss out on the chance to experience them live! Book your ticket now and be part of an unforgettable event. Secure your spot here today!")
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal,25)
                                        
                                        
                                    }
                                }
                            }
                            
                            // Future Events Section
                            if let futureEvents = user.attendedEvents.filter({ ($0.startDate ?? Date()) >= Calendar.current.startOfDay(for: Date()) }).sorted(by: { $0.startDate ?? Date() < $1.startDate ?? Date() }), !futureEvents.isEmpty {
                                
                                Text("Upcoming Events")
                                    .font(.title2)
                                    .bold()
                                    .padding(.bottom, 10)
                                
                                ForEach(futureEvents.prefix(5)) { item in
                                    NavigationLink {
                                        ViewEventDetail(event: item)
                                    } label: {
                                        RegularEventCard(event: item)
                                    }
                                }
                            }
                            
                            // Today’s Events Section
                            if let todayEvents = user.attendedEvents.filter({ Calendar.current.isDateInToday($0.startDate ?? Date()) }), !todayEvents.isEmpty {
                                
                                Text("Today’s Events")
                                    .font(.title2)
                                    .bold()
                                    .padding(.vertical, 10)
                                
                                ForEach(todayEvents) { item in
                                    NavigationLink {
                                        ViewEventDetail(event: item)
                                    } label: {
                                        RegularEventCard(event: item)
                                    }
                                }
                            }
                            
                            // Past Events Section
                            if let pastEvents = user.attendedEvents.filter({ ($0.startDate ?? Date()) < Calendar.current.startOfDay(for: Date()) }).sorted(by: { $0.startDate ?? Date() > $1.startDate ?? Date() }), !pastEvents.isEmpty {
                                
                                Text("Expired Tickets")
                                    .font(.title2)
                                    .bold()
                                    .padding(.vertical, 10)
                                
                                ForEach(pastEvents.prefix(5)) { item in
                                    NavigationLink {
                                        ViewEventDetail(event: item)
                                    } label: {
                                        RegularEventCard(event: item)
                                    }
                                }
                            }
                        }

                    }
                    .padding(.bottom,70)
                    
                    
                }
            }.padding(.horizontal)
                .navigationTitle("Notifications")
                .navigationBarTitleDisplayMode(.inline)
            
            
        
        .onAppear {
            //fetch all attended events
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if !user.firstName.isEmpty{
                    user.fetchAttendedEvents()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if user.attendedEvents.isEmpty {
                    user.fetchUserInformation()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        if !user.firstName.isEmpty{
                            user.fetchAttendedEvents()
                        }
                    }
                }
            }
           
            
        }
        
    }
}

struct LanguageSettingsView: View {
    var body: some View {
        Text("Language Settings View")
            .navigationTitle("Language")
    }
}

struct NotificationSettingsView: View {
    var body: some View {
        Text("Notification Settings View")
            .navigationTitle("Notifications")
    }
}

struct ThemeSettingsView: View {
    var body: some View {
        Text("Theme Settings View")
            .navigationTitle("Theme")
    }
}

// Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user:  UserStore())
    }
}
