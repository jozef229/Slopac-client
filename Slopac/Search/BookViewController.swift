//
//  BookViewController.swift
//  Slopac
//
//  Created by Jozef Varga on 11/11/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

import UIKit
import os.log

//protocol BookDelegate {
//    func sendDataFromBookView(bookDelegateData: BooksCoreData)
//    func sendUpdateDataFromBookView(bookDelegateData: BooksCoreData, updateId: Int32, updatePath: String, updateIsInDatabase: Int16)
//}

class BookViewController: UIViewController, UITextViewDelegate {
    
//    var delegate : BookDelegate?
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var editionLabel: UILabel!
    @IBOutlet weak var publicationPlaceLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var publisherStaticLabel: UILabel!
    @IBOutlet weak var publicationPlaceStaticLabel: UILabel!
    @IBOutlet weak var editionStaticValue: UILabel!
    
    @IBOutlet weak var availabilityButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var authorStaticLabel: UILabel!
    @IBOutlet weak var languageStaticLabel: UILabel!
    @IBOutlet weak var isbnStaticLabel: UILabel!
    @IBOutlet weak var yearStaticLabel: UILabel!
    @IBOutlet weak var descriptionStaticLabel: UILabel!
    @IBOutlet weak var BookScrollView: UIScrollView!
    @IBOutlet weak var BookViewOnScrollView: UIView!
    
    
    
    @IBOutlet weak var addToFavoriteButton: UIButton!
    
    @IBOutlet weak var saveBookBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var languageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var isbnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var yearTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var authorTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var editionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var publisherTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var publicationPlaceConstraint: NSLayoutConstraint!
    
    
    var book: Book?
    var usersData : [UsersCoreData]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersData = DatabaseHandler.fetchDataUsers()!
        setText()
        setUX()
        // Do any additional setup after loading the view.
    }
    
    func setUX(){
        view.backgroundColor = COLOR_THEME
        BookViewOnScrollView.backgroundColor = COLOR_THEME
    
        editionLabel.customLabel()
        publicationPlaceLabel.customLabel()
        publisherLabel.customLabel()
        publisherStaticLabel.customBoldLabel()
        publicationPlaceStaticLabel.customBoldLabel()
        editionStaticValue.customBoldLabel()
        
        titleLabel.customLabel()
        authorLabel.customLabel()
        isbnLabel.customLabel()
        languageLabel.customLabel()
        yearLabel.customLabel()
        availabilityButton.customButton()
        availabilityButton.setIconLeft(UIImage(named: "icon_info_white")!)
        addToFavoriteButton.customButton()
        addToFavoriteButton.setIconLeft(UIImage(named: "icon_heart_white")!)
        descriptionTextView.customTextView()
        authorStaticLabel.customBoldLabel()
        languageStaticLabel.customBoldLabel()
        isbnStaticLabel.customBoldLabel()
        yearStaticLabel.customBoldLabel()
        descriptionStaticLabel.customBoldLabel()
        saveBookBarButtonItem.image = UIImage(named: "icon_share_white")
        
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isEditable = false
        self.descriptionTextView.delegate = self
        bookImageView.backgroundColor = COLOR_THEME_DARK
        bookImageView.contentMode = .scaleAspectFit
    }
    
    func setText() {
        self.navigationItem.title = "detail_of_the_book".localized
 
        availabilityButton.setTitle("availability".localized, for: .normal)
        addToFavoriteButton.setTitle("save_book".localized, for: .normal)
        titleLabel.text = book?.title
//        if(book?.author == "" || book?.author == " "){
//            print("autor nieje")
//            authorTopConstraint.constant = -51
//            authorLabel.isHidden = true
//            authorStaticLabel.isHidden = true
//        }
//        else{
            print("autor je")
            authorStaticLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
            authorTopConstraint.constant = 20
            authorStaticLabel.isHidden = false
            authorLabel.isHidden = false
            authorStaticLabel.text = "author".localized
        
        if(book?.author == "" || book?.author == " "){
            authorLabel.text = "undefined".localized
        }
        else{
            authorLabel.text = book?.author
        }
        
        
//        }
        if(book?.isbn == ""){
            isbnTopConstraint.constant = -51
            isbnLabel.isHidden = true
            isbnStaticLabel.isHidden = true
        }
        else{
            isbnStaticLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
            isbnTopConstraint.constant = 20
            isbnStaticLabel.isHidden = false
            isbnLabel.isHidden = false
            isbnStaticLabel.text = "isbn".localized
            isbnLabel.text = book?.isbn
        }
        
        if(book?.description == ""){
            descriptionTopConstraint.constant = -51
            descriptionStaticLabel.isHidden = true
            descriptionTextView.isHidden = true
        }
        else{
            descriptionStaticLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
            descriptionTopConstraint.constant = 20
            descriptionStaticLabel.isHidden = false
            descriptionTextView.isHidden = false
            descriptionStaticLabel.text = "about_the_book".localized
            descriptionTextView.text = book?.description
        }
        if(book?.language == ""){
            languageTopConstraint.constant = -51
            languageStaticLabel.isHidden = true
            languageLabel.isHidden = true
        }
        else{
            languageStaticLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
            languageTopConstraint.constant = 20
            languageStaticLabel.isHidden = false
            languageLabel.isHidden = false
            languageStaticLabel.text = "language".localized
            languageLabel.text = book?.language
        }
        if(book?.publishYear == ""){
            yearTopConstraint.constant = -51
            yearStaticLabel.isHidden = true
            yearLabel.isHidden = true
        }
        else{
            yearStaticLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
            yearTopConstraint.constant = 20
            yearStaticLabel.isHidden = false
            yearLabel.isHidden = false
            yearStaticLabel.text = "publish_year".localized
            yearLabel.text = book?.publishYear
        }
        
        
        
        if(book?.edition == ""){
            editionTopConstraint.constant = -51
            editionStaticValue.isHidden = true
            editionLabel.isHidden = true
        }
        else{
            editionStaticValue.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
            editionTopConstraint.constant = 20
            editionStaticValue.isHidden = false
            editionLabel.isHidden = false
            editionStaticValue.text = "edition".localized
            editionLabel.text = book?.edition
        }
        if(book?.publisher == ""){
            publisherTopConstraint.constant = -51
            publisherStaticLabel.isHidden = true
            publisherLabel.isHidden = true
        }
        else{
            publisherStaticLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
            publisherTopConstraint.constant = 20
            publisherStaticLabel.isHidden = false
            publisherLabel.isHidden = false
            publisherStaticLabel.text = "publisher".localized
            publisherLabel.text = book?.publisher
        }
        if(book?.publicationPlace == ""){
            publicationPlaceConstraint.constant = -51
            publicationPlaceStaticLabel.isHidden = true
            publicationPlaceLabel.isHidden = true
        }
        else{
            publicationPlaceStaticLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
            publicationPlaceConstraint.constant = 20
            publicationPlaceStaticLabel.isHidden = false
            publicationPlaceLabel.isHidden = false
            publicationPlaceStaticLabel.text = "publish_place".localized
            publicationPlaceLabel.text = book?.publicationPlace
        }
    
        if((book?.image) == nil){
            bookImageView.image = UIImage(named: "default_photo_book_1")
        }
        else{
            imageRotate(imagePhoto: (book?.image)!)
        }
        
    }
    
    func imageRotate(imagePhoto: UIImage){
        if(imagePhoto.size.width > imagePhoto.size.height){
            bookImageView.image = imagePhoto.rotate(radians: .pi/2)
        }else{
            bookImageView.image = imagePhoto
        }
    }
    
    
    @IBAction func saveButtonClick(_ sender: Any) {
        if(bookImageView.image == nil || bookImageView.image == UIImage(named: "default_photo_book_1")){
            insertBook(title_data: (book?.title)!, author_data: (book?.author)!, notes_data: (book?.description)!, feedback_data: 0, language_data: (book?.language)!, year_data: (book?.publishYear)!, edition_data: (book?.edition)!, publisher_data: (book?.publisher)!, publication_data: (book?.publicationPlace)!, isbn_data: (book?.isbn)!, tags: (book?.tags)!)
        }
        else{
            insertBookWithImage(imagePhoto: bookImageView.image!, title_data: (book?.title)!, author_data: (book?.author)!, notes_data: (book?.description)!, feedback_data: 0, isbn_data: (book?.isbn)!, language_data: (book?.language)!, year_data: (book?.publishYear)!, edition_data: (book?.edition)!, publisher_data: (book?.publisher)!, publication_data: (book?.publicationPlace)!, tags: (book?.tags)!)
        }
        self.alert(message: "alert_save_to_favorite_message".localized, title: "alert_save_to_favorite_title".localized, buttonTitle: "alert_save_to_favorite_button".localized)
    }
    @IBAction func saveBarButtonClick(_ sender: Any) {
        let initValue = "share_book".localized
        let title1 = "title".localized + " :"
        let title2 = book?.title ?? "undefined".localized
        let newLine = "\n"
        let newDoubleLine = "\n\n"
        var text = initValue + newDoubleLine + title1 + newLine + title2 + newDoubleLine
        
        
        //        shareAll.
        if(book?.author != ""){
            let author1 = "author".localized + " :"
            let author2 = book?.author ?? "undefined".localized
            text = text + author1 + newLine + author2 + newDoubleLine
        }
        if(book?.isbn != ""){
            let isbn1 = "isbn".localized + " :"
            let isbn2 = book?.isbn ?? "undefined".localized
            text = text + isbn1 + newLine + isbn2 + newDoubleLine
        }
        if(book?.language != ""){
            let language1 = "language".localized + " :"
            let language2 = book?.language ?? "undefined".localized
            text = text + language1 + newLine + language2 + newDoubleLine
        }
        if(book?.publisher != ""){
            let publisher1 = "publisher".localized + " :"
            let publisher2 = book?.publisher ?? "undefined".localized
            text = text + publisher1 + newLine + publisher2 + newDoubleLine
        }
        
        if(book?.publicationPlace != ""){
            let publish_place1 = "publish_place".localized + " :"
            let publish_place2 = book?.publicationPlace ?? "undefined".localized
            text = text + publish_place1 + newLine + publish_place2 + newDoubleLine
        }
        if(book?.edition != ""){
            let edition1 = "edition".localized + " :"
            let edition2 = book?.edition ?? "undefined".localized
            text = text + edition1 + newLine + edition2 + newDoubleLine
        }
        if(book?.publishYear != ""){
            let publish_year1 = "publish_year".localized + " :"
            let publish_year2 = book?.publishYear ?? "undefined".localized
            text = text + publish_year1 + newLine + publish_year2 + newDoubleLine
        }
        if(book?.description != ""){
            let notes1 = "notes".localized + " :"
            let notes2 = book?.description ?? "undefined".localized
            text = text + notes1 + newLine + notes2 + newDoubleLine
        }
        
        let shareAll = [text] as [Any]
        
        print(shareAll)
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func insertBookWithImage(imagePhoto: UIImage, title_data: String, author_data: String, notes_data: String, feedback_data: Int, isbn_data: String, language_data: String, year_data: String, edition_data: String, publisher_data: String, publication_data: String, tags: Int16 ){
        CHANGE_FAVORITE_BOOK = true
        var updateIsInDatabase = WITHOUT_SAVE_WITH_PICTURE_DATABASE
        var bookCoreData: BooksCoreData?
        if((usersData?.count)! < 1){
            bookCoreData = DatabaseHandler.saveDataBooksWithPictureReturn(author: author_data, cover: imagePhoto, cover_path: "", feedback: Int16(feedback_data), id: -1, isbn: isbn_data, notes: notes_data, title: title_data, user_id: -1, language: language_data, year: year_data, edition: edition_data, publisher: publisher_data, publication: publication_data, tags: tags, isInDatabase: Int16(updateIsInDatabase))
            //            if(!DatabaseHandler.saveDataBooksWithPicture(author: author_data, cover: imagePhoto, cover_path: "", feedback: Int16(feedback_data), id: -1, isbn: isbn_data, notes: notes_data, title: title_data, user_id: -1, isInDatabase: Int16(self.updateIsInDatabase))){
            //                print("error create library card")
            //            }
            return
        }
        else{
            bookCoreData = DatabaseHandler.saveDataBooksWithPictureReturn(author: author_data, cover: imagePhoto, cover_path: "", feedback: Int16(feedback_data), id: -1, isbn: isbn_data, notes: notes_data, title: title_data, user_id: (usersData?[0].id)!, language: language_data, year: year_data, edition: edition_data, publisher: publisher_data, publication: publication_data, tags: tags, isInDatabase: Int16(updateIsInDatabase))
            //            if(!DatabaseHandler.saveDataBooksWithPicture(author: author_data, cover: imagePhoto, cover_path: "", feedback: Int16(feedback_data), id: -1, isbn: isbn_data, notes: notes_data, title: title_data, user_id: (usersData?[0].id)!, isInDatabase: Int16(self.updateIsInDatabase))){
            //                print("error create library card")
            //            }
//            callDelegateSendData()
        }
        let myUrl = NSURL(string: URL_UPDATE_FILE_WITH_PICTURE);
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        let param = [
            "uploadType"  : "4",
            "user_id"     : String(usersData?[0].id ?? 0),
            "title"       : title_data,
            "author"      : author_data,
            "isbn"        : isbn_data,
            "notes"       : notes_data,
            "feedback"    : String(feedback_data),
            "language"    : language_data,
            "year"        : year_data,
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
        let imageData = bookImageView.image?.jpegData(compressionQuality: 0.50)
        if(imageData==nil)  {
            return
        }
        request.httpBody = createBodyWithParameters(parameters: (param), filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        print("3")
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            guard let data = data, error == nil else {
                return
            }
            print("4")
            if let value = String(data: data, encoding: .utf8){
                print("5")
                if let jsonData = value.data(using: .utf8){
                    do{
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                        print(json)
                        let version = json["data"] as? Dictionary<String, Any> ?? [:]
                        let picture = json["picture"] as? Dictionary<String, Any> ?? [:]
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let versionTime = dateFormatter.date(from: version["versionTime"] as? String ?? "")
                        let updateId = version["id"] as? Int32 ?? 0
                        updateIsInDatabase = OK_DATABASE
                        let updatePath = picture["imageName"] as?  String ?? ""
                        if(!DatabaseHandler.updateDataBooksWithPictureIdDatabaseTypeAndPicturePath(booksCoreData: bookCoreData!, id: updateId, cover_path: updatePath, isInDatabase: Int16(updateIsInDatabase))){
                            os_log("Error updateDataLibraryCardDatabaseType", log: OSLog.default, type: .debug)
                        }
                        
                        
                        //                        if(!DatabaseHandler.saveDataBooksWithPicture(author: author_data, cover: imagePhoto, cover_path: self.updatePath, feedback: Int16(feedback_data), id: self.updateId, isbn: isbn_data, notes: notes_data, title: title_data, user_id: (self.usersData?[0].id)!, isInDatabase: Int16(self.updateIsInDatabase))){
                        //                            print("error create library card")
                        //                        }
                        if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (self.usersData?[0])!, version_book: (self.usersData?[0].version_book)!, version_library_card: versionTime!)){
                            print("error update user")
                        }
                        bookCoreData?.id = updateId
                        bookCoreData?.isInDatabase = Int16(updateIsInDatabase)
                        bookCoreData?.cover_path = updatePath
//                        callDelegateSendUpdateData()
                    }catch{
                        print("Unable to Parse JSON")
                    }
                }
            }
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
    
    
    func insertBook(title_data: String, author_data: String, notes_data: String, feedback_data: Int, language_data: String, year_data: String, edition_data: String, publisher_data: String, publication_data: String, isbn_data: String, tags: Int16){
        CHANGE_FAVORITE_BOOK = true
//        var updateIsInDatabase = -1
        var updateIsInDatabase = WITHOUT_SAVE_DATABASE
        var bookCoreData: BooksCoreData?
        if((usersData?.count)! < 1){
            print("without userData")
            bookCoreData = DatabaseHandler.saveDataBooksReturn(author: author_data, cover_path: "", feedback: Int16(feedback_data), id: -1, isbn: isbn_data, notes: notes_data, title: title_data, user_id: -1, language: language_data, year: year_data, edition: edition_data, publisher: publisher_data, publication: publication_data, tags: tags, isInDatabase: Int16(updateIsInDatabase))
//            callDelegateSendData()
            return
        }
        else{
            print("with userData")
            bookCoreData = DatabaseHandler.saveDataBooksReturn(author: author_data, cover_path: "", feedback: Int16(feedback_data), id: -1, isbn: isbn_data, notes: notes_data, title: title_data, user_id: (usersData?[0].id)!, language: language_data, year: year_data, edition: edition_data, publisher: publisher_data, publication: publication_data, tags: tags, isInDatabase: Int16(updateIsInDatabase))
            
//            callDelegateSendData()
        }
        let task: URLSessionDataTask?
        guard let url = URL(string: URL_UPDATE_FILE) else {
            print("Bad Url")
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
        let postDict : [String: Any] = [uploadType: 2,
                                        user_id: usersData?[0].id ?? 0,
                                        title: title_data,
                                        author: author_data,
                                        isbn: isbn_data,
                                        notes: notes_data,
                                        feedback: feedback_data]
        print("postDic")
        print(postDict)
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
                        print("aaaaaaaaaaaaaaaaa")
                        print(json)
                        print("aaaaaaaaaaaaaaaaa")
                        let version = json["data"] as? Dictionary<String, Any> ?? [:]
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let versionTime = dateFormatter.date(from: version["versionTime"] as? String ?? "")
                        let updateId = version["id"] as? Int32 ?? 0
                        updateIsInDatabase = OK_DATABASE
                        
                        if(!DatabaseHandler.updateDataBooksDatabaseTypeAndId(booksCoreData: bookCoreData!, isInDatabase: Int16(updateIsInDatabase), id: updateId)){
                            os_log("Error updateDataLibraryCardDatabaseTypeAndId", log: OSLog.default, type: .debug)
                        }
                        if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (self.usersData?[0])!, version_book: (self.usersData?[0].version_book)!, version_library_card: versionTime!)){
                            print("error update user")
                        }
//                        book?.id = updateId
//                        book?.isInDatabase = Int16(updateIsInDatabase)
//                        self.callDelegateSendUpdateData()
                    }catch{
                        print("Unable to Parse JSON")
                    }
                }
            }
        }
        task?.resume()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == "AvailableShowDetail"){
            if !InternetTest.isConnectedToNetwork(){
                self.alert(message: "alert_internet_message".localized, title: "alert_internet_title".localized, buttonTitle: "alert_internet_button".localized)
                return false
            }
            else {
                return true
            }
        }
        else{
            return false
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "AvailableShowDetail":
            guard let availableViewController = segue.destination as? AvailabilityViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            availableViewController.book = book
            
            //            let vc : EditLibraryCardViewController = segue.destination as! EditLibraryCardViewController
        //            vc.delegate = self
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
}
