import Foundation
import Firebase
import FirebaseFirestore
import Combine

class EventService: ObservableObject {
    @Published var events: [Event] = []
    @Published var featuredEvents: [Event] = []
    @Published var error: Error?
    
    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchEvents() async throws {
        do {
            let snapshot = try await db.collection("events").getDocuments()
            DispatchQueue.main.async {
                self.events = snapshot.documents.compactMap { document in
                    try? document.data(as: Event.self)
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error
            }
            throw error
        }
    }
    
    func fetchFeaturedEvents() async throws {
        do {
            let snapshot = try await db.collection("events")
                .whereField("isFeatured", isEqualTo: true)
                .getDocuments()
            
            DispatchQueue.main.async {
                self.featuredEvents = snapshot.documents.compactMap { document in
                    try? document.data(as: Event.self)
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error
            }
            throw error
        }
    }
    
    func createEvent(_ event: Event) async throws {
        do {
            let documentRef = try await db.collection("events").addDocument(from: event)
            DispatchQueue.main.async {
                var updatedEvent = event
                updatedEvent.id = documentRef.documentID
                self.events.append(updatedEvent)
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error
            }
            throw error
        }
    }
    
    func updateEvent(_ event: Event) async throws {
        guard let id = event.id else { return }
        
        do {
            try await db.collection("events").document(id).setData(from: event)
            DispatchQueue.main.async {
                if let index = self.events.firstIndex(where: { $0.id == id }) {
                    self.events[index] = event
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error
            }
            throw error
        }
    }
    
    func deleteEvent(_ event: Event) async throws {
        guard let id = event.id else { return }
        
        do {
            try await db.collection("events").document(id).delete()
            DispatchQueue.main.async {
                self.events.removeAll { $0.id == id }
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error
            }
            throw error
        }
    }
    
    func searchEvents(query: String) async throws {
        do {
            let snapshot = try await db.collection("events")
                .whereField("name", isGreaterThanOrEqualTo: query)
                .whereField("name", isLessThanOrEqualTo: query + "\u{f8ff}")
                .getDocuments()
            
            DispatchQueue.main.async {
                self.events = snapshot.documents.compactMap { document in
                    try? document.data(as: Event.self)
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error
            }
            throw error
        }
    }
} 