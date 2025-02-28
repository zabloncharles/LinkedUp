//
//  LocationSelectView.swift
//  Soul25
//
//  Created by Zablon Charles on 1/9/25.
//

import SwiftUI
import MapKit

struct LocationSelectView: View {
    @StateObject private var viewModel = AddressSearchViewModel()
    @Binding var selectedAddress: String
    @Binding var currentTab : Int // Tracks the current tab
    @State var showMap = false
    @State var confirmed = false
    @FocusState private var isFocused: Bool
    //@State var isFocused = true
    var body: some View {
        ZStack {
           
            VStack {
                if !isFocused {
                    LottieView(filename: "locationbubble" ,loop: true)
                        .frame(height: 200)
                        .padding(.top, 30)
                        .padding(.bottom,10)
                        .overlay{
                            Image(systemName: "location.fill.viewfinder")
                                .frame(height: 400)
                                .padding(.top, 30)
                                .padding(.bottom,10)
                                .font(.title)
                    }
                }
                HStack {
                    Text("Add an address for Your Event")
                        .font(.title3)
                        .padding(.bottom,3)
                    Image(systemName: "info.circle")
                } .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple, .blue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                ).fontWeight(.bold)
                    .multilineTextAlignment(isFocused ? .leading : .center)
                    .padding(.bottom,5)
                
                Text("Provide the location details where your event will take place. This can include the venue name, street address, city, state, and zip code to ensure attendees can easily find and navigate to your event location")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(isFocused ? .leading : .center)
                    .padding(.horizontal,isFocused ? 0 : 25)
                TextField("Enter Address", text: $viewModel.queryFragment)
                    .focused($isFocused)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .padding()
                
                if !viewModel.suggestions.isEmpty {
                    ForEach(viewModel.suggestions.prefix(3), id: \.self) { suggestion in
                        Button(action: {
                            selectedAddress = viewModel.fullAddress
                            viewModel.getCoordinates(for: suggestion)
                            
                            
                            withAnimation(.spring()) {
                                showMap = true
                            }
                            
                            
                        }) {
                            
                            VStack {
                                Divider()
                                Text(suggestion)
                                    .font(.callout) // Set the font size for event titles
                                                    // Make the event name bold
                                .foregroundColor(.primary)
                            } // Set primary text color (based on light/dark mode)
                            Spacer()
                        }  .padding(.vertical, 7)
                            .padding(.horizontal, 10)
                        // Add a background color to the event row
                            .cornerRadius(9)
                        
                            .padding(.horizontal)
                        
                    }
                }
              
                
                Spacer()
            }.padding(.horizontal,isFocused ? 25 : 0)
            
            
            if showMap {
            Rectangle()
                .fill(.clear)
                .background(Color.dynamic)
                .edgesIgnoringSafeArea(.all)
            
            
          
                VStack{
                    Text(confirmed && !selectedAddress.isEmpty ? "You have chosen \(selectedAddress)" : "Please confirm the location of the event on the map below.")
                        .foregroundColor(.invert)
                        .multilineTextAlignment(.center)
                    Divider()
                        if let region = viewModel.region {
                            Map(coordinateRegion: .constant(region), annotationItems: [viewModel.annotation]) { item in
                                MapMarker(coordinate: item.coordinate, tint: .blue)
                            }
                            .frame(height: 500)
                           
                            
                            
                           
                            
                        }
                    Divider()
                    if !confirmed {
                        HStack {
                            Button("Back") {
                                withAnimation(.spring())  {
                                    showMap = false
                                }
                            }
                          
                            .buttonStyle(NextButtonStyle(color: Color.white, background: Color.gray)
                                )
                            
                            Button("Confirm") {
                                selectedAddress = viewModel.fullAddress
                                currentTab += 1
                                withAnimation() {
                                    confirmed = true
                                }
                            }
                            .buttonStyle(NextButtonStyle(color: Color.white))
                        }.opacity(confirmed ? 0 : 1)
                    }
                    
                    if confirmed {
                        Button("Success!") {
                            
                        }
                        .buttonStyle(NextButtonStyle(color: Color.white))
                        .foregroundColor(.red)
                    }
                    
                }.padding()
                    .onAppear{
                        isFocused = false
                    }
            }
        }
    }
}

struct MapAnnotationEvent: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

class AddressSearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    @Published var suggestions: [String] = []
    @Published var region: MKCoordinateRegion?
    @Published var annotation: MapAnnotationEvent = MapAnnotationEvent(coordinate: CLLocationCoordinate2D())
    @Published var fullAddress: String = "Fetching address..."
    
    private let geocoder = CLGeocoder()
    private var searchCompleter: MKLocalSearchCompleter
    
    override init() {
        self.searchCompleter = MKLocalSearchCompleter()
        self.searchCompleter.resultTypes = .address
        super.init()
        self.searchCompleter.delegate = self
    }
    
    func getCoordinates(for address: String) {
        geocoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
            if let error = error {
                print("Geocoding failed: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first,
                  let location = placemark.location else {
                print("No coordinates found for the given address.")
                return
            }
            
            DispatchQueue.main.async {
                let coordinate = location.coordinate
                self?.annotation = MapAnnotationEvent(coordinate: coordinate)
                self?.region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                self?.fetchFullAddress(for: coordinate)
            }
        }
    }
    
//    func fetchFullAddress(for coordinate: CLLocationCoordinate2D) {
//        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
//            if let error = error {
//                print("Error fetching address: \(error.localizedDescription)")
//                self?.fullAddress = "Unable to fetch address"
//                return
//            }
//
//            if let placemark = placemarks?.first {
//                var addressParts: [String] = []
//                if let name = placemark.name { addressParts.append(name) }
//                if let locality = placemark.locality { addressParts.append(locality) }
//                if let administrativeArea = placemark.administrativeArea { addressParts.append(administrativeArea) }
//                if let postalCode = placemark.postalCode { addressParts.append(postalCode) }
//                if let country = placemark.country { addressParts.append(country) }
//
//                self?.fullAddress = addressParts.joined(separator: ", ")
//            } else {
//                self?.fullAddress = "Address not found"
//            }
//        }
//    }
    func fetchFullAddress(for coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("Error fetching address: \(error.localizedDescription)")
                self?.fullAddress = "Unable to fetch address"
                return
            }
            
            if let placemark = placemarks?.first {
                var addressParts: [String] = []
                if let name = placemark.name { addressParts.append(name) }
                if let locality = placemark.locality { addressParts.append(locality) }
                
                // Combine latitude and longitude into the format
                let coordinates = "\(coordinate.latitude), \(coordinate.longitude)"
                addressParts.append(coordinates)
                
                self?.fullAddress = addressParts.joined(separator: ", ")
            } else {
                self?.fullAddress = "Address not found"
            }
        }
    }
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.suggestions = completer.results.map { $0.title + ", " + $0.subtitle }
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error fetching suggestions: \(error.localizedDescription)")
    }
}

struct LocationSelectView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSelectView(selectedAddress: .constant(""), currentTab: .constant(0))
    }
}
