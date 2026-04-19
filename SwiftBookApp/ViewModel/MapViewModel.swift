//
//  MapViewModel.swift
//  BookProject
//
//  Created by Tasnim Haque on 3/19/26.
//

import Foundation
import Combine
import CoreLocation
import CoreLocationUI
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Firebase
import MapKit
// must make mapviewmodel of type NSObject and CLLocationManagerDelegate on top of being an
// ObservableObject since it uses the CCLocationManager class (inhertied from NSObject and reports to CLLocationManagerDelegate)
// https://developer.apple.com/documentation/corelocation/cllocationmanager
class MapViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    // location manager must be used in order to call the requestlocation() method
    // source is the location manager class from https://www.hackingwithswift.com/quick-start/swiftui/how-to-read-the-users-location-using-locationbutton
    let manager = CLLocationManager()
    // published var that stores the users current location
    @Published var userCurrentLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    // published var that stores the users favorite stores
    @Published var userFavoriteStores: [Bookstore] = []
   
    // the function that requests the location from the user upon pressing the share location button
    func requestUserLocation() {
        // also the soltuion stated to to set the delegate to self
        // directly in the function before calling request location
        manager.delegate = self
        manager.requestLocation()
    }
    // function that returns the coordinates of the user's current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userCurrentLocation = locations.first?.coordinate
    }
    // getting an error that locationManager must respond to didFailWithError
    // the reccomended solution is to add this event handler below to account for any errors in requesting location
    // source https://stackoverflow.com/questions/40345170/delegate-must-respond-to-locationmanagerdidupdatelocations-swift-eroor
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get users location.")
        // if failed, set to default location of tempe
        userCurrentLocation = CLLocationCoordinate2D(latitude: 33.4255, longitude: -111.9400)
    }
    
    // function to check if the user has already authorized location services, if yes then immediately load and do not ask for permission
    // source https://developer.apple.com/documentation/corelocation/requesting-authorization-to-use-location-services
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        // location services are available
        case .authorizedWhenInUse:
            requestUserLocation()
            break
        // location services are restricted
        case .restricted, .denied:
            // set to the default value
            userCurrentLocation = CLLocationCoordinate2D(latitude: 33.4255, longitude: -111.9400)
            break
        // location services have not been enabled yet
        case .notDetermined:
           manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
    // function for adding the favorite store to the database
    func addToFavoriteStores(myStore: Bookstore, userId: String) {
        let db = Firestore.firestore()
        let addrandStore = "\(myStore.storeName)\(myStore.id)"
        let data: [String: Any] = [
            // using address as indentifier
            "id": myStore.id,
            "storeName": myStore.storeName,
            "storeDistance": myStore.storeDistance,
            "storePhoneNumber": myStore.storePhone
        ]
       
        db.collection("users").document(userId).collection("favoriteStores").document(addrandStore).setData(data)
    }
    
    func removeFromFavoriteStores(myStore: Bookstore, userId: String) {
        let db = Firestore.firestore()
        let addrandStore = "\(myStore.storeName)\(myStore.id)"
        // function to delete a document in firestore https://www.hackingwithswift.com/forums/swiftui/firestore-delete/8831
        let docRef = db.collection("users").document(userId).collection("favoriteStores").document(addrandStore)
        docRef.delete() { (error) in
            if let error = error {
                print("error removing store \(error)")
            } else {
                print("store successfully removed from favorites")
            }
        }
    }

    func fetchFavBookStores() async {
       let db = Firestore.firestore()
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "").collection("favoriteStores").addSnapshotListener { (querySnapshot, error) in
         guard let documents = querySnapshot?.documents else {
           print("No documents")
           return
         }
    
         self.userFavoriteStores = documents.map { queryDocumentSnapshot -> Bookstore in
           let data = queryDocumentSnapshot.data()
           let id = data["id"] as? String ?? ""
           let storeDistance = data["storeDistance"] as? Double ?? 0.0
           let storeName = data["storeName"] as? String ?? ""
           let storePhoneNumber = data["storePhoneNumber"] as? String ?? ""
    
           return Bookstore(id: id, storeDistance: storeDistance, storeName: storeName, storePhone: storePhoneNumber)
         }
       }
     }
}
