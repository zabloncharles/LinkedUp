//
//  ContentView.swift
//  DesignCodeiOS15
//
//  Created by Meng To on 2021-10-14.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    @AppStorage("signedIn") var signedIn: Bool = false
    @AppStorage("hideTab") var hideTab: Bool = false
    @StateObject var user = UserStore()
    @StateObject  var eventFetcher = EventFetcher()
    
    var body: some View {
        ZStack {
            if signedIn {
                ZStack {
                    // Main content view for different tabs
                    switch selectedTab {
                        case .home:
                            EventView(user:user,fetch:eventFetcher)
                        case .explore:
                            EventMapView(user:user)
                        case .notifications:
                            MainNotificationsView(user: user)
                           
                        case .account:
                            ProfileView(user: user)
                    }
                    
                    TabBar()
                }
                .scaleEffect(signedIn ? 1 : 0.97)
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 44)
                }
                .onAppear {
                    hideTab = false
                    if user.firstName.isEmpty {
                        user.fetchUserInformation()
                    }
                    
                }
            } else {
                LoginView(user: user)
                    .transition(.move(edge: .bottom)) // Apply bottom-to-top transition
                    .onAppear{
                        selectedTab = .home
                    }
            }
        }
        .animation(.spring(), value: signedIn) // Animate the change of showLogin
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)
            
        }
    }
}
