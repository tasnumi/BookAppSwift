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
    let id: String
    let storeAddress: String
    let storeDistance: Double
    let storeName: String
    let storePhone: String
}
