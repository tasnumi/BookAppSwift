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
                                        if let thumbnail = book.volumeInfo.imageLinks?.thumbnail, let URL = URL(string: thumbnail.replacingOccurrences(of: "http://", with: "https://")) { //the API returns books in HTTP but AsyncImage works with HTTPS so we need to convert the HTTP image to HTTPS with replacingOccurrences
                                            
                                            AsyncImage(url: URL) { image in
                                                image.resizable()
                                                    .scaledToFit()
                                            } placeholder: {
                                                ProgressView()
                                            }

                                        }
                                                                            
                                        VStack {
                                            Text(book.volumeInfo.title ?? "Unknown Title")
                                            Text(book.volumeInfo.authors?.first ?? "Unknown Author")
                                        }
                                    }
                                
                            }
                        }
                    }
                }
            .scrollContentBackground(.hidden)
            }
        }
    }
}

#Preview {
    HomeView()
}
