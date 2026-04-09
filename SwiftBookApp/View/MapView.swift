//
//  MapView.swift
//  SwiftBookApp
//
//  Created by Tasnim Haque on 3/21/26.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI
// location struct
struct Location: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

//display the map to locate bookstores
struct MapView : View {
    var lat: Double
    var lon: Double
    // this view is where we will request the user's current location and display store search results
    // near them
    // source is the content view from https://www.hackingwithswift.com/quick-start/swiftui/how-to-read-the-users-location-using-locationbutton
    // private state object that calls the mapviewmodel
    @StateObject private var locationManager = MapViewModel()
    // initial variable for mapview start position
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 33.4255,
            longitude: -111.9400
        ),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    @State private var storeMarkers = [
        Location(coordinate: CLLocationCoordinate2D(latitude: 33.4255, longitude: -111.9400))
    ]
    
    @State private var searchText = ""

    @State var initalCoords = CLLocationCoordinate2D(latitude: 33.4255, longitude: -111.9400)
    
    var body: some View {
        
            VStack {
                LocationButton(.shareMyCurrentLocation) {
                    locationManager.requestUserLocation()
                }
                .frame(height: 44)
                .padding()
                
                if let location = locationManager.userCurrentLocation {
                    Text("Your location: \(location.latitude), \(location.longitude)")
                    searchBar
                    // if they accept location services, then load the map of their location here along with a search bar for stores
                    ZStack(alignment: .bottom) {
                        // can show the user's location
                        // continously by setting the showsUserLocation to true
                        //https://www.hackingwithswift.com/quick-start/swiftui/how-to-show-a-map-view
                        Map(coordinateRegion: $region,
                            interactionModes: .all,
                            showsUserLocation: true,
                            annotationItems: storeMarkers,
                            // use mappins https://codewithchris.com/swiftui-map-annotation/
                            annotationContent: { location in
                                 MapPin(coordinate: location.coordinate, tint: .red)
                               })
//                        ){ location in
//                            //MapMarker(coordinate: location.coordinate)
//                            // how to add text to markers
//                            //https://stackoverflow.com/questions/62543034/swiftui-map-display-annotations
//                            MapAnnotation(coordinate: location.coordinate){
//                                VStack {
//                                    Circle()
//                                        .strokeBorder(.red, lineWidth: 2)
//                                        .frame(width:20, height: 20)
//                                }
//                             }
//                        }
                    } .onAppear{loadUserLoction(latCoord: location.latitude, lonCoord: location.longitude)}
                    // tested with name + loc but it was not proving as accurate as passing just the name into GLGeocoder
                    .ignoresSafeArea()
                    .frame(width: 380, height: 415)
                }
                   
            }
        }
    // function that loads the user's location on the map once they allow sharing
    func loadUserLoction(latCoord: Double, lonCoord: Double)
    {
        // instead of using the function in the example code to search by name, i will just set the coordinates equal to the ones i passed in to ensure accuracy to the geonames json coordinates returned
        let coords = CLLocationCoordinate2D(
            latitude: latCoord,
            longitude: lonCoord
        )
        print(coords.latitude)
        print(coords.longitude)
        
        DispatchQueue.main.async
            {
                initalCoords = coords
                region.center = coords
            }
    }
    private var searchBar: some View {
        HStack {
            Button {
                let searchRequest = MKLocalSearch.Request()
                searchRequest.naturalLanguageQuery = searchText
                searchRequest.region = region
                
                MKLocalSearch(request: searchRequest).start { response, error in
                    guard let response = response else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error").")
                        return
                    }
                    region = response.boundingRegion
                    // update the store markers array with the stores returned in search
                    storeMarkers = response.mapItems.map { item in
                        Location(
                            coordinate: item.placemark.coordinate
                        )
                    }
                }
            } label: {
                Image(systemName: "location.magnifyingglass")
                    .resizable()
                    .foregroundColor(.brown)
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 12)
            }
            TextField("Search e.g. Barnes&Noble", text: $searchText)
                .foregroundColor(.black)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
                .border(Color.gray)
        }
        .padding()
    }
}

#Preview {
    MapView(lat: 0.0, lon: 0.0)
}
