//
//  LibraryCardTableViewController.swift
//  Slopac
//
//  Created by Jozef Varga on 15/12/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

import UIKit
//import Foundation
import CoreLocation
import os.log

class LibraryCardTableViewController: UITableViewController, EditLibraryCardDelegate, ShowLibraryCardDelegate {
    
    
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    
    func sendDataFromDetail(libraryCardDelegateData: LibraryCardCoreData, isFromShowing: Bool) {
        DispatchQueue.main.async {
            if(isFromShowing == true){
                let index = self.cardData?.index(where: { $0.uuid == libraryCardDelegateData.uuid })
                self.cardData![index!] = libraryCardDelegateData
            }
            else{
                self.cardData?.append(libraryCardDelegateData)
            }
        }
        updateData()
        print("sendDataFromDetail")
        print("////////////////////////////////////////")
//        print(libraryCardDelegateData)
//        if(isFromShowing == false){
//            print("isFromShowing")
//            _ = navigationController?.popViewController(animated: true)
//        }
    }
    
    
    
    var noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    var cardData : [LibraryCardCoreData]?
    var usersData : [UsersCoreData]?
    
    func sendData(libraryCardDelegateData: LibraryCardCoreData, isFromShowing: Bool) {
        DispatchQueue.main.async {
            if(isFromShowing == true){
                let index = self.cardData?.index(where: { $0.uuid == libraryCardDelegateData.uuid })
                self.cardData![index!] = libraryCardDelegateData
            }
            else{
                self.cardData?.append(libraryCardDelegateData)
            }
        }
        updateData()
        print("sendData")
        print("////////////////////////////////////////")
        print(libraryCardDelegateData)
        if(isFromShowing == false){
            print("isFromShowing")
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func sendUpdateData(libraryCardDelegateData: LibraryCardCoreData, updateId: Int32, updatePath: String, updateIsInDatabase: Int16) {
        let index = self.cardData?.index(where: { $0.uuid == libraryCardDelegateData.uuid })
        self.cardData![index!].id = updateId
        self.cardData![index!].picture_path = updatePath
        self.cardData![index!].isInDatabase = updateIsInDatabase
        print("sendUpdateData")
        print("////////////////////////////////////////")
        print(self.cardData![index!])
    }
    
//    var libraryCardData: LibraryCard
    
//    func sendData(libraryCardDelegateData: LibraryCardCoreData, isUpdate: Bool) {
//        print("Ale nie")
//        if(isUpdate == true){
//            let index = cardData?.index(where: { $0.id == libraryCardDelegateData.id })
//            cardData![index!] = libraryCardDelegateData
//        }
//        else{
//            cardData?.append(libraryCardDelegateData)
//        }
//
//        _ = navigationController?.popViewController(animated: true)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.leftBarButtonItem = editButtonItem
        usersData = DatabaseHandler.fetchDataUsers()!
        setText()
        setUX()
        loadCard()
        editBarButtonItem.title = "asdasd"
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(doThisWhenNotify),
//                                               name: NSNotification.Name(rawValue: "saveLibraryCard"),
//                                               object: nil)
    }
    
//    @objc func doThisWhenNotify() {
////        _ = navigationController?.popViewController(animated: true)
//        loadCard()
//    }
    
    func setUX(){
        self.tableView.rowHeight = UITableView.automaticDimension
        view.backgroundColor = COLOR_THEME
        editBarButtonItem.image = UIImage(named: "icon_edit_white")
        noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.text          = "no_passes".localized
        noDataLabel.customLabel()
        noDataLabel.textAlignment = .center
        tableView.backgroundView  = noDataLabel
    }
    
    func setText(){
        self.navigationItem.title = "passes".localized
    }
    
    
    @IBAction func editClick(_ sender: Any) {
        if(self.tableView.isEditing == true)
        {
            self.tableView.isEditing = false 
        }
        else
        {
            self.tableView.isEditing = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //        var numOfSections: Int = 0
        if (cardData?.count)! > 0
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
        return (cardData?.count)!
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LibraryCardTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LibraryCardTableViewCell  else {
            fatalError("The dequeued cell is not an instance of LibraryCardTableViewCell.")
        }
        let card = cardData?[indexPath.row]
        cell.backgroundColor = COLOR_THEME
        cell.nameLabel.customCellTableLabel(text: (card?.library_name)!)
        cell.code.customSmallCellTableLabel(text: (card?.code)!)
        cell.accessoryType = .disclosureIndicator
        if((card?.date)! < Date()){
            cell.expirationImageView.image = UIImage(named: "icon_importance_red")!
            cell.expirationImageRightConstraint.constant = 0
            cell.expirationImageView.isHidden = false
        }
        else{
            cell.expirationImageRightConstraint.constant = -30
            cell.expirationImageView.isHidden = true
            
        }
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            deleteLibraryCard(card: (cardData?[indexPath.row])!)
            cardData?.remove(at: indexPath.row)
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
    
    func loadCard(){
//        cardData = DatabaseHandler.fetchDataLibraryCard()!
        cardData = DatabaseHandler.fetchDataLibraryCardWithoutDelete()!
        if((cardData?.count)! > 0){
            updateData()
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddLibraryCardItem":
            os_log("Adding a new card.", log: OSLog.default, type: .debug)
            guard let libraryCardEditViewController = segue.destination as? EditLibraryCardViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            libraryCardEditViewController.usersData = usersData
//            libraryCardEditViewController.isChangePhoto = false
            libraryCardEditViewController.delegate = self
            
        case "ShowLibraryCardDetail":
            guard let libraryCardDetailViewController = segue.destination as? ShowLibraryCardViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedLibraryCardCell = sender as? LibraryCardTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedLibraryCardCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedLibraryCard = cardData?[indexPath.row]
            libraryCardDetailViewController.libraryCard = selectedLibraryCard
            libraryCardDetailViewController.usersData = usersData
            libraryCardDetailViewController.delegate = self
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    func deleteLibraryCard(card: LibraryCardCoreData?){
        print("A")
        if((usersData?.count)! < 1){
            print("without userData")
            if(!DatabaseHandler.deleteDataLibraryCard(libraryCard: card!)){
                os_log("Error deleteDataLibraryCard", log: OSLog.default, type: .debug)
            }
            return
        }
        else{
            print("with userData")
            if(!DatabaseHandler.updateDataLibraryCardDatabaseType(libraryCardCoreData: card!, isInDatabase: Int16(DELTETE))){
                os_log("Error updateDataLibraryCardDatabaseType", log: OSLog.default, type: .debug)
            }
            
        }
        let task: URLSessionDataTask?
        guard let url = URL(string: URL_LIBRARY_CARD_DELETE) else {
            os_log("Bad Url deleteLibraryCard", log: OSLog.default, type: .debug)
            return
        }
        print("B")
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
                print("c")
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
        task?.resume()
    }
}
