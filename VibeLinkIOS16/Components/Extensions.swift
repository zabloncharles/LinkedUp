//
//  Extensions.swift
//  VibeLink
//
//  Created by Zablon Charles on 1/12/25.
//

import SwiftUI
import UIKit
import CoreLocation

// Default background modifier in your app
extension View {
    func blurredBackground() -> some View {
        self.background(
            ZStack {
                // Background with moving image animation
                
                AnimatedBackgroundImage()
                
                // Overlaying a blur effect on top of the image
                
                    
            }.edgesIgnoringSafeArea(.all)
        )
    }
}

extension Color {
    /// Provides access to a dynamic color set called "Dynamic" from the asset catalog.
    static var dynamic: Color {
        return Color("dynamic")
    }
}

extension Color {
    /// Provides access to a dynamic color set called "Dynamic" from the asset catalog.
    static var invert: Color {
        return Color("invert")
    }
}

/// Function to trigger a light vibration
func triggerLightVibration() {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.prepare() // Prepares the generator for use
    generator.impactOccurred() // Triggers the vibration
}
// Struct that takes a URL and displays the image
struct URLImageView: View {
    @State private var image: Image? = nil
    @State private var isLoading = true
    
    // The URL string passed in to load the image
    let urlString: String
    @State var notLoading = false
    
    var body: some View {
        Group {
            if isLoading {
                // Show a loading indicator while the image is being loaded
                ZStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1)
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                               // notLoading = true
                            }
                    }
                    
                   
                }
            } else {
                // Show the image once it's loaded
                image?
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            loadImageFromURL()
        }
    }
    
    // Function to load the image from a URL
    func loadImageFromURL() {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // Fetch the image data asynchronously
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            
            // Check if data is valid and convert it to an image
            guard let data = data, let uiImage = UIImage(data: data) else {
                print("Error converting data to image")
                return
            }
            
            // Convert UIImage to SwiftUI Image and update the state
            DispatchQueue.main.async {
                self.image = Image(uiImage: uiImage)
                self.isLoading = false
            }
        }.resume() // Start the task
    }
}
func getAddressFromLocationString(location: String, completion: @escaping (String) -> Void) {
    // Split and parse the location string
    let components = location.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
    
    guard components.count >= 4,
          let latitude = Double(components[2]),
          let longitude = Double(components[3]) else {
        completion("No location found") // Return default if parsing fails
        return
    }
    
    // Reverse geocoding to fetch address
    let geocoder = CLGeocoder()
    let locationCoordinates = CLLocation(latitude: latitude, longitude: longitude)
    
    geocoder.reverseGeocodeLocation(locationCoordinates) { placemarks, error in
        var address = "No location found" // Default in case reverse geocoding fails
        
        if let placemark = placemarks?.first {
            address = [placemark.name, placemark.locality, placemark.country].compactMap { $0 }.joined(separator: ", ")
        }
        
        completion(address) // Return address asynchronously via the completion handler
    }
}
// Function to load an image from a URL and display it in an image view
func loadImageFromURL(urlString: String, imageView: UIImageView) {
    // Check if the URL is valid
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }
    
    // Fetch the image data asynchronously
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error loading image: \(error)")
            return
        }
        
        // Check if data is valid
        guard let data = data, let image = UIImage(data: data) else {
            print("Error converting data to image")
            return
        }
        
        // Update the image view on the main thread
        DispatchQueue.main.async {
            imageView.image = image
        }
    }.resume() // Start the task
}
struct AnimatedBackgroundImage: View {
    @State private var imageOffset: CGFloat = 0
    @State private var animateUp = true
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Image(colorScheme == .dark ? "Blob 1 Dark" : "Blob 1")
            .resizable()
            .scaledToFit()
            .blur(radius: 80)
            .edgesIgnoringSafeArea(.all) // Makes sure the image takes up the full screen but doesn't move other content
            //.offset(y: imageOffset)
            .offset(y: 500)
            .onAppear {
                // Start the animation when the image appears
              //  withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
               //     imageOffset = animateUp ? -50 : 50 // Moves up and down
              //  }
            }
            .background(colorScheme == .dark ? .black : .white)
            .padding(.horizontal, 50)
    }
}

struct ScrollHideTabView: View {
    @Binding var hideTab: Bool
    @State private var previousOffset: CGFloat = 0
    @State private var lastScrollDate: Date = Date()
    @State private var timer: Timer? = nil
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .onAppear {
                  //  previousOffset = geometry.frame(in: .global).minY
                }
//                .onChange(of: geometry.frame(in: .global).minY) { newOffset in
//                    //only do this when at home
//                    if selectedTab == .home {
//                    if newOffset > previousOffset {
//                        // Scrolling up, show the tab bar
//                        withAnimation {
//                           // hideTab = false
//                        }
//                    } else if newOffset < previousOffset {
//                        // Scrolling down, hide the tab bar
//                        withAnimation {
//                            hideTab = true
//                        }
//                    }
//                    previousOffset = newOffset
//                    // Reset timer on every scroll movement
//                    lastScrollDate = Date()
//
//                        startHideTimer()
//                    }
//                }
        }
        .frame(height: 0) // This is just a placeholder, we don't need to display anything
        .onAppear {
            // Start a timer on view appearance
           // startHideTimer()
        }
    }
    
    private func startHideTimer() {
        // Invalidate the previous timer, if any
        timer?.invalidate()
        
        // Start a new timer to check if 3 seconds passed without scrolling
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            if Date().timeIntervalSince(lastScrollDate) >= 2 {
                // If 3 seconds have passed without scrolling, show the tab bar
                withAnimation {
                    
                    hideTab = false
                }
            }
        }
    }
}

