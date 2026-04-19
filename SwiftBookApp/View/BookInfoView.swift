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
    @StateObject private var profileVM = ProfileViewModel()
    @State private var description: String = ""
    @State var isCollapsed = true
    @State private var isBookFavorited: Bool = false
    @State private var isBookRead: Bool = false
    @State private var isEnabled = true
   
    var body: some View {
    ZStack {
            Color("Background")
                .ignoresSafeArea()
        
            ScrollView(.vertical, showsIndicators: true) {
                if let thumbnail = book.volumeInfo.imageLinks?.thumbnail {
                    if(book.volumeInfo.imageLinks?.isAsset == true) { //if the asset field is set to true, that means the mock API data was loaded so we need to display the image from the loaded image in the Assets folder
                        Image(thumbnail)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 230, height: 315)
                            .clipped()
                            .cornerRadius(8)
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
                        .frame(width: 230, height: 315)
                        .clipped()
                        .cornerRadius(8)
                        .padding(.bottom, 10)
                        .padding(.top, 10)
                        }
                    }
                // reference for how to create the star rating view from here https://medium.com/@jacob.rakidzich/a-precise-5-star-rating-with-swiftui-a859322d7e48
                let bookRating = book.volumeInfo.averageRating ?? 0.0
                if(bookRating  > 0.0){
                    FiveStarView(rating: bookRating)
                                  .frame(minWidth: 1, idealWidth: 90, maxWidth: 90, minHeight: 1, idealHeight: 25, maxHeight: 25, alignment: .center).padding(.bottom, 5)
                 }
                VStack(alignment: .leading, spacing: 10) {
                    Text("Title: ").bold().foregroundStyle(Color("GreenButton")).font(.system(size: 21)) + Text("\(book.volumeInfo.title ?? "Unknown Title")").font(.system(size: 19))
                    Text("Author: ").bold().foregroundStyle(Color("GreenButton")).font(.system(size: 21)) + Text("\(book.volumeInfo.authors?.first ?? "Unknown Author")").font(.system(size: 19))
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
                    // check if string is empty "" or nil https://stackoverflow.com/questions/29381994/check-string-for-nil-empty
                    let descriptionCheck = book.volumeInfo.description
                    (Text("Description: ").bold().foregroundStyle(Color("GreenButton")).font(.system(size: 21)) + Text("\((descriptionCheck ?? "").isEmpty ? "No description available." : descriptionCheck!)").font(.system(size: 19))).truncateText(length: 9, isEnabled: isEnabled, animation: .smooth(duration: 0.5, extraBounce: 0)).onTapGesture {
                        isEnabled.toggle()
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }.padding(.horizontal, 20).navigationTitle("Book Information")
                
            }
    }.task {
        // fetch the data when the content view loads
        await profileVM.fetchFavBookData()
        await profileVM.fetchReadBookData()
    }
    .toolbar {
        // use toolbaritemgroup with spacing to format https://www.hackingwithswift.com/forums/swiftui/spacing-toolbar-elements/7285
          ToolbarItemGroup(placement: .bottomBar) {
              Button {
                  // if the book is already in their favorites, remove it
                  if profileVM.favoriteBooks.contains(where: {$0.id == book.id}) {
                      bookInfoVM.removeFromFavorites(currentBook: book, userId: Auth.auth().currentUser?.uid ?? "")
                  }
                  else {
                      bookInfoVM.addToFavorites(book: book, userId: Auth.auth().currentUser?.uid ?? "")
                  }
              } label: {
                  // modify the image conditionally between filled and unfilled based on
                  // the if book is in favorites
                  if profileVM.favoriteBooks.contains(where: {$0.id == book.id}) {
                      Image(systemName: "heart.fill").foregroundStyle(.red)
                  }
                  else {
                      Image(systemName: "heart")
                  }
              }
              Button {
                  if profileVM.readBooks.contains(where: {$0.id == book.id}) {
                      // remove from read books
                      bookInfoVM.removeFromRead(currentBook: book, userId: Auth.auth().currentUser?.uid ?? "")
                  }
                  else {
                      bookInfoVM.markAsRead(book: book, userId: Auth.auth().currentUser?.uid ?? "")
                  }
              } label: {
                  if profileVM.readBooks.contains(where: {$0.id == book.id}) {
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
// how to turn decimal values into a star rating
// the source code reference for this method is from this website tutorial https://medium.com/@jacob.rakidzich/a-precise-5-star-rating-with-swiftui-a859322d7e48
// and github https://github.com/JZDesign/FiveStarRating_SwiftUI/blob/master/Sources/FiveStarRating/FiveStarRating.swift
public struct FiveStarView: View {
    // change decimal to double since google books stores ratings as such
    var rating: Double
    var color: Color
    var backgroundColor: Color


    public init(
        rating: Double,
        // set color to green asset color
        color: Color = Color("GreenButton"),
        backgroundColor: Color = .gray
    ) {
        self.rating = rating
        self.color = color
        self.backgroundColor = backgroundColor
    }


    public var body: some View {
        ZStack {
            BackgroundStars(backgroundColor)
            ForegroundStars(rating: rating, color: color)
        }
    }
}

struct RatingStar: View {
    var rating: CGFloat
    var color: Color
    var index: Int
    
    
    var maskRatio: CGFloat {
        let mask = rating - CGFloat(index)
        
        switch mask {
        case 1...: return 1
        case ..<0: return 0
        default: return mask
        }
    }


    init(rating: Double, color: Color, index: Int) {
        
        self.rating = CGFloat(Double(rating.description) ?? 0)
        self.color = color
        self.index = index
    }


    var body: some View {
        GeometryReader { star in
            StarImage()
                .foregroundColor(self.color)
                .mask(
                    Rectangle()
                        .size(
                            width: star.size.width * self.maskRatio,
                            height: star.size.height
                        )
                    
                )
        }
    }
}

private struct StarImage: View {


    var body: some View {
        Image(systemName: "star.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
        
    }
}

private struct BackgroundStars: View {
    var color: Color


    init(_ color: Color) {
        self.color = color
    }


    var body: some View {
        HStack {
            ForEach(0..<5) { _ in
                StarImage()
            }
        }.foregroundColor(color)
    }
}


private struct ForegroundStars: View {
    var rating: Double
    var color: Color


    init(rating: Double, color: Color) {
        self.rating = rating
        self.color = color
    }


    var body: some View {
        HStack {
            ForEach(0..<5) { index in
                RatingStar(
                    rating: self.rating,
                    color: self.color,
                    index: index
                )
            }
        }
    }
}

//display the book info page
//#Preview {
//    BookInfoView(book: Book(volumeInfo: VolumeInfo(title: "hello", authors: ["hello"], description: "Hello", imageLinks: ImageLinks(thumbnail: "hi"))))
//}
