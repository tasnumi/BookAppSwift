//
//  BookInfoView.swift
//  SwiftBookApp
//
//  Created by Tasnim Haque on 3/20/26.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct BookInfoView: View {
    @State var book: Book
    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var bookInfoVM = BookDetailViewModel()
    
    @State private var description: String = ""
    var body: some View {
        
        VStack {
            HStack(alignment: .top, spacing: 12){
                let thumbnail = book.volumeInfo.imageLinks?.thumbnail
                
                let URL = URL(string: thumbnail?.replacingOccurrences(of: "http://", with: "https://") ?? "")
                AsyncImage(url: URL) { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 140, height: 200)
                .clipped()
                .cornerRadius(8)
                VStack(alignment: .leading, spacing: 6) {
                    Text(book.volumeInfo.title ?? "Unknown Title")
                    Text(book.volumeInfo.authors?.first ?? "Unknown Author")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Text(book.volumeInfo.description ?? "No description available.")
            Button("Add to Favorites") {
                //https://firebase.google.com/docs/auth/web/manage-users
                //get the currently logged in user using Firebase Auth documentation
                bookInfoVM.addToFavorites(book: book, userId: Auth.auth().currentUser?.uid ?? "")
            }
        }
        
    }
}

//display the book info page
#Preview {
    BookInfoView(book: Book(volumeInfo: VolumeInfo(title: "hello", authors: ["hello"], description: "Hello", imageLinks: ImageLinks(thumbnail: "hi"))))
}
