import Foundation
import Combine

struct EventListState {
    var events: [Event] = []
    var featuredEvents: [Event] = []
    var selectedFilter: EventFilter = .all
    var searchQuery = ""
    var selectedCategory: EventCategory?
    var priceRange: ClosedRange<Double> = 0...1000
    var selectedDate: Date?
}

enum EventListAction {
    case loadEvents
    case loadFeaturedEvents
    case filterChanged(EventFilter)
    case searchQueryChanged(String)
    case categorySelected(EventCategory?)
    case priceRangeChanged(ClosedRange<Double>)
    case dateSelected(Date?)
    case bookmarkEvent(String)
    case unbookmarkEvent(String)
}

class EventListViewModel: BaseViewModelImpl<EventListState, EventListAction> {
    private let eventService: EventService
    private let userService: UserService
    
    init(eventService: EventService, userService: UserService) {
        self.eventService = eventService
        self.userService = userService
        super.init(initialState: EventListState())
    }
    
    override func dispatch(_ action: EventListAction) {
        switch action {
        case .loadEvents:
            loadEvents()
        case .loadFeaturedEvents:
            loadFeaturedEvents()
        case .filterChanged(let filter):
            updateState { $0.selectedFilter = filter }
            loadEvents()
        case .searchQueryChanged(let query):
            updateState { $0.searchQuery = query }
            searchEvents(query: query)
        case .categorySelected(let category):
            updateState { $0.selectedCategory = category }
            loadEvents()
        case .priceRangeChanged(let range):
            updateState { $0.priceRange = range }
            loadEvents()
        case .dateSelected(let date):
            updateState { $0.selectedDate = date }
            loadEvents()
        case .bookmarkEvent(let eventId):
            bookmarkEvent(eventId)
        case .unbookmarkEvent(let eventId):
            unbookmarkEvent(eventId)
        }
    }
    
    private func loadEvents() {
        Task {
            setLoading(true)
            do {
                try await eventService.fetchEvents()
                updateState { state in
                    state.events = eventService.events.filter { event in
                        filterEvent(event)
                    }
                }
            } catch {
                setError(error)
            }
            setLoading(false)
        }
    }
    
    private func loadFeaturedEvents() {
        Task {
            setLoading(true)
            do {
                try await eventService.fetchFeaturedEvents()
                updateState { state in
                    state.featuredEvents = eventService.featuredEvents
                }
            } catch {
                setError(error)
            }
            setLoading(false)
        }
    }
    
    private func searchEvents(query: String) {
        Task {
            setLoading(true)
            do {
                try await eventService.searchEvents(query: query)
                updateState { state in
                    state.events = eventService.events.filter { event in
                        filterEvent(event)
                    }
                }
            } catch {
                setError(error)
            }
            setLoading(false)
        }
    }
    
    private func bookmarkEvent(_ eventId: String) {
        Task {
            do {
                try await userService.bookmarkEvent(eventId)
            } catch {
                setError(error)
            }
        }
    }
    
    private func unbookmarkEvent(_ eventId: String) {
        Task {
            do {
                try await userService.unbookmarkEvent(eventId)
            } catch {
                setError(error)
            }
        }
    }
    
    private func filterEvent(_ event: Event) -> Bool {
        let state = self.state
        
        // Filter by category
        if let category = state.selectedCategory,
           event.category != category {
            return false
        }
        
        // Filter by price range
        if let price = Double(event.price),
           !state.priceRange.contains(price) {
            return false
        }
        
        // Filter by date
        if let selectedDate = state.selectedDate {
            let calendar = Calendar.current
            let eventDate = event.startDate
            if !calendar.isDate(eventDate, inSameDayAs: selectedDate) {
                return false
            }
        }
        
        // Filter by search query
        if !state.searchQuery.isEmpty {
            return event.name.localizedCaseInsensitiveContains(state.searchQuery)
        }
        
        return true
    }
} 