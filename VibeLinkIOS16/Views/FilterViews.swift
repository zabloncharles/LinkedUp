//
//  FilterViews.swift
//  VibeLink
//
//  Created by Zablon Charles on 1/13/25.
//

import SwiftUI
struct FiltersView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Enable or disable specific filters to refine your search. Toggle the options based on your preferences.")
                .font(.body)
                .padding(.bottom)
            
            // Example filter options (checkbox or toggle for specific filters)
            Toggle("Enable Filter 1", isOn: .constant(true))
                .padding()
            Toggle("Enable Filter 2", isOn: .constant(false))
                .padding()
            
            Spacer()
        }
        .navigationTitle("Filters")
        .padding()
    }
}

struct DateView: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Date")
                .font(.callout)
                .bold()
            
            Text("Pick a specific date for your event. Choose from the calendar to narrow your search.")
                .font(.body)
                .padding(.bottom)
            
            DatePicker("Choose a date:", selection: $selectedDate, displayedComponents: .date)
                .padding()
                .datePickerStyle(GraphicalDatePickerStyle())
            
            Spacer()
        }
        .navigationTitle("Date")
        .padding()
    }
}

struct PriceView: View {
    @State private var maxPrice: Double = 200
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Price Range")
                .font(.callout)
                .bold()
            
            Text("Use the slider to set your preferred price range for the event. This helps filter events by affordability.")
                .font(.body)
                .padding(.bottom)
            
            HStack {
                Text("Min: $\(Int(0))")
                    .font(.callout)
                
                Spacer()
                
                Text("Max: $\(Int(maxPrice))")
                    .font(.callout)
            }
            .padding()
            
            // Maximum Price Slider
            Slider(value: $maxPrice, in: 0...200, step: 1)
                .padding()
            
            Spacer()
        }.background(Image("Background 8").scaledToFill().blur(radius: 70))
        .navigationTitle("Price")
        .padding()
    }
}

struct CategoryView: View {
    @State private var selectedCategory = "Events"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Category")
                .font(.callout)
                .bold()
            
            Text("Choose the category of events you are interested in. You can select from a range of categories like events, parties, etc.")
                .font(.body)
                .padding(.bottom)
            
            Picker("Category", selection: $selectedCategory) {
                Text("Events").tag("Events")
                Text("Parties").tag("Parties")
                Text("Workshops").tag("Workshops")
                Text("Conferences").tag("Conferences")
            }
            .pickerStyle(WheelPickerStyle())
            .padding()
            
            Spacer()
        }
        .navigationTitle("Category")
        .padding()
    }
}

