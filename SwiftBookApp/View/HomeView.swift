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
            List(homeVM.books) { book in
                        VStack(alignment: .leading) {
                            HStack {
                                let coverId = book.cover_i ?? 0
                                let URL = URL(string: "https://covers.openlibrary.org/b/id/\(coverId)-S.jpg")
                                
                                //use Apple's documentation to asynchronously fetch the images from the book cover id
                                //https://developer.apple.com/documentation/SwiftUI/AsyncImage
                                AsyncImage(url: URL) { image in
                                    image.resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                VStack {
                                    Text(book.title ?? "Unknown Title")
                                    Text(book.author_name?.first ?? "Unknown Author")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
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
