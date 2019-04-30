//
//  LanguageData.swift
//  Slopac
//
//  Created by Jozef Varga on 22/12/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

import UIKit

class Language{
    //MARK: Properties
    var name: String
    var code: String
    
    //MARK: Initialization
    
    init?(name: String, code: String) {
        self.name = name
        self.code = code
    }
}
