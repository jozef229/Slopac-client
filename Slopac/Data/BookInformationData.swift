//
//  BookInformationData.swift
//  Slopac
//
//  Created by Jozef Varga on 02/03/2019.
//  Copyright © 2019 Jozef Varga. All rights reserved.
//

import UIKit

class BookInformation{
    //MARK: Properties
    var address: String
    var city: String
    var postal_code: String
    var latitude: Double
    var longtitude: Double
    var location_name: String
    var sublocation_name: String
    var available_books: Int
    var lent_books: Int
    var presence_books: Int
    

    //MARK: Initialization

    init?(address: String, city: String, postal_code: String, latitude: Double, longtitude: Double, location_name: String, sublocation_name: String, available_books: Int, lent_books: Int, presence_books: Int) {
        self.address = address
        self.city = city
        self.postal_code = postal_code
        self.latitude = latitude
        self.longtitude = longtitude
        self.location_name = location_name
        self.sublocation_name = sublocation_name
        self.available_books = available_books
        self.lent_books = lent_books
        self.presence_books = presence_books
    }
}

