//
//  FetchClass.swift
//  VibeLink
//
//  Created by Zablon Charles on 1/20/25.
//

import Foundation
import Firebase

class EventFetcher: ObservableObject {
    @Published var filteredCloseEvents: [Event] = []
    @Published var filteredClosePopularEvents: [Event] = []
    @Published var errorMessage: String? = nil
    
    // Hardcoded location (e.g., New York City)
    private let currentLatitude: Double = 40.7128
    private let currentLongitude: Double = -74.0060
    private let maxDistance: Double = 100.0 // 100 miles
    private let earthRadius: Double = 3958.8 // Earth radius in miles
    
    // Function to fetch future events within 100 miles
    func nearbyFutureEvents() {
        let db = Firestore.firestore()
        
        db.collection("events").getDocuments { snapshot, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error fetching events: \(error.localizedDescription)"
                }
                return
            }
            
            guard let documents = snapshot?.documents else {
                DispatchQueue.main.async {
                    self.errorMessage = "No events found."
                }
                return
            }
            
            var events: [Event] = []
            
            for doc in documents {
                let data = doc.data()
                
                // Extract event data
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let type = data["type"] as? String ?? ""
                let views = data["views"] as? String ?? ""
                let images = data["images"] as? [String] ?? []
                let location = data["location"] as? String ?? ""
                let price = data["price"] as? String ?? ""
                let owner = data["owner"] as? String ?? ""
                let isTimed = data["isTimed"] as? Bool ?? false
                let participants = data["participants"] as? [String] ?? []
                let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                let startDate = (data["startDate"] as? Timestamp)?.dateValue() ?? Date()
                let endDate = (data["endDate"] as? Timestamp)?.dateValue() ?? Date()
                
                // Skip past events
                if startDate <= Date() {
                    continue
                }
                
                // Extract and parse coordinates
                let components = location.split(separator: ",")
                guard components.count >= 4,
                      let latitude = Double(components[2].trimmingCharacters(in: .whitespaces)),
                      let longitude = Double(components[3].trimmingCharacters(in: .whitespaces)) else {
                    continue
                }
                
                // Calculate distance using Haversine formula
                let dLat = (latitude - self.currentLatitude).degreesToRadians
                let dLon = (longitude - self.currentLongitude).degreesToRadians
                let a = sin(dLat / 2) * sin(dLat / 2) +
                cos(self.currentLatitude.degreesToRadians) * cos(latitude.degreesToRadians) *
                sin(dLon / 2) * sin(dLon / 2)
                let c = 2 * atan2(sqrt(a), sqrt(1 - a))
                let distance = self.earthRadius * c
                
                // Check if the event is within the distance limit
                if distance <= self.maxDistance {
                    let event = Event(
                        id: doc.documentID,
                        name: name,
                        description: description,
                        type: type,
                        views: views,
                        images: images,
                        location: location,
                        price: price,
                        owner: owner,
                        participants: participants,
                        isTimed: isTimed,
                        startDate: startDate,
                        endDate: endDate,
                        createdAt: createdAt
                    )
                    events.append(event)
                }
            }
            
            // Update state with the filtered events
            DispatchQueue.main.async {
                self.filteredCloseEvents = events
            }
        }
    }
    
    func filterPopularEvents() {
        let db = Firestore.firestore()
        
        db.collection("events").getDocuments { snapshot, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error fetching events: \(error.localizedDescription)"
                }
                return
            }
            
            guard let documents = snapshot?.documents else {
                DispatchQueue.main.async {
                    self.errorMessage = "No events found."
                }
                return
            }
            
            var events: [Event] = []
            
            for doc in documents {
                let data = doc.data()
                
                // Extract event data
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let type = data["type"] as? String ?? ""
                let views = data["views"] as? String ?? ""
                let images = data["images"] as? [String] ?? []
                let location = data["location"] as? String ?? ""
                let price = data["price"] as? String ?? ""
                let owner = data["owner"] as? String ?? ""
                let isTimed = data["isTimed"] as? Bool ?? false
                let participants = data["participants"] as? [String] ?? []
                let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                let startDate = (data["startDate"] as? Timestamp)?.dateValue() ?? Date()
                let endDate = (data["endDate"] as? Timestamp)?.dateValue() ?? Date()
                
                // Skip past events
                if startDate <= Date() {
                    continue
                }
                
                // Extract and parse coordinates
                let components = location.split(separator: ",")
                guard components.count >= 4,
                      let latitude = Double(components[2].trimmingCharacters(in: .whitespaces)),
                      let longitude = Double(components[3].trimmingCharacters(in: .whitespaces)) else {
                    continue
                }
                
                // Calculate distance using Haversine formula
                let dLat = (latitude - self.currentLatitude).degreesToRadians
                let dLon = (longitude - self.currentLongitude).degreesToRadians
                let a = sin(dLat / 2) * sin(dLat / 2) +
                cos(self.currentLatitude.degreesToRadians) * cos(latitude.degreesToRadians) *
                sin(dLon / 2) * sin(dLon / 2)
                let c = 2 * atan2(sqrt(a), sqrt(1 - a))
                let distance = self.earthRadius * c
                
                // Check if the event is within the distance limit
                if distance <= self.maxDistance && participants.count > 3 {
                    let event = Event(
                        id: doc.documentID,
                        name: name,
                        description: description,
                        type: type,
                        views: views,
                        images: images,
                        location: location,
                        price: price,
                        owner: owner,
                        participants: participants,
                        isTimed: isTimed,
                        startDate: startDate,
                        endDate: endDate,
                        createdAt: createdAt
                    )
                    events.append(event)
                }
            }
            
            // Update state with the filtered events
            DispatchQueue.main.async {
                self.filteredClosePopularEvents = events
            }
        }
    }



    
    
}

// Extension for degree to radian conversion
extension Double {
    var degreesToRadians: Double { self * .pi / 180 }
}
