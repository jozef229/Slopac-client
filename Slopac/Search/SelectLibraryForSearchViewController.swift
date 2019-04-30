//
//  SelectLibraryForSearchViewController.swift
//  Slopac
//
//  Created by Jozef Varga on 23/02/2019.
//  Copyright © 2019 Jozef Varga. All rights reserved.
//

import UIKit
import os.log
import MapKit

class SelectLibraryForSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mapsBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var selectLibraryTableView: UITableView!
    @IBOutlet weak var searchLibrarySegmentedControl: UISegmentedControl!
    
    
    //@IBOutlet weak var saveSelectLibraryBarButtonItem: UIBarButtonItem!
//    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    
    
    var noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    var cities : [CitiesCoreData]?
    //    var libraryData : [LibrariesCoreData]?
    var libraryData = [LibrariesCoreData]()
    var addressData : [AddressCoreData]?
    var textNameOfFavoriteBook = ""
//    var selectLibrary = [LibrariesCoreData]()
    var citiesCountLibraries: [Int] = []
    var citiesCountBeforeLibraries: [Int] = []
    var lastSwitch = UISwitch()
    
    func getCountSave() -> Int{
        return libraryData.filter{ $0.save_search == true }.count
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//    navigationItem.leftBarButtonItem = editButtonItem
        selectLibraryTableView.delegate = self
        selectLibraryTableView.dataSource = self
        loadData()
//        print(selectLibrary.count)
//        if(selectLibrary.count > 0){
        setUX()
        setText()
        if(getCountSave() > 0){
////            saveSelectLibraryBarButtonItem.isEnabled = false
////            saveSelectLibraryBarButtonItem.image = nil
            self.searchLibrarySegmentedControl.selectedSegmentIndex = 1
//            saveSelectLibraryBarButtonItem.image = UIImage(named: "icon_edit_white")
        }
        else{
            showAlert(title: "select_library_alert_title".localized, message: "select_library_alert_message".localized, title_button: "select_library_alert_button".localized)
////            editBarButtonItem.isEnabled = false
////            editBarButtonItem.image = nil
//
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setText()
         
    }
    
    func setUX(){
        self.selectLibraryTableView.rowHeight = UITableView.automaticDimension
        view.backgroundColor = COLOR_THEME
        selectLibraryTableView.backgroundColor = COLOR_THEME
//        saveSelectLibraryBarButtonItem.title = ""
//        editBarButtonItem.title = ""
        noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: selectLibraryTableView.bounds.size.width, height: selectLibraryTableView.bounds.size.height))
        
        noDataLabel.customLabel()
        noDataLabel.textAlignment = .center
        selectLibraryTableView.backgroundView  = noDataLabel
        if(searchLibrarySegmentedControl.selectedSegmentIndex == 1){
//            saveSelectLibraryBarButtonItem.image = UIImage(named: "icon_edit_white")
            noDataLabel.text          = "no_save_libraries".localized
        }
        else{
//            saveSelectLibraryBarButtonItem.image = UIImage(named: "icon_save_white")
            noDataLabel.text          = "no_libraries".localized
        }
        
    }
    
    func setText(){
        self.navigationItem.title = "library_selection".localized
        searchLibrarySegmentedControl.setTitle("all_libraries".localized, forSegmentAt: 0)
        searchLibrarySegmentedControl.setTitle("favorit_library".localized, forSegmentAt: 1)
        searchLibrarySegmentedControl.setIconLeft(UIImage(named: "icon_settings_white")!, index: 0)
        searchLibrarySegmentedControl.setWidth(50, forSegmentAt: 0)
//        searchLibrarySegmentedControl.setImage(UIImage(named: "icon_barcode_scanner_white")!, forSegmentAt: 0)

        mapsBarButtonItem.image = UIImage(named: "icon_map_white")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
//    private func tableView(tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
////        let mainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//
//
//    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == "showLibraryMap"){
            return true
        }
        if(identifier == "libraryBookSearch" || identifier == "booksTableView"){
        
            if(searchLibrarySegmentedControl.selectedSegmentIndex == 0){
                
                return false
            }
            else{
//                if(self.tabBarController?.selectedIndex == 2){
                    //            performSegue(withIdentifier: "booksSearch", sender: nil)
                    
                    ////            dismissViewControllerAnimated(true, completion: nil)
                    //        }
                
                //        if(self.tabBarController?.selectedIndex == 2){
                //            performSegue(withIdentifier: "booksSearch", sender: nil)
                
                ////            dismissViewControllerAnimated(true, completion: nil)
                //        }
//                if(self.tabBarController?.selectedIndex == 2){
//                    print("XXX")
//                    print("AAAAAAA")
//                    if(self.tabBarController?.selectedIndex == 2){
//                        print("AAAAAAA")
//                        let bookViewController = self.storyboard?.instantiateViewController(withIdentifier: "BookViewController") as! BookViewController
//
//                        print("AAAAAAA")
//                        present(bookViewController, animated: true, completion: nil)
//                        //                self.navigationController?.pushViewController(BookViewController, animated: true)

//                        //            self.navigationController?.setViewControllers(UserDetail, animated: true)
//                    }
//                    return false
//                    //            present(UserDetail, animated: true, completion: nil)
////                    self.navigationController?.pushViewController(BookViewController, animated: true)
//
//                    //            self.navigationController?.setViewControllers(UserDetail, animated: true)
//                }
                return true
            }
        }
        else{
            return false
        }
    }
    
//    @IBAction func selectLibraryBarButtonClick(_ sender: Any) {
//        var textField = UITextField()
//        let alert = UIAlertController(title: "alert_save_search_library_title".localized, message: "alert_save_search_library_message".localized, preferredStyle: .alert)
//
//        let action = UIAlertAction(title: "alert_save_search_library_button".localized, style: .default) { (action) in
//            //What happens when the user clicks the add item button
//            //We are in a closure so we need to use the keyword self
//
//            if(textField.text! != ""){
//                print(LIBRARYID)
//                var select_libraries = ""
//                for libraryId in LIBRARYID{
//                    if(select_libraries != ""){
//                        select_libraries += "-"
//                    }
//                    select_libraries += String(libraryId)
//                }
////                let newItem = DatabaseHandler.saveDataSelectLibrarariesReturn(select_library_id: select_libraries, name: textField.text!)
////                self.selectLibrary.append(newItem)
//                self.searchLibrarySegmentedControl.selectedSegmentIndex = 1
////                self.saveSelectLibraryBarButtonItem.image = nil
////                self.saveSelectLibraryBarButtonItem.isEnabled = false
//                self.updateData()
//            }
//        }
//
//        alert.addTextField { (alertTextField) in
//            alertTextField.placeholder = "Create New Item"
//            textField = alertTextField
//        }
//        alert.addAction(action)
//
//        alert.addAction(UIAlertAction(title: "cancel".localized, style: UIAlertAction.Style.default, handler: { _ in
//            //Cancel Action
//        }))
//
//        present(alert, animated: true, completion: nil)
//    }
    
    @IBAction func saveSelectLibraryClick(_ sender: Any) {
        print("save")
        
        if(searchLibrarySegmentedControl.selectedSegmentIndex == 0){
            searchLibrarySegmentedControl.selectedSegmentIndex = 1;
//            saveSelectLibraryBarButtonItem.isEnabled = false
//            saveSelectLibraryBarButtonItem.image = nil
//            saveSelectLibraryBarButtonItem.image = UIImage(named: "icon_edit_white")
            updateData()
        }
        else{
            searchLibrarySegmentedControl.selectedSegmentIndex = 0;
            //            saveSelectLibraryBarButtonItem.isEnabled = false
            //            saveSelectLibraryBarButtonItem.image = nil
//            saveSelectLibraryBarButtonItem.image = UIImage(named: "icon_save_white")
            updateData()
//            if(self.selectLibraryTableView.isEditing == true){
//                self.selectLibraryTableView.isEditing = false
//                //            self.navigationItem.rightBarButtonItem?.title = "Done"
//            }
//            else{
//                self.selectLibraryTableView.isEditing = true
//                //            self.navigationItem.rightBarButtonItem?.title = "Edit"
//            }
        }
        
        
//        searchLibrarySegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment;
    }
    

    
    @IBAction func selectIndexChanged(_ sender: Any) {
        
        switch searchLibrarySegmentedControl.selectedSegmentIndex
        {
        case 0:
            print("a")
            showAlert(title: "select_library_alert_title".localized, message: "select_library_alert_message".localized, title_button: "select_library_alert_button".localized)
//            editBarButtonItem.isEnabled = false
//            editBarButtonItem.image = nil
//            saveSelectLibraryBarButtonItem.image = UIImage(named: "icon_save_white")
//            saveSelectLibraryBarButtonItem.isEnabled = true
//            for libraryDataControll in libraryData{
//                libraryDataControll.save_search = false
//                for selectLibraryControl in selectLibrary{
//                    if libraryDataControll.id == selectLibraryControl.id {
//                        libraryDataControll.save_search = true
//                        print("break")
//                        break
//                    }
//                }
//            }
        case 1:
            selectLibraryTableView.setContentOffset(.zero, animated: true)
//            saveSelectLibraryBarButtonItem.image = UIImage(named: "icon_edit_white")
//            selectLibrary = DatabaseHandler.fetchDataLibrariesSaveTrue()!
//            updateData()
            print("b")
            
            
            
        default:
            break
        }
        updateData()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(searchLibrarySegmentedControl.selectedSegmentIndex == 0){
            return cities![section].city
        }
        else{
            return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        
        if(searchLibrarySegmentedControl.selectedSegmentIndex == 1){
            noDataLabel.text = "no_save_libraries".localized
            if(cities!.count > 0){
                selectLibraryTableView.separatorStyle = .singleLine
//                noDataLabel.isHidden = true
            }
            else{
                selectLibraryTableView.separatorStyle  = .none
//                noDataLabel.isHidden = false
            }
        }
        else{
            noDataLabel.text = "no_libraries".localized
            if(cities!.count > 0){
                selectLibraryTableView.separatorStyle = .singleLine
//                noDataLabel.isHidden = true
            }
            else{
                selectLibraryTableView.separatorStyle  = .none
//                noDataLabel.isHidden = false
            }
        }
//        selectLibraryTableView.separatorStyle  = .none
        if(searchLibrarySegmentedControl.selectedSegmentIndex == 0){
            noDataLabel.text = "no_libraries".localized
            if(cities!.count > 0){
                selectLibraryTableView.separatorStyle = .singleLine
                noDataLabel.isHidden = true
            }
            else{
                selectLibraryTableView.separatorStyle  = .none
                noDataLabel.isHidden = false
            }
            return cities!.count
        }
        else{
            noDataLabel.text = "no_save_libraries".localized
            if(LIBRARYID.count > 0){
                selectLibraryTableView.separatorStyle = .singleLine
                noDataLabel.isHidden = true
            }
            else{
                selectLibraryTableView.separatorStyle  = .none
                noDataLabel.isHidden = false
            }
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchLibrarySegmentedControl.selectedSegmentIndex == 0){
            return citiesCountLibraries[section]
        }
        else{
//            return selectLibrary.count
            return LIBRARYID.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SelectLibraryForSearchTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SelectLibraryForSearchTableViewCell  else {
            fatalError("The dequeued cell is not an instance of LibraryCardTableViewCell.")
        }
        cell.backgroundColor = COLOR_THEME
        cell.nameTextView.customTextView()
        cell.nameTextView.isScrollEnabled = false
        cell.nameTextView.isEditable = false
        cell.nameTextView.isUserInteractionEnabled = false
        //        cell.nameTextView.delegate = self
        if(searchLibrarySegmentedControl.selectedSegmentIndex == 0){
            
            print(citiesCountBeforeLibraries)
            var help = 0
            if(indexPath.section != 0){
                help = citiesCountBeforeLibraries[indexPath.section - 1]
            }
            let libraryCell = libraryData[indexPath.row + help]
            
            cell.selectSwitch.isHidden = false
            
            if(libraryData[indexPath.row + help].save_search == true){
                cell.selectSwitch.setOn(true, animated: true)
            }
            else{
                cell.selectSwitch.setOn(false, animated: true)
            }
            cell.selectSwitch.tintColor = GREEN
            cell.selectSwitch.thumbTintColor = COLOR_THEME_WHITE
            cell.selectSwitch.onTintColor = GREEN
            cell.selectSwitch.isUserInteractionEnabled = true
            cell.nameTextView.text = (libraryCell.library_name)!
            cell.selectSwitch.addTarget(self, action: #selector(changeValueSwitch), for: .valueChanged)
            cell.setId(id: Int(libraryCell.id))
            cell.isSelected = false
            cell.selectionStyle = .none
            cell.selectSwitch.isUserInteractionEnabled = false
            cell.setLeftConstraint(value: 80)
            cell.accessoryType = .none
//            cell.libraryData = libraryData[indexPath.row + help]
            return cell
        }
        else{
            
//            let selectLibraryCell = libraryData[LIBRARYID[indexPath.row]]
//            for libId in selectLibraryCell.select_library_id!.split(separator: "-") {
//                cell.cellLibraryId.append(Int(libId)!)
//            }
            
//            if((libraryData.first(where: { $0.id == LIBRARYID[indexPath.row] })) != nil){
            print(indexPath.row)
            print("x",LIBRARYID)
            
            let selectLibraryCell = libraryData.first(where: {$0.id == LIBRARYID[indexPath.row]})
//            }
            cell.setId(id: Int(selectLibraryCell!.id))

            cell.nameTextView.text = selectLibraryCell!.library_name
            cell.selectSwitch.isHidden = true
            cell.isSelected = true
            cell.selectionStyle = .default
            cell.setLeftConstraint(value: 20)
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
//    // Override to support conditional editing of the table view.
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        
//        if(searchLibrarySegmentedControl.selectedSegmentIndex == 0){
//            return false
//        }
//        else{
//            return true
//        }
//    }
    
//    // Override to support editing the table view.
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//            print(LIBRARYID)
//            print(LIBRARYID[indexPath.row])
//
//            let indexLib = libraryData.firstIndex(where: {$0.id == LIBRARYID[indexPath.row]})
//
//            libraryData[indexLib!].save_search = !libraryData[indexLib!].save_search
//            if(!DatabaseHandler.updateDataLibrariesSave(librariesCoreData: libraryData[indexLib!], save_search: libraryData[indexLib!].save_search )){}
//
//            LIBRARYID.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//
//            print(LIBRARYID)
//
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let cell = tableView.cellForRow(at: indexPath) as? SelectLibraryForSearchTableViewCell
        
        print("wtf indexPath" + String(indexPath.row))
        
        if(searchLibrarySegmentedControl.selectedSegmentIndex == 0){
            
//            libraryData[indexPath.row]
//            print("1")
//            print(indexPath.row)
            
            
            var help = 0
            if(indexPath.section != 0){
                help = citiesCountBeforeLibraries[indexPath.section - 1]
            }
            print(help + indexPath.row)
            let cell = tableView.cellForRow(at: indexPath) as? SelectLibraryForSearchTableViewCell
            cell?.changeSwitchValue()
//            cell!.nameTextView.text
            libraryData[help + indexPath.row].save_search = !libraryData[help + indexPath.row].save_search
            if(!DatabaseHandler.updateDataLibrariesSave(librariesCoreData: libraryData[help + indexPath.row], save_search: libraryData[help + indexPath.row].save_search)){}
            
//            print(libraryData[help + indexPath.row].save_search)
            
        }
        else{
            let cell = tableView.cellForRow(at: indexPath) as? SelectLibraryForSearchTableViewCell
//            cell?.changeSwitchValue()
//            print(indexPath.row, " pokus ",cell?.getId(), " a " , cell?.nameTextView.text )
            LIBRARY_NAME_SELECT_FOR_SEARCH = (cell?.nameTextView.text)!
            LIBRARY_ID_SELECT_FOR_SEARCH = (cell?.getId())!
            print(LIBRARY_ID_SELECT_FOR_SEARCH, "aaa")
            if(self.tabBarController?.selectedIndex == 2){
                performSegue(withIdentifier: "booksTableView", sender: self)
            }
            else
            {
                performSegue(withIdentifier: "libraryBookSearch", sender: self)
            }
        }
    }
    
    @objc func changeValueSwitch(switchLibrary: UISwitch) {
        print("switch")
    }
    
    func updateData(){
        DispatchQueue.main.async {
            self.selectLibraryTableView.reloadData()
        }
    }
    
    func loadData(){
        var libraryDataFull : [LibrariesCoreData]?
        cities?.removeAll()
        libraryData.removeAll()
        addressData?.removeAll()
        libraryDataFull?.removeAll()
        LIBRARYID.removeAll()
//        selectLibrary.removeAll()
//        selectLibrary = DatabaseHandler.fetchDataLibrariesSaveTrue()!
        cities = DatabaseHandler.fetchDataCitiesSort()!
        libraryDataFull = DatabaseHandler.fetchDataLibrariesSort()
        addressData = DatabaseHandler.fetchDataAddress()
        
//        for library in libraryDataFull! {
//            if((addressData?.first(where: { $0.id == library.address_id })) != nil){
//                if(library.save_search == true){
//                    LIBRARYID.append(Int(library.id))
//                }
//            }
//        }
        
        var i = -1
        for city in cities!{
            i += 1
            citiesCountLibraries.append(0)
            citiesCountBeforeLibraries.append(0)
            if(i != 0){
                citiesCountBeforeLibraries[i] = citiesCountBeforeLibraries[i-1]
            }
            
            
            
            for library in libraryDataFull! {
                if(addressData?.first(where: { $0.id == library.address_id })?.city_id == city.id){
                    citiesCountLibraries[i] += 1
                    citiesCountBeforeLibraries[i] += 1
                    libraryData.append(library)
                    if(library.save_search == true){
                        LIBRARYID.append(Int(library.id))
                        print("aaa " , library.id)
                    }
                }
            }
        }
        
        let helpSort = LIBRARYID
        LIBRARYID.removeAll()
        let libraryDataSort = DatabaseHandler.fetchDataLibrariesSort()!
        for librarySort in libraryDataSort {
            if((helpSort.first(where: { $0 == librarySort.id })) != nil){
                LIBRARYID.append(Int(librarySort.id))
            }
        }
        
//        for library in DatabaseHandler.fetchDataLibraries()!{
//            if(library.)
//        }
    }
    
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        if(identifier == "AvailableShowDetail"){
//            if !InternetTest.isConnectedToNetwork(){
//                self.alert(message: "alert_internet_message".localized, title: "alert_internet_title".localized, buttonTitle: "alert_internet_button".localized)
//                return false
//            }
//            else {
//                return true
//            }
//        }
//        else{
//            return false
//        }
//    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "booksTableView":
            os_log("books.", log: OSLog.default, type: .debug)
            if let destination = segue.destination as? BookTableViewController{
                //            print(selectLibraryId, " hovadina")
                //            destination.selectLibraryId = selectLibraryId
                print("p1")
                print(textNameOfFavoriteBook)
                print("p2")
                destination.passedAuthor = ""
                destination.passedTitle = textNameOfFavoriteBook
                destination.passedIsbn = ""
            }
            
        case "showLibraryMap":
            os_log("new map show library", log: OSLog.default, type: .debug)
            
    
            
            
            
        case "libraryBookSearch":
            os_log("Adding a new card.", log: OSLog.default, type: .debug)
            
            
//            guard let SearchBookViewController = segue.destination as? SearchBookViewController else {
//                fatalError("Unexpected destination: \(segue.destination)")
//            }
//            SearchBookViewController
            
            
            

//            print(selectLibraryId, "toto nechcem")
            
        
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

    func showAlert(title: String, message: String, title_button: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: title_button, style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
