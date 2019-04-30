//
//  Constants.swift
//  Slopac
//
//  Created by Jozef Varga on 20/12/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

import UIKit

let URL_BASIC = "http://127.0.0.1:8000"

// MARK: - Variables
let TABLE_LANGUAGE_HEIGHT = 4 * 44
var LIBRARYID = [Int]()
var LIBRARY_ID_SELECT_FOR_SEARCH = 0
var LIBRARY_NAME_SELECT_FOR_SEARCH = ""
var CHANGE_FAVORITE_BOOK = false
let TYPE_LIBRARY = 1
let TYPE_CITY = 2
let PARAMETER_NOTHING = ""

// MARK: - URL

//let URL_BASIC = "http://147.175.160.255:8000"
let URL_LOGIN_USER = URL_BASIC + "/login_user"
let URL_CREATE_USER = URL_BASIC + "/create_user"
let URL_VERSIONS = URL_BASIC + "/versions"
let URL_VERSIONS_USER = URL_BASIC + "/versionsAndUser"
let URL_VERSIONS_DATA = URL_BASIC + "/versionsData"
let URL_VERSIONS_USER_DATA = URL_BASIC + "/versionsDataAndUser"
let URL_LIBRARY_CARD_DELETE = URL_BASIC + "/deleteLibraryCard"
let URL_BOOK_DELETE = URL_BASIC + "/deleteBook"
let URL_UPDATE_FILE = URL_BASIC + "/uploadFile"
let URL_UPDATE_FILE_WITH_PICTURE = URL_BASIC + "/uploadFileWithPicture"
let URL_SEARCH_BOOKS_FROM_LIBRARY = URL_BASIC + "/searchBooks"
let URL_AVAILABILITY_BOOK = URL_BASIC + "/availabilityBook"
let URL_PICTURE_BOOK = URL_BASIC + "/picture/"

// MARK: - ObalkyKnyh.cz
let COMPONENTS_SCHEME = "http"
let COMPONENTS_HOST = "cache.obalkyknih.cz"
let COMPONENTS_PATH = "/api/cover"
let ENCSIGLA_CODE = "FK6mC5rMzzchOxseTwNi3A"

// MARK: - SearchBook
let COUNT_LOAD_BOOKS = "20"
let COMPRESSION_QUALITY = CGFloat(0.50)

// MARK: - Database variables
let OK_DATABASE = 0
let WITHOUT_SAVE_DATABASE = 1
let WITHOUT_UPDATE_DATABASE = 2
let WITHOUT_SAVE_WITH_PICTURE_DATABASE = 3
let WITHOUT_UPDATE_WITH_PICTURE_DATABASE = 4
let DELTETE = 5

// MARK: - Color
let COLOR_THEME = UIColor(displayP3Red: 50/255, green: 45/255, blue: 55/255, alpha: 1)
let COLOR_THEME_DARK = UIColor(displayP3Red: 34/255, green: 29/255, blue: 39/255, alpha: 1)
let COLOR_THEME_GREY = UIColor(displayP3Red: 109/255, green: 105/255, blue: 114/255, alpha: 1)
let COLOR_THEME_WHITE = UIColor(displayP3Red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
let BLUE = UIColor(displayP3Red: 45/255, green: 123/255, blue: 246/255, alpha: 1)
let GREY = UIColor(displayP3Red: 37/255, green: 36/255, blue: 35/255, alpha: 1)
let RED = UIColor(displayP3Red: 212/255, green: 0/255, blue: 0/255, alpha: 1)
let ORANGE = UIColor(displayP3Red: 200/255, green: 120/255, blue: 0/255, alpha: 1)
let GREEN = UIColor(displayP3Red: 128/255, green: 140/255, blue: 0/255, alpha: 1)

// MARK: - Language
var LANGUAGES = [Language]()

func addLanguages(){
    LANGUAGES.removeAll()
    guard let language1 = Language(
        name: "english".localized,
        code: "en"
        )else {fatalError("Unable to instantiate language")}
    guard let language2 = Language(
        name: "slovak".localized,
        code: "sk"
        )else {fatalError("Unable to instantiate language")}
    guard let language3 = Language(
        name: "german".localized,
        code: "de"
        )else {fatalError("Unable to instantiate language")}
    guard let language4 = Language(
        name: "czech".localized,
        code: "cs"
        )else {fatalError("Unable to instantiate language")}
    guard let language5 = Language(
        name: "hungarian".localized,
        code: "hu"
        )else {fatalError("Unable to instantiate language")}
    
    LANGUAGES += [language1]
    LANGUAGES += [language2]
    LANGUAGES += [language3]
    LANGUAGES += [language4]
    LANGUAGES += [language5]
    LANGUAGES.sort{$0.name < $1.name}
}

