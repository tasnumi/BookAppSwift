//
//  BookModel.swift
//  BookProject
//
//  Created by Tasnim Haque on 3/19/26.
//

import Foundation
import SwiftUI

//google books api docs:
//https://developers.google.com/books/docs/v1/using
//resource for creating model: https://youtu.be/XvOgTmG86FE?si=_WE-oXI28JQIlHIJ

struct GoogleBooksResponse: Decodable {
    let items: [Book]? //when searching for books, this struct will store the response which is of type Book
}

struct Book: Decodable, Identifiable { //type Book will store the book's id which will either be the book's title if it exists, or a unique UUID string. It will also store the book's information of type VolumeInfo
    var id: String { //3 different ID's: volume ID, bookshelf ID, userID
            volumeInfo.title ?? UUID().uuidString
        }
    let volumeInfo: VolumeInfo //VolumeInfo contains information about each book
}

struct VolumeInfo: Decodable { //type VolumeInfo stores all of the book information as according to the docs. We are interested in receiving the title, authors, description, and type ImageLinks which contains the cover of the books
    let title: String? //contains book title
    let authors: [String]? //contains authuors in string array
    let description: String? //contains description
    let imageLinks: ImageLinks? //contains book covers or imageLinks
}

struct ImageLinks: Decodable { //type ImageLink has a thumbnail which gets returned from the API. the API returns this in a HTTP link, we will need to later convert this to HTTPS to use AsyncImage to load this image into the application
    let thumbnail: String? //imageLink contains thumbnail of each book
}
