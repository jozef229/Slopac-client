//
//  SaveBookTableViewController.swift
//  Slopac
//
//  Created by Jozef Varga on 15/12/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

import UIKit
import os.log

class SaveBookTableViewController: UITableViewController, EditBookDelegate, ShowBookDelegate {
    
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    
//    var updateIsInDatabase = -1
//    var book: BooksCoreData?
//    var updateId = Int32(0)
//    var updatePath = ""
//
//    func sendSaveDataBookFromSearch(sendBook: Book, sendUser: [UsersCoreData]){
//        insertBookWithUser(sendUser: sendUser, title_data: sendBook.title, author_data: sendBook.author, notes_data: sendBook.description, feedback_data: 0, isbn_data: sendBook.isbn)
//        print("ale blbost vyskocila ako ma")
//    }
//
//    func insertBookWithUser(sendUser: [UsersCoreData],title_data: String, author_data: String, notes_data: String, feedback_data: Int, isbn_data: String){
//
//        self.updateIsInDatabase = WITHOUT_SAVE_DATABASE
//        if((sendUser.count) < 1){
//            print("without userData")
//            book = DatabaseHandler.saveDataBooksReturn(author: author_data, cover_path: "", feedback: Int16(feedback_data), id: -1, isbn: isbn_data, notes: notes_data, title: title_data, user_id: -1, isInDatabase: Int16(self.updateIsInDatabase))
//            self.bookData?.append(book!)
//            updateData()
//            return
//        }
//        else{
//            print("with userData")
//            book = DatabaseHandler.saveDataBooksReturn(author: author_data, cover_path: "", feedback: Int16(feedback_data), id: -1, isbn: isbn_data, notes: notes_data, title: title_data, user_id: (sendUser[0].id), isInDatabase: Int16(self.updateIsInDatabase))
//
//            self.bookData?.append(book!)
//            updateData()
//        }
//        let task: URLSessionDataTask?
//        guard let url = URL(string: URL_UPDATE_FILE) else {
//            print("Bad Url")
//            return
//        }
//        let sessionConfig = URLSessionConfiguration.default
//        sessionConfig.httpAdditionalHeaders = ["Authorization": "Bearer " + (usersData?[0].auth)!]
//
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "POST"
//
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
//        let uploadType = "uploadType"
//        let user_id = "user_id"
//        let title = "title"
//        let author = "author"
//        let isbn = "isbn"
//        let notes = "notes"
//        let feedback = "feedback"
//        let postDict : [String: Any] = [uploadType: 2,
//                                        user_id: usersData?[0].id ?? 0,
//                                        title: title_data,
//                                        author: author_data,
//                                        isbn: isbn_data,
//                                        notes: notes_data,
//                                        feedback: feedback_data]
//        print("postDic")
//        print(postDict)
//        guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
//            return
//        }
//        urlRequest.httpBody = postData
//        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
//        task = session.dataTask(with: urlRequest){
//            data, response, error in
//            guard let data = data, error == nil else {
//
//                return
//            }
//
//            if let value = String(data: data, encoding: .utf8){
//                if let jsonData = value.data(using: .utf8){
//                    do{
//                        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
//                        print(json)
//
//                        let version = json["data"] as? Dictionary<String, Any> ?? [:]
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//                        let versionTime = dateFormatter.date(from: version["versionTime"] as? String ?? "")
//                        self.updateId = version["id"] as? Int32 ?? 0
//                        self.updateIsInDatabase = OK_DATABASE
//
//                        if(!DatabaseHandler.updateDataBooksDatabaseTypeAndId(booksCoreData: self.book!, isInDatabase: Int16(self.updateIsInDatabase), id: self.updateId)){
//                            os_log("Error updateDataLibraryCardDatabaseTypeAndId", log: OSLog.default, type: .debug)
//                        }
//                        if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: sendUser[0], version_book: self.usersData![0].version_book!, version_library_card: versionTime!)){
//                            print("error update user")
//                        }
//                        self.book?.id = self.updateId
//                        self.book?.isInDatabase = Int16(self.updateIsInDatabase)
//                        self.bookData?.append(self.book!)
//                        self.updateData()
//                    }catch{
//                        print("Unable to Parse JSON")
//                    }
//                }
//            }
//        }
//        task?.resume()
//    }
    
    func sendDataFromDetail(bookDelegateData: BooksCoreData, isFromShowing: Bool) {
        DispatchQueue.main.async {
            if(isFromShowing == true){
                let index = self.bookData?.index(where: { $0.uuid == bookDelegateData.uuid })
                self.bookData![index!] = bookDelegateData
            }
            else{
                self.bookData?.append(bookDelegateData)
            }
        }
        updateData()
    }
    
    var bookData : [BooksCoreData]?
    var usersData : [UsersCoreData]?
    
    var noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    
    func sendData(bookDelegateData: BooksCoreData, isFromShowing: Bool) {
        DispatchQueue.main.async {
            if(isFromShowing == true){
                let index = self.bookData?.index(where: { $0.uuid == bookDelegateData.uuid })
                self.bookData![index!] = bookDelegateData
            }
            else{
                self.bookData?.append(bookDelegateData)
            }
        }
        updateData()
        if(isFromShowing == false){
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func sendUpdateData(bookDelegateData: BooksCoreData, updateId: Int32, updatePath: String, updateIsInDatabase: Int16) {
        let index = self.bookData?.index(where: { $0.uuid == bookDelegateData.uuid })
        self.bookData![index!].id = updateId
        self.bookData![index!].cover_path = updatePath
        self.bookData![index!].isInDatabase = updateIsInDatabase
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.leftBarButtonItem = editButtonItem
        usersData = DatabaseHandler.fetchDataUsers()!
        setUX()
        setText()
        loadBook()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(CHANGE_FAVORITE_BOOK == true){
            
            if((bookData) != nil){
                bookData?.removeAll()
            }
            if((usersData) != nil){
                usersData?.removeAll()
            }
            loadBook()
            CHANGE_FAVORITE_BOOK = false
        }
    }
    
    @IBAction func editClick(_ sender: Any) {
        if(self.tableView.isEditing == true){
            self.tableView.isEditing = false
        }
        else{
            self.tableView.isEditing = true
        }
    
    }
    //    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated) // No need for semicolon
//
//        usersData?.removeAll()
//        usersData = DatabaseHandler.fetchDataUsers()!
//        setText()
//        loadBook()
//    }
    
    
    
    func setUX(){
        self.tableView.rowHeight = UITableView.automaticDimension
        view.backgroundColor = COLOR_THEME
        editBarButtonItem.image = UIImage(named: "icon_edit_white")
        noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.text          = "no_favorete_book".localized
        noDataLabel.customLabel()
        noDataLabel.textAlignment = .center
        tableView.backgroundView  = noDataLabel
        
        
    }
    
    func setText(){
        self.navigationItem.title = "favorite_books".localized
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
//        var numOfSections: Int = 0
        if (bookData?.count)! > 0
        {
            tableView.separatorStyle = .singleLine
            noDataLabel.isHidden = true
//            numOfSections            = 1
////            tableView.backgroundView = nil
        }
        else
        {
            tableView.separatorStyle  = .none
            noDataLabel.isHidden = false
        }
//        return numOfSections
        
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (bookData?.count)!
    }
    
    
    
    
   
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SaveBookTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SaveBookTableViewCell  else {
            fatalError("The dequeued cell is not an instance of SaveBookTableViewCell.")
        }
        // Fetches the appropriate meal for the data source layout.
        let favorite = bookData?[indexPath.row]
        cell.backgroundColor = COLOR_THEME
        cell.authorLabel.customSmallCellTableLabel(text: (favorite?.author)!)
        cell.titleLabel.customCellTableLabel(text: (favorite?.title)!)
        cell.bookImageView.backgroundColor = COLOR_THEME_DARK
//        cell.bookImageView.tintColor = COLOR_THEME //COLOR_THEME_DARK
        cell.bookImageView.contentMode = .scaleAspectFit
//        cell.bookImageView.backgroundColor = COLOR_THEME_DARK
        cell.accessoryType = .disclosureIndicator
        
        if(favorite?.tags == 0){
            cell.tagLabel.isHidden = true
            cell.tagImageView.isHidden = true
        }
        else if(favorite?.tags == 1){
            cell.tagLabel.isHidden = false
            cell.tagImageView.isHidden = false
            cell.tagImageView.image = UIImage(named: "icon_tags_white")
            cell.tagLabel.customTagLabel()
            cell.tagLabel.text = "i_will_read".localized
            cell.tagImageView.image = cell.tagImageView.image!.imageWithColor(color: RED)
        }
        else if(favorite?.tags == 2){
            cell.tagLabel.isHidden = false
            cell.tagImageView.isHidden = false
            cell.tagImageView.image = UIImage(named: "icon_tags_white")
            cell.tagLabel.customTagLabel()
            cell.tagLabel.text = "i_reading".localized
            cell.tagImageView.image = cell.tagImageView.image!.imageWithColor(color: ORANGE)
        }
        else if(favorite?.tags == 3){
            cell.tagLabel.isHidden = false
            cell.tagImageView.isHidden = false
            cell.tagImageView.image = UIImage(named: "icon_tags_white")
            cell.tagLabel.customTagLabel()
            cell.tagLabel.text = "read_on".localized
            cell.tagImageView.image = cell.tagImageView.image!.imageWithColor(color: GREEN)
        }
        
        
        
        
        
        cell.selectionStyle = .none
        if((favorite?.cover?.isEmpty) ?? true){
            cell.bookImageView.image = UIImage(named: "default_photo_book_1")
//            cell.bookImageView.backgroundColor = COLOR_THEME_DARK/
            
        }
        else{
            print("nacitavam obrazok cislo xxx")
            cell.bookImageView.image = imageRotate(imagePhoto: UIImage(data:(favorite?.cover)!,scale:1.0)!)
            
        }
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func imageRotate(imagePhoto: UIImage) -> UIImage{
        if(imagePhoto.size.width > imagePhoto.size.height){
            return imagePhoto.rotate(radians: .pi/2)!
        }else{
            return imagePhoto
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            deleteFavoriteBook(book: (bookData?[indexPath.row])!, usersDate: usersData)
            bookData?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func updateData(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadBook(){
        bookData = DatabaseHandler.fetchDataBookWithoutDelete()!
        if((bookData?.count)! > 0){
            updateData()
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddBookItem":
            guard let bookEditViewController = segue.destination as? EditBookViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            bookEditViewController.usersData = usersData
            //            libraryCardEditViewController.isChangePhoto = false
            bookEditViewController.delegate = self
            
            os_log("Adding a new card.", log: OSLog.default, type: .debug)
            
        case "ShowBookDetail":
            guard let FavoriteBookDetailViewController = segue.destination as? ShowFavoriteBookViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedBookCell = sender as? SaveBookTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedBookCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedBook = bookData?[indexPath.row]
            FavoriteBookDetailViewController.favoriteBook = selectedBook
            FavoriteBookDetailViewController.usersData = usersData
            FavoriteBookDetailViewController.delegate = self
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    func deleteFavoriteBook(book: BooksCoreData?, usersDate: [UsersCoreData]?){
        if((usersData?.count)! < 1){
            print("without userData")
            if(!DatabaseHandler.deleteDataBooks(books: book!)){
                os_log("Error deleteDataLibraryCard", log: OSLog.default, type: .debug)
            }
            return
        }
        else{
            print("with userData")
            if(!DatabaseHandler.updateDataBooksDatabaseType(booksCoreData: book!, isInDatabase: Int16(DELTETE)) ){
                os_log("Error updateDataLibraryCardDatabaseType", log: OSLog.default, type: .debug)
            }
        }
        let task: URLSessionDataTask?
        guard let url = URL(string: URL_BOOK_DELETE) else {
            print("Bad Url")
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
//                if(!DatabaseHandler.updateDataBooksDatabaseType(booksCoreData: book!, isInDatabase: 4)){
//                    print("update problem")
//                }
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
                        print("Unable to Parse JSON")
                    }
                }
            }
        }
        task?.resume()
    }
    
}
