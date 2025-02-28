//
//  UserStore.swift
//
//  Copyright © 2020 Zablon Charles To. All rights reserved.
//

import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore
import CoreLocation

class UserStore: ObservableObject {
   
    @Published var showLogin = false
    @Published var errorMessage: String? = nil // To store any login errors
    @Published var searchEvent: Event = sampleEvent
    // Properties to store user information
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var dateOfBirth: String = ""
    @Published var phoneNumber: String = ""
    @Published var avatar: String = ""
    @Published var myEventsIds: [String] = [""]
    @Published var attendedEventsIds: [String] = [""]
    @Published var bookmarkedEventsIds: [String] = [""]
    
    @Published var allEvents: [Event] = []
    @Published var attendedEvents: [Event] = []
    @Published var createdEvents: [Event] = []
    @Published var bookmarkedEvents: [Event] = []
    // Function to fetch user information from Firestore
    func fetchUserInformation() {
        guard let currentUser = Auth.auth().currentUser else {
            errorMessage = "No user is logged in."
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUser.uid)
        
        userRef.getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No user data found."
                return
            }
            
            // Parse the user data
            self.firstName = data["firstName"] as? String ?? ""
            self.lastName = data["lastName"] as? String ?? ""
            self.email = data["email"] as? String ?? ""
            self.dateOfBirth = data["dateOfBirth"] as? String ?? ""
            self.phoneNumber = data["phoneNumber"] as? String ?? ""
            self.avatar = data["avatar"] as? String ?? ""
            self.myEventsIds = data["myEvents"] as? [String] ?? [""]
            self.attendedEventsIds = data["attendedEvents"] as? [String] ?? [""]
            self.bookmarkedEventsIds = data["bookmark"] as? [String] ?? [""]
            print("User data fetched successfully.")
        }
    }
    
    // Logout function
    func logout() {
       
        
        // Update the local state
        showLogin = true
       
        
        
        
        do {
            try Auth.auth().signOut()  // Firebase sign out
            print("User signed out successfully.")
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
        // Clear other user data if necessary
        // For example: UserDefaults.standard.removeObject(forKey: "someKey")
    }
    
    // Login function
    func login() {
        
        showLogin = false
    }
    
    // Function to get the current user's email
    func getCurrentUserEmail() -> String? {
        if let email = Auth.auth().currentUser?.email {
            return email
        } else {
            errorMessage = "No user is currently logged in."
            return nil
        }
    }
    func fetchAllEvents() {
        let db = Firestore.firestore()
        
        db.collection("events").getDocuments { snapshot, error in
            if let error = error {
                self.errorMessage = "Error fetching events: \(error.localizedDescription)"
                return
            }
            
            guard let documents = snapshot?.documents else {
                self.errorMessage = "No events found."
                return
            }
            
            // Parse all documents into Event objects
            let events: [Event] = documents.compactMap { doc in
                let data = doc.data()
                
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
                
                return Event(
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
            }
            
            // Update your UI or state with the fetched events
            DispatchQueue.main.async {
                self.allEvents = events
            }
        }
    }

    func fetchEvent(eventId: String) {
        let db = Firestore.firestore()
        
        db.collection("events").document(eventId).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let snapshot = snapshot, let data = snapshot.data() else {
                self.errorMessage = "No event found or invalid snapshot."
                return
            }
            
            // Parse the event data
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
            
            // Create the event instance
            let event = Event(
                id: snapshot.documentID,
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
            
            // Update your UI or state here
            DispatchQueue.main.async {
                self.searchEvent = event
            }
        }
    }
    // Function to fetch events the user created
    func fetchCreatedEvents() {
        
        guard !myEventsIds.isEmpty else {
            errorMessage = "No events found for this user."
            return
        }
        
        let db = Firestore.firestore()
        
        // Fetch the events from the "events" collection based on the myEvents array
        db.collection("events").whereField(FieldPath.documentID(), in: myEventsIds).getDocuments { snapshot, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let documents = snapshot?.documents else {
                self.errorMessage = "No events found."
                return
            }
            
            // Parse the events data
            self.createdEvents = documents.compactMap { doc in
                let data = doc.data()
                let id = doc.documentID
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
                
                return Event(
                    id: id,
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
            }
            
            print("Events fetched successfully.")
        }
    }
    // Function to fetch events the user created
    func fetchBookMarkedEvents() {
        
        guard !bookmarkedEventsIds.isEmpty else {
            errorMessage = "No events found for this user."
            return
        }
        
        let db = Firestore.firestore()
        
        // Fetch the events from the "events" collection based on the myEvents array
        db.collection("events").whereField(FieldPath.documentID(), in: bookmarkedEventsIds).getDocuments { snapshot, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let documents = snapshot?.documents else {
                self.errorMessage = "No events found."
                return
            }
            
            // Parse the events data
            self.bookmarkedEvents = documents.compactMap { doc in
                let data = doc.data()
                let id = doc.documentID
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
                
                return Event(
                    id: id,
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
            }
            
            print("Events fetched successfully.")
        }
    }
    
    func fetchAttendedEvents() {
        
        guard !attendedEventsIds.isEmpty else {
            self.errorMessage = "No events found for this user."
            return
        }
        
        let db = Firestore.firestore()
        
        // Fetch the events from the "events" collection based on the attendedEventsIds array
        db.collection("events")
            .whereField(FieldPath.documentID(), in: attendedEventsIds)
            .getDocuments { snapshot, error in
                // Handle error gracefully
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error fetching events: \(error.localizedDescription)"
                    }
                    return
                }
                
                // Ensure we have documents in the snapshot
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    DispatchQueue.main.async {
                        self.errorMessage = "No events found."
                    }
                    return
                }
                
                // Parse the events data safely
                self.attendedEvents = documents.compactMap { doc in
                    let data = doc.data()
                    
                    // Safely parse each field, providing default values when necessary
                    guard let name = data["name"] as? String,
                          let description = data["description"] as? String,
                          let type = data["type"] as? String,
                          let views = data["views"] as? String,
                          let images = data["images"] as? [String],
                          let location = data["location"] as? String,
                          let price = data["price"] as? String,
                          let owner = data["owner"] as? String,
                          let isTimed = data["isTimed"] as? Bool,
                          let participants = data["participants"] as? [String] else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Error parsing event data."
                        }
                        return nil
                    }
                    
                    let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                    let startDate = (data["startDate"] as? Timestamp)?.dateValue() ?? Date()
                    let endDate = (data["endDate"] as? Timestamp)?.dateValue() ?? Date()
                    
                    return Event(
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
                }
                
                DispatchQueue.main.async {
                    print("Events fetched successfully.")
                    // Optionally update the UI or state
                }
            }
    }

  


}

