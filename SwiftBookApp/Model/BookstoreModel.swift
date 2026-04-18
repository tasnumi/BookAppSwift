//
//  BookstoreModel.swift
//  BookProject
//
//  Created by Tasnim Haque on 3/19/26.
//
import Foundation
import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI
// this file will store information related to the bookstore that we retrieve from the map
// MKLocalSearch returns an array of type MKMapItem
// source https://nshipster.com/mklocalsearch/
// this will be what we use to load and display the store results
struct Bookstore: Identifiable {
    let id: UUID
    let store: MKMapItem
    let address: String
    let distanceInMi: Double
}
// this is what gets saved in the database, we will compare the storeIndentifier to currently loaded ones to mark the heart
// button as filled or unfilled and allow users to either remove or add stores from their favorites in the database
struct favBookStores: Identifiable {
    let id: String
    let storeDistance: Double
    let storeName: String
}
