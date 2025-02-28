//
//  RegularEventCard.swift
//  VibeLink
//
//  Created by Zablon Charles on 1/12/25.
//

import SwiftUI

struct RegularEventCard: View {
    var event : Event = sampleEvent
    let colors: [Color] = [.red, .blue, .green, .orange]
    var body: some View {
        VStack {
            ZStack {
                LinearGradient(colors: [.black,.black.opacity(0.40),.black.opacity(0.60)], startPoint: .bottomLeading, endPoint: .topTrailing)
                
                ZStack {
                    
                    VStack(alignment: .leading) {
                        HStack {
                            
                            
                            if event.endDate == nil {
                                Text("Ongoing")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Event")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                            } else {
                                Text(returnMonthOrDay(from: event.startDate ?? Date(), getDayNumber: false).capitalized)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text(returnMonthOrDay(from: event.startDate ?? Date(), getDayNumber: true))
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.top, 10)
                        
                        
                        Spacer()
                        HStack(alignment: .bottom) {
                            Spacer()
                            VStack(alignment: .leading, spacing: 3) {
                                Text(event.description.split(separator: ".")[0] + ".")
                                    .font(.callout)
                                    .foregroundColor(.white)
                                    .padding(.leading)
                                    .lineLimit(2)
                                
                            }.multilineTextAlignment(.trailing)
                        }
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(event.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.clear) // Make the original text transparent
                                    .overlay(
                                        LinearGradient(
                                            gradient: Gradient(colors: [colors.randomElement() ?? .blue, .purple]), // Define your gradient colors
                                            startPoint: .leading, // Starting point of the gradient
                                            endPoint: .trailing   // Ending point of the gradient
                                        )
                                        .mask(
                                            Text(event.name) // Mask the gradient with the text
                                                .font(.title2)
                                                .fontWeight(.bold)
                                        )
                                    )
                                Text(event.location.components(separatedBy: ",")[0])
                            }.multilineTextAlignment(.leading)
                            Spacer()
                            VStack {
                                ZStack {
                                    ForEach(0..<colors.count, id: \.self) { index in
                                        Circle()
                                            .fill(colors[index])
                                            .frame(width: 15, height: 15)
                                            .offset(x: CGFloat(index * 10 - 0))
                                    }
                                }
                                Text("\(event.participants.count) \(event.participants.count > 1 ? "Participants" : "Participant")")
                                
                                    .font(.footnote)
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    }
                    .padding()
                }
                
                
                
                
            }.background(
                Image(event.images[0]) // Replace with actual background image
                .resizable()
                .scaledToFill())
            
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.invert.opacity(0.20), lineWidth: 1)
            )
            .cornerRadius(20)
            
            
        }//.frame(height:300)
        
    }
    
    func returnMonthOrDay(from date: Date, getDayNumber: Bool) -> String {
        let calendar = Calendar.current
        if getDayNumber {
            // Get the day as a number (e.g., 28)
            let day = calendar.component(.day, from: date)
            return "\(day)"
        } else {
            // Get the month as a three-letter abbreviation (e.g., Jan)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM"
            return dateFormatter.string(from: date)
        }
    }
    
}
