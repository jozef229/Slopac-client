//
//  BookTableViewController.swift
//  Slopac
//
//  Created by Jozef Varga on 10/11/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

import UIKit
import os.log


class BookTableViewController: UITableViewController {
    
    
    //MARK: Properties
    
    //    var books: [Book] = []
    var books = [Book]()
    var passedAuthor = ""
    var passedTitle = ""
    var passedIsbn = ""
    var fromNumber = 0
    var totalResult = 0
    var semaphore = false
//    var selectLibraryId = 0
    var showImage = true
//    var indicator = UIActivityIndicatorView()
    let spinner = UIActivityIndicatorView()
    let loadingView = UIView()
    
    let loadingLabel = UILabel()
    var noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("poslane1")
        print(passedTitle)
        print("poslane2")
        setText()
        setUX()
        loadBooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        indicator.startAnimating()
//        indicator.backgroundColor = UIColor.white
    }
    
    
    
//    private func setLoadingScreen() {
//
//        // Sets the view which contains the loading text and the spinner
//        let width: CGFloat = 120
//        let height: CGFloat = 30
//        let x = (tableView.frame.width / 2) - (width / 2)
//        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
//        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
//        loadingView.backgroundColor = COLOR_THEME_DARK
//        loadingView.isHidden = false
//        loadingView.layer.cornerRadius = 5
//
//        // Sets loading text
//        loadingLabel.textColor = .gray
//        loadingLabel.textAlignment = .center
//        loadingLabel.text = "Loading..."
//        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
//
//        // Sets spinner
//        spinner.style = .gray
//        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        spinner.startAnimating()
//
//        // Adds text and spinner to the view
//        loadingView.addSubview(spinner)
//        loadingView.addSubview(loadingLabel)
//        tableView.isUserInteractionEnabled = false
//        tableView.addSubview(loadingView)
//
//    }
    
//    // Remove the activity indicator from the main view
//    private func removeLoadingScreen() {
//        spinner.stopAnimating()
//        spinner.isHidden = true
//        loadingLabel.isHidden = true
//        loadingView.isHidden = true
//        tableView.isUserInteractionEnabled = true
//    }
    
    func setUX(){
        self.tableView.rowHeight = UITableView.automaticDimension
        view.backgroundColor = COLOR_THEME
        noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.text = ""
        noDataLabel.customLabel()
        noDataLabel.textAlignment = .center
        tableView.backgroundView  = noDataLabel
    }
    
    
    func setText(){
        self.navigationItem.title = "found_books".localized
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //        var numOfSections: Int = 0
        if books.count > 0
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
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "BookTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BookTableViewCell  else {
            fatalError("The dequeued cell is not an instance of BookTableViewCell.")
        }
        // Fetches the appropriate meal for the data source layout.
        let book = books[indexPath.row]
        
        print(book.title)
        
        cell.backgroundColor = COLOR_THEME
        cell.selectionStyle = .none
        cell.titleLabel.customCellTableLabel(text: book.title)
        if(showImage == true){
            cell.bookImageView.backgroundColor = COLOR_THEME_DARK
            cell.bookImageView.contentMode = .scaleAspectFit
            cell.bookImageView.loadPicture(isbn: book.isbn)
        }
        else{
            cell.bookImageView.isHidden = true
            cell.hiddenImage()
//            cell.bookImageView.frame.size.width = 0.0
//            cell.bookImageView.frame.size.height = 0.0
        }
         //.image = book.image
        cell.authorLabel.customSmallCellTableLabel(text: book.author) //.customCellTableLabel(text: book.author)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func updateData(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "ShowDetailBook":
            guard let bookDetailViewController = segue.destination as? BookViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedBookCell = sender as? BookTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "sad")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedBookCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            books[indexPath.row].image = selectedBookCell.bookImageView.image
            let selectedBook = books[indexPath.row]
            bookDetailViewController.book = selectedBook
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "asd")")
        }
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//
//        //        let lastElement = dataSource.count - 1
////        if !loadingData && indexPath.row == lastElement {
////            indicator.startAnimating()
////            loadingData = true
////            loadMoreData()
////        }
//    }
    
//
//    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        let lastElement = dataSource.count - 1
//        if indexPath.row == lastElement {
//            // handle your logic here to get more items, add it to dataSource and reload tableview
//        }
//    }
    
    
    
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if(fromNumber >= totalResult && semaphore == true){
//            print("from ", fromNumber, " total ", totalResult)
//            let height = scrollView.frame.size.height
//            let contentYoffset = scrollView.contentOffset.y
//            let distanceFromBottom = scrollView.contentSize.height - contentYoffset
//            if distanceFromBottom < height {
//                semaphore = false
//                loadBooks()
//
//                print(" you reached end of the table")
//            }
//        }
//    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == books.count - 1 {
            // we are at last cell load more content
            
            if(fromNumber < totalResult && semaphore == true){
                print("from ", fromNumber, " total ", totalResult)
                
                semaphore = false
                loadBooks()
                
                print(" you reached end of the table")
            
            }
            
            print("ahoj")
        }
    }
    
    
    func loadBooks(){
        setLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner, tableView: tableView, navigationController: navigationController!, text: "loading".localized)
        print(books.count)
        if(passedAuthor == "" && passedTitle == "" && passedIsbn == ""){
            DispatchQueue.main.async {
                removeLoadingScreen(loadingView: self.loadingView, loadingLabel: self.loadingLabel, spinner: self.spinner, tableView: self.tableView)
                self.noDataLabel.text = "no_books".localized
            }
            return;
        }
        let task: URLSessionDataTask?
        guard let url = URL(string: URL_SEARCH_BOOKS_FROM_LIBRARY) else {
            print("Bad Url")
            DispatchQueue.main.async {
                removeLoadingScreen(loadingView: self.loadingView, loadingLabel: self.loadingLabel, spinner: self.spinner, tableView: self.tableView)
                self.noDataLabel.text = "no_books".localized
            }
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let author = "author"
        let title = "title"
        let isbn = "isbn"
        let from = "from"
        let count = "count"
        let library = "library"
        let postDict : [String: Any] = [author: passedAuthor,
                                        title: passedTitle,
                                        isbn: passedIsbn,
                                        from: fromNumber,
                                        count: COUNT_LOAD_BOOKS,
                                        library: LIBRARY_ID_SELECT_FOR_SEARCH]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
            DispatchQueue.main.async {
                removeLoadingScreen(loadingView: self.loadingView, loadingLabel: self.loadingLabel, spinner: self.spinner, tableView: self.tableView)
                self.noDataLabel.text = "no_books".localized
            }
            return
        }
        urlRequest.httpBody = postData
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        task = session.dataTask(with: urlRequest){
            data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { // Make sure you're on the main thread here
                    removeLoadingScreen(loadingView: self.loadingView, loadingLabel: self.loadingLabel, spinner: self.spinner, tableView: self.tableView)
                    self.noDataLabel.text = "no_books".localized
                }
                return
            }
            
            if let value = String(data: data, encoding: .utf8){
                if let jsonData = value.data(using: .utf8){
                    do{
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String : Any]
                        let bookArray = json["books"] as? [Dictionary<String, Any>] ?? []
                        let image = UIImage(named: "default_photo_book_1")
                        for book in bookArray {
                         
                            let EditionData = book["Edition"] as? String ?? ""
                            let PublisherData = book["Publisher"] as? String ?? ""
                            let Publication_placeData = book["Publication_place"] as? String ?? ""
                            let imageData = image
                            let bookIdData = book["Id"] as? String ?? ""
                            let titleData = book["Title"] as? String ?? ""
                            let authorData = book["Author"] as? String ?? ""
                            let publishYearData = book["Publication_date"] as? String ?? "" 
                            let descriptionData = book["Note"] as? String ?? ""
                            let languageData = book["Language"] as? String ?? ""
                            let isbnData = book["Isbn"] as? String ?? ""
                            let tagsData = book["tags"] as? Int16 ?? 0
                            guard let help = Book(
                                image: imageData,
                                bookId: bookIdData,
                                title: titleData,
                                author: authorData,
                                publishYear: publishYearData,
                                totalResult: "",
                                description: descriptionData,
                                language: languageData,
                                isbn: isbnData,
                                edition: EditionData,
                                publisher: PublisherData,
                                publicationPlace: Publication_placeData,
                                library_name: LIBRARY_NAME_SELECT_FOR_SEARCH,
                                library_id: LIBRARY_ID_SELECT_FOR_SEARCH,
                                tags: tagsData
                                )else {
                                    DispatchQueue.main.async { // Make sure you're on the main thread here
                                        removeLoadingScreen(loadingView: self.loadingView, loadingLabel: self.loadingLabel, spinner: self.spinner, tableView: self.tableView)
                                        self.noDataLabel.text          = "no_books".localized
                                    }
                                    fatalError("Unable to instantiate book")
                            }
                            self.books += [help]
//                            self.books.sort{$0.title < $1.title}
                            
                        }
                        
                        self.totalResult = json["dataCount"]  as? Int ?? 0
                        self.fromNumber += Int(COUNT_LOAD_BOOKS)!
                        print(self.totalResult)
                        self.updateData()
                        self.semaphore = true
                        DispatchQueue.main.async { // Make sure you're on the main thread here
                            removeLoadingScreen(loadingView: self.loadingView, loadingLabel: self.loadingLabel, spinner: self.spinner, tableView: self.tableView)
                            self.noDataLabel.text          = "no_books".localized
                        }
                        
                    }catch{
                        DispatchQueue.main.async { // Make sure you're on the main thread here
                            removeLoadingScreen(loadingView: self.loadingView, loadingLabel: self.loadingLabel, spinner: self.spinner, tableView: self.tableView)
                            self.noDataLabel.text          = "no_books".localized
                        }
                        print("Unable to Parse JSON")
                    }
                }
            }
        }
        task?.resume()
    }
    
    
}
