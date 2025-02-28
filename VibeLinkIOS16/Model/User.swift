//
//  User.swift
//  VibeLink
//
//  Created by Zablon Charles on 1/19/25.
//

import Foundation


struct User {
    var firstName: String
    var lastName: String
    var email: String
    var dateOfBirth: String
    var phoneNumber: String
    var avatar: String
    var bookmark: [String]
    var myEvents: [String]
    var attendedEvents: [String]
}

let sampleUser = User(
    firstName: "Zack",
    lastName: "Charles",
    email: "zcharles@gmail.com",
    dateOfBirth: "01/01/1990",
    phoneNumber: "2012675068",
    avatar: "bg4",
    bookmark:["jAQIwFTHOxBAO5PaKvtM"],
    myEvents: ["vmAs5mZeTFIvAGefcJsX"],
    attendedEvents: ["zSGTX4B6lJleIqZ8e4pG","rZpj7lA0WbBEND9WZxE7"]
)

// Sample Users with assigned event document IDs and avatars
var sampleUsers: [User] = [
    User(
        firstName: "John",
        lastName: "Doe",
        email: "john.doe@example.com",
        dateOfBirth: "01/01/1990",
        phoneNumber: "123-456-7890",
        avatar: "https://plus.unsplash.com/premium_photo-1671656349218-5218444643d8?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8YXZhdGFyfGVufDB8fDB8fHww",
        bookmark:[""],
        myEvents: ["481CsW9n1sHmlpTXfZbZ", "5IBXl9PHiXLl4ToKVuss", "Nv2Npx3TuRU2b4n1b4e1"], // Assigned doc IDs
        attendedEvents: ["XcGxIHKKyCD5sZPyh2Ah", "jAQIwFTHOxBAO5PaKvtM"]
         // Avatar added (could be an asset or URL)
    ),
    User(
        firstName: "Jane",
        lastName: "Smith",
        email: "jane.smith@example.com",
        dateOfBirth: "02/14/1985",
        phoneNumber: "234-567-8901",
        avatar: "https://plus.unsplash.com/premium_photo-1658527049634-15142565537a?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8YXZhdGFyfGVufDB8fDB8fHww",
        bookmark:[""],
        myEvents: ["Nv2Npx3TuRU2b4n1b4e1", "XcGxIHKKyCD5sZPyh2Ah", "jAQIwFTHOxBAO5PaKvtM"], // Assigned doc IDs
        attendedEvents: ["5IBXl9PHiXLl4ToKVuss", "rZpj7lA0WbBEND9WZxE7"]
        // Avatar added
    ),
    User(
        firstName: "Alice",
        lastName: "Johnson",
        email: "alice.johnson@example.com",
        dateOfBirth: "05/25/1992",
        phoneNumber: "345-678-9012",
        avatar: "https://images.unsplash.com/photo-1580489944761-15a19d654956?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8YXZhdGFyfGVufDB8fDB8fHww",
        bookmark:[""],
        myEvents: ["rZpj7lA0WbBEND9WZxE7", "tZkA2dXFy4FmNq65GIv7", "tmOfuJUoEp9WFgNjYh8m"], // Assigned doc IDs
        attendedEvents: ["Nv2Npx3TuRU2b4n1b4e1", "zSGTX4B6lJleIqZ8e4pG"]
       
    ),
    User(
        firstName: "Bob",
        lastName: "Brown",
        email: "bob.brown@example.com",
        dateOfBirth: "03/08/1983",
        phoneNumber: "456-789-0123",
        avatar: "https://images.unsplash.com/photo-1566492031773-4f4e44671857?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGF2YXRhcnxlbnwwfHwwfHx8MA%3D%3D",
        bookmark:[""],
        myEvents: ["tZkA2dXFy4FmNq65GIv7", "tmOfuJUoEp9WFgNjYh8m", "vmAs5mZeTFIvAGefcJsX"], // Assigned doc IDs
        attendedEvents: ["XcGxIHKKyCD5sZPyh2Ah", "rZpj7lA0WbBEND9WZxE7"]
        
    ),
    User(
        firstName: "Charlie",
        lastName: "Davis",
        email: "charlie.davis@example.com",
        dateOfBirth: "11/22/1987",
        phoneNumber: "567-890-1234",
        avatar: "https://images.unsplash.com/photo-1543610892-0b1f7e6d8ac1?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGF2YXRhcnxlbnwwfHwwfHx8MA%3D%3D",
        bookmark:[""],
        myEvents: ["zSGTX4B6lJleIqZ8e4pG", "rZpj7lA0WbBEND9WZxE7", "jAQIwFTHOxBAO5PaKvtM"], // Assigned doc IDs
        attendedEvents: ["5IBXl9PHiXLl4ToKVuss", "Nv2Npx3TuRU2b4n1b4e1"]
       
    )
]
