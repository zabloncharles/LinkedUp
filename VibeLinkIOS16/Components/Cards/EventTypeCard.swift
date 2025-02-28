//
//  EventTypeCard.swift
//  VibeLink
//
//  Created by Zablon Charles on 1/12/25.
//

import SwiftUI

struct EventTypeCard: View {
    let images = ["image_01", "image_03"]
    var type = "Party"
    let colors: [Color] = [.red, .green, .blue, .yellow, .orange, .purple, .pink, .cyan]
    // SF Symbols mapping for event types
    let typeSymbols: [String: String] = [
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
    var body: some View {
        HStack {
            // Uncomment and modify this line if you want an image
            // Image(images.randomElement() ?? "image_03") // Replace with actual profile image
            //     .resizable()
            //     .scaledToFill()
            //     .frame(width: 50, height: 50)
            //     .clipShape(Circle())
            // Fetching symbol for event type
            Image(systemName: typeSymbols[type] ?? "questionmark.circle.fill")
            
                .foregroundColor(.white) // Color of the symbol
            
            Text(type)
                .font(.callout)
                .foregroundColor(.white)
                .lineLimit(1)
            
            
        } .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(randomDarkColor()) // Use the random light color function
            .cornerRadius(10)
    }
    
    // Function to generate a random dark color
    func randomDarkColor() -> Color {
        let randomHue = Double.random(in: 0...1) // Random hue between 0 and 1
        let randomSaturation = Double.random(in: 0.2...0.8) // Ensure color saturation isn't too low, to keep colors vibrant
        let randomBrightness = Double.random(in: 0.2...0.5) // Brightness should be low for darker colors but not too dark (avoid black)
        
        return Color(hue: randomHue, saturation: randomSaturation, brightness: randomBrightness)
    }
    
}
