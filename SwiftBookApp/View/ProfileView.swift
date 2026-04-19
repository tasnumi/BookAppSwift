//
//  ProfileView.swift
//  SwiftBookApp
//
//  Created by Tasnim Haque on 3/20/26.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

//display the user's profile page
struct ProfileView: View {
    //@State var book: Book
    @StateObject var homeVM = HomeViewModel()
    @StateObject var profileVM = ProfileViewModel()

    @State var username: String = ""

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack(spacing: 30) {
                Text("\(homeVM.username)")
                    .font(.largeTitle)
                    .padding(15)
                
                    .bold()
                    .background(Color("GreenButton"))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                // how to get the user's account creation date from firebase https://stackoverflow.com/questions/38174178/get-created-date-and-last-login-date-from-firuser-with-firebase-3
                let joinDate = Auth.auth().currentUser?.metadata.creationDate
                // format date and dont include the time of the creation https://developer.apple.com/documentation/foundation/date/formatstyle
                Text("Join Date : \(joinDate?.formatted(date: .long, time: .omitted) ?? "N/A")").bold().foregroundStyle(Color("GreenButton")).font(.system(size: 21))
                VStack {
                    Text("Favorite Books").bold().foregroundStyle(Color("GreenButton")).font(.system(size: 21))
                    // horizontal scroll view in swift https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-horizontal-and-vertical-scrolling-using-scrollview
                    HStack {
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 20) {
                            if(profileVM.favoriteBooks.count == 0 ){
                                Spacer()
                                Text("No Favorite Books Yet").padding(18).frame(height: 160).multilineTextAlignment(.center).font(.system(size: 19)).padding(.horizontal, 22)
                                Spacer()
                            }
                            else {
                                ForEach(profileVM.favoriteBooks) { item in
                                    // make the images navigation links
                                    NavigationStack {
                                        NavigationLink(destination: BookInfoView(book: item)) {
                                            if let thumbnail = item.volumeInfo.imageLinks?.thumbnail {
                                                if(item.volumeInfo.imageLinks?.isAsset == true) { //if the asset field is set to true, that means the mock API data was loaded so we need to display the image from the loaded image in the Assets folder
                                                    Image(thumbnail)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 120, height: 160)
                                                        .clipped()
                                                        .cornerRadius(13)
                                                        .padding(.bottom, 10)
                                                        .padding(.top, 10)
                                                }
                                                else if let url = URL(string: thumbnail.replacingOccurrences(of: "http://", with: "https://")) { //if isAssets is false, that means that the API is currently working so we will asynchronously display the image from the API results
                                                    AsyncImage(url: url) { image in
                                                        image.resizable()
                                                            .scaledToFill()
                                                    } placeholder: {
                                                        ProgressView()
                                                    }
                                                    .frame(width: 120, height: 160)
                                                    .clipped()
                                                    .cornerRadius(13)
                                                    .padding(.bottom, 10)
                                                    .padding(.top, 10)
                                                    }
                                                }
                                        }
                                    }
                                }.padding(18)
                            }
                        }.padding(.horizontal, 10)
                    }
                    }.padding(.horizontal, 8).background(Color("GreyAccentColor")).cornerRadius(16).padding(.bottom, 15)
                    Text("Books Read: \(profileVM.readBooks.count)").bold().foregroundStyle(Color("GreenButton")).font(.system(size: 21))
                    HStack {
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 20) {
                            if(profileVM.readBooks.count == 0 ){
                                Spacer()
                                    Text("No Books Read Yet").padding(18).frame(height: 160).multilineTextAlignment(.center).font(.system(size: 19)).padding(.horizontal, 36)
                                Spacer()
                            }
                            else {
                                ForEach(profileVM.readBooks) { item in
                                    NavigationStack {
                                        NavigationLink(destination: BookInfoView(book: item)) {
                                            if let thumbnail = item.volumeInfo.imageLinks?.thumbnail {
                                                if(item.volumeInfo.imageLinks?.isAsset == true) { //if the asset field is set to true, that means the mock API data was loaded so we need to display the image from the loaded image in the Assets folder
                                                    Image(thumbnail)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 120, height: 160)
                                                        .clipped()
                                                        .cornerRadius(13)
                                                        .padding(.bottom, 10)
                                                        .padding(.top, 10)
                                                }
                                                else if let url = URL(string: thumbnail.replacingOccurrences(of: "http://", with: "https://")) { //if isAssets is false, that means that the API is currently working so we will asynchronously display the image from the API results
                                                    AsyncImage(url: url) { image in
                                                        image.resizable()
                                                            .scaledToFill()
                                                    } placeholder: {
                                                        ProgressView()
                                                    }
                                                    .frame(width: 120, height: 160)
                                                    .clipped()
                                                    .cornerRadius(13)
                                                    .padding(.bottom, 10)
                                                    .padding(.top, 10)
                                                    }
                                                }
                                        }
                                    }
                                    
                                }.padding(18)
                            }
                        }.padding(.horizontal, 10)
                    }
                    }.padding(.horizontal, 8).background(Color("GreyAccentColor")).cornerRadius(16).padding(.bottom, 15)
                }.padding(.horizontal, 20)
                
            }
        }.toolbar{
            ToolbarItem(placement: .bottomBar) {
                NavigationStack {
                    NavigationLink(destination: MapView(lat: 0.0, lon: 0.0)){
                    Image(systemName: "map.fill").foregroundStyle(Color("GreenButton"))
                    }
                }
            }
        }.task {
            // fetch the data when the content view loads
            await profileVM.fetchFavBookData()
            await profileVM.fetchReadBookData()
            homeVM.getUsername()
        }
    }
}
