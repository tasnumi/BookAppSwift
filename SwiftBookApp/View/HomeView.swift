//
//  HomeView.swift
//  SwiftBookApp
//
//  Created by Tasnim Haque on 3/20/26.
//

import Foundation
import SwiftUI

//display the home page (search functionality)
struct HomeView: View {
    @StateObject var homeVM = HomeViewModel()
    var body: some View {
        NavigationStack {
        VStack {
            VStack {
                Text("Home Page")
                    .font(.largeTitle)
                    .bold()
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.blue)
                    TextField("Enter book name", text: $homeVM.bookTitle)
                        .textFieldStyle(.plain)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Button("Start search") {
                    homeVM.searchBook(searchItem: homeVM.bookTitle)
                }
            }
                List {
                    ForEach(homeVM.books, id: \.id) { book in
                        
                        NavigationLink(destination: BookInfoView(book: book)) {
                            HStack() {
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
                
            }
        }
    }
}

#Preview {
    HomeView()
}
