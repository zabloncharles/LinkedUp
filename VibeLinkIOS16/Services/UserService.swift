import Foundation
import Firebase
import FirebaseFirestore
import Combine

class UserService: ObservableObject {
    @Published var currentUserProfile: UserProfile?
    @Published var error: Error?
    
    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchUserProfile(userId: String) async throws {
        do {
            let document = try await db.collection("users").document(userId).getDocument()
            if let userProfile = try? document.data(as: UserProfile.self) {
                DispatchQueue.main.async {
                    self.currentUserProfile = userProfile
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error
            }
            throw error
        }
    }
    
    func updateUserProfile(_ profile: UserProfile) async throws {
        guard let userId = profile.id else { return }
        
        do {
            try await db.collection("users").document(userId).setData(from: profile)
            DispatchQueue.main.async {
                self.currentUserProfile = profile
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error
            }
            throw error
        }
    }
    
    func bookmarkEvent(_ eventId: String) async throws {
        guard let userId = currentUserProfile?.id else { return }
        
        do {
            try await db.collection("users").document(userId).updateData([
                "bookmarkedEvents": FieldValue.arrayUnion([eventId])
            ])
            
            DispatchQueue.main.async {
                if !self.currentUserProfile!.bookmarkedEvents.contains(eventId) {
                    self.currentUserProfile!.bookmarkedEvents.append(eventId)
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error
            }
            throw error
        }
    }
    
    func unbookmarkEvent(_ eventId: String) async throws {
        guard let userId = currentUserProfile?.id else { return }
        
        do {
            try await db.collection("users").document(userId).updateData([
                "bookmarkedEvents": FieldValue.arrayRemove([eventId])
            ])
            
            DispatchQueue.main.async {
                self.currentUserProfile!.bookmarkedEvents.removeAll { $0 == eventId }
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error
            }
            throw error
        }
    }
    
    func fetchUserEvents() async throws -> [Event] {
        guard let userId = currentUserProfile?.id else { return [] }
        
        do {
            let snapshot = try await db.collection("events")
                .whereField("ownerId", isEqualTo: userId)
                .getDocuments()
            
            return snapshot.documents.compactMap { document in
                try? document.data(as: Event.self)
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error
            }
            throw error
        }
    }
} 