//
//  UpdateDataViewController.swift
//  Slopac
//
//  Created by Jozef Varga on 08/01/2019.
//  Copyright © 2019 Jozef Varga. All rights reserved.
//

//    let OK_DATABASE = 0
//    let WITHOUT_SAVE_DATABASE = 1
//    let WITHOUT_UPDATE_DATABASE = 2
//    let WITHOUT_SAVE_WITH_PICTURE_DATABASE = 3
//    let WITHOUT_UPDATE_WITH_PICTURE_DATABASE = 4
//    let DELTETE = 5

import UIKit
import os.log

/// First class for update data
class UpdateDataViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var updateProgress: UIProgressView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var loadImageView: UIImageView!
    
    // MARK: - Variables
    var versionData : [VersionsCoreData]?
    var usersData : [UsersCoreData]?
    var booksData : [BooksCoreData]?
    var libraryCardData : [LibraryCardCoreData]?
    var updateIsInDatabase = -1
    var updateId = Int32(0)
    var updatePath = ""
    
    // MARK: - Start function, text and UX settup
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProgress.progress = 1// 0.10
        setText()
        setUX()
        showTimer()
        print("asdaklsjdlkajsld")
    }
    
    func showTimer() {
//        progressBarNIB.setCircleStrokeWidth(10)
        var second: CGFloat = 0
//        progressBarNIB.setProgressText("\(Int(second))")
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] (timer) in
            second += 1
            self?.updateProgress.progress = Float(second/10)
            
            if second == 10 { // restart rotation
                timer.invalidate()
                self!.updateButton.isHidden = false
                self!.updateButton.isEnabled = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setText()
        showTimer()
    }
    
    func setUX(){
        view.backgroundColor = COLOR_THEME
        updateButton.customButton()
        updateProgress.transform = updateProgress.transform.scaledBy(x: 1, y: 7)
        updateProgress.layer.cornerRadius = 2
        loadImageView.image = UIImage(named: "load_photo")
        loadImageView.contentMode = .scaleAspectFit
        infoLabel.customLabel()
        infoLabel.isHidden = true
    }
    
    
    func setText(){
        self.navigationItem.title = "update_data".localized
        updateButton.setTitle("continue".localized, for: .normal)
        infoLabel.text = "  "
        updateButton.isHidden = true
        updateButton.isEnabled = false
        DispatchQueue.main.async { // Make sure you're on the main thread here
            //self.updateButton.isHidden = false
            //self.updateButton.isEnabled = true
            //self.infoLabel.text = "data_update_problem".localized
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        versionData = DatabaseHandler.fetchDataVersions()!
        usersData = DatabaseHandler.fetchDataUsers()!
        booksData = DatabaseHandler.fetchDataBooks()!
        libraryCardData = DatabaseHandler.fetchDataLibraryCard()!
        
        if((usersData!.count) > 0){
            if((booksData?.count)! > 0){
                for book in booksData! {
                    switch Int(book.isInDatabase) {
                    case WITHOUT_SAVE_DATABASE:
                        insertBook(actualBook: book, title_data: book.title!, author_data: book.author!, notes_data: book.notes!, feedback_data: Int(book.feedback), isbn_data: book.isbn!, language_data: book.language!, year_data: book.year!, edition_data: book.edition!, publisher_data: book.publisher!, publication_data: book.publication!)
                    case WITHOUT_UPDATE_DATABASE:
                        updateBook(actualBook: book, id_data: book.id, path_data: book.cover_path! , title_data: book.title!, author_data: book.author!, notes_data: book.notes!, feedback_data: Int(book.feedback), isbn_data: book.isbn!, language_data: book.language!, year_data: book.year!, edition_data: book.edition!, publisher_data: book.publisher!, publication_data: book.publication!)
                    case WITHOUT_SAVE_WITH_PICTURE_DATABASE:
                        insertBookWithImage(actualBook: book, imagePhoto: UIImage(data: book.cover!)!, title_data: book.title!, author_data: book.author!, notes_data: book.notes!, feedback_data: Int(book.feedback), isbn_data: book.isbn!, language_data: book.language!, year_data: book.year!, edition_data: book.edition!, publisher_data: book.publisher!, publication_data: book.publication!)
                    case WITHOUT_UPDATE_WITH_PICTURE_DATABASE:
                        updateBookWithImage(actualBook: book, id_data: book.id, imagePhoto: UIImage(data: book.cover!)!, title_data: book.title!, author_data: book.author!, notes_data: book.notes!, feedback_data: Int(book.feedback), isbn_data: book.isbn!, language_data: book.language!, year_data: book.year!, edition_data: book.edition!, publisher_data: book.publisher!, publication_data: book.publication!)
                    case DELTETE:
                        deleteBook(book: book, usersDate: usersData)
                    default:
                        os_log("Default choice switch for save data book", log: OSLog.default, type: .debug)
                    }
                }
            }
            
            if((libraryCardData?.count)! > 0){
                for libraryCard in libraryCardData! {
                    switch Int(libraryCard.isInDatabase) {
                    case WITHOUT_SAVE_DATABASE:
                        insertLibraryCard(actualLibraryCard: libraryCard)
                    case WITHOUT_UPDATE_DATABASE:
                        updateLibraryCard(actualLibraryCard: libraryCard)
                    case WITHOUT_SAVE_WITH_PICTURE_DATABASE:
                        insertLibraryCardWithImage(actualLibraryCard: libraryCard)
                    case WITHOUT_UPDATE_WITH_PICTURE_DATABASE:
                        updateLibraryCardWithImage(actualLibraryCard: libraryCard)
                    case DELTETE:
                        deleteLibraryCard(card: libraryCard)
                    default:
                        os_log("Default choice switch for save data libraryCard", log: OSLog.default, type: .debug)
                    }
                }
            }
            loadUserVersions(versionDate: versionData, usersDate: usersData)
        }
        else {
            loadVersions(versionDate: versionData)
        }
        
    }

    // MARK: - Update / Insert / Delete book
    func updateBookWithImage(actualBook: BooksCoreData, id_data: Int32, imagePhoto: UIImage, title_data: String, author_data: String, notes_data: String, feedback_data: Int, isbn_data: String, language_data: String, year_data: String, edition_data: String, publisher_data: String, publication_data: String ){
        self.updateIsInDatabase = WITHOUT_UPDATE_WITH_PICTURE_DATABASE
        let myUrl = NSURL(string: URL_UPDATE_FILE_WITH_PICTURE);
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        var new_year_data = ""
        if(year_data == ""){
            new_year_data = "0"
        }
        else{
            new_year_data = year_data
        }
        let param = [
            "uploadType"  : "3",
            "user_id"     : String(usersData?[0].id ?? 0),
            "title"       : title_data,
            "author"      : author_data,
            "isbn"        : isbn_data,
            "notes"       : notes_data,
            "feedback"    : String(feedback_data),
            "guid"        : usersData?[0].guid ?? "",
            "language"    : language_data,
            "year"        : new_year_data,
            "edition"     : edition_data,
            "publisher"   : publisher_data,
            "publication" : publication_data,
            "id"          : String(id_data)
        ]
        
        let boundary = generateBoundaryString()
        let token = (usersData?[0].auth)!
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        let imageData = imagePhoto.jpegData(compressionQuality: COMPRESSION_QUALITY)
        if(imageData==nil)  { return; }
        request.httpBody = createBodyWithParameters(parameters: (param), filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            if let value = String(data: data, encoding: .utf8){
                if let jsonData = value.data(using: .utf8){
                    do{
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                        let version = json["data"] as? Dictionary<String, Any> ?? [:]
                        let picture = json["picture"] as? Dictionary<String, Any> ?? [:]
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let versionTime = dateFormatter.date(from: version["versionTime"] as? String ?? "")
                        self.updatePath = picture["imageName"] as?  String ?? ""
                        self.updateId = id_data
                        self.updateIsInDatabase = OK_DATABASE
                        
                        if(!DatabaseHandler.updateDataBooksDatabaseType(booksCoreData: actualBook, isInDatabase: Int16(self.updateIsInDatabase))){
                            os_log("Error updateDataLibraryCardDatabaseType updateBookWithImage", log: OSLog.default, type: .debug)
                        }
                        
                        if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (self.usersData?[0])!, version_book: (self.usersData?[0].version_book)!, version_library_card: versionTime!)){
                            os_log("Error updateDataUsersVersion updateBookWithImage", log: OSLog.default, type: .debug)
                        }
                    }catch{
                        os_log("Unable to Parse JSON updateBookWithImage", log: OSLog.default, type: .debug)
                        
                    }
                }
            }
        }
        DispatchQueue.main.async { // Make sure you're on the main thread here
            //self.updateProgress.progress = 1// 1
            //self.updateButton.isHidden = false
            //self.updateButton.isEnabled = true
        }
        task.resume()
    }
    
    func insertBookWithImage(actualBook: BooksCoreData, imagePhoto: UIImage, title_data: String, author_data: String, notes_data: String, feedback_data: Int, isbn_data: String, language_data: String, year_data: String, edition_data: String, publisher_data: String, publication_data: String ){
        self.updateIsInDatabase = WITHOUT_SAVE_WITH_PICTURE_DATABASE
        let myUrl = NSURL(string: URL_UPDATE_FILE_WITH_PICTURE);
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        var new_year_data = ""
        if(year_data == ""){
            new_year_data = "0"
        }
        else{
            new_year_data = year_data
        }
        let param = [
            "uploadType"  : "4",
            "user_id"     : String(usersData?[0].id ?? 0),
            "title"       : title_data,
            "author"      : author_data,
            "isbn"        : isbn_data,
            "notes"       : notes_data,
            "feedback"    : String(feedback_data),
            "language"    : language_data,
            "year"        : new_year_data,
            "edition"     : edition_data,
            "publisher"   : publisher_data,
            "publication" : publication_data,
            "guid"        : usersData?[0].guid ?? ""
        ]
        print(param)
        let boundary = generateBoundaryString()
        let token = (usersData?[0].auth)!
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        let imageData = imagePhoto.jpegData(compressionQuality: COMPRESSION_QUALITY)
        if(imageData==nil)  {
            return
        }
        request.httpBody = createBodyWithParameters(parameters: (param), filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            guard let data = data, error == nil else {
                return
            }
            if let value = String(data: data, encoding: .utf8){
                if let jsonData = value.data(using: .utf8){
                    do{
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                        print(json)
                        let version = json["data"] as? Dictionary<String, Any> ?? [:]
                        let picture = json["picture"] as? Dictionary<String, Any> ?? [:]
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let versionTime = dateFormatter.date(from: version["versionTime"] as? String ?? "")
                        self.updateId = version["id"] as? Int32 ?? 0
                        self.updateIsInDatabase = OK_DATABASE
                        self.updatePath = picture["imageName"] as?  String ?? ""
                        if(!DatabaseHandler.updateDataBooksWithPictureIdDatabaseTypeAndPicturePath(booksCoreData: actualBook, id: self.updateId, cover_path: self.updatePath, isInDatabase: Int16(self.updateIsInDatabase))){
                            os_log("Error updateDataBooksWithPictureIdDatabaseTypeAndPicturePath insertBookWithImage", log: OSLog.default, type: .debug)
                        }
                        if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (self.usersData?[0])!, version_book: (self.usersData?[0].version_book)!, version_library_card: versionTime!)){
                            os_log("Error updateDataUsersVersion updateBookWithImage insertBookWithImage", log: OSLog.default, type: .debug)
                        }
                        
                    }catch{
                        os_log("Unable to Parse JSON insertBookWithImage", log: OSLog.default, type: .debug)
                    }
                }
            }
        }
        DispatchQueue.main.async { // Make sure you're on the main thread here
            //self.updateProgress.progress = 1// 1
            //self.updateButton.isHidden = false
            //self.updateButton.isEnabled = true
        }
        task.resume()
    }
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")
        return body
    }
    
    func insertBook(actualBook: BooksCoreData, title_data: String, author_data: String, notes_data: String, feedback_data: Int, isbn_data: String, language_data: String, year_data: String, edition_data: String, publisher_data: String, publication_data: String ){
        self.updateIsInDatabase = WITHOUT_SAVE_DATABASE
        
        let task: URLSessionDataTask?
        guard let url = URL(string: URL_UPDATE_FILE) else {
            os_log("Bad URL insertBook", log: OSLog.default, type: .debug)
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = ["Authorization": "Bearer " + (usersData?[0].auth)!]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let uploadType = "uploadType"
        let user_id = "user_id"
        let title = "title"
        let author = "author"
        let isbn = "isbn"
        let notes = "notes"
        let feedback = "feedback"
        let language = "language"
        let year = "year"
        let edition = "edition"
        let publisher = "publisher"
        let publication = "publication"
        let postDict : [String: Any] = [uploadType: 2,
                                        user_id: usersData?[0].id ?? 0,
                                        title: title_data,
                                        author: author_data,
                                        isbn: isbn_data,
                                        notes: notes_data,
                                        language: language_data,
                                        year: Int(year_data) ?? 0,
                                        edition: edition_data,
                                        publisher: publisher_data,
                                        publication: publication_data,
                                        feedback: feedback_data]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
            return
        }
        urlRequest.httpBody = postData
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        task = session.dataTask(with: urlRequest){
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            if let value = String(data: data, encoding: .utf8){
                if let jsonData = value.data(using: .utf8){
                    do{
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                        let version = json["data"] as? Dictionary<String, Any> ?? [:]
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let versionTime = dateFormatter.date(from: version["versionTime"] as? String ?? "")
                        self.updateId = version["id"] as? Int32 ?? 0
                        self.updateIsInDatabase = OK_DATABASE
                        if(!DatabaseHandler.updateDataBooksDatabaseTypeAndId(booksCoreData: actualBook, isInDatabase: Int16(self.updateIsInDatabase), id: self.updateId)){
                            os_log("Error updateDataBooksDatabaseTypeAndId insertBook", log: OSLog.default, type: .debug)
                        }
                        if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (self.usersData?[0])!, version_book: (self.usersData?[0].version_book)!, version_library_card: versionTime!)){
                            os_log("Error updateDataUsersVersion insertBook", log: OSLog.default, type: .debug)
                        }
                    }catch{
                        os_log("Unable to Parse JSON insertBook", log: OSLog.default, type: .debug)
                    }
                }
            }
        }
//        DispatchQueue.main.async { // Make sure you're on the main thread here
//            //self.updateProgress.progress = 1// 1
//            //self.updateButton.isHidden = false
//            //self.updateButton.isEnabled = true
//        }
        task?.resume()
    }
    
    func updateBook(actualBook: BooksCoreData, id_data: Int32, path_data: String, title_data: String, author_data: String, notes_data: String, feedback_data: Int, isbn_data: String, language_data: String, year_data: String, edition_data: String, publisher_data: String, publication_data: String ){
        self.updateIsInDatabase = WITHOUT_UPDATE_DATABASE
        let task: URLSessionDataTask?
        guard let url = URL(string: URL_UPDATE_FILE) else {
            os_log("Bad URL updateBook", log: OSLog.default, type: .debug)
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = ["Authorization": "Bearer " + (usersData?[0].auth)!]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let uploadType = "uploadType"
        let id = "id"
        let user_id = "user_id"
        let title = "title"
        let author = "author"
        let isbn = "isbn"
        let notes = "notes"
        let feedback = "feedback"
        let language = "language"
        let year = "year"
        let edition = "edition"
        let publisher = "publisher"
        let publication = "publication"
        let cover_path = "cover_path"
        let postDict : [String: Any] = [uploadType: 1,
                                        id: id_data,
                                        user_id: usersData?[0].id ?? 0,
                                        title: title_data,
                                        author: author_data,
                                        isbn: isbn_data,
                                        notes: notes_data,
                                        feedback: feedback_data,
                                        language: language_data,
                                        year: Int(year_data) ?? 0,
                                        edition: edition_data,
                                        publisher: publisher_data,
                                        publication: publication_data,
                                        cover_path: path_data]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
            return
        }
        urlRequest.httpBody = postData
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        task = session.dataTask(with: urlRequest){
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            if let value = String(data: data, encoding: .utf8){
                if let jsonData = value.data(using: .utf8){
                    do{
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                        let version = json["data"] as? Dictionary<String, Any> ?? [:]
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let versionTime = dateFormatter.date(from: version["versionTime"] as? String ?? "")
                        self.updateId = id_data
                        self.updateIsInDatabase = OK_DATABASE
                        self.updatePath = path_data
                        
                        if(!DatabaseHandler.updateDataBooksDatabaseType(booksCoreData: actualBook, isInDatabase: Int16(self.updateIsInDatabase))){
                            os_log("Error updateDataUsersVersion updateBook", log: OSLog.default, type: .debug)
                        }
                        
                        if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (self.usersData?[0])!, version_book: (self.usersData?[0].version_book)!, version_library_card: versionTime!)){
                            os_log("Error updateDataUsersVersion updateBook", log: OSLog.default, type: .debug)
                        }
                    }catch{
                        os_log("Unable to Parse JSON updateBook", log: OSLog.default, type: .debug)
                    }
                }
            }
        }
//        DispatchQueue.main.async { // Make sure you're on the main thread here
//            //self.updateProgress.progress = 1// 1
//            //self.updateButton.isHidden = false
//            //self.updateButton.isEnabled = true
//        }
        task?.resume()
    }
    
    
    func deleteBook(book: BooksCoreData?, usersDate: [UsersCoreData]?){
        if((usersData?.count)! < 1){
            print("without userData")
            if(!DatabaseHandler.deleteDataBooks(books: book!)){
                os_log("Error deleteDataLibraryCard deleteBook", log: OSLog.default, type: .debug)
            }
            return
        }
        else{
            if(!DatabaseHandler.updateDataBooksDatabaseType(booksCoreData: book!, isInDatabase: Int16(DELTETE)) ){
                os_log("Error updateDataLibraryCardDatabaseType deleteBook", log: OSLog.default, type: .debug)
            }
        }
        let task: URLSessionDataTask?
        guard let url = URL(string: URL_BOOK_DELETE) else {
            os_log("Bad URL deleteBook", log: OSLog.default, type: .debug)
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = ["Authorization": "Bearer " + (usersDate?[0].auth)!]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let id = "id"
        let user_id = "user_id"
        let postDict : [String: Any] = [id: book?.id ?? 0,
                                        user_id: usersDate?[0].id ?? 0]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
            return
        }
        urlRequest.httpBody = postData
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        task = session.dataTask(with: urlRequest){
            data, response, error in
            guard let data = data, error == nil else { 
                return
            }
            
            if let value = String(data: data, encoding: .utf8){
                if let jsonData = value.data(using: .utf8){
                    do{
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                        print(json)
                        let userUpdates = json["userUpdate"] as? Dictionary<String, Any> ?? [:]
                        let userUpdate = userUpdates["data"] as? Int
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let versionTime = dateFormatter.date(from: userUpdates["versionTime"] as? String ?? "")
                        let libraryCard = json["libraryCard"] as? Int
                        if(userUpdate == 1 && libraryCard == 1){
                            if(!DatabaseHandler.deleteDataBooks(books: book!)){
                                print("error delet from core data")
                            }
                            if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (self.usersData?[0])!, version_book: (self.usersData?[0].version_book)!, version_library_card: versionTime!)){
                                print("error update user")
                            }
                        }
                        else{
                            if(!DatabaseHandler.updateDataBooksDatabaseType(booksCoreData: book!, isInDatabase: Int16(DELTETE))){
                                print("update problem")
                            }
                        }
                    }catch{
                        os_log("Unable to Parse JSON deleteBook", log: OSLog.default, type: .debug)
                    }
                }
            }
        }
//        DispatchQueue.main.async { // Make sure you're on the main thread here
//            //self.updateProgress.progress = 1// 1
//            //self.updateButton.isHidden = false
//            //self.updateButton.isEnabled = true
//        }
        task?.resume()
    }
    
    
    func updateLibraryCardWithImage(actualLibraryCard: LibraryCardCoreData){
        self.updateIsInDatabase = WITHOUT_UPDATE_WITH_PICTURE_DATABASE
        
        let myUrl = NSURL(string: URL_UPDATE_FILE_WITH_PICTURE);
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let dateFormatterSend = DateFormatter()
        dateFormatterSend.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let param = [
            "uploadType"  : "7",
            "user_id"     : String(actualLibraryCard.user_id),
            "library_id"  : String(actualLibraryCard.library_id),
            "library_name": actualLibraryCard.library_name!,
            "guid"        : usersData?[0].guid ?? "",
            "code"        : actualLibraryCard.code!,
            "id"          : String(actualLibraryCard.id),
            "date"        : dateFormatterSend.string(from: actualLibraryCard.date!),
            "password"    : String(actualLibraryCard.password!)
        ]
        
        let boundary = generateBoundaryString()
        let token = (usersData?[0].auth)!
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        let helpImage = UIImage(data: actualLibraryCard.picture!)!
        let imageData = helpImage.jpegData(compressionQuality: COMPRESSION_QUALITY)
        if(imageData==nil)  { return; }
        request.httpBody = createBodyWithParameters(parameters: (param), filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            if let value = String(data: data, encoding: .utf8){
                if let jsonData = value.data(using: .utf8){
                    do{
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                        let version = json["data"] as? Dictionary<String, Any> ?? [:]
                        let picture = json["picture"] as? Dictionary<String, Any> ?? [:]
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let versionTime = dateFormatter.date(from: version["versionTime"] as? String ?? "")
                        self.updatePath = picture["imageName"] as?  String ?? ""
                        self.updateId = actualLibraryCard.id
                        self.updateIsInDatabase = OK_DATABASE
                        
                        if(!DatabaseHandler.updateDataLibraryCardDatabaseType(libraryCardCoreData: actualLibraryCard, isInDatabase: Int16(self.updateIsInDatabase))){
                            os_log("Error updateDataLibraryCardDatabaseType", log: OSLog.default, type: .debug)
                        }
                        if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (self.usersData?[0])!, version_book: (self.usersData?[0].version_book)!, version_library_card: versionTime!)){
                            os_log("Error updateDataUsersVersion", log: OSLog.default, type: .debug)
                        }
                    }catch{
                        os_log("Unable to Parse JSON updateLibraryCardWithImage", log: OSLog.default, type: .debug)
                    }
                }
            }
        }
//        DispatchQueue.main.async { // Make sure you're on the main thread here
//            //self.updateProgress.progress = 1// 1
//            //self.updateButton.isHidden = false
//            //self.updateButton.isEnabled = true
//        }
        task.resume()
    }
    
    func insertLibraryCardWithImage(actualLibraryCard: LibraryCardCoreData ){
        self.updateIsInDatabase = WITHOUT_SAVE_WITH_PICTURE_DATABASE
        
        let myUrl = NSURL(string: URL_UPDATE_FILE_WITH_PICTURE);
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let dateFormatterSend = DateFormatter()
        dateFormatterSend.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let param = [
            "uploadType"  : "8",
            "user_id"     : String(actualLibraryCard.user_id),
            "library_id"  : String(actualLibraryCard.library_id),
            "library_name": actualLibraryCard.library_name!,
            "guid"        : usersData?[0].guid ?? "",
            "code"        : actualLibraryCard.code!,
            "id"          : String(actualLibraryCard.id),
            "date"        : dateFormatterSend.string(from: actualLibraryCard.date!),
            "password"    : String(actualLibraryCard.password!)
        ]
        let boundary = generateBoundaryString()
        let token = (usersData?[0].auth)!
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        let helpImage = UIImage(data: actualLibraryCard.picture!)!
        let imageData = helpImage.jpegData(compressionQuality: COMPRESSION_QUALITY)
        if(imageData==nil)  {
            return
        }
        request.httpBody = createBodyWithParameters(parameters: (param), filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            if let value = String(data: data, encoding: .utf8){
                if let jsonData = value.data(using: .utf8){
                    do{
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                        let version = json["data"] as? Dictionary<String, Any> ?? [:]
                        let picture = json["picture"] as? Dictionary<String, Any> ?? [:]
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let versionTime = dateFormatter.date(from: version["versionTime"] as? String ?? "")
                        self.updateId = version["id"] as? Int32 ?? 0
                        self.updateIsInDatabase = OK_DATABASE
                        self.updatePath = picture["imageName"] as?  String ?? ""
                        
                        if(!DatabaseHandler.updateDataLibraryCardWithPictureIdDatabaseTypeAndPicturePath(libraryCardCoreData: actualLibraryCard, id: self.updateId, picture_path: self.updatePath, isInDatabase: Int16(self.updateIsInDatabase))){
                            print("Error")
                        }
                        if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (self.usersData?[0])!, version_book: (self.usersData?[0].version_book)!, version_library_card: versionTime!)){
                            os_log("Error updateDataUsersVersion", log: OSLog.default, type: .debug)
                        }
                    }catch{
                        os_log("Unable to Parse JSON insertLibraryCardWithImage", log: OSLog.default, type: .debug)
                    }
                }
            }
        }
//        DispatchQueue.main.async { // Make sure you're on the main thread here
//            //self.updateProgress.progress = 1// 1
//            //self.updateButton.isHidden = false
//            //self.updateButton.isEnabled = true
//        }
        task.resume()
    }
    
    
    
    func insertLibraryCard(actualLibraryCard: LibraryCardCoreData){
        self.updateIsInDatabase = WITHOUT_SAVE_DATABASE
        let task: URLSessionDataTask?
        guard let url = URL(string: URL_UPDATE_FILE) else {
            os_log("Bad Url insertLibraryCard", log: OSLog.default, type: .debug)
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = ["Authorization": "Bearer " + (usersData?[0].auth)!]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let uploadType = "uploadType"
        let user_id = "user_id"
        let library_id = "library_id"
        let library_name = "library_name"
        let code = "code"
        let date = "date"
        let password = "password"
        print("chyba insertu y")
        let dateFormatterSend = DateFormatter()
        dateFormatterSend.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let postDict : [String: Any] = [uploadType: 6,
                                        user_id: usersData?[0].id ?? 0,
                                        library_id: actualLibraryCard.library_id  ,
                                        library_name: String(actualLibraryCard.library_name ?? ""),
                                        code: String(actualLibraryCard.code ?? ""),
                                        date: dateFormatterSend.string(from: actualLibraryCard.date!),
                                        password: actualLibraryCard.password!
                                        ]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
            return
        }
        urlRequest.httpBody = postData
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        task = session.dataTask(with: urlRequest){
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            if let value = String(data: data, encoding: .utf8){
                if let jsonData = value.data(using: .utf8){
                    do{
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                        let version = json["data"] as? Dictionary<String, Any> ?? [:]
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let versionTime = dateFormatter.date(from: version["versionTime"] as? String ?? "")
                        
                        self.updateId = version["id"] as? Int32 ?? 0
                        self.updateIsInDatabase = OK_DATABASE
                        
                        if(!DatabaseHandler.updateDataLibraryCardDatabaseTypeAndId(libraryCardCoreData: actualLibraryCard, isInDatabase: Int16(self.updateIsInDatabase), id: self.updateId)){
                            os_log("Error updateDataLibraryCardDatabaseTypeAndId", log: OSLog.default, type: .debug)
                        }
                        if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (self.usersData?[0])!, version_book: (self.usersData?[0].version_book)!, version_library_card: versionTime!)){
                            os_log("Error updateDataUsersVersion", log: OSLog.default, type: .debug)
                        }
                    }catch{
                        os_log("Unable to Parse JSON insertLibraryCard", log: OSLog.default, type: .debug)
//                        DispatchQueue.main.async { // Make sure you're on the main thread here
//                            //self.updateButton.isHidden = false
//                            //self.updateButton.isEnabled = true
//                            //self.infoLabel.text = "ok".localized
//                        }
                    }
                }
            }
        }
//        DispatchQueue.main.async { // Make sure you're on the main thread here
//            //self.updateProgress.progress = 1// 1
//            //self.updateButton.isHidden = false
//            //self.updateButton.isEnabled = true
//        }
        task?.resume()
    }
    
    
    
    func updateLibraryCard(actualLibraryCard: LibraryCardCoreData){
        
        self.updateIsInDatabase = WITHOUT_UPDATE_DATABASE
        let task: URLSessionDataTask?
        guard let url = URL(string: URL_UPDATE_FILE) else {
            os_log("Bad Url updateLibraryCard", log: OSLog.default, type: .debug)
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = ["Authorization": "Bearer " + (usersData?[0].auth)!]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let uploadType = "uploadType"
        let user_id = "user_id"
        let library_id = "library_id"
        let library_name = "library_name"
        let code = "code"
        let id = "id"
        let path = "path"
        let password = "password"
        let date = "date"
        let dateFormatterSend = DateFormatter()
        dateFormatterSend.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let postDict : [String: Any] = [uploadType: 5,
                                        id: actualLibraryCard.id ,
                                        user_id: usersData?[0].id ?? 0,
                                        library_id: actualLibraryCard.library_id,
                                        library_name: actualLibraryCard.library_name!,
                                        code: actualLibraryCard.code!,
                                        path: actualLibraryCard.picture_path!,
                                        date: dateFormatterSend.string(from: actualLibraryCard.date!),
                                        password: actualLibraryCard.password!
                                        ]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
            return
        }
        urlRequest.httpBody = postData
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        task = session.dataTask(with: urlRequest){
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            if let value = String(data: data, encoding: .utf8){
                if let jsonData = value.data(using: .utf8){
                    do{
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                        let version = json["data"] as? Dictionary<String, Any> ?? [:]
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let versionTime = dateFormatter.date(from: version["versionTime"] as? String ?? "")
                        
                        self.updateId = actualLibraryCard.id
                        self.updateIsInDatabase = OK_DATABASE
                        self.updatePath = actualLibraryCard.picture_path!
                        
                        if(!DatabaseHandler.updateDataLibraryCardDatabaseType(libraryCardCoreData: actualLibraryCard, isInDatabase: Int16(self.updateIsInDatabase))){
                            os_log("Error updateDataLibraryCardDatabaseType", log: OSLog.default, type: .debug)
                        }
                        if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (self.usersData?[0])!, version_book: (self.usersData?[0].version_book)!, version_library_card: versionTime!)){
                            os_log("Error updateDataUsersVersion", log: OSLog.default, type: .debug)
                        } 
                    }catch{
                        os_log("Unable to Parse JSON updateLibraryCard", log: OSLog.default, type: .debug)
                    }
                }
            }
        }
//        DispatchQueue.main.async { // Make sure you're on the main thread here
//            //self.updateProgress.progress = 1// 1
//            //self.updateButton.isHidden = false
//            //self.updateButton.isEnabled = true
//        }
        task?.resume()
    }
    
    func deleteLibraryCard(card: LibraryCardCoreData?){
        if((usersData?.count)! < 1){
            if(!DatabaseHandler.deleteDataLibraryCard(libraryCard: card!)){
                os_log("Error deleteDataLibraryCard", log: OSLog.default, type: .debug)
            }
            return
        }
        else{
            if(!DatabaseHandler.updateDataLibraryCardDatabaseType(libraryCardCoreData: card!, isInDatabase: Int16(DELTETE))){
                os_log("Error updateDataLibraryCardDatabaseType", log: OSLog.default, type: .debug)
            }
            
        }
        let task: URLSessionDataTask?
        guard let url = URL(string: URL_LIBRARY_CARD_DELETE) else {
            os_log("Bad Url deleteLibraryCard", log: OSLog.default, type: .debug)
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = ["Authorization": "Bearer " + (usersData?[0].auth)!]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let id = "id"
        let user_id = "user_id"
        let postDict : [String: Any] = [id: card?.id ?? 0,
                                        user_id: usersData?[0].id ?? 0]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
            return
        }
        urlRequest.httpBody = postData
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        task = session.dataTask(with: urlRequest){
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            if let value = String(data: data, encoding: .utf8){
                if let jsonData = value.data(using: .utf8){
                    do{
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                        let userUpdates = json["userUpdate"] as? Dictionary<String, Any> ?? [:]
                        let userUpdate = userUpdates["data"] as? Int
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let versionTime = dateFormatter.date(from: userUpdates["versionTime"] as? String ?? "")
                        let libraryCard = json["libraryCard"] as? Int
                        if(userUpdate == 1 && libraryCard == 1){
                            if(!DatabaseHandler.deleteDataLibraryCard(libraryCard: card!)){
                                os_log("Error deleteDataLibraryCard", log: OSLog.default, type: .debug)
                            }
                            if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (self.usersData?[0])!, version_book: (self.usersData?[0].version_book)!, version_library_card: versionTime!)){
                                os_log("Error updateDataUsersVersion", log: OSLog.default, type: .debug)
                            }
                        }
                        else{
                            if(!DatabaseHandler.updateDataLibraryCardDatabaseType(libraryCardCoreData: card!, isInDatabase: Int16(DELTETE))){
                                os_log("Error updateDataUsersVersion", log: OSLog.default, type: .debug)
                            }
                        }
                    }catch{
                        os_log("Unable to Parse JSON deleteLibraryCard", log: OSLog.default, type: .debug)
                    }
                }
            }
        }
//        DispatchQueue.main.async { // Make sure you're on the main thread here
//            //self.updateProgress.progress = 1// 1
//            //self.updateButton.isHidden = false
//            //self.updateButton.isEnabled = true
//        }
        task?.resume()
    }
    
    func loadData(addressVersion: Int, librariesVersion: Int, citiesVersion: Int, locationVersion: Int, sublocationVersion: Int){
        let task: URLSessionDataTask?
        guard let url = URL(string: URL_VERSIONS_DATA) else {
            print("Bad Url")
//            DispatchQueue.main.async { // Make sure you're on the main thread here
//                //self.updateButton.isHidden = false
//                //self.updateButton.isEnabled = true
//                //self.infoLabel.text = "data_update_problem".localized
//            }
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let address = "address"
        let cities = "cities"
        let libraries = "libraries"
        let libraryLocations = "libraryLocations"
        let librarySublocations = "librarySublocations"
        let postDict : [String: Any] = [address: addressVersion,
                                        cities: citiesVersion,
                                        libraries: librariesVersion,
                                        libraryLocations: locationVersion,
                                        librarySublocations: sublocationVersion]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
//            DispatchQueue.main.async { // Make sure you're on the main thread here
//                //self.updateButton.isHidden = false
//                //self.updateButton.isEnabled = true
//                //self.infoLabel.text = "data_update_problem".localized
//            }
            return
        }
//        DispatchQueue.main.async { // Make sure you're on the main thread here
//            //self.updateProgress.progress = 1// 0.15
//        }
        urlRequest.httpBody = postData
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        task = session.dataTask(with: urlRequest){
            data, response, error in
            guard let data = data, error == nil else {
//                DispatchQueue.main.async { // Make sure you're on the main thread here
//                    //self.updateButton.isHidden = false
//                    //self.updateButton.isEnabled = true
//                    //self.infoLabel.text = "data_update_problem".localized
//                }
                return
                
            }
            
            if let value = String(data: data, encoding: .utf8){
                if let jsonData = value.data(using: .utf8){
                    do{
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                        print(json)
                        if(addressVersion == 1){
                            if(!DatabaseHandler.cleanDataAddress()){
                                os_log("Error cleanDataAddress", log: OSLog.default, type: .debug)
                            }
                            let addressData = json["address"] as? Dictionary<String, Any> ?? [:]
                            let address = addressData["data"] as? [Dictionary<String, Any>] ?? []
                            for add in address{
                                let postal_code = add["postal_code"] as? String ?? ""
                                let country = add["country"] as? String ?? ""
                                let address = add["address"] as? String ?? ""
                                let city_id = add["city_id"] as? Int32 ?? 0
                                let id = add["id"] as? Int32 ?? 0
                                let latitude = add["latitude"] as? String ?? ""
                                let longtitude = add["longtitude"] as? String ?? ""
                                if(!DatabaseHandler.saveDataAddress(address: address, city_id: city_id, country: country, id: id, latitude: Double(latitude)!, longtitude: Double(longtitude)!, postal_code: postal_code, updated_at: Date())){
                                    os_log("Error saveDataAddress", log: OSLog.default, type: .debug)
                                }
                            }
                        }
//                        DispatchQueue.main.async { // Make sure you're on the main thread here
//                            //self.updateProgress.progress = 1// 0.25
//                        }
                        if(citiesVersion == 1){
                            if(!DatabaseHandler.cleanDataCities()){
                                os_log("Error cleanDataCities", log: OSLog.default, type: .debug)
                            }
                            let citiesData = json["cities"] as? Dictionary<String, Any> ?? [:]
                            let cities = citiesData["data"] as? [Dictionary<String, Any>] ?? []
                            for city in cities{
                                let nameCity = city["city"] as? String ?? ""
                                let id = city["id"] as? Int32 ?? 0
                                let latitude = city["latitude"] as? String ?? ""
                                let longtitude = city["longtitude"] as? String ?? ""
                                if(false == DatabaseHandler.saveDataCities(city: nameCity, id: id, latitude: Double(latitude)!, longtitude: Double(longtitude)!, updated_at: Date())){
                                    os_log("Error saveDataCities", log: OSLog.default, type: .debug)
                                }
                            }
                        }
//                        DispatchQueue.main.async { // Make sure you're on the main thread here
//                            //self.updateProgress.progress = 1// 0.35
//                        }
                        if(librariesVersion == 1){
                            if(!DatabaseHandler.cleanDataLibraries()){
                                print("error clean data")
                            }
                            let librariesData = json["libraries"] as? Dictionary<String, Any> ?? [:]
                            let libraries = librariesData["data"] as? [Dictionary<String, Any>] ?? []
                            for library in libraries{
                                let library_name = library["library_name"] as? String ?? ""
                                let address_id = library["address_id"] as? Int32 ?? 0
                                let id = library["id"] as? Int32 ?? 0
                                print("Jejda")
                                let library_address = library["library_address"] as? String ?? ""
                                print(library_address)
                                print("Jejda")
                                if(!DatabaseHandler.saveDataLibraries(address_id: address_id, id: id, library_name: library_name, library_address: library_address, updated_at: Date())){
                                    print("error save to database librar")
                                }
                                print("Jejda")
                            }
                        }
//                        DispatchQueue.main.async { // Make sure you're on the main thread here
//                            //self.updateProgress.progress = 1// 0.45
//                        }
                        if(locationVersion == 1){
                            if(!DatabaseHandler.cleanDataLibraryLocations()){
                                print("error clean data")
                            }
                            let locationsData = json["libraryLocations"] as? Dictionary<String, Any> ?? [:]
                            let locations = locationsData["data"] as? [Dictionary<String, Any>] ?? []
                            for location in locations{
                                let location_name = location["location_name"] as? String ?? ""
                                let location_acronym = location["location_acronym"] as? String ?? ""
                                let library_id = location["library_id"] as? Int32 ?? 0
                                let address_id = location["address_id"] as? Int32 ?? 0
                                let id = location["id"] as? Int32 ?? 0
                                if(!DatabaseHandler.saveDataLibraryLocations(address_id: address_id, id: id, library_id: library_id, location_acronym: location_acronym, location_name: location_name, updated_at: Date())){
                                    print("error save to database  loc")
                                }
                            }
                        }
//                        DispatchQueue.main.async { // Make sure you're on the main thread here
//                            //self.updateProgress.progress = 1// 0.55
//                        }
                        if(sublocationVersion == 1){
                            if(!DatabaseHandler.cleanDataLibrarySublocations()){
                                print("error clean data")
                            }
                            let sublocationsData = json["librarySublocations"] as? Dictionary<String, Any> ?? [:]
                            let sublocations = sublocationsData["data"] as? [Dictionary<String, Any>] ?? []
                            for sublocation in sublocations{
                                let sublocation_name = sublocation["sublocation_name"] as? String ?? ""
                                let sublocation_acronym = sublocation["sublocation_acronym"] as? String ?? ""
                                let libraryLocation_id = sublocation["libraryLocation_id"] as? Int32 ?? 0
                                let address_id = sublocation["address_id"] as? Int32 ?? 0
                                let id = sublocation["id"] as? Int32 ?? 0
                                if(!DatabaseHandler.saveDataLibrarySublocations(address_id: address_id, id: id, libraryLocation_id: libraryLocation_id, sublocation_acronym: sublocation_acronym, sublocation_name: sublocation_name, updated_at: Date())){
                                    print("error save to database  suvblo")
                                }
                            }
                        }
//                        DispatchQueue.main.async { // Make sure you're on the main thread here
//                            //self.updateProgress.progress = 1// 0.65
//                        }
//                        DispatchQueue.main.async { // Make sure you're on the main thread here
//                            //self.updateButton.isHidden = false
//                            //self.updateButton.isEnabled = true
//                            //self.infoLabel.text = "ok".localized
//                        }
                    }catch{
                        print("Unable to Parse JSON")
                        
                        //self.updateButton.isHidden = false
                        //self.updateButton.isEnabled = true
                        //self.infoLabel.text = "data_update_problem".localized
                    }
                }
//                DispatchQueue.main.async { // Make sure you're on the main thread here
//                    //self.updateButton.isHidden = false
//                    //self.updateButton.isEnabled = true
//                    //self.infoLabel.text = "ok".localized
//                }
            }
        }
//        DispatchQueue.main.async { // Make sure you're on the main thread here
//            //self.updateButton.isHidden = false
//            //self.updateButton.isEnabled = true
//            //self.infoLabel.text = "ok".localized
//            //self.updateProgress.progress = 1// 1
//        }
        task?.resume()
    }
    
    
    
    
    func loadVersions(versionDate: [VersionsCoreData]?){
//        DispatchQueue.main.async { // Make sure you're on the main thread here
//            //self.updateProgress.progress = 1// 0.5
//        }
        let task: URLSessionDataTask?
        guard let url = URL(string: URL_VERSIONS) else {
//            DispatchQueue.main.async { // Make sure you're on the main thread here
//                //self.updateButton.isHidden = false
//                //self.updateButton.isEnabled = true
//                //self.infoLabel.text = "data_update_problem".localized
//            }
            print("Bad Url")
            return
        }
        let session = URLSession(configuration: .default)
        task = session.dataTask(with: url){
            data, response, error in
            guard let data = data, error == nil else {
//                DispatchQueue.main.async { // Make sure you're on the main thread here
//                    //self.updateButton.isHidden = false
//                    //self.updateButton.isEnabled = true
//                    //self.infoLabel.text = "data_update_problem".localized
//                }
                return
                
            }
            
            if let value = String(data: data, encoding: .utf8){
                if let jsonData = value.data(using: .utf8){
                    do{
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                        print(json)
                        let versions = json["data"] as? [Dictionary<String, Any>] ?? []
                        for version in versions{
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                            let library_version = dateFormatter.date(from:version["library_version"] as? String ?? "")
                            let city_version = dateFormatter.date(from:version["city_version"] as? String ?? "")
                            let location_version = dateFormatter.date(from:version["location_version"] as? String ?? "")
                            let sublocation_version = dateFormatter.date(from:version["sublocaion_version"] as? String ?? "")
                            let address_version = dateFormatter.date(from:version["address_version"] as? String ?? "")
                            
                            var locationValue = 0
                            var addressValue = 0
                            var librariesValue = 0
                            var citiesValue = 0
                            var sublocationsValue = 0
                            
                            if((versionDate!.count) > 0){
                                if((versionDate?[0].location_version)! < location_version!){
                                    locationValue = 1
                                }
                                if((versionDate?[0].address_version)! < address_version!){
                                    addressValue = 1
                                }
                                if((versionDate?[0].city_version)! < city_version!){
                                    citiesValue = 1
                                }
                                if((versionDate?[0].library_version)! < library_version!){
                                    librariesValue = 1
                                }
                                if((versionDate?[0].sublocation_version)! < sublocation_version!){
                                    sublocationsValue = 1
                                }
                            }else {
                                locationValue = 1
                                addressValue = 1
                                librariesValue = 1
                                citiesValue = 1
                                sublocationsValue = 1
                            }
//                            DispatchQueue.main.async { // Make sure you're on the main thread here
//                                //self.updateProgress.progress = 1// 0.10
//                            }
                            if(locationValue == 0 && addressValue == 0 && librariesValue == 0 && citiesValue == 0 && sublocationsValue == 0){
//                                DispatchQueue.main.async { // Make sure you're on the main thread here
//                                    //self.updateProgress.progress = 1// 1.0
//                                    //self.updateButton.isHidden = false
//                                    //self.updateButton.isEnabled = true
//                                }
                            }else{
                                self.loadData(addressVersion: addressValue, librariesVersion: librariesValue, citiesVersion: citiesValue, locationVersion: locationValue, sublocationVersion: sublocationsValue)
                                if((versionDate!.count) > 0){
                                    if(!DatabaseHandler.updateDataVersions(versionsCoreData: (versionDate?[0])!, address_version: address_version!, city_version: city_version!, library_version: library_version!, location_version: location_version!, sublocation_version: sublocation_version!, updated_at: Date())){
                                        print("error update data")
                                    }
                                }
                                else{
                                    if(!DatabaseHandler.saveDataVersions(address_version: address_version!, city_version: city_version!, id: 1, library_version: library_version!, location_version: location_version!, sublocation_version: sublocation_version!, updated_at: Date())){
                                        print("error save to database  version")
                                    }
                                }
                            }
                        }
//                        DispatchQueue.main.async { // Make sure you're on the main thread here
////                            //self.updateButton.isHidden = false
////                            //self.updateButton.isEnabled = true
//                            //self.infoLabel.text = "ok".localized
//                        }
                    }catch{
                        print("Unable to Parse JSON")
                        
//                        //self.updateButton.isHidden = false
//                        //self.updateButton.isEnabled = true
                        //self.infoLabel.text = "data_update_problem".localized
                    }
                }
//                DispatchQueue.main.async { // Make sure you're on the main thread here
//                    //self.updateButton.isHidden = false
//                    //self.updateButton.isEnabled = true
//                    //self.infoLabel.text = "ok".localized
//                }
            }
        }
//        DispatchQueue.main.async { // Make sure you're on the main thread here
//            //self.updateButton.isHidden = false
//            //self.updateButton.isEnabled = true
//            //self.infoLabel.text = "ok".localized
//            //self.updateProgress.progress = 1// 1
//        }
        task?.resume()
    }
    
    
    
    
    
    
    func loadUserData(addressVersion: Int, librariesVersion: Int, citiesVersion: Int, locationVersion: Int, sublocationVersion: Int, booksVersion: Int, libraryCardVersion: Int , usersDate: [UsersCoreData]?){
        
        print("3")
        
        let task: URLSessionDataTask?
        guard let url = URL(string: URL_VERSIONS_USER_DATA) else {
            print("Bad Url")
//            DispatchQueue.main.async { // Make sure you're on the main thread here
//                //self.updateButton.isHidden = false
//                //self.updateButton.isEnabled = true
//                //self.infoLabel.text = "data_update_problem".localized
//            }
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = ["Authorization": "Bearer " + (usersDate?[0].auth)!]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let address = "address"
        let cities = "cities"
        let libraries = "libraries"
        let libraryLocations = "libraryLocations"
        let librarySublocations = "librarySublocations"
        let books = "books"
        let libraryCard = "libraryCard"
        let user_id = "user_id"
        let postDict : [String: Any] = [address: addressVersion,
                                        cities: citiesVersion,
                                        libraries: librariesVersion,
                                        libraryLocations: locationVersion,
                                        librarySublocations: sublocationVersion,
                                        books: booksVersion,
                                        libraryCard: libraryCardVersion,
                                        user_id: usersDate?[0].id ?? 0]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
//            DispatchQueue.main.async { // Make sure you're on the main thread here
//                //self.updateButton.isHidden = false
//                //self.updateButton.isEnabled = true
//                //self.infoLabel.text = "data_update_problem".localized
//            }
            return
        }
//        DispatchQueue.main.async { // Make sure you're on the main thread here
//            //self.updateProgress.progress = 1// 0.15
//        }
        urlRequest.httpBody = postData
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        task = session.dataTask(with: urlRequest){
            data, response, error in
            guard let data = data, error == nil else {
//                DispatchQueue.main.async { // Make sure you're on the main thread here
//                    //self.updateButton.isHidden = false
//                    //self.updateButton.isEnabled = true
//                    //self.infoLabel.text = "data_update_problem".localized
//                }
                return
                
            }
            
            if let value = String(data: data, encoding: .utf8){
                if let jsonData = value.data(using: .utf8){
                    do{
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                        print(json)
                        if(citiesVersion == 1){
                            if(!DatabaseHandler.cleanDataCities()){
                                print("error clean data")
                            }
                            let citiesData = json["cities"] as? Dictionary<String, Any> ?? [:]
                            let cities = citiesData["data"] as? [Dictionary<String, Any>] ?? []
                            for city in cities{
                                let nameCity = city["city"] as? String ?? ""
                                let id = city["id"] as? Int32 ?? 0
                                let latitude = city["latitude"] as? String ?? ""
                                let longtitude = city["longtitude"] as? String ?? ""
                                if(false == DatabaseHandler.saveDataCities(city: nameCity, id: id, latitude: Double(latitude)!, longtitude: Double(longtitude)!, updated_at: Date())){
                                    print("error save to database city")
                                }
                            }
                        }
//                        DispatchQueue.main.async { // Make sure you're on the main thread here
//                            //self.updateProgress.progress = 1// 0.25
//                        }
                        if(addressVersion == 1){
                            if(!DatabaseHandler.cleanDataAddress()){
                                print("error clean data")
                            }
                            let addressData = json["address"] as? Dictionary<String, Any> ?? [:]
                            let address = addressData["data"] as? [Dictionary<String, Any>] ?? []
                            for add in address{
                                let postal_code = add["postal_code"] as? String ?? ""
                                let country = add["country"] as? String ?? ""
                                let address = add["address"] as? String ?? ""
                                let city_id = add["city_id"] as? Int32 ?? 0
                                let id = add["id"] as? Int32 ?? 0
                                let latitude = add["latitude"] as? String ?? ""
                                let longtitude = add["longtitude"] as? String ?? ""
                                if(!DatabaseHandler.saveDataAddress(address: address, city_id: city_id, country: country, id: id, latitude: Double(latitude)!, longtitude: Double(longtitude)!, postal_code: postal_code, updated_at: Date())){
                                    print("error save to database   address")
                                }
                            }
                        }
//                        DispatchQueue.main.async { // Make sure you're on the main thread here
//                            //self.updateProgress.progress = 1// 0.35
//                        }
                        if(librariesVersion == 1){
                            if(!DatabaseHandler.cleanDataLibraries()){
                                print("error clean data")
                            }
                            let librariesData = json["libraries"] as? Dictionary<String, Any> ?? [:]
                            let libraries = librariesData["data"] as? [Dictionary<String, Any>] ?? []
                            for library in libraries{
                                let library_name = library["library_name"] as? String ?? ""
                                let address_id = library["address_id"] as? Int32 ?? 0
                                let id = library["id"] as? Int32 ?? 0
                                let library_address = library["library_address"] as? String ?? ""
                                if(!DatabaseHandler.saveDataLibraries(address_id: address_id, id: id, library_name: library_name, library_address: library_address, updated_at: Date())){
                                    print("error save to database librar")
                                }
                            }
                        }
//                        DispatchQueue.main.async { // Make sure you're on the main thread here
//                            //self.updateProgress.progress = 1// 0.45
//                        }
                        if(locationVersion == 1){
                            if(!DatabaseHandler.cleanDataLibraryLocations()){
                                print("error clean data")
                            }
                            let locationsData = json["libraryLocations"] as? Dictionary<String, Any> ?? [:]
                            let locations = locationsData["data"] as? [Dictionary<String, Any>] ?? []
                            for location in locations{
                                let location_name = location["location_name"] as? String ?? ""
                                let location_acronym = location["location_acronym"] as? String ?? ""
                                let library_id = location["library_id"] as? Int32 ?? 0
                                let address_id = location["address_id"] as? Int32 ?? 0
                                let id = location["id"] as? Int32 ?? 0
                                if(!DatabaseHandler.saveDataLibraryLocations(address_id: address_id, id: id, library_id: library_id, location_acronym: location_acronym, location_name: location_name, updated_at: Date())){
                                    print("error save to database  loc")
                                }
                            }
                        }
//                        DispatchQueue.main.async { // Make sure you're on the main thread here
//                            //self.updateProgress.progress = 1// 0.45
//                        }
                        if(sublocationVersion == 1){
                            if(!DatabaseHandler.cleanDataLibrarySublocations()){
                                print("error clean data")
                            }
                            let sublocationsData = json["librarySublocations"] as? Dictionary<String, Any> ?? [:]
                            let sublocations = sublocationsData["data"] as? [Dictionary<String, Any>] ?? []
                            for sublocation in sublocations{
                                let sublocation_name = sublocation["sublocation_name"] as? String ?? ""
                                let sublocation_acronym = sublocation["sublocation_acronym"] as? String ?? ""
                                let libraryLocation_id = sublocation["libraryLocation_id"] as? Int32 ?? 0
                                let address_id = sublocation["address_id"] as? Int32 ?? 0
                                let id = sublocation["id"] as? Int32 ?? 0
                                if(!DatabaseHandler.saveDataLibrarySublocations(address_id: address_id, id: id, libraryLocation_id: libraryLocation_id, sublocation_acronym: sublocation_acronym, sublocation_name: sublocation_name, updated_at: Date())){
                                    print("error save to database  suvblo")
                                }
                            }
                        }
//                        DispatchQueue.main.async { // Make sure you're on the main thread here
//                            //self.updateProgress.progress = 1// 0.55
//                        }
                        if(booksVersion == 1){
                            if(!DatabaseHandler.cleanDataBooks()){
                                print("error clean data")
                            }
                            let booksData = json["books"] as? Dictionary<String, Any> ?? [:]
                            let books = booksData["data"] as? [Dictionary<String, Any>] ?? []
                            for book in books{
                                let id = book["id"] as? Int32 ?? 0
                                let user_id = book["user_id"] as? Int32 ?? 0
                                let title = book["title"] as? String ?? ""
                                let author = book["author"] as? String ?? ""
                                let isbn = book["isbn"] as? String ?? ""
                                let notes = book["notes"] as? String ?? ""
                                let cover_path = book["cover_path"] as? String ?? ""
                                let feedback = book["feedback"] as? Int16 ?? 0
                                let language = book["language"] as? String ?? ""
                                let publisher = book["publisher"] as? String ?? ""
                                let publication = book["publication"] as? String ?? ""
                                let edition = book["edition"] as? String ?? ""
                                let year = book["year"] as? String ?? ""
                                let tags = book["tags"] as? Int16 ?? 0
                                print(" id ", id," user_id ", user_id," title ", title," author ", author," isbn ", isbn," notes ", notes," cover_path ", cover_path," feedback ", feedback," language ", language," publisher ", publisher," publication ", publication," edition ", edition," year ", year)
                                
                                let bookSave = DatabaseHandler.saveDataBooksReturn(author: author, cover_path: cover_path, feedback: feedback, id: id, isbn: isbn, notes: notes, title: title, user_id: user_id, language: language, year: year, edition: edition, publisher: publisher, publication: publication, tags: tags, isInDatabase: 0)
//                                if(!DatabaseHandler.saveDataBooks(author: author, cover_path: cover_path, feedback: feedback, id: id, isbn: isbn, notes: notes, title: title, user_id: user_id, language: language, year: year, edition: edition, publisher: publisher, publication: publication, isInDatabase: 0)){
//                                    print("error save to database  books")
//                                }
                                if(cover_path != ""){
//                                    loadPictureForLibraryCard
                                    self.loadPictureForBook(actualBook: bookSave)
                                }
                            }
                        }
//                        DispatchQueue.main.async { // Make sure you're on the main thread here
//                            //self.updateProgress.progress = 1// 0.60
//                        }
                        if(libraryCardVersion == 1){
                            if(!DatabaseHandler.cleanDataLibraryCard()){
                                print("error clean data")
                            }
                            let libraryCardsData = json["libraryCard"] as? Dictionary<String, Any> ?? [:]
                            let libraryCards = libraryCardsData["data"] as? [Dictionary<String, Any>] ?? []
                            for libraryCard in libraryCards{
                                
                                let id = libraryCard["id"] as? Int32 ?? 0
                                let user_id = libraryCard["user_id"] as? Int32 ?? 0
                                let library_id = libraryCard["library_id"] as? Int32 ?? 0
                                let library_name = libraryCard["library_name"] as? String ?? ""
                                let code = libraryCard["code"] as? String ?? ""
                                let picture_path = libraryCard["picture_path"] as? String ?? ""
                                let password = libraryCard["password"] as? String ?? ""
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                let expiration_date = dateFormatter.date(from: libraryCard["date"] as? String ?? "")
                                
                                let libraryCardSave = DatabaseHandler.saveDataLibraryCardReturn(code: code, id: id, library_id: library_id, library_name: library_name, picture_path: picture_path, updated_at: Date(), user_id: user_id, date: expiration_date!, password: password, isInDatabase: 0)
                                if(picture_path != ""){
                                    self.loadPictureForLibraryCard(actualLibraryCard: libraryCardSave)
                                }
                            }
                        }
//                        DispatchQueue.main.async { // Make sure you're on the main thread here
//                            //self.updateProgress.progress = 1// 0.65
//                        }
//                        DispatchQueue.main.async { // Make sure you're on the main thread here
//                            //self.updateButton.isHidden = false
//                            //self.updateButton.isEnabled = true
//                            //self.infoLabel.text = "ok".localized
//                        }
                    }catch{
                        print("Unable to Parse JSON")
                        //self.updateButton.isHidden = false
                        //self.updateButton.isEnabled = true
                        //self.infoLabel.text = "data_update_problem".localized
                    }
                }
//                DispatchQueue.main.async { // Make sure you're on the main thread here
//                    //self.updateButton.isHidden = false
//                    //self.updateButton.isEnabled = true
//                    //self.infoLabel.text = "ok".localized
//                }
            }
        }
//        DispatchQueue.main.async { // Make sure you're on the main thread here
//            //self.updateButton.isHidden = false
//            //self.updateButton.isEnabled = true
//            //self.infoLabel.text = "ok".localized
//            //self.updateProgress.progress = 1// 1
//        }
        task?.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func loadPictureForLibraryCard(actualLibraryCard: LibraryCardCoreData) {
        // create a queue
        let downloadQueue = DispatchQueue(label:"download",qos:.userInitiated)
        let realUrl = URL_PICTURE_BOOK + (usersData?[0].guid)! + "/" + actualLibraryCard.picture_path!
        downloadQueue.async {
            if let url = URL(string: realUrl), let imgData = try? Data(contentsOf: url)
            {
                let image = UIImage(data: imgData)
                DispatchQueue.main.async {
                    if(!DatabaseHandler.updateDataLibraryCardPicture(libraryCardCoreData: actualLibraryCard, picture: image!)){
                        print("asd")
                    }
                }
            }
        }
    }
    
    func loadPictureForBook(actualBook: BooksCoreData) {
        // create a queue
        let downloadQueue = DispatchQueue(label:"download",qos:.userInitiated)
        let realUrl = URL_PICTURE_BOOK + (usersData?[0].guid)! + "/" + actualBook.cover_path!
        downloadQueue.async {
            if let url = URL(string: realUrl), let imgData = try? Data(contentsOf: url)
            {
                let image = UIImage(data: imgData)
                DispatchQueue.main.async {
                    if(!DatabaseHandler.updateDataBooksCover(booksCoreData: actualBook, cover: image!)){
                        print("asd")
                    }
                }
            }
        }
    }
     
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
     
    
    func loadUserVersions(versionDate: [VersionsCoreData]?, usersDate: [UsersCoreData]?){
        let task: URLSessionDataTask?
        
        print("3")
        guard let url = URL(string: URL_VERSIONS_USER) else {
            DispatchQueue.main.async { // Make sure you're on the main thread here
                //self.updateButton.isHidden = false
                //self.updateButton.isEnabled = true
                //self.infoLabel.text = "data_update_problem".localized
            }
            print("Bad Url")
            return
        }
        
        print("4")
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = ["Authorization": "Bearer " + (usersDate?[0].auth)!]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        print("5n")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let id = "id"
        let postDict : [String: Any] = [id: usersDate?[0].id ?? 0]
        
        print("6")
        guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
            DispatchQueue.main.async { // Make sure you're on the main thread here
                //self.updateButton.isHidden = false
                //self.updateButton.isEnabled = true
                //self.infoLabel.text = "data_update_problem".localized
            }
            return
        }
        print("7")
        sessionConfig.timeoutIntervalForRequest = 5.0
        urlRequest.httpBody = postData
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        task = session.dataTask(with: urlRequest){
            data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { // Make sure you're on the main thread here
                    //self.updateButton.isHidden = false
                    //self.updateButton.isEnabled = true
                    //self.infoLabel.text = "data_update_problem".localized
                }
                
                return
                
            }
            
            if let value = String(data: data, encoding: .utf8){
                if let jsonData = value.data(using: .utf8){
                    do{
                        
                        var booksValue = 0
                        var libraryCardValue = 0
                        
                        var count1 = 0
                        var count2 = 0
                        
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                        print(json)
                        let versionsData = json["version"] as? Dictionary<String, Any> ?? [:]
                        let versions = versionsData["data"] as? [Dictionary<String, Any>] ?? []
                        let userVersionsData = json["user_version"] as? Dictionary<String, Any> ?? [:]
                        let userVersions = userVersionsData["data"] as? [Dictionary<String, Any>] ?? []
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        
                        var version_book = dateFormatter.date(from: "1999-11-11'T'11:11:11.111'Z'")
                        var version_library_card = dateFormatter.date(from: "1999-11-11'T'11:11:11.111'Z'")
                        
                        for userVersion in userVersions{
                            if(count1 == 0){
                                count1 = 1
                                version_book = dateFormatter.date(from:userVersion["version_book"] as? String ?? "")
                                version_library_card = dateFormatter.date(from:userVersion["version_library_card"] as? String ?? "")
                                if((usersDate!.count) > 0){ 
                                    if((usersDate?[0].version_book)! < version_book!){
                                        booksValue = 1
                                    }
                                    if((usersDate?[0].version_library_card)! < version_library_card!){
                                        libraryCardValue = 1
                                    }
                                }
                                else {
                                    booksValue = 1
                                    libraryCardValue = 1
                                }
                            }
                        }
                        DispatchQueue.main.async { // Make sure you're on the main thread here
                            //self.updateProgress.progress = 1// 0.5
                        }

                        
                        for version in versions{
                            if(count2 == 0){
                                count2 = 1
                                let library_version = dateFormatter.date(from:version["library_version"] as? String ?? "")
                                let city_version = dateFormatter.date(from:version["city_version"] as? String ?? "")
                                let location_version = dateFormatter.date(from:version["location_version"] as? String ?? "")
                                let sublocation_version = dateFormatter.date(from:version["sublocaion_version"] as? String ?? "")
                                let address_version = dateFormatter.date(from:version["address_version"] as? String ?? "")
                                
                                var locationValue = 0
                                var addressValue = 0
                                var librariesValue = 0
                                var citiesValue = 0
                                var sublocationsValue = 0
                                
                                if((versionDate!.count) > 0){
                                    if((versionDate?[0].location_version)! < location_version!){
                                        locationValue = 1
                                    }
                                    if((versionDate?[0].address_version)! < address_version!){
                                        addressValue = 1
                                    }
                                    if((versionDate?[0].city_version)! < city_version!){
                                        citiesValue = 1
                                    }
                                    if((versionDate?[0].library_version)! < library_version!){
                                        librariesValue = 1
                                    }
                                    if((versionDate?[0].sublocation_version)! < sublocation_version!){
                                        sublocationsValue = 1
                                    }
                                }else {
                                    locationValue = 1
                                    addressValue = 1
                                    librariesValue = 1
                                    citiesValue = 1
                                    sublocationsValue = 1
                                }
                                DispatchQueue.main.async { // Make sure you're on the main thread here
                                    //self.updateProgress.progress = 1// 0.10
                                }
                                
                                
                                print("4")
                                if(locationValue == 0 && addressValue == 0 && librariesValue == 0 && citiesValue == 0 && sublocationsValue == 0 && booksValue == 0 && libraryCardValue == 0){
                                    print("5o")
                                    DispatchQueue.main.async { // Make sure you're on the main thread here
                                        //self.updateProgress.progress = 1// 1
                                        //self.updateButton.isHidden = false
                                        //self.updateButton.isEnabled = true
                                    }
                                }
                                else{
                                    
                                    print("6")
                                    self.loadUserData(addressVersion: addressValue, librariesVersion: librariesValue, citiesVersion: citiesValue, locationVersion: locationValue, sublocationVersion: sublocationsValue, booksVersion: booksValue, libraryCardVersion: libraryCardValue, usersDate: usersDate )
                                    
                                    if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (usersDate?[0])!, version_book: version_book!, version_library_card: version_library_card!)){
                                        print("error update data")
                                    }
                                    
                                    if((versionDate!.count) > 0){
                                        if(!DatabaseHandler.updateDataVersions(versionsCoreData: (versionDate?[0])!, address_version: address_version!, city_version: city_version!, library_version: library_version!, location_version: location_version!, sublocation_version: sublocation_version!, updated_at: Date())){
                                            print("error update data")
                                        }
                                    }
                                    else{
                                        if(!DatabaseHandler.saveDataVersions(address_version: address_version!, city_version: city_version!, id: 1, library_version: library_version!, location_version: location_version!, sublocation_version: sublocation_version!, updated_at: Date())){
                                            print("error save to database  version")
                                        }
                                    }
                                }
                            }
                        }
                        DispatchQueue.main.async { // Make sure you're on the main thread here
                            //self.updateButton.isHidden = false
                            //self.updateButton.isEnabled = true
                            //self.infoLabel.text = "ok".localized
                        }
                    }catch{
                        print("Unable to Parse JSON")
                        //self.updateButton.isHidden = false
                        //self.updateButton.isEnabled = true
                        //self.infoLabel.text = "data_update_problem".localized
                    }
                }
            }
            DispatchQueue.main.async { // Make sure you're on the main thread here
                //self.updateButton.isHidden = false
                //self.updateButton.isEnabled = true
                //self.infoLabel.text = "ok".localized
            }
        }
        DispatchQueue.main.async { // Make sure you're on the main thread here
            //self.updateButton.isHidden = false
            //self.updateButton.isEnabled = true
            //self.infoLabel.text = "ok".localized
            //self.updateProgress.progress = 1// 1
        }
        task?.resume()
    }
    
}
