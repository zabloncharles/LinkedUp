//
//  MainNotificationsView.swift
//  VibeLink
//
//  Created by Zablon Charles on 1/21/25.
//

import Foundation
import SwiftUI

struct MainNotificationsView: View {
    @State private var event: Event = sampleEvent
    @State var events : [Event] = sampleEvents
    @State private var errorMessage: String? = nil
    @ObservedObject var user: UserStore
    @State var showNoEvents = false
    var body: some View {
        NavigationView {
            VStack(spacing: 0.0) {
                ScrollView(.vertical, showsIndicators: false) { // Make the ScrollView horizontal
                    LazyVStack {
                        VStack(alignment: .leading) {
                            Text("My Tickets")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.invert, .red, Color.invert]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            Text("Here are your tickets for your events. Explore and manage the tickets you've purchased.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            
                            Divider()
                            
                        }
                        VStack(alignment: .leading, spacing: 20) {
                            
                            if user.attendedEvents.isEmpty{
                                if !showNoEvents {
                                    ProgressView()
                                        .padding(.top,50)
                                        .onAppear{
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                                withAnimation(.easeOut) {
                                                    if user.attendedEvents.isEmpty {
                                                        showNoEvents = true
                                                    }
                                                    
                                                }
                                            }
                                        }
                                } else {
                                    //Show details that user has no tickets
                                    VStack{
                                        LottieView(filename: "telescope" ,loop: false)
                                            .frame(height: 200)
                                            .padding(.top, 30)
                                            .padding(.bottom,10)
                                        
                                        Text("Hmm! Looks like you have no tickets!")
                                            .font(.headline)
                                            .padding(.bottom,5)
                                        Text("Don't miss out on the chance to experience them live! Book your ticket now and be part of an unforgettable event. Secure your spot here today!")
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal,25)
                                        
                                        
                                    }
                                }
                            }
                            
                            // Future Events Section
                            if let futureEvents = user.attendedEvents.filter({ ($0.startDate ?? Date()) >= Calendar.current.startOfDay(for: Date()) }).sorted(by: { $0.startDate ?? Date() < $1.startDate ?? Date() }), !futureEvents.isEmpty {
                                
                                Text("Upcoming Events")
                                    .font(.title2)
                                    .bold()
                                    .padding(.bottom, 10)
                                
                                ForEach(futureEvents.prefix(5)) { item in
                                    NavigationLink {
                                        ViewEventDetail(event: item)
                                    } label: {
                                        RegularEventCard(event: item)
                                    }
                                }
                            }
                            
                            // Today’s Events Section
                            if let todayEvents = user.attendedEvents.filter({ Calendar.current.isDateInToday($0.startDate ?? Date()) }), !todayEvents.isEmpty {
                                
                                Text("Today’s Events")
                                    .font(.title2)
                                    .bold()
                                    .padding(.vertical, 10)
                                
                                ForEach(todayEvents) { item in
                                    NavigationLink {
                                        ViewEventDetail(event: item)
                                    } label: {
                                        RegularEventCard(event: item)
                                    }
                                }
                            }
                            
                            // Past Events Section
                            if let pastEvents = user.attendedEvents.filter({ ($0.startDate ?? Date()) < Calendar.current.startOfDay(for: Date()) }).sorted(by: { $0.startDate ?? Date() > $1.startDate ?? Date() }), !pastEvents.isEmpty {
                                
                                Text("Past Events")
                                    .font(.title2)
                                    .bold()
                                    .padding(.vertical, 10)
                                
                                ForEach(pastEvents.prefix(5)) { item in
                                    NavigationLink {
                                        ViewEventDetail(event: item)
                                    } label: {
                                        RegularEventCard(event: item)
                                    }
                                }
                            }
                        }
                        
                    }
                    .padding(.bottom,70)
                    
                    
                }
            }.toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: NotificationSettingsDetailView()) {
                        Image(systemName: "gearshape")
                    }
                    
                    NavigationLink(destination: NotificationListView()) {
                        ZStack {
                            Image(systemName: "bell")
                            ZStack {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 16, height: 16)
                                Text("\(user.attendedEvents.count)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .offset(x: 12, y: -12)
                        }
                    }
                }
            }.padding(.horizontal)
                .navigationTitle("Notifications")
                .navigationBarTitleDisplayMode(.inline)
            
            
        }
        .onAppear {
            //fetch all attended events
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if !user.firstName.isEmpty{
                    user.fetchAttendedEvents()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if user.attendedEvents.isEmpty {
                    user.fetchUserInformation()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        if !user.firstName.isEmpty{
                            user.fetchAttendedEvents()
                        }
                    }
                }
            }
            
            
        }
        
    }
}
