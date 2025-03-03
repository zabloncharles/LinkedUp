import SwiftUI
import Firebase

@main
struct VibeLinkApp: App {
    // MARK: - Dependencies
    @StateObject private var appState = AppState()
    @StateObject private var authService = AuthenticationService()
    @StateObject private var eventService = EventService()
    @StateObject private var userService = UserService()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(authService)
                .environmentObject(eventService)
                .environmentObject(userService)
        }
    }
} 