//
//  HomeView.swift
//  SwiftBookApp
//
//  Created by Tasnim Haque on 3/20/26.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

//display the home page (search functionality)
struct HomeView: View {
    @StateObject var homeVM = HomeViewModel()
    @State var username: String = ""
    var body: some View {
        
            NavigationStack {
                ZStack {
                    Color("Background")
                        .ignoresSafeArea()
                
            VStack {
                VStack(spacing: 30) {
                    Text("Hello, \(homeVM.username)")
                        .font(.largeTitle)
                        .padding(15)
                    
                        .bold()
                        .background(Color("GreenButton"))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Enter book name", text: $homeVM.bookTitle)
                            .textFieldStyle(.plain)
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .overlay (
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .frame(alignment: .center)
                    
                    Button("Start search") {
                        homeVM.searchBook(searchItem: homeVM.bookTitle)
                    }
                }
                .onAppear {
                    homeVM.getUsername()
                }
                    List {
                        ForEach(homeVM.books, id: \.id) { book in
                            
                            NavigationLink(destination: BookInfoView(book: book)) {
                                
                                    HStack {
                                        //use Apple's documentation to asynchronously fetch the images from the book cover id
                                        //https://developer.apple.com/documentation/SwiftUI/AsyncImage
                                        if let thumbnail = book.volumeInfo.imageLinks?.thumbnail { //if the thumbnail field contains some data
                                            if(book.volumeInfo.imageLinks?.isAsset == true) { //if the asset field is set to true, that means the mock API data was loaded so we need to display the image from the loaded image in the Assets folder
                                                Image(thumbnail)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 90, height: 135)
                                            }
                                            else if let url = URL(string: thumbnail.replacingOccurrences(of: "http://", with: "https://")) { //if isAssets is false, that means that the API is currently working so we will asynchronously display the image from the API results
                                                AsyncImage(url: url) { image in
                                                    image.resizable()
                                                        .scaledToFit()
                                                        .frame(width: 90, height: 135)
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                }
                                            }
                                                                            
                                        VStack(alignment: .leading) {
                                            Text(book.volumeInfo.title ?? "Unknown Title")
                                            Text(book.volumeInfo.authors?.first ?? "Unknown Author")
                                        }
                                    }
                                
                            }
                        }
                    }
                }
            .scrollContentBackground(.hidden)
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
    }
}

#Preview {
    HomeView()
}
