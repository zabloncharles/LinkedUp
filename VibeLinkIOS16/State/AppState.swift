import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published var selectedTab: Tab = .home
    @Published var isShowingOnboarding = true
    @Published var isShowingLogin = false
    @Published var isShowingCreateEvent = false
    @Published var selectedEvent: Event?
    @Published var searchQuery = ""
    @Published var selectedFilter: EventFilter = .all
    
    // UI State
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    // Navigation State
    @Published var navigationPath = NavigationPath()
    
    // Theme and Appearance
    @Published var isDarkMode = false
    @Published var selectedTheme: AppTheme = .system
    
    // Location State
    @Published var userLocation: CLLocation?
    @Published var selectedLocation: CLLocation?
    
    // Filter State
    @Published var priceRange: ClosedRange<Double> = 0...1000
    @Published var selectedDate: Date?
    @Published var selectedCategory: EventCategory?
    
    func showError(_ message: String) {
        errorMessage = message
        showError = true
    }
    
    func dismissError() {
        showError = false
    }
    
    func navigateToEvent(_ event: Event) {
        selectedEvent = event
        navigationPath.append(event)
    }
    
    func navigateBack() {
        navigationPath.removeLast()
    }
}

enum Tab: String, CaseIterable {
    case home
    case search
    case create
    case notifications
    case profile
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .search: return "magnifyingglass"
        case .create: return "plus.circle.fill"
        case .notifications: return "bell.fill"
        case .profile: return "person.fill"
        }
    }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .search: return "Search"
        case .create: return "Create"
        case .notifications: return "Notifications"
        case .profile: return "Profile"
        }
    }
}

enum EventFilter: String, CaseIterable {
    case all
    case upcoming
    case past
    case bookmarked
    case myEvents
}

enum AppTheme: String, CaseIterable {
    case light
    case dark
    case system
}

enum EventCategory: String, CaseIterable {
    case music
    case sports
    case arts
    case food
    case business
    case education
    case other
} 