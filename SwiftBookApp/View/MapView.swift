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
import FirebaseAuth
// location struct
struct Location: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

//display the map to locate bookstores
struct MapView : View {
    var lat: Double
    var lon: Double
    @StateObject var homeVM = HomeViewModel()
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
    
    // variable that stores the stores returned from MKLocalSearch
    // will be iterated and displayed in the list
    @State private var storeResults: [Bookstore] = []
    
    var body: some View {
        //ScrollView(.vertical, showsIndicators: true) {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
            VStack {
                LocationButton(.shareMyCurrentLocation) {
                    locationManager.requestUserLocation()
                }
                .frame(height: 20)
                .padding()
            }
                
                if let location = locationManager.userCurrentLocation {
                    VStack{
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
                    } .onAppear{loadUserLoction(latCoord: location.latitude, lonCoord: location.longitude)}
                        .ignoresSafeArea()
                        .frame(width: 360, height: 360)
                        List {
                            ForEach(storeResults, id: \.id) { storeResult in
                                HStack{
                                    VStack(alignment: .leading){
                                        // documentation on what MKMapItem contains https://developer.apple.com/documentation/mapkit/mkmapitem/identifier-swift.class
                                        Text(storeResult.store.name ?? "No Store Name Found")
                                        // display the address below
                                        Text(storeResult.address).font(.subheadline).foregroundColor(.gray)
                                    }
                                    Spacer()
                                    VStack (spacing: 5) {
                                        Text(String(format: "%.2f mi", storeResult.distanceInMi)).font(.subheadline).foregroundColor(.gray)
                                        Button {
                                            // if the store is already in their favorites, remove it
                                            // using store address as id
                                            if locationManager.userFavoriteStores.contains(where: {$0.id == storeResult.address}) {
                                                locationManager.removeFromFavoriteStores(myStore: storeResult, userId: Auth.auth().currentUser?.uid ?? "", address: storeResult.address)
                                            }
                                            else {
                                                print("Store added to favorites")
                                                locationManager.addToFavoriteStores(myStore: storeResult, userId: Auth.auth().currentUser?.uid ?? "", address: storeResult.address)
                                            }
                                        } label: {
                                            // modify the image conditionally between filled and unfilled based on
                                            // the if store is in favorites
                                            if locationManager.userFavoriteStores.contains(where: {$0.id == storeResult.address}) {
                                                Image(systemName: "heart.fill").font(.system(size: 25)).foregroundStyle(.red)
                                            }
                                            else {
                                                Image(systemName: "heart").font(.system(size: 25))
                                            }
                                        }
                                    }
                                }
                               
                            }
                        } .task {
                            await locationManager.fetchFavBookStores()
                        }.scrollContentBackground(.hidden)
                        .background(Color("Background"))

                 }
                }
                
            }
        }.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationStack {
                    NavigationLink(destination: ProfileView(homeVM: homeVM)){
                        Image(systemName: "person.crop.circle.fill").foregroundStyle(Color("GreenButton"))
                    }
                }
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
                // reset stores and markers
                storeResults.removeAll()
                storeMarkers.removeAll()
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
                    // keep the store results in the array
                    //https://stackoverflow.com/questions/48676292/using-mklocalsearch-completionhandler-correctly
                    for item in (response.mapItems) {
                        // how to calculate distance between user and the store using coordinates
                        //https://stackoverflow.com/questions/73735692/display-the-distance-between-two-coordinates-in-km-in-swiftui
                        let storeCoordinates = CLLocation(latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude)
                        let userCoordinates = CLLocation(latitude: initalCoords.latitude ?? 50, longitude: initalCoords.longitude ?? 30)
                        // divide the meters distance by 1609.344  to get miles
                        let distance = userCoordinates.distance(from: storeCoordinates) / 1609.344
                        // how to get address https://stackoverflow.com/questions/15890687/ios6-mapkit-mklocalsearch-how-to-get-address-of-a-mapitem
                        let streetAddr = item.placemark.thoroughfare ?? ""
                        let storeCity = item.placemark.locality ?? ""
                        let storeState = item.placemark.administrativeArea ?? ""
                        let address = "\(streetAddr) \(storeCity), \(storeState)"
                        // add the store object with distance to the array
                        storeResults.append(Bookstore(id: UUID(), store: item, address: address, distanceInMi: distance))
                    }
                }
            } label: {
                Image(systemName: "location.magnifyingglass")
                    .resizable()
                    .foregroundColor(Color("GreenButton"))
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

//#Preview {
//    MapView(lat: 0.0, lon: 0.0)
//}
