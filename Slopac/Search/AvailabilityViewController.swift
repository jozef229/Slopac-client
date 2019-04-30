//
//  AvailabilityViewController.swift
//  Slopac
//
//  Created by Jozef Varga on 21/12/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

import UIKit

class AvailabilityViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet weak var opacButton: UIButton!
    @IBOutlet weak var borderForName: UILabel!
    @IBOutlet weak var libraryInformationTableView: UITableView!
    @IBOutlet weak var libraryNameLabel: UILabel!
    
    let spinner = UIActivityIndicatorView()
    let loadingView = UIView()
    let loadingLabel = UILabel()
    var bookInformation = [BookInformation]()
    var book: Book?
    var urlLibrary = ""
    var selectBookInformation = BookInformation(address: "", city: "", postal_code: "", latitude: 0.0, longtitude: 0.0, location_name: "", sublocation_name: "", available_books: 0, lent_books: 0, presence_books: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad() //tu by som dal este dole mapu ze kde to je ako obrazok
        setLoadingScreen(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner, tableView: libraryInformationTableView, navigationController: navigationController!, text: "loading".localized)
        print()
        let idForLibrary = book?.library_id
//        print(idForLibrary)
        let libraries = DatabaseHandler.fetchDataLibrariesFromId(id: String((idForLibrary)!))
//        print(libraries)
        urlLibrary = (libraries?[0].library_address)!
        print(urlLibrary)
        
        addLibraryInformation()
        setText()
        setUX()
        
        // Do any additional setup after loading the view.
    }
    
   
    
    func setText(){
        self.navigationItem.title = "availability".localized
        libraryNameLabel.text = book?.library_name
        opacButton.setTitle(" " + "open_opac_library".localized, for: .normal)
        
    }
    func setUX(){
        libraryInformationTableView.backgroundColor = COLOR_THEME
        libraryInformationTableView.delegate = self
        libraryInformationTableView.dataSource = self
        libraryNameLabel.customBoldLabel()
        opacButton.setIconLeft(UIImage(named: "icon_info_white")!)
        borderForName.layer.addBorder(edge: .bottom, color: COLOR_THEME_GREY, thickness: 1.5, shiftY: 0, shiftX: 5, longLeftSide: 0)
//        libraryNameLabel.layer.addBorder(edge: .bottom, color: COLOR_THEME_GREY, thickness: 0.5, shiftY: 5, shiftX: 5, longLeftSide: 0)
//        libraryInformationTableView.addB
//        libraryInformationTableView.layer.borderWidth = 2.0;
//        libraryInformationTableView.layer.borderColor = COLOR_THEME_GREY.cgColor;
//        libraryInformationTableView.layer.bo
//        libraryInformationTableView.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 0, shiftX: 0, longLeftSide: 0)
        
        view.backgroundColor = COLOR_THEME
    }
    
    
    @IBAction func opacButtonClick(_ sender: Any) {
        guard let url = URL(string: urlLibrary) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    func addLibraryInformation(){
        
        let task: URLSessionDataTask?
        guard let url = URL(string: URL_AVAILABILITY_BOOK) else {
            print("Bad Url")
            DispatchQueue.main.async { // Make sure you're on the main thread here
                removeLoadingScreen(loadingView: self.loadingView, loadingLabel: self.loadingLabel, spinner: self.spinner, tableView: self.libraryInformationTableView)
            }
            
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let libraryId = "libraryId"
        let bookId = "bookId"
        let bookIsbn = "isbn"
        print("send to server available ", book?.bookId ?? "" , " ", book?.library_id ?? 0, " ", book?.isbn ?? "")
        
        let postDict : [String: Any] = [bookId: book?.bookId ?? "",
                                        libraryId: book?.library_id ?? 0,
                                        bookIsbn: book?.isbn ?? ""]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
            DispatchQueue.main.async { // Make sure you're on the main thread here
                removeLoadingScreen(loadingView: self.loadingView, loadingLabel: self.loadingLabel, spinner: self.spinner, tableView: self.libraryInformationTableView)
            }
            
            return
        }
        urlRequest.httpBody = postData
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        task = session.dataTask(with: urlRequest){
            data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { // Make sure you're on the main thread here
                    removeLoadingScreen(loadingView: self.loadingView, loadingLabel: self.loadingLabel, spinner: self.spinner, tableView: self.libraryInformationTableView)
                }
                return
            }
            
            if let value = String(data: data, encoding: .utf8){
                if let jsonData = value.data(using: .utf8){
                    do{
                        print(jsonData)
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String : Any]
                        print(json)
                        let bookArray = json["availableBooks"] as? [Dictionary<String, Any>] ?? []
                        for book in bookArray {
                            print(book)
                            
                            let locationAcronym = book["locationAcronym"] as? String ?? ""
                            let sublocationAcronym = book["sublocationAcronym"] as? String ?? ""
                            let lent = book["lent"] as? Int ?? 0
                            let presence = book["presence"] as? Int ?? 0
                            let available = book["available"] as? Int ?? 0
//                            print("asd", book["locationAcronym"])
//                            print("asd", book["available"])
//                            print(" la ",locationAcronym," sa ",sublocationAcronym," l ",lent," p ",presence," a ",available )
                            var idForAddress = Int32(0)
                            
                            var locationsData = DatabaseHandler.fetchDataLibraryLocationsFromAcronym(location_acronym: locationAcronym)
                            var sublocationName = ""
                            
                            if(sublocationAcronym == "" || sublocationAcronym == " "){
                                idForAddress = (locationsData?[0].address_id)!
                                print("location")
                                print(idForAddress)
                                print(locationsData![0])
                            }
                            else{
                                var sublocationsData = DatabaseHandler.fetchDataLibrarySublocationsFromAcronym(sublocation_acronym: sublocationAcronym)
                                sublocationName = (sublocationsData?[0].sublocation_name)!
                                idForAddress = (sublocationsData?[0].address_id)!
                                print("sublocation")
                                print(idForAddress)
                                print(sublocationsData![0])
                            }
                            var addressData = DatabaseHandler.fetchDataAddressFromId(id: String(idForAddress))
//                            print(addressData)
                            print(idForAddress)
                            let cityData = DatabaseHandler.fetchDataCitiesFromId(id: String((addressData?[0].city_id)!))
                            
                            guard let help = BookInformation(
                                address: (addressData?[0].address)!,
                                city: String((cityData?[0].city)!) + ", " + (addressData?[0].country)!,
                                postal_code: (addressData?[0].postal_code)!,
                                latitude: (addressData?[0].latitude)!,
                                longtitude: (addressData?[0].longtitude)!,
                                location_name: (locationsData?[0].location_name)!,
                                sublocation_name: sublocationName,
                                available_books: available,
                                lent_books: lent,
                                presence_books: presence
                                )else {
                                    DispatchQueue.main.async { // Make sure you're on the main thread here
                                        removeLoadingScreen(loadingView: self.loadingView, loadingLabel: self.loadingLabel, spinner: self.spinner, tableView: self.libraryInformationTableView)
                                    }
                                    fatalError("Unable to instantiate book")
                            }
                            
                            print("ahoj")
                            self.bookInformation += [help]
                            
                            print("jejda")
                            //                            self.books.sort{$0.title < $1.title}
                            
                        }
                        
                        
                        self.updateData()
                        
                        print("update")
                        DispatchQueue.main.async { // Make sure you're on the main thread here
                            removeLoadingScreen(loadingView: self.loadingView, loadingLabel: self.loadingLabel, spinner: self.spinner, tableView: self.libraryInformationTableView)
                        }
                        
                    }catch{
                        print("Unable to Parse JSON")
                        DispatchQueue.main.async { // Make sure you're on the main thread here
                            removeLoadingScreen(loadingView: self.loadingView, loadingLabel: self.loadingLabel, spinner: self.spinner, tableView: self.libraryInformationTableView
                            )
                        }
                        
                    }
                }
            }
        }
        task?.resume()
    }
    
    func updateData(){
        DispatchQueue.main.async {
            self.libraryInformationTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookInformation.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "AvailableTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AvailableTableViewCell  else {
            fatalError("The dequeued cell is not an instance of AvailableTableViewCell.")
        }
//        cell.textLabel?.text = LANGUAGES[indexPath.row].name
        cell.backgroundColor = COLOR_THEME
        cell.textLabel?.textColor = COLOR_THEME_WHITE
        let addres2Text = bookInformation[indexPath.row].postal_code + " " + bookInformation[indexPath.row].city
        let availableBookText = "available".localized + ": " + String(bookInformation[indexPath.row].available_books)
        let lentBookText = "lent".localized + ": " + String(bookInformation[indexPath.row].lent_books)
        let presenceBookText = "presence".localized + ": " + String(bookInformation[indexPath.row].presence_books)
        cell.locationNameLabel.customCellTableLabel(text: bookInformation[indexPath.row].location_name)
        cell.sublocationNameLabel.customCellTableLabel(text: bookInformation[indexPath.row].sublocation_name)
        cell.locationNameLabel.font = UIFont.boldSystemFont(ofSize: cell.locationNameLabel.font.pointSize)
        cell.sublocationNameLabel.font = UIFont.boldSystemFont(ofSize: cell.sublocationNameLabel.font.pointSize)
        cell.address1Label.customCellTableLabel(text: bookInformation[indexPath.row].address)
        cell.address2Label.customCellTableLabel(text: addres2Text)
        cell.addressStaticLabel.customCellTableLabel(text: "address".localized)
        cell.addressStaticLabel.customBoldLabel()
        cell.availableLabel.customSmallCellTableLabel(text: availableBookText)
        cell.lentLabel.customSmallCellTableLabel(text: lentBookText)
        cell.presenceLabel.customSmallCellTableLabel(text: presenceBookText)
        cell.cellBookInformation = bookInformation[indexPath.row]
//        cell.showMapButton.setImage(UIImage(named: "icon_map_white"), for: .normal)
        cell.showMapButton.setTitle("", for: .normal)
        cell.showMapButton.setBackgroundImage(UIImage(named: "icon_map_blue"), for: .disabled)
//        cell.showMapButton.bac imageView?.tintColor = UIColor .blue
        
        cell.accessoryType = .disclosureIndicator
//        cell.showMapButton.backgroundColor = UIColor .blue
        cell.showMapButton.isEnabled = false
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectBookInformation = bookInformation[indexPath.row]
        print("oznacena cell;")
        print(indexPath.row)
        print(bookInformation[indexPath.row])
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "ShowMapController":
            guard let mapViewController = segue.destination as? MapViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedAvailabilityCell = sender as? AvailableTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = libraryInformationTableView.indexPath(for: selectedAvailabilityCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            print("----------------------------")
            print(bookInformation[indexPath.row].address)
            print(bookInformation[indexPath.row].available_books)
            print(bookInformation[indexPath.row].longtitude)
            print(bookInformation[indexPath.row].latitude)
            print(bookInformation[indexPath.row].address)
            print(bookInformation[indexPath.row].address)
            mapViewController.latitudeLibrary = bookInformation[indexPath.row].latitude
            mapViewController.longitudeLibrary = bookInformation[indexPath.row].longtitude
            mapViewController.setupTitle = bookInformation[indexPath.row].location_name
            mapViewController.setupSubtitle = bookInformation[indexPath.row].sublocation_name
            print("----------------------------")
            
//            print(selectBookInformation?.location_name)
//            print((selectBookInformation?.latitude)!)
//            print((selectBookInformation?.longtitude)!)
//            mapViewController.latitudeLibrary = (selectBookInformation?.latitude)!
//            mapViewController.longitudeLibrary = (selectBookInformation?.longtitude)!
//            mapViewController.setupTitle = (selectBookInformation?.location_name)!
//            mapViewController.setupSubtitle = (selectBookInformation?.sublocation_name)!
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    

    
}
