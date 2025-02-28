//
//  Event.swift
//  VibeLink
//
//  Created by Zablon Charles on 1/11/25.
//

import SwiftUI
import CoreLocation


// Event Model
struct Event: Identifiable, Equatable {
    var id: String
    var name: String
    var description: String
    var type: String
    var views: String
    var images: [String]
    var location: String
    var price: String
    var owner: String
    var participants: [String]
    var isTimed: Bool
    var startDate: Date?
    var endDate: Date?
    var createdAt: Date?
    
    var coordinate: CLLocationCoordinate2D {
        // Extract latitude and longitude from location string
        let components = location.split(separator: ",")
        if components.count == 4,
           let latitude = Double(components[2].trimmingCharacters(in: .whitespaces)),
           let longitude = Double(components[3].trimmingCharacters(in: .whitespaces)) {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return CLLocationCoordinate2D(latitude: 0, longitude: 0) // Return default value if coordinates aren't found
    }
}

extension Event {
    var distanceFromUser: Double? {
        get { return distanceFromUserBacking }
        set { distanceFromUserBacking = newValue }
    }
}


private var distanceFromUserBacking: Double? // Temporary property to store distance


extension DateFormatter {
    static var shortDateStyle: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}
// Enum for Event Types
enum EventType {
    case ongoing
    case timed
}

let eventTypes: [String] = [
    "Corporate",
    "Concert",
    "Marketing",
    "Health & Wellness",
    "Technology",
    "Art & Culture",
    "Charity",
    "Literature",
    "Lifestyle",
    "Environmental",
    "Entertainment"
]
let typeSymbols: [String: String] = [
    "Concert":"figure.dance",
    "Corporate": "building.2.fill",
    "Marketing": "megaphone.fill",
    "Health & Wellness": "heart.fill",
    "Technology": "desktopcomputer",
    "Art & Culture": "paintbrush.fill",
    "Charity": "heart.circle.fill",
    "Literature": "book.fill",
    "Lifestyle": "leaf.fill",
    "Environmental": "leaf.arrow.triangle.circlepath",
    "Entertainment": "music.note.list"
]



let sampleEvent = Event(
    id: UUID().uuidString,
    name: "Sample Music Festival",
    description: "Join us for an unforgettable day of music, food, and fun at the Summer Music Festival! Enjoy live performances from top artists, great food trucks, and plenty of activities for all ages.",
    type: "Concert",
    views:"342",
    images: ["bg3","bg7"],
    location: "Central Park, New York, 40.785091, -73.968285",
    price:"23",
    owner: "XS2bhb0PngeOsSR3vzIhAUBkEfC3",  // Owner's email
    participants: ["zack@gmail.com"],
    isTimed: true,  // This event has a specific date/time
    startDate: Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date(),
    endDate: Calendar.current.date(byAdding: .day, value: 45, to: Date()) ?? Date(),  // 10 days from today
    createdAt: Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date()
)


let sampleEvents: [Event] = [
    Event(
        id: UUID().uuidString,
        name: "Sample Team Building Retreat",
        description: "A weekend retreat to improve team dynamics and collaboration.Join us for an unforgettable day of music, food, and fun at the Summer Music Festival! Enjoy live performances from top artists, great food trucks, and plenty of activities for all ages.",
        type: "Corporate",
        views:"3434",
        images: ["bg1","bg2"],
        location: "Soho House, New York, 40.7247, -73.9973",  // Example coordinates for Soho House
        price:"12",
        owner: "HR Department",
        participants: ["Alice", "Bob", "Charlie", "Dana"],
        isTimed: true,
        startDate: Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 45, to: Date()) ?? Date(),
        createdAt: Date()
    ),
    Event(
        id: UUID().uuidString,
        name: "Product Launch",
        description: "Launching the latest version of our flagship product.",
        type: "Marketing",
        views:"544",
        images: ["bg3","bg6"],
        location: "The Library, New York, 40.7532, -73.9822",  // Example coordinates for The Library
        price:"5",
        owner: "Marketing Team",
        participants: ["Eve", "Frank", "Grace"],
        isTimed: true,
        startDate: Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 45, to: Date()) ?? Date(),
        createdAt: Date()
    ),
    Event(
        id: UUID().uuidString,
        name: "Yoga Workshop",
        description: "An introductory yoga workshop for beginners.",
        type: "Health & Wellness",
        views:"6564",
        images: ["bg4","bg5"],
        location: "The Wing, New York, 40.7398, -73.9934",  // Example coordinates for The Wing
        price:"65",
        owner: "Wellness Club",
        participants: ["Hank", "Ivy", "Jack"],
        isTimed: false,
        startDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 45, to: Date()) ?? Date(),
        createdAt: Date()
    ),
    Event(
        id: UUID().uuidString,
        name: "Hackathon 2025",
        description: "A 48-hour coding marathon to develop innovative solutions.",
        type: "Technology",
        views:"23",
        images: ["bg6","bg4"],
        location: "NeueHouse, New York, 40.7401, -73.9969",  // Example coordinates for NeueHouse
        price:"29.99",
        owner: "Tech Team",
        participants: ["Kate", "Leo", "Mona", "Nina"],
        isTimed: true,
        startDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 45, to: Date())  ?? Date(),
        createdAt: Date()
    ),
    Event(
        id: UUID().uuidString,
        name: "Art Exhibition",
        description: "Showcasing local artists' work for the year 2025.",
        type: "Art & Culture",
        views:"3444",
        images: ["bg1","bg4"],
        location: "The Strand Bookstore, New York, 40.7332, -73.9907",  // Example coordinates for The Strand
        price:"0",
        owner: "Art Collective",
        participants: ["Olivia", "Paul"],
        isTimed: false,
        startDate: Calendar.current.date(byAdding: .day, value: 20, to: Date()) ?? Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 45, to: Date()) ?? Date(),
        createdAt: Date()
    ),
    Event(
        id: UUID().uuidString,
        name: "Charity Gala",
        description: "An annual gala to raise funds for underprivileged children.",
        type: "Charity",
        views:"23232",
        images: ["bg8","bg6"],
        location: "The Soho Grand Hotel, New York, 40.7403, -74.0028",  // Example coordinates for Soho Grand
        price:"6",
        owner: "Charity Foundation",
        participants: ["Quincy", "Rachel", "Sam", "Tina"],
        isTimed: true,
        startDate: Calendar.current.date(byAdding: .day, value: 60, to: Date()) ?? Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 45, to: Date()) ?? Date(),
        createdAt: Date()
    ),
    Event(
        id: UUID().uuidString,
        name: "Book Club Meeting",
        description: "Monthly book discussion on contemporary literature.",
        type: "Literature",
        views:"233",
        images: ["bg1","bg4"],
        location: "New York Public Library, New York, 40.7128, -74.0060",  // Example coordinates for New York Public Library
        price:"66",
        owner: "Book Club",
        participants: ["Uma", "Victor", "Wendy"],
        isTimed: true,
        startDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 45, to: Date()) ?? Date(),
        createdAt: Date()
    ),
    Event(
        id: UUID().uuidString,
        name: "Cooking Class",
        description: "Learn how to prepare Italian dishes from a professional chef.",
        type: "Lifestyle",
        views:"12",
        images: ["bg6","bg7"],
        location: "La Scuola di Eataly, New York, 40.7377, -73.9933",  // Example coordinates for La Scuola di Eataly
        price:"44",
        owner: "Chef Giovanni",
        participants: ["Xander", "Yara"],
        isTimed: true,
        startDate: Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) ?? Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 45, to: Date()) ?? Date(),
        createdAt: Date()
    ),
    Event(
        id: UUID().uuidString,
        name: "Community Cleanup",
        description: "Join us in cleaning up the neighborhood park.",
        type: "Environmental",
        views:"65",
        images: ["bg3","bg5"],
        location: "Bryant Park, New York, 40.7549, -73.9840",  // Example coordinates for Bryant Park
        price:"89",
        owner: "Community Volunteers",
        participants: ["Zara", "Alex", "Bella"],
        isTimed: false,
        startDate: Calendar.current.date(byAdding: .day, value: 45, to: Date()) ?? Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 45, to: Date()) ?? Date(),
        createdAt: Date()
    ),
    Event(
        id: UUID().uuidString,
        name: "Music Festival",
        description: "An outdoor festival featuring local and international artists.",
        type: "Entertainment",
        views:"98",
        images: ["bg7","bg1"],
        location: "Brooklyn Bowl, New York, 40.7110, -73.9573",  // Example coordinates for Brooklyn Bowl
        price:"5",
        owner: "Festival Committee",
        participants: ["Chris", "Diane", "Eli"],
        isTimed: true,
        startDate: Calendar.current.date(byAdding: .day, value: 15, to: Date()) ?? Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 45, to: Date()) ?? Date(),
        createdAt: Date()
    )
]

