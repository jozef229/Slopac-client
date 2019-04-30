//
//  BookData.swift
//  Slopac
//
//  Created by Jozef Varga on 10/11/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

import UIKit

class Book{
    //MARK: Properties
    var image: UIImage?
    var bookId: String
    var title: String
    var author: String
    var publishYear: String
    var totalResult: String
    var description: String
    var language: String
    var isbn: String
    var edition: String
    var publisher: String
    var publicationPlace: String
    var library_name: String
    var library_id: Int
    var tags: Int16
    

    //MARK: Initialization

    init?(image: UIImage?, bookId: String, title: String, author: String, publishYear: String, totalResult: String, description: String, language: String, isbn: String, edition: String, publisher: String, publicationPlace: String, library_name: String, library_id: Int, tags: Int16) {
        self.image = image
        self.bookId = bookId
        self.title = title
        self.author = author
        self.publishYear = publishYear
        self.totalResult = totalResult
        self.description = description
        self.language = language
        self.isbn = isbn
        self.edition = edition
        self.publisher = publisher
        self.publicationPlace = publicationPlace
        self.library_name = library_name
        self.library_id = library_id
        self.tags = tags
    }
}
