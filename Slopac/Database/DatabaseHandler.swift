//
//  DatabaseHandler.swift
//  Slopac
//
//  Created by Jozef Varga on 08/01/2019.
//  Copyright © 2019 Jozef Varga. All rights reserved.
//

import UIKit
import CoreData
import os.log


/// class for controll core data
class DatabaseHandler: NSObject {
    
    
    /// Get context for data
    ///
    /// - Returns: data
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate: AppDelegate
        if Thread.current.isMainThread {
            appDelegate = UIApplication.shared.delegate as! AppDelegate
        } else {
            appDelegate = DispatchQueue.main.sync {
                return UIApplication.shared.delegate as! AppDelegate
            }
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Save core data function
    class func saveDataAddress(address: String, city_id: Int32, country: String, id: Int32, latitude: Double, longtitude: Double, postal_code: String, updated_at: Date) -> Bool {
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Address", in: context) else { return false }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        managedObject.setValue(address, forKey: "address")
        managedObject.setValue(city_id, forKey: "city_id")
        managedObject.setValue(country, forKey: "country")
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(latitude, forKey: "latitude")
        managedObject.setValue(longtitude, forKey: "longtitude")
        managedObject.setValue(postal_code, forKey: "postal_code")
        managedObject.setValue(updated_at, forKey: "updated_at")
        do {
            try context.save()
            return true
        }catch {
            return false
        }
    }
    
    class func saveDataBooks(author: String, cover_path: String, feedback: Int16, id: Int32, isbn: String, notes: String, title: String, user_id: Int32, language: String, year: String, edition: String, publisher: String, publication: String, tags: Int16, isInDatabase: Int16) -> Bool {
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Books", in: context) else { return false }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        managedObject.setValue(author, forKey: "author")
        managedObject.setValue(cover_path, forKey: "cover_path")
        managedObject.setValue(feedback, forKey: "feedback")
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(isbn, forKey: "isbn")
        managedObject.setValue(notes, forKey: "notes")
        managedObject.setValue(title, forKey: "title")
        managedObject.setValue(user_id, forKey: "user_id")
        managedObject.setValue(isInDatabase, forKey: "isInDatabase")
        managedObject.setValue(UUID().uuidString, forKey: "uuid")
        managedObject.setValue(tags, forKey: "tags")
        
        managedObject.setValue(language, forKey: "language")
        managedObject.setValue(year, forKey: "year")
        managedObject.setValue(edition, forKey: "edition")
        managedObject.setValue(publisher, forKey: "publisher")
        managedObject.setValue(publication, forKey: "publication")
        
        do {
            try context.save()
            return true
        }catch {
            return false
        }
    }
    
    class func saveDataBooksWithPicture(author: String, cover: UIImage, cover_path: String, feedback: Int16, id: Int32, isbn: String, notes: String, title: String, user_id: Int32 ,language: String, year: String, edition: String, publisher: String, publication: String, tags: Int16, isInDatabase: Int16) -> Bool {
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Books", in: context) else { return false }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        managedObject.setValue(author, forKey: "author")
        managedObject.setValue(cover.jpegData(compressionQuality: COMPRESSION_QUALITY), forKey: "cover")
        managedObject.setValue(cover_path, forKey: "cover_path")
        managedObject.setValue(feedback, forKey: "feedback")
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(isbn, forKey: "isbn")
        managedObject.setValue(notes, forKey: "notes")
        managedObject.setValue(title, forKey: "title")
        managedObject.setValue(user_id, forKey: "user_id")
        managedObject.setValue(isInDatabase, forKey: "isInDatabase")
        managedObject.setValue(UUID().uuidString, forKey: "uuid")
        managedObject.setValue(language, forKey: "language")
        managedObject.setValue(year, forKey: "year")
        managedObject.setValue(edition, forKey: "edition")
        managedObject.setValue(publisher, forKey: "publisher")
        managedObject.setValue(publication, forKey: "publication")
        managedObject.setValue(tags, forKey: "tags")
        
        do {
            try context.save()
            return true
        }catch {
            return false
        }
    }
    
    class func saveDataCities(city: String, id: Int32, latitude: Double, longtitude: Double, updated_at: Date) -> Bool {
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Cities", in: context) else { return false }
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        managedObject.setValue(city, forKey: "city")
        managedObject.setValue(latitude, forKey: "latitude")
        managedObject.setValue(longtitude, forKey: "longtitude")
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(updated_at, forKey: "updated_at")
        
        do {
            try context.save()
            return true
        }catch {
            return false
        }
    }
    
    class func saveDataLibraries(address_id: Int32, id: Int32, library_name: String, library_address: String, updated_at: Date) -> Bool {
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Libraries", in: context) else { return false }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        managedObject.setValue(address_id, forKey: "address_id")
        managedObject.setValue(library_name, forKey: "library_name")
        managedObject.setValue(updated_at, forKey: "updated_at")
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(library_address, forKey: "library_address")
        managedObject.setValue(false, forKey: "save_search")
        
        do {
            try context.save()
            return true
        }catch {
            return false
        }
    }
    
    class func saveDataLibraryCardWithPicture(code: String, id: Int32, library_id: Int32, library_name: String, picture: UIImage, picture_path: String , updated_at: Date, user_id: Int32, date: Date, password: String, isInDatabase: Int16) -> Bool {
        
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "LibraryCard", in: context) else { return false }
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        managedObject.setValue(code, forKey: "code")
        managedObject.setValue(library_id, forKey: "library_id")
        managedObject.setValue(library_name, forKey: "library_name")
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(picture.jpegData(compressionQuality: COMPRESSION_QUALITY), forKey: "picture")
        managedObject.setValue(picture_path, forKey: "picture_path")
        managedObject.setValue(updated_at, forKey: "updated_at")
        managedObject.setValue(user_id, forKey: "user_id")
        managedObject.setValue(isInDatabase, forKey: "isInDatabase")
        managedObject.setValue(UUID().uuidString, forKey: "uuid")
        managedObject.setValue(date, forKey: "date")
        managedObject.setValue(password, forKey: "password")
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func saveDataLibraryCard(code: String, id: Int32, library_id: Int32, library_name: String,/* picture: UIImage,*/picture_path: String , updated_at: Date, user_id: Int32, date: Date, password: String, isInDatabase: Int16) -> Bool {
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "LibraryCard", in: context) else { return false }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        managedObject.setValue(code, forKey: "code")
        managedObject.setValue(library_id, forKey: "library_id")
        managedObject.setValue(library_name, forKey: "library_name")
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(picture_path, forKey: "picture_path")
        managedObject.setValue(updated_at, forKey: "updated_at")
        managedObject.setValue(user_id, forKey: "user_id")
        managedObject.setValue(isInDatabase, forKey: "isInDatabase")
        managedObject.setValue(UUID().uuidString, forKey: "uuid")
        managedObject.setValue(date, forKey: "date")
        managedObject.setValue(password, forKey: "password")
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func saveDataLibraryLocations(address_id: Int32, id: Int32, library_id: Int32, location_acronym: String, location_name: String, updated_at: Date) -> Bool {
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "LibraryLocations", in: context) else { return false }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        managedObject.setValue(address_id, forKey: "address_id")
        managedObject.setValue(library_id, forKey: "library_id")
        managedObject.setValue(location_acronym, forKey: "location_acronym")
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(location_name, forKey: "location_name")
        managedObject.setValue(updated_at, forKey: "updated_at")
        
        do {
            try context.save()
            return true
        }catch {
            return false
        }
    }
    
    class func saveDataLibrarySublocations(address_id: Int32, id: Int32, libraryLocation_id: Int32, sublocation_acronym: String, sublocation_name: String, updated_at: Date) -> Bool {
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "LibrarySublocations", in: context) else { return false }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        managedObject.setValue(address_id, forKey: "address_id")
        managedObject.setValue(libraryLocation_id, forKey: "libraryLocation_id")
        managedObject.setValue(sublocation_acronym, forKey: "sublocation_acronym")
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(sublocation_name, forKey: "sublocation_name")
        managedObject.setValue(updated_at, forKey: "updated_at")
        
        do {
            try context.save()
            return true
        }catch {
            return false
        }
    }
    
    class func saveDataUsers(guid: String, auth: String, email: String, first_name: String, id: Int32, last_name: String, version_book: Date, version_library_card: Date) -> Bool {
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Users", in: context) else { return false }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        managedObject.setValue(guid, forKey: "guid")
        managedObject.setValue(auth, forKey: "auth")
        managedObject.setValue(email, forKey: "email")
        managedObject.setValue(first_name, forKey: "first_name")
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(last_name, forKey: "last_name")
        managedObject.setValue(version_book, forKey: "version_book")
        managedObject.setValue(version_library_card, forKey: "version_library_card")
        
        do {
            try context.save()
            return true
        }catch {
            return false
        }
    }
    
    class func saveDataVersions(address_version: Date, city_version: Date, id: Int32, library_version: Date, location_version: Date, sublocation_version: Date, updated_at: Date) -> Bool {
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Versions", in: context) else { return false }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        managedObject.setValue(address_version, forKey: "address_version")
        managedObject.setValue(city_version, forKey: "city_version")
        managedObject.setValue(library_version, forKey: "library_version")
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(location_version, forKey: "location_version")
        managedObject.setValue(updated_at, forKey: "updated_at")
        managedObject.setValue(sublocation_version, forKey: "sublocation_version")
        
        do {
            try context.save()
            return true
        }catch {
            return false
        }
    }
    
    // MARK: - Save with return coreData function
    
    class func saveDataBooksReturn(author: String, cover_path: String, feedback: Int16, id: Int32, isbn: String, notes: String, title: String, user_id: Int32, language: String, year: String, edition: String, publisher: String, publication: String, tags: Int16, isInDatabase: Int16) -> BooksCoreData {
        let context = getContext()
        let newBook = BooksCoreData(context: context)
        newBook.author = author
        newBook.cover_path = cover_path
        newBook.feedback = feedback
        newBook.id = id
        newBook.isbn = isbn
        newBook.notes = notes
        newBook.title = title
        newBook.user_id = user_id
        newBook.isInDatabase = isInDatabase
        newBook.uuid = UUID().uuidString
        newBook.language = language
        newBook.tags = tags
        newBook.year = year
        newBook.edition = edition
        newBook.publisher = publisher
        newBook.publication = publication
        do {
            try context.save()
            return newBook
        } catch {
            print("error saveDataLibraryCardReturn")
            return newBook
        }
    }
    
    class func saveDataBooksWithPictureReturn(author: String, cover: UIImage, cover_path: String, feedback: Int16, id: Int32, isbn: String, notes: String, title: String, user_id: Int32, language: String, year: String, edition: String, publisher: String, publication: String, tags: Int16 , isInDatabase: Int16) -> BooksCoreData {
        let context = getContext()
        let newBook = BooksCoreData(context: context)
        newBook.author = author
        newBook.cover = cover.jpegData(compressionQuality: COMPRESSION_QUALITY)
        newBook.cover_path = cover_path
        newBook.feedback = feedback
        newBook.id = id
        newBook.isbn = isbn
        newBook.notes = notes
        newBook.title = title
        newBook.user_id = user_id
        newBook.isInDatabase = isInDatabase
        newBook.uuid = UUID().uuidString
        newBook.language = language
        newBook.year = year
        newBook.tags = tags
        newBook.edition = edition
        newBook.publisher = publisher
        newBook.publication = publication
        
        do {
            try context.save()
            return newBook
        } catch {
            print("error saveDataLibraryCardReturn")
            return newBook
        }
    }
    
    class func saveDataLibraryCardReturn(code: String, id: Int32, library_id: Int32, library_name: String,/* picture: UIImage,*/picture_path: String , updated_at: Date, user_id: Int32, date: Date, password: String, isInDatabase: Int16) -> LibraryCardCoreData {
        let context = getContext()
        let newLibraryCard = LibraryCardCoreData(context: context)
        
        newLibraryCard.code = code
        newLibraryCard.library_id = library_id
        newLibraryCard.library_name = library_name
        newLibraryCard.id = id
        newLibraryCard.picture_path = picture_path
        newLibraryCard.updated_at = updated_at
        newLibraryCard.user_id = user_id
        newLibraryCard.isInDatabase = isInDatabase
        newLibraryCard.uuid = UUID().uuidString
        newLibraryCard.date = date
        newLibraryCard.password = password
        
        do {
            try context.save()
            return newLibraryCard
        } catch {
            print("error saveDataLibraryCardReturn")
            return newLibraryCard
        }
    }
    
    class func saveDataLibraryCardWithPictureReturn(code: String, id: Int32, library_id: Int32, library_name: String, picture: UIImage, picture_path: String , updated_at: Date, user_id: Int32, date: Date, password: String, isInDatabase: Int16) -> LibraryCardCoreData {
        let context = getContext()
        let newLibraryCard = LibraryCardCoreData(context: context)
        newLibraryCard.code = code
        newLibraryCard.library_id = library_id
        newLibraryCard.library_name = library_name
        newLibraryCard.id = id
        newLibraryCard.picture = picture.jpegData(compressionQuality: COMPRESSION_QUALITY)
        newLibraryCard.picture_path = picture_path
        newLibraryCard.updated_at = updated_at
        newLibraryCard.user_id = user_id
        newLibraryCard.isInDatabase = isInDatabase
        newLibraryCard.uuid = UUID().uuidString
        newLibraryCard.date = date
        newLibraryCard.password = password
        
        do {
            try context.save()
            return newLibraryCard
        } catch {
            print("error saveDataLibraryCardReturn")
            return newLibraryCard
        }
    }
    
    
    // MARK: - Get Context by ID
    class func getByIdAddress(id: NSManagedObjectID) -> AddressCoreData? {
        return getContext().object(with: id) as? AddressCoreData
    }
    
    class func getByIdBooks(id: NSManagedObjectID) -> BooksCoreData? {
        return getContext().object(with: id) as? BooksCoreData
    }
    
    class func getByIdCities(id: NSManagedObjectID) -> CitiesCoreData? {
        return getContext().object(with: id) as? CitiesCoreData
    }
    
    class func getByIdLibraries(id: NSManagedObjectID) -> LibrariesCoreData? {
        return getContext().object(with: id) as? LibrariesCoreData
    }
    
    class func getByIdLibraryCard(id: NSManagedObjectID) -> LibraryCardCoreData? {
        return getContext().object(with: id) as? LibraryCardCoreData
    }
    
    class func getByIdLibraryLocations(id: NSManagedObjectID) -> LibraryLocationsCoreData? {
        return getContext().object(with: id) as? LibraryLocationsCoreData
    }
    
    class func getByIdLibrarySublocations(id: NSManagedObjectID) -> LibrarySublocationsCoreData? {
        return getContext().object(with: id) as? LibrarySublocationsCoreData
    }
    
    class func getByIdUsers(id: NSManagedObjectID) -> UsersCoreData? {
        return getContext().object(with: id) as? UsersCoreData
    }
    
    class func getByIdVersions(id: NSManagedObjectID) -> VersionsCoreData? {
        return getContext().object(with: id) as? VersionsCoreData
    }
    
    // MARK: - Update core data function
    
    class func updateDataAddress(addressCoreData: AddressCoreData, address: String, city_id: Int32, country: String, latitude: Double, longtitude: Double, postal_code: String, updated_at: Date) -> Bool {
        if let addressCD = getByIdAddress(id: addressCoreData.objectID) {
            let context = getContext()
            addressCD.address = address
            addressCD.city_id = city_id
            addressCD.country = country
            addressCD.latitude = latitude
            addressCD.longtitude = longtitude
            addressCD.postal_code = postal_code
            addressCD.updated_at = updated_at
            
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    class func updateDataBooksCover(booksCoreData: BooksCoreData, cover: UIImage) -> Bool {
        if let booksCD = getByIdBooks(id: booksCoreData.objectID) {
            let context = getContext()
            booksCD.cover = cover.jpegData(compressionQuality: COMPRESSION_QUALITY)
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    class func updateDataBooks(booksCoreData: BooksCoreData, author: String, cover_path: String, feedback: Int16, isbn: String, notes: String, title: String, user_id: Int32, language: String, year: String, edition: String, publisher: String, publication: String, tags: Int16,  isInDatabase: Int16) -> Bool {
        if let booksCD = getByIdBooks(id: booksCoreData.objectID) {
            let context = getContext()
            booksCD.author = author
            booksCD.cover_path = cover_path
            booksCD.feedback = feedback
            booksCD.isbn = isbn
            booksCD.notes = notes
            booksCD.title = title
            booksCD.user_id = user_id
            booksCD.isInDatabase = isInDatabase
            booksCD.tags = tags
            
            booksCD.language = language
            booksCD.year = year
            booksCD.edition = edition
            booksCD.publisher = publisher
            booksCD.publication = publication
            
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    class func updateDataBooksWithPicture(booksCoreData: BooksCoreData, cover: UIImage, author: String, cover_path: String, feedback: Int16, isbn: String, notes: String, title: String, user_id: Int32, language: String, year: String, edition: String, publisher: String, publication: String, tags: Int16, isInDatabase: Int16) -> Bool {
        if let booksCD = getByIdBooks(id: booksCoreData.objectID) {
            let context = getContext()
            booksCD.author = author
            booksCD.cover_path = cover_path
            booksCD.cover = cover.jpegData(compressionQuality: COMPRESSION_QUALITY)
            booksCD.feedback = feedback
            booksCD.isbn = isbn
            booksCD.notes = notes
            booksCD.title = title
            booksCD.user_id = user_id
            booksCD.isInDatabase = isInDatabase
            booksCD.tags = tags
            
            booksCD.language = language
            booksCD.year = year
            booksCD.edition = edition
            booksCD.publisher = publisher
            booksCD.publication = publication
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    class func updateDataBooksDatabaseType(booksCoreData: BooksCoreData, isInDatabase: Int16) -> Bool {
        if let booksCD = getByIdBooks(id: booksCoreData.objectID) {
            let context = getContext()
            booksCD.isInDatabase = isInDatabase
            
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    class func updateDataBooksWithPictureIdDatabaseTypeAndPicturePath(booksCoreData: BooksCoreData,id: Int32, cover_path: String, isInDatabase: Int16) -> Bool {
        if let booksCD = getByIdBooks(id: booksCoreData.objectID) {
            let context = getContext()
            booksCD.cover_path = cover_path
            booksCD.isInDatabase = isInDatabase
            booksCD.id = id
            
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    
    class func updateDataBooksDatabaseTypeAndId(booksCoreData: BooksCoreData, isInDatabase: Int16, id: Int32) -> Bool {
        if let booksCD = getByIdBooks(id: booksCoreData.objectID) {
            let context = getContext() 
            booksCD.isInDatabase = isInDatabase
            booksCD.id = id
            
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    class func updateDataCities(citiesCoreData: CitiesCoreData, city: String, latitude: Double, longtitude: Double, updated_at: Date) -> Bool {
        if let citiesCD = getByIdCities(id: citiesCoreData.objectID) {
            let context = getContext()
            citiesCD.city = city
            citiesCD.latitude = latitude
            citiesCD.longtitude = longtitude
            citiesCD.updated_at = updated_at
            
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    class func updateDataLibrariesSave(librariesCoreData: LibrariesCoreData, save_search: Bool) -> Bool {
        if let librariesCD = getByIdLibraries(id: librariesCoreData.objectID) {
            let context = getContext()
            librariesCD.save_search = save_search
            
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    class func updateDataLibraries(librariesCoreData: LibrariesCoreData, address_id: Int32, library_name: String, library_address: String, updated_at: Date) -> Bool {
        if let librariesCD = getByIdLibraries(id: librariesCoreData.objectID) {
            let context = getContext()
            librariesCD.address_id = address_id
            librariesCD.library_name = library_name
            librariesCD.library_address = library_address
            librariesCD.updated_at = updated_at
            
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    class func updateDataLibraryCardPicture(libraryCardCoreData: LibraryCardCoreData, picture: UIImage) -> Bool {
        if let libraryCardCD = getByIdLibraryCard(id: libraryCardCoreData.objectID) {
            let context = getContext()
            libraryCardCD.picture = picture.jpegData(compressionQuality: COMPRESSION_QUALITY)
            
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    class func updateDataLibraryCard(libraryCardCoreData: LibraryCardCoreData, code: String, library_id: Int32, library_name: String, picture_path: String, updated_at: Date, user_id: Int32, date: Date, password: String, isInDatabase: Int16) -> Bool {
        if let libraryCardCD = getByIdLibraryCard(id: libraryCardCoreData.objectID) {
            let context = getContext()
            libraryCardCD.code = code
            libraryCardCD.library_id = library_id
            libraryCardCD.library_name = library_name
            libraryCardCD.picture_path = picture_path
            libraryCardCD.updated_at = updated_at
            libraryCardCD.user_id = user_id
            libraryCardCD.isInDatabase = isInDatabase
            libraryCardCD.date = date
            libraryCardCD.password = password
            
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    
    class func updateDataLibraryCardDatabaseTypeAndId(libraryCardCoreData: LibraryCardCoreData, isInDatabase: Int16, id: Int32) -> Bool {
        if let libraryCardCD = getByIdLibraryCard(id: libraryCardCoreData.objectID) {
            let context = getContext()
            libraryCardCD.isInDatabase = isInDatabase
            libraryCardCD.id = id
            
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    class func updateDataLibraryCardDatabaseType(libraryCardCoreData: LibraryCardCoreData, isInDatabase: Int16) -> Bool {
        if let libraryCardCD = getByIdLibraryCard(id: libraryCardCoreData.objectID) {
            let context = getContext()
            libraryCardCD.isInDatabase = isInDatabase
            
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    class func updateDataLibraryCardWithPicture(libraryCardCoreData: LibraryCardCoreData, picture: UIImage, code: String, library_id: Int32, library_name: String, picture_path: String, updated_at: Date, user_id: Int32, date: Date, password: String, isInDatabase: Int16) -> Bool {
        if let libraryCardCD = getByIdLibraryCard(id: libraryCardCoreData.objectID) {
            let context = getContext()
            libraryCardCD.code = code
            libraryCardCD.library_id = library_id
            libraryCardCD.picture = picture.jpegData(compressionQuality: COMPRESSION_QUALITY)
            libraryCardCD.library_name = library_name
            libraryCardCD.picture_path = picture_path
            libraryCardCD.updated_at = updated_at
            libraryCardCD.user_id = user_id
            libraryCardCD.isInDatabase = isInDatabase
            libraryCardCD.date = date
            libraryCardCD.password = password
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    class func updateDataLibraryCardWithPictureIdDatabaseTypeAndPicturePath(libraryCardCoreData: LibraryCardCoreData,id: Int32, picture_path: String, isInDatabase: Int16) -> Bool {
        if let libraryCardCD = getByIdLibraryCard(id: libraryCardCoreData.objectID) {
            let context = getContext()
            libraryCardCD.picture_path = picture_path
            libraryCardCD.isInDatabase = isInDatabase
            libraryCardCD.id = id
            
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    
    
    class func updateDataLibraryLocations(libraryLocationsCoreData: LibraryLocationsCoreData, address_id: Int32, library_id: Int32, location_acronym: String, location_name: String, updated_at: Date) -> Bool {
        if let libraryLocationsCD = getByIdLibraryLocations(id: libraryLocationsCoreData.objectID) {
            let context = getContext()
            libraryLocationsCD.address_id = address_id
            libraryLocationsCD.library_id = library_id
            libraryLocationsCD.location_acronym = location_acronym
            libraryLocationsCD.location_name = location_name
            libraryLocationsCD.updated_at = updated_at
            
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    class func updateDataLibrarySublocations(librarySublocationsCoreData: LibrarySublocationsCoreData, address_id: Int32, libraryLocation_id: Int32, sublocation_acronym: String, sublocation_name: String, updated_at: Date) -> Bool {
        if let librarySublocationsCD = getByIdLibrarySublocations(id: librarySublocationsCoreData.objectID) {
            let context = getContext()
            librarySublocationsCD.address_id = address_id
            librarySublocationsCD.libraryLocation_id = libraryLocation_id
            librarySublocationsCD.sublocation_acronym = sublocation_acronym
            librarySublocationsCD.sublocation_name = sublocation_name
            librarySublocationsCD.updated_at = updated_at
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    class func updateDataUsers(usersCoreData: UsersCoreData, auth: String, email: String, first_name: String, last_name: String, password: String, guid: String, version_book: Date, version_library_card: Date) -> Bool {
        if let usersCD = getByIdUsers(id: usersCoreData.objectID) {
            let context = getContext()
            usersCD.auth = auth
            usersCD.email = email
            usersCD.first_name = first_name
            usersCD.last_name = last_name
            usersCD.password = password
            usersCD.guid = guid
            usersCD.version_book = version_book
            usersCD.version_library_card = version_library_card
            
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    class func updateDataUsersVersion(usersCoreData: UsersCoreData, version_book: Date, version_library_card: Date) -> Bool {
        if let usersCD = getByIdUsers(id: usersCoreData.objectID) {
            let context = getContext()
            usersCD.version_book = version_book
            usersCD.version_library_card = version_library_card
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    class func updateDataVersions(versionsCoreData: VersionsCoreData, address_version: Date, city_version: Date, library_version: Date, location_version: Date, sublocation_version: Date, updated_at: Date) -> Bool {
        if let versionsCD = getByIdVersions(id: versionsCoreData.objectID) {
            let context = getContext()
            versionsCD.address_version = address_version
            versionsCD.city_version = city_version
            versionsCD.library_version = library_version
            versionsCD.location_version = location_version
            versionsCD.sublocation_version = sublocation_version
            versionsCD.updated_at = updated_at
            
            do {
                try context.save()
                return true
            }catch {
                return false
            }
        }
        return false
    }
    
    // MARK: - Fetch Core Data function
    
    class func fetchDataAddress() -> [AddressCoreData]? {
        let context = getContext()
        var address: [AddressCoreData]?
        do {
            address = try context.fetch(AddressCoreData.fetchRequest())
            return address
        } catch {
            return address
        }
    }
    
    class func fetchDataAddressFromId(id: String) -> [AddressCoreData]? {
        let context = getContext()
        var address: [AddressCoreData]?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Address")
        request.predicate = NSPredicate(format: "id == %@", id)
        request.returnsObjectsAsFaults = false
        
        do {
            address = try (context.fetch(request) as? [AddressCoreData])
            return address
        } catch {
            return address
        }
    }
    
    
    class func fetchDataCitiesFromId(id: String) -> [CitiesCoreData]? {
        let context = getContext()
        var cities: [CitiesCoreData]?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cities")
        request.predicate = NSPredicate(format: "id == %@", id)
        request.returnsObjectsAsFaults = false
        do {
            cities = try (context.fetch(request) as? [CitiesCoreData])
            return cities
        } catch {
            return cities
        }
    }
    
    
    class func fetchDataBooks() -> [BooksCoreData]? {
        let context = getContext()
        var books: [BooksCoreData]?
        do {
            books = try context.fetch(BooksCoreData.fetchRequest())
            return books
        } catch {
            return books
        }
    }
    
    class func fetchDataBookWithoutDelete() -> [BooksCoreData]? {
        let context = getContext()
        var book: [BooksCoreData]?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
        request.predicate = NSPredicate(format: "isInDatabase != %@", "5")
        request.returnsObjectsAsFaults = false
        
        do {
            book = try (context.fetch(request) as? [BooksCoreData])
            return book
        } catch {
            return book
        }
    }
    
    class func fetchDataCities() -> [CitiesCoreData]? {
        let context = getContext()
        var cities: [CitiesCoreData]?
        do {
            cities = try context.fetch(CitiesCoreData.fetchRequest())
            return cities
        } catch {
            return cities
        }
    }
    
    class func fetchDataCitiesSort() -> [CitiesCoreData]? {
        let context = getContext()
        var cities: [CitiesCoreData]?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cities")
        request.sortDescriptors = [NSSortDescriptor.init(key: "city", ascending: true)]
        request.returnsObjectsAsFaults = false
        
        do {
            cities = try (context.fetch(request) as? [CitiesCoreData])
            return cities
        } catch {
            return cities
        }
    }
    
    
    
    class func fetchDataLibrariesFromId(id: String) -> [LibrariesCoreData]? {
        let context = getContext()
        var library: [LibrariesCoreData]?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Libraries")
        request.predicate = NSPredicate(format: "id == %@", id)
        request.returnsObjectsAsFaults = false
        
        do {
            library = try (context.fetch(request) as? [LibrariesCoreData])
            return library
        } catch {
            return library
        }
    }
    
    class func fetchDataLibrariesSaveTrue() -> [LibrariesCoreData]? {
        let context = getContext()
        var library: [LibrariesCoreData]?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Libraries")
        request.predicate = NSPredicate(format: "save_search != %@", "true")
        request.returnsObjectsAsFaults = false
        
        do {
            library = try (context.fetch(request) as? [LibrariesCoreData])
            return library
        } catch {
            return library
        }
    }
    
    class func fetchDataLibrariesSaveFalse() -> [LibrariesCoreData]? {
        let context = getContext()
        var library: [LibrariesCoreData]?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Libraries")
        request.predicate = NSPredicate(format: "save_search != %@", "false")
        request.returnsObjectsAsFaults = false
        
        do {
            library = try (context.fetch(request) as? [LibrariesCoreData])
            return library
        } catch {
            return library
        }
    }
    
    class func fetchDataLibrariesSort() -> [LibrariesCoreData]? {
        let context = getContext()
        var library: [LibrariesCoreData]?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Libraries")
        request.sortDescriptors = [NSSortDescriptor.init(key: "library_name", ascending: true)]
        request.returnsObjectsAsFaults = false
        
        do {
            library = try (context.fetch(request) as? [LibrariesCoreData])
            return library
        } catch {
            return library
        }
    }
    
    class func fetchDataLibraries() -> [LibrariesCoreData]? {
        let context = getContext()
        var libraries: [LibrariesCoreData]?
        do {
            libraries = try context.fetch(LibrariesCoreData.fetchRequest())
            return libraries
        } catch {
            return libraries
        }
    }
    
    class func fetchDataLibraryCard() -> [LibraryCardCoreData]? {
        let context = getContext()
        var libraryCard: [LibraryCardCoreData]?
        do {
            libraryCard = try context.fetch(LibraryCardCoreData.fetchRequest())
            return libraryCard
        } catch {
            return libraryCard
        }
    }
    
    
    class func fetchDataLibraryCardWithoutDelete() -> [LibraryCardCoreData]? {
        let context = getContext()
        var libraryCard: [LibraryCardCoreData]?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LibraryCard")
        request.predicate = NSPredicate(format: "isInDatabase != %@", "5")
        request.returnsObjectsAsFaults = false
        
        do {
            libraryCard = try (context.fetch(request) as? [LibraryCardCoreData])
            return libraryCard
        } catch {
            return libraryCard
        }
    }
    
    class func fetchDataLibraryLocations() -> [LibraryLocationsCoreData]? {
        let context = getContext()
        var libraryLocations: [LibraryLocationsCoreData]?
        do {
            libraryLocations = try context.fetch(LibraryLocationsCoreData.fetchRequest())
            return libraryLocations
        } catch {
            return libraryLocations
        }
    }
    
    class func fetchDataLibraryLocationsFromAcronym(location_acronym: String) -> [LibraryLocationsCoreData]? {
        let context = getContext()
        var libraryLocations: [LibraryLocationsCoreData]?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LibraryLocations")
        request.predicate = NSPredicate(format: "location_acronym == %@", location_acronym)
        request.returnsObjectsAsFaults = false
        
        do {
            libraryLocations = try (context.fetch(request) as? [LibraryLocationsCoreData])
            return libraryLocations
        } catch {
            return libraryLocations
        }
    }
    
    class func fetchDataLibrarySublocations() -> [LibrarySublocationsCoreData]? {
        let context = getContext()
        var librarySublocations: [LibrarySublocationsCoreData]?
        do {
            librarySublocations = try context.fetch(LibrarySublocationsCoreData.fetchRequest())
            return librarySublocations
        } catch {
            return librarySublocations
        }
    }
    
    class func fetchDataLibrarySublocationsFromAcronym(sublocation_acronym: String) -> [LibrarySublocationsCoreData]? {
        let context = getContext()
        var librarySublocations: [LibrarySublocationsCoreData]?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LibrarySubocations")
        request.predicate = NSPredicate(format: "sublocation_acronym == %@", sublocation_acronym)
        request.returnsObjectsAsFaults = false
        
        do {
            librarySublocations = try (context.fetch(request) as? [LibrarySublocationsCoreData])
            return librarySublocations
        } catch {
            return librarySublocations
        }
    }
    
    class func fetchDataUsers() -> [UsersCoreData]? {
        let context = getContext()
        var users: [UsersCoreData]?
        do {
            users = try context.fetch(UsersCoreData.fetchRequest())
            return users
        } catch {
            return users
        }
    }
    
    class func fetchDataVersions() -> [VersionsCoreData]? {
        let context = getContext()
        var versions: [VersionsCoreData]?
        do {
            versions = try context.fetch(VersionsCoreData.fetchRequest())
            return versions
        } catch {
            return versions
        }
    }
    
    // MARK: - Delete Core Data function
    
    class func deleteDataAddress(address: AddressCoreData) -> Bool {
        let context = getContext()
        context.delete(address)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func deleteDataBooks(books: BooksCoreData) -> Bool {
        let context = getContext()
        context.delete(books)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func deleteDataCities(cities: CitiesCoreData) -> Bool {
        let context = getContext()
        context.delete(cities)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func deleteDataLibraries(libraries: LibrariesCoreData) -> Bool {
        let context = getContext()
        context.delete(libraries)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func deleteDataLibraryCard(libraryCard: LibraryCardCoreData) -> Bool {
        let context = getContext()
        context.delete(libraryCard)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func deleteDataLibraryLocations(libraryLocations: LibraryLocationsCoreData) -> Bool {
        let context = getContext()
        context.delete(libraryLocations)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func deleteDataLibrarySublocations(librarySublocations: LibrarySublocationsCoreData) -> Bool {
        let context = getContext()
        context.delete(librarySublocations)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func deleteDataUsers(users: UsersCoreData) -> Bool {
        let context = getContext()
        context.delete(users)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func deleteDataVersions(versions: VersionsCoreData) -> Bool {
        let context = getContext()
        context.delete(versions)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    // Mark: - Clean Core Data function
    
    class func cleanDataAddress() -> Bool {
        let context = getContext()
        let deleteReq = NSBatchDeleteRequest(fetchRequest: AddressCoreData.fetchRequest())
        do {
            try context.execute(deleteReq)
            return true
        } catch {
            return false
        }
    }
    
    class func cleanDataBooks() -> Bool {
        let context = getContext()
        let deleteReq = NSBatchDeleteRequest(fetchRequest: BooksCoreData.fetchRequest())
        do {
            try context.execute(deleteReq)
            return true
        } catch {
            return false
        }
    }
    
    class func cleanDataCities() -> Bool {
        let context = getContext()
        let deleteReq = NSBatchDeleteRequest(fetchRequest: CitiesCoreData.fetchRequest())
        do {
            try context.execute(deleteReq)
            return true
        } catch {
            return false
        }
    }
    
    class func cleanDataLibraries() -> Bool {
        let context = getContext()
        let deleteReq = NSBatchDeleteRequest(fetchRequest: LibrariesCoreData.fetchRequest())
        do {
            try context.execute(deleteReq)
            return true
        } catch {
            return false
        }
    }
    
    class func cleanDataLibraryCard() -> Bool {
        let context = getContext()
        let deleteReq = NSBatchDeleteRequest(fetchRequest: LibraryCardCoreData.fetchRequest())
        do {
            try context.execute(deleteReq)
            return true
        } catch {
            return false
        }
    }
    
    class func cleanDataLibraryLocations() -> Bool {
        let context = getContext()
        let deleteReq = NSBatchDeleteRequest(fetchRequest: LibraryLocationsCoreData.fetchRequest())
        do {
            try context.execute(deleteReq)
            return true
        } catch {
            return false
        }
    }
    
    class func cleanDataLibrarySublocations() -> Bool {
        let context = getContext()
        let deleteReq = NSBatchDeleteRequest(fetchRequest: LibrarySublocationsCoreData.fetchRequest())
        do {
            try context.execute(deleteReq)
            return true
        } catch {
            return false
        }
    }
    
    class func cleanDataUsers() -> Bool {
        let context = getContext()
        let deleteReq = NSBatchDeleteRequest(fetchRequest: UsersCoreData.fetchRequest())
        do {
            try context.execute(deleteReq)
            return true
        } catch {
            return false
        }
    }
    
    class func cleanDataVersions() -> Bool {
        let context = getContext()
        let deleteReq = NSBatchDeleteRequest(fetchRequest: VersionsCoreData.fetchRequest())
        do {
            try context.execute(deleteReq)
            return true
        } catch {
            return false
        }
    }

}
