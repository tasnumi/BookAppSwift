//
//  BookInfoView.swift
//  SwiftBookApp
//
//  Created by Tasnim Haque on 3/20/26.
//

import Foundation
import SwiftUI
import FirebaseAuth
import SwiftUI

struct BookInfoView: View {
    @State var book: Book
    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var bookInfoVM = BookDetailViewModel()
    
    @State private var description: String = ""
    @State var isCollapsed = true
    @State private var isBookFavorited: Bool = false
    @State private var isBookRead: Bool = false
    @State private var isEnabled = true
   
    var body: some View {
    ZStack {
            Color("Background")
                .ignoresSafeArea()

            let thumbnail = book.volumeInfo.imageLinks?.thumbnail
           
            let URL = URL(string: thumbnail?.replacingOccurrences(of: "http://", with: "https://") ?? "")
        
            ScrollView(.vertical, showsIndicators: true) {
                AsyncImage(url: URL) { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 230, height: 315)
                .clipped()
                .cornerRadius(8)
                .padding(.bottom, 10)
                .padding(.top, 30)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Title: \(book.volumeInfo.title ?? "Unknown Title")").font(.system(size: 19))
                    Text("Author: \(book.volumeInfo.authors?.first ?? "Unknown Author")").font(.system(size: 19))
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
                    // check if string is empty "" or nil https://stackoverflow.com/questions/29381994/check-string-for-nil-empty
                    let descriptionCheck = book.volumeInfo.description
                    Text("Description: \((descriptionCheck ?? "").isEmpty ? "No description available." : descriptionCheck!)").font(.system(size: 19)).truncateText(length: 5, isEnabled: isEnabled, animation: .smooth(duration: 0.5, extraBounce: 0)).onTapGesture {
                        isEnabled.toggle()
                    }.frame(maxWidth: .infinity, alignment: .leading)
//                    Text("Description: \(book.volumeInfo.description ?? "No description available.")").font(.system(size: 19)).truncateText(length: 5, isEnabled: isEnabled, animation: .smooth(duration: 0.5, extraBounce: 0)).onTapGesture {
//                        isEnabled.toggle()
//                    }.frame(maxWidth: .infinity, alignment: .leading)
                }.padding(.horizontal, 20) .navigationTitle("Book Information")
                
            }
    }.onAppear{
        bookInfoVM.isInFavorites(currentBook: book, userId:  Auth.auth().currentUser?.uid ?? "")
        bookInfoVM.isInRead(currentBook: book, userId:  Auth.auth().currentUser?.uid ?? "")
    }
    .toolbar {
        // use toolbaritemgroup with spacing to format https://www.hackingwithswift.com/forums/swiftui/spacing-toolbar-elements/7285
          ToolbarItemGroup(placement: .bottomBar) {
              Button {
                  // if the book is already in their favorites, remove it
                  if(bookInfoVM.isInFav) {
                      print("book removed from favorites")
                      // remove from favorites
                      bookInfoVM.removeFromFavorites(currentBook: book, userId: Auth.auth().currentUser?.uid ?? "")
                  }
                  else {
                      print("book saved to favorites")
                      bookInfoVM.addToFavorites(book: book, userId: Auth.auth().currentUser?.uid ?? "")
                  }
              } label: {
                  // modify the image conditionally between filled and unfilled based on
                  // the if book is in favorites
                  if(bookInfoVM.isInFav) {
                      Image(systemName: "heart.fill").foregroundStyle(.red)
                  }
                  else {
                      Image(systemName: "heart")
                  }
              }
              Button {
                  if(bookInfoVM.isInRead) {
                      print("book removed from read")
                      // remove from read books
                      bookInfoVM.removeFromRead(currentBook: book, userId: Auth.auth().currentUser?.uid ?? "")
                  }
                  else {
                      print("book marked as read")
                      bookInfoVM.markAsRead(book: book, userId: Auth.auth().currentUser?.uid ?? "")
                  }
              } label: {
                  if(bookInfoVM.isInRead) {
                      Image(systemName: "bookmark.fill")
                  }
                  else {
                      Image(systemName: "bookmark")
                  }
              }
              Spacer()
          }
      }
    }
    
   
}
// following this tutorial https://www.youtube.com/watch?v=gFn6LgDPx5g
// on how to make an extention that will enable and animate text truncation for long book descriptions
// this function trucateText is called on the description text, users have the choice to expand it by clicking the text to toggle
extension Text {
    @ViewBuilder
    func truncateText(length: Int, isEnabled: Bool, animation: Animation) -> some View {
        self
            .modifier(TruncateTextViewModifier(length: length, isEnabled: isEnabled, animation: animation))
    }
}
struct TruncateTextViewModifier: ViewModifier {
    var length: Int
    var isEnabled: Bool
    var animation: Animation
    @State private var limitedSize: CGSize = .zero
    @State private var fullSize: CGSize = .zero
    @State private var animatedProgress: CGFloat = 0
    func body(content: Content) -> some View {
        content
            .lineLimit(length)
            .opacity(0)
            .fixedSize(horizontal: false, vertical: true)
            .onGeometryChange(for: CGSize.self) {
                $0.size
            } action: {newSize in
                limitedSize = newSize
            }
            .frame(height: isExpanded ? fullSize.height: nil)
            .overlay {
                GeometryReader {
                    let contentSize = $0.size
                    
                    content
                        . fixedSize(horizontal: false, vertical: true)
                        .onGeometryChange(for: CGSize.self) {
                            $0.size
                        } action: {newSize in
                            fullSize = newSize
                        }
                        .frame(maxWidth: contentSize.width, maxHeight: contentSize.height, alignment: isExpanded ? .center : .top)
                }
                
            }
            .clipped()
            .onChange(of: isEnabled) { oldVal, newVal in
                withAnimation(animation) {
                    animatedProgress = !newVal ? 1 : 0
                }
                
            }.onAppear {
                animatedProgress = !isEnabled ? 1 : 0
            }
    }
    var isExpanded: Bool {
        animatedProgress == 1
    }
    
}

//display the book info page
//#Preview {
//    BookInfoView(book: Book(volumeInfo: VolumeInfo(title: "hello", authors: ["hello"], description: "Hello", imageLinks: ImageLinks(thumbnail: "hi"))))
//}
