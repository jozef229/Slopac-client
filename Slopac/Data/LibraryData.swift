//
//  LibraryData.swift
//  Slopac
//
//  Created by Jozef Varga on 15/12/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

import UIKit

class Library{
    //MARK: Properties
    var id: Int32
    var address_id: Int32
    var library_name: String

    //MARK: Initialization

    init?(id: Int32, address_id: Int32, library_name: String) {
        self.id = id
        self.address_id = address_id
        self.library_name = library_name
    }
}
