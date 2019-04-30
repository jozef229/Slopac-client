//
//  EditLibraryCardViewController.swift
//  Slopac
//
//  Created by Jozef Varga on 15/12/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

//is in database?
//
//0-ok
//1- without save in database (create)
//2- without update in database
//
//3- without save in database (create) PICTURE
//4- without update in database PICTURE
//
//5- delete





import UIKit
//import Foundation
import os.log

protocol EditLibraryCardDelegate {
    func sendData(libraryCardDelegateData: LibraryCardCoreData, isFromShowing: Bool)
    func sendUpdateData(libraryCardDelegateData: LibraryCardCoreData, updateId: Int32, updatePath: String, updateIsInDatabase: Int16)
}

protocol EditLibraryCardShowDelegate {
    func sendShowData(libraryCardDelegateData: LibraryCardCoreData)
}

class EditLibraryCardViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ScanISBNDelegate {
    
    var delegate : EditLibraryCardDelegate?
    var delegateShow : EditLibraryCardShowDelegate?
    
    func writeISBN(isbnText: String) {
        codeTextField.text = isbnText
        _ = navigationController?.popViewController(animated: true)
    }
    
    var setLibrary = 0
    var isFromShowing = false
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var libraryCardImageView: UIImageView!
    @IBOutlet weak var libraryNameLabel: UILabel!
    @IBOutlet weak var libraryNameTextField: UITextField!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var editCardViewOnScrollView: UIView!
    @IBOutlet weak var editCardScrollView: UIScrollView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var isbnPhotoButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var libraryTableView: UITableView!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var showLibraryCardImageView: UIImageView!
    
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBOutlet weak var datePickerLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    
    
    var isbnScan = ""
    var isTableVisible = false
    var isExist = false
    
    var updateId = Int32(0)
    var updatePath = ""
    var updateIsInDatabase = -1
    
    var dateFromShow = ""
    var libraryData : [LibrariesCoreData]?
    var libraryCard: LibraryCardCoreData?
    var usersData : [UsersCoreData]?
    var libraries = [Library]()
    var isChangePhoto = false
    let dateFormatter = DateFormatter()
    //-----------------------------------------------------------------
    var tbAccessoryView : UIToolbar?
    var curTag = 0
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
         editCardScrollView.setContentOffset(CGPoint(x: 0, y: (textField.frame.origin.y) - (view.bounds.size.height / 3)), animated: true)
        if(textField == libraryNameTextField){curTag = 0}
        if tbAccessoryView == nil {
            tbAccessoryView = UIToolbar.init(frame:CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
            let bbiPrev = UIBarButtonItem.init(title: "previous".localized, style: .plain, target: self, action: #selector(doBtnPrev))
            let bbiNext = UIBarButtonItem.init(title: "next".localized, style: .plain, target: self, action: #selector(doBtnNext))
            let bbiSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let bbiSubmit = UIBarButtonItem.init(title: "hidden".localized, style: .plain, target: self, action: #selector(doBtnSubmit))
            tbAccessoryView?.items = [bbiPrev, bbiNext, bbiSpacer, bbiSubmit]
        }
        textField.inputAccessoryView = tbAccessoryView
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("ee")
        print(curTag)
        editCardScrollView.setContentOffset(CGPoint(x: 0, y: (textView.frame.origin.y) - (view.bounds.size.height / 3) + (textView.frame.size.height)), animated: true)
        
        if(textView == codeTextField){curTag = 3}
        if tbAccessoryView == nil {
            tbAccessoryView = UIToolbar.init(frame:CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
            let bbiPrev = UIBarButtonItem.init(title: "previous".localized, style: .plain, target: self, action: #selector(doBtnPrev))
            let bbiNext = UIBarButtonItem.init(title: "next".localized, style: .plain, target: self, action: #selector(doBtnNext))
            let bbiSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let bbiSubmit = UIBarButtonItem.init(title: "hidden".localized, style: .plain, target: self, action: #selector(doBtnSubmit))
            tbAccessoryView?.items = [bbiPrev, bbiNext, bbiSpacer, bbiSubmit]
        }
        textView.inputAccessoryView = tbAccessoryView
        return true
    }
    
    @objc func doBtnPrev() {
        // decrement or roll over
        
        if(curTag > 0){
            curTag = curTag - 1
        }
        print(curTag)
        if(curTag == 0){libraryNameTextField.becomeFirstResponder()}
        if(curTag == 1){codeTextField.becomeFirstResponder()}
        if(curTag == 2){passwordTextField.becomeFirstResponder()}
    }
    
    @objc func doBtnNext() {
        if(curTag < 2){
            curTag = curTag + 1
        }
        print(curTag)
        if(curTag == 0){libraryNameTextField.becomeFirstResponder()}
        if(curTag == 1){codeTextField.becomeFirstResponder()}
        if(curTag == 2){passwordTextField.becomeFirstResponder()}
    }
    
    @objc func doBtnSubmit() {
        self.view.endEditing(true)
    }
    
    //-----------------------------------------------------------------
    
    
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        showDatePicker() //aaasdasdasdasdasdasdasdadasdasdasdasdasdasdasdasd
        
        
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        libraryCardImageView.isUserInteractionEnabled = true
        libraryCardImageView.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(fullImageTapped(tapGestureRecognizer:)))
        showLibraryCardImageView.isUserInteractionEnabled = true
        showLibraryCardImageView.addGestureRecognizer(tapGestureRecognizer2)
        
        setUX()
        setText()
        
        loadLibrary()
    }

    @objc func dataChanged(datePicker: UIDatePicker){
        let dateFormatter22 = DateFormatter()
        dateFormatter22.dateFormat = "yyyy-MM-dd"
        datePickerTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dataChanged) , for: .valueChanged)
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "done".localized, style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "hidden".localized, style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        datePickerTextField.inputAccessoryView = toolbar
        datePickerTextField.inputView = datePicker
        
    }
    
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        datePickerTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        if(!isExist){
            if((libraryCard) != nil){
                isExist = true
                libraryNameTextField.text = libraryCard?.library_name!
                codeTextField.text = libraryCard?.code!
                let help = libraries.first(where: { $0.id == libraryCard?.library_id })!
                libraryButton.setTitle(help.library_name, for: .normal)
                setLibrary = Int(help.id)
                if(libraryCard?.picture != nil){
                    imageRotate(image: UIImage(data: ((libraryCard?.picture)!))!)
                }
                else{
                }
                print("pokus1")
                passwordTextField.text = libraryCard?.password!
                
                print("pokus2")
                if(dateFromShow != ""){
                    datePickerTextField.text = dateFromShow
                }
            }
            else{
                isExist = false
            }
        }
    }
    
    
    
    func setUX(){
        editCardViewOnScrollView.backgroundColor = COLOR_THEME
        view.backgroundColor = COLOR_THEME
        showLibraryCardImageView.isHidden = true
        libraryCardImageView.isUserInteractionEnabled = false
        showLibraryCardImageView.isUserInteractionEnabled = false
        photoButton.customButton()
        libraryButton.customButton()
        datePickerLabel.customLabel()
        libraryNameLabel.customLabel()
        codeLabel.customLabel()
        libraryButton.setIconLeft(UIImage(named: "icon_library_white")!)
        passwordLabel.customLabel()
        passwordTextField.customTextfield()
        
        libraryTableView.customTableView()
        libraryNameTextField.customTextfield()
        codeTextField.customTextfield()
        datePickerTextField.customTextfield()
        photoButton.setIconLeft(UIImage(named: "icon_camera_white")!)
        saveBarButtonItem.image = UIImage(named: "icon_save_white")
        libraryCardImageView.contentMode = .scaleAspectFit
        showLibraryCardImageView.contentMode = .scaleAspectFit
        self.codeTextField.delegate = self
        self.libraryNameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        
        
        
        libraryTableView.delegate = self
        libraryTableView.dataSource = self
        self.libraryTableView.isHidden = true
    }
    
    func setText(){
        self.navigationItem.title = "editing_information".localized
        libraryNameLabel.text = "name_of_license".localized + " *"
        libraryNameTextField.customSetText(text: "enter_name_of_license".localized)
        codeLabel.text = "code_of_the_card".localized + " *"
        codeTextField.customSetText(text: "enter_the_code_of_the_card".localized)
        photoButton.setTitle("take_a_photo_of_the_card".localized, for: .normal)
        libraryButton.setTitle("library_selection".localized + " *", for: .normal)
        datePickerLabel.text = "date_expiration".localized + " *"
        datePickerTextField.customSetText(text: "enter_date".localized)
        
        passwordLabel.text = "password".localized + " *"
        passwordTextField.customSetText(text: "please_enter_password".localized)

        
        print("pokus3")
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "scanISBN" {
            let vc : BarcodeScannerViewController = segue.destination as! BarcodeScannerViewController
            vc.delegate = self
        }
    }
    
    func updateData(){
        DispatchQueue.main.async {
            self.libraryTableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraries.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "library")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "library")
        }
        cell?.textLabel!.customCellTableLabel(text: libraries[indexPath.row].library_name)
        cell?.backgroundColor = COLOR_THEME
        cell?.textLabel?.textColor = COLOR_THEME_WHITE
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        print("XXXXXXXXXXXXXXXXX")
        tableView.deselectRow(at: indexPath, animated: true)
//        print("XXXXXXXXXXXXXXXXX")
        setLibrary = Int(libraries[indexPath.row].id)
        libraryButton.setTitle(libraries[indexPath.row].library_name, for: .normal)
        self.isTableVisible = false
        libraryTableView.isHidden = true
        isHiddenLibraryCardForm(value: false, table: true)
    }
    
    func loadLibrary(){ ////////////////////////////////////////////////////////////////////
        libraryData = DatabaseHandler.fetchDataLibraries()!
        libraries.removeAll()
        if((libraryData?.count)! > 0){
            for library in libraryData! {
                guard let help = Library(
                    id: library.id,
                    address_id: 0,
                    library_name: library.library_name!
                    )else {
                        fatalError("Unable to instantiate book")
                }
                libraries += [help]
                libraries.sort{$0.library_name < $1.library_name}
                updateData()
            }
        }
    }
    
    @IBAction func takePhotoLibraryCard(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            isChangePhoto = true
            imageRotate(image: pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imageRotate(image: UIImage){
        if(image.size.width < image.size.height){
            libraryCardImageView.image = image.rotate(radians: .pi/2)
            showLibraryCardImageView.image = image
        }else{
            libraryCardImageView.image = image
            showLibraryCardImageView.image = image.rotate(radians: .pi/2)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        showLibraryCardImageView.isHidden =  false
        isHiddenLibraryCardForm(value: true, table: false)
    }
    
    @objc func fullImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        showLibraryCardImageView.image = libraryCardImageView.image
        showLibraryCardImageView.isHidden =  true
        isHiddenLibraryCardForm(value: false, table: false)
    }
    
    func isHiddenLibraryCardForm(value: Bool, table: Bool){
        photoButton.isHidden = value
        isbnPhotoButton.isHidden = value
        libraryNameLabel.isHidden = value
        codeLabel.isHidden = value
        libraryTableView.isHidden = value
        libraryNameTextField.isHidden = value
        passwordTextField.isHidden = value
        passwordLabel.isHidden = value
        codeTextField.isHidden = value
        libraryCardImageView.isHidden = value
        isTableVisible = value
        datePickerTextField.isHidden = value
        datePickerLabel.isHidden = value
//        showLibraryCardImageView.isHidden = !value
        if(table == true){
            self.libraryTableView.isHidden = !value
        }
        else{
            if(value == true){
                editCardViewOnScrollView.backgroundColor = UIColor.black
            }
            else{
                editCardViewOnScrollView.backgroundColor = COLOR_THEME
            }
            libraryButton.isHidden = value
            self.libraryTableView.isHidden = true
        }
    }
    
    @IBAction func libraryClick(_ sender: Any) {
        if self.isTableVisible == false {
            isHiddenLibraryCardForm(value: true, table: true)
            self.libraryTableView.isHidden = false
            libraryTableView.frame = CGRect(x: libraryTableView.frame.origin.x, y: libraryTableView.frame.origin.y, width: libraryTableView.frame.size.width, height: libraryTableView.contentSize.height)
            libraryTableView.reloadData()
        } else {
            isHiddenLibraryCardForm(value: false, table: true)
            self.libraryTableView.isHidden = true
        }
    }
    
    func updateLibraryCardWithImage(id_data: Int32, imagePhoto: UIImage, library_id_data: Int, library_name_data: String, code_data: String, password_data: String ){
        
        print("pokus4")
        let dateFromDatePicker = dateFormatter.date(from: datePickerTextField.text!)
        self.updateIsInDatabase = WITHOUT_UPDATE_WITH_PICTURE_DATABASE
        
        if(self.libraryCard?.isInDatabase == Int16(WITHOUT_SAVE_DATABASE) || self.libraryCard?.isInDatabase == Int16(WITHOUT_SAVE_WITH_PICTURE_DATABASE)){
            self.updateIsInDatabase = WITHOUT_SAVE_WITH_PICTURE_DATABASE
        }
        if((usersData?.count)! < 1){
            if(!DatabaseHandler.updateDataLibraryCardWithPicture(libraryCardCoreData: self.libraryCard!, picture: imagePhoto, code: code_data, library_id: Int32(library_id_data), library_name: library_name_data, picture_path: "", updated_at: Date(), user_id: -1, date: dateFromDatePicker!, password: password_data, isInDatabase: Int16(self.updateIsInDatabase))){
                os_log("Error updateDataLibraryCardWithPicture", log: OSLog.default, type: .debug)
            }
            callDelegateShowSendData()
            return
        }
        else{
            if(!DatabaseHandler.updateDataLibraryCardWithPicture(libraryCardCoreData: self.libraryCard!, picture: imagePhoto, code: code_data, library_id: Int32(library_id_data), library_name: library_name_data, picture_path: "", updated_at: Date(), user_id: (usersData?[0].id)!, date: dateFromDatePicker!, password: password_data, isInDatabase: Int16(self.updateIsInDatabase))){
                os_log("Error updateDataLibraryCardWithPicture", log: OSLog.default, type: .debug)
            }
            callDelegateShowSendData()
        }
        
        if(self.libraryCard?.id == -1 || self.updateIsInDatabase == WITHOUT_SAVE_WITH_PICTURE_DATABASE){
            print("Nema id")
            return
        }
        let myUrl = NSURL(string: URL_UPDATE_FILE_WITH_PICTURE);
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let dateFormatterSend = DateFormatter()
        dateFormatterSend.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let param = [
            "uploadType"  : "7",
            "user_id"     : String(usersData?[0].id ?? 0),
            "library_id"  : String(library_id_data),
            "library_name": library_name_data,
            "guid"        : usersData?[0].guid ?? "",
            "code"        : code_data,
            "id"          : String(id_data),
            "date"        : dateFormatterSend.string(from: dateFromDatePicker!),
            "password"    : password_data
        ]
        
        let boundary = generateBoundaryString()
        let token = (usersData?[0].auth)!
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        let imageData = libraryCardImageView.image?.jpegData(compressionQuality: COMPRESSION_QUALITY)
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
                        self.updateId = (self.libraryCard?.id)!
                        self.updateIsInDatabase = OK_DATABASE
                        
                        if(!DatabaseHandler.updateDataLibraryCardDatabaseType(libraryCardCoreData: self.libraryCard!, isInDatabase: Int16(self.updateIsInDatabase))){
                            os_log("Error updateDataLibraryCardDatabaseType", log: OSLog.default, type: .debug)
                        }
                        if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (self.usersData?[0])!, version_book: (self.usersData?[0].version_book)!, version_library_card: versionTime!)){
                            os_log("Error updateDataUsersVersion", log: OSLog.default, type: .debug)
                        }
                        self.callDelegateSendUpdateData()
                    }catch{
                        os_log("Unable to Parse JSON updateLibraryCardWithImage", log: OSLog.default, type: .debug)
                    }
                }
            }
        }
        task.resume()
    }
    
    func insertLibraryCardWithImage(imagePhoto: UIImage, library_id_data: Int, library_name_data: String, code_data: String, password_data: String ){
 
        let dateFromDatePicker = dateFormatter.date(from: datePickerTextField.text!)
        self.updateIsInDatabase = WITHOUT_SAVE_WITH_PICTURE_DATABASE
        if((usersData?.count)! < 1){
            libraryCard = DatabaseHandler.saveDataLibraryCardWithPictureReturn(code: code_data, id: -1, library_id: Int32(library_id_data), library_name: library_name_data, picture: imagePhoto, picture_path: "", updated_at: Date(), user_id: -1, date: dateFromDatePicker!, password: password_data, isInDatabase: Int16(self.updateIsInDatabase))
            callDelegateSendData()
            return
        }
        else{
            libraryCard = DatabaseHandler.saveDataLibraryCardWithPictureReturn(code: code_data, id: -1, library_id: Int32(library_id_data), library_name: library_name_data, picture: imagePhoto, picture_path: "", updated_at: Date(), user_id: (usersData?[0].id)!, date: dateFromDatePicker!, password: password_data, isInDatabase: Int16(self.updateIsInDatabase))
            callDelegateSendData()
        }
        let myUrl = NSURL(string: URL_UPDATE_FILE_WITH_PICTURE);
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let dateFormatterSend = DateFormatter()
        dateFormatterSend.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let param = [
            "uploadType"  : "8",
            "user_id"     : String(usersData?[0].id ?? 0),
            "library_id"  : String(library_id_data),
            "library_name": library_name_data,
            "guid"        : usersData?[0].guid ?? "",
            "code"        : code_data,
            "date"        : dateFormatterSend.string(from: dateFromDatePicker!),
            "password"    : password_data
        ]
        let boundary = generateBoundaryString()
        let token = (usersData?[0].auth)!
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        let imageData = libraryCardImageView.image?.jpegData(compressionQuality: COMPRESSION_QUALITY)
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
                        
                        if(!DatabaseHandler.updateDataLibraryCardWithPictureIdDatabaseTypeAndPicturePath(libraryCardCoreData: self.libraryCard!, id: self.updateId, picture_path: self.updatePath, isInDatabase: Int16(self.updateIsInDatabase))){
                            print("Error")
                            }
                        if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (self.usersData?[0])!, version_book: (self.usersData?[0].version_book)!, version_library_card: versionTime!)){
                            os_log("Error updateDataUsersVersion", log: OSLog.default, type: .debug)
                        }
                        self.libraryCard?.id = self.updateId
                        self.libraryCard?.isInDatabase = Int16(self.updateIsInDatabase)
                        self.libraryCard?.picture_path = self.updatePath
                        self.callDelegateSendUpdateData()
                    }catch{
                        os_log("Unable to Parse JSON insertLibraryCardWithImage", log: OSLog.default, type: .debug)
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
    
    
    func insertLibraryCard(library_id_data: Int, library_name_data: String, code_data: String, password_data: String ){
        let dateFromDatePicker = dateFormatter.date(from: datePickerTextField.text!)
        self.updateIsInDatabase = WITHOUT_SAVE_DATABASE
        if((usersData?.count)! < 1){
            libraryCard = DatabaseHandler.saveDataLibraryCardReturn(code: code_data, id: -1, library_id: Int32(library_id_data), library_name: library_name_data, picture_path: "", updated_at: Date(), user_id: -1, date: dateFromDatePicker!, password: password_data, isInDatabase: Int16(self.updateIsInDatabase))
            callDelegateSendData()
            return
        }
        else{
            libraryCard = DatabaseHandler.saveDataLibraryCardReturn(code: code_data, id: -1, library_id: Int32(library_id_data), library_name: library_name_data, picture_path: "", updated_at: Date(), user_id: (usersData?[0].id)!, date: dateFromDatePicker!, password: password_data, isInDatabase: Int16(self.updateIsInDatabase))
            callDelegateSendData()
        }
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
        
        let dateFormatterSend = DateFormatter()
        dateFormatterSend.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let postDict : [String: Any] = [uploadType: 6,
                                        user_id: usersData?[0].id ?? 0,
                                        library_id: library_id_data,
                                        library_name: library_name_data,
                                        code: code_data,
                                        date: dateFormatterSend.string(from: dateFromDatePicker!),
                                        password: password_data
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
                        if(!DatabaseHandler.updateDataLibraryCardDatabaseTypeAndId(libraryCardCoreData: self.libraryCard!, isInDatabase: Int16(self.updateIsInDatabase), id: self.updateId)){
                            os_log("Error updateDataLibraryCardDatabaseTypeAndId", log: OSLog.default, type: .debug)
                        }
                        if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (self.usersData?[0])!, version_book: (self.usersData?[0].version_book)!, version_library_card: versionTime!)){
                            os_log("Error updateDataUsersVersion", log: OSLog.default, type: .debug)
                        }
                        self.libraryCard?.id = self.updateId
                        self.libraryCard?.isInDatabase = Int16(self.updateIsInDatabase)
                        self.callDelegateSendUpdateData()
                    }catch{
                        os_log("Unable to Parse JSON insertLibraryCard", log: OSLog.default, type: .debug)
                    }
                }
            }
        }
        task?.resume()
    }
    
    
    
    func updateLibraryCard(id_data: Int32, library_id_data: Int, library_name_data: String, code_data: String, path_data: String, password_data: String ){
        
        print("pokus7")
        let dateFromDatePicker = dateFormatter.date(from: datePickerTextField.text!)
        self.updateIsInDatabase = WITHOUT_UPDATE_DATABASE
        if(self.libraryCard?.isInDatabase == Int16(WITHOUT_SAVE_DATABASE)){
            self.updateIsInDatabase = WITHOUT_SAVE_DATABASE
        }
        if(self.libraryCard?.isInDatabase == Int16(WITHOUT_SAVE_WITH_PICTURE_DATABASE)){
            self.updateIsInDatabase = WITHOUT_SAVE_WITH_PICTURE_DATABASE
        }
        if(self.libraryCard?.isInDatabase == Int16(WITHOUT_UPDATE_WITH_PICTURE_DATABASE)){
            self.updateIsInDatabase = WITHOUT_UPDATE_WITH_PICTURE_DATABASE
        }
        if((usersData?.count)! < 1){
            if(!DatabaseHandler.updateDataLibraryCard(libraryCardCoreData: self.libraryCard!, code: code_data, library_id: Int32(library_id_data), library_name: library_name_data, picture_path: path_data, updated_at: Date(), user_id: -1, date: dateFromDatePicker!, password: password_data, isInDatabase: Int16(self.updateIsInDatabase))){
                os_log("Error updateDataLibraryCard", log: OSLog.default, type: .debug)
            }
            callDelegateShowSendData()
            return
        }
        else{
            if(!DatabaseHandler.updateDataLibraryCard(libraryCardCoreData: self.libraryCard!, code: code_data, library_id: Int32(library_id_data), library_name: library_name_data, picture_path: path_data, updated_at: Date(), user_id: (usersData?[0].id)!, date: dateFromDatePicker!, password: password_data, isInDatabase: Int16(self.updateIsInDatabase))){
                os_log("Error updateDataLibraryCard", log: OSLog.default, type: .debug)
            }
            callDelegateShowSendData()
        }
        if(self.libraryCard?.id == -1 || self.updateIsInDatabase != Int16(WITHOUT_UPDATE_DATABASE)){
            print("Nema id")
            return
        }
        
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
                                        id: id_data,
                                        user_id: usersData?[0].id ?? 0,
                                        library_id: library_id_data,
                                        library_name: library_name_data,
                                        code: code_data,
                                        path: path_data,
                                        date: dateFormatterSend.string(from: dateFromDatePicker!),
                                        password: password_data]
        
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
                        
                        
                        self.updateId = (self.libraryCard?.id)!
                        self.updateIsInDatabase = OK_DATABASE
                        self.updatePath = (self.libraryCard?.picture_path)!
                        
                        if(!DatabaseHandler.updateDataLibraryCardDatabaseType(libraryCardCoreData: self.libraryCard!, isInDatabase: Int16(self.updateIsInDatabase))){
                            os_log("Error updateDataLibraryCardDatabaseType", log: OSLog.default, type: .debug)
                        }
                        if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (self.usersData?[0])!, version_book: (self.usersData?[0].version_book)!, version_library_card: versionTime!)){
                            os_log("Error updateDataUsersVersion", log: OSLog.default, type: .debug)
                        }
                        self.callDelegateSendUpdateData()
                    }catch{
                        os_log("Unable to Parse JSON updateLibraryCard", log: OSLog.default, type: .debug)
                    }
                }
            }
        }
        task?.resume()
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        if(setLibrary == 0 || libraryNameTextField.text! == "" || codeTextField.text! == "" || datePickerTextField.text! == "" || passwordTextField.text! == ""){
            showAlert()
        }
        else{
//            print(passwordTextField.text)
            if(isExist == true){
                if(libraryCardImageView.image == nil || isChangePhoto == false){
                    updateLibraryCard(id_data: (libraryCard?.id)!, library_id_data: setLibrary, library_name_data: libraryNameTextField.text!, code_data: codeTextField.text!, path_data: libraryCard?.picture_path ?? "", password_data: passwordTextField.text!)
                }
                else{
                    updateLibraryCardWithImage(id_data: (libraryCard?.id)!, imagePhoto: libraryCardImageView.image!, library_id_data: setLibrary, library_name_data: libraryNameTextField.text!, code_data: codeTextField.text!, password_data: passwordTextField.text!)
                    
                    libraryCard?.picture_path = libraryCard?.picture_path ?? ""
                    libraryCard?.picture = libraryCardImageView.image!.pngData()
                }
                libraryCard?.code = codeTextField.text!
                libraryCard?.library_name = libraryNameTextField.text!
                libraryCard?.library_id = Int32(setLibrary)
                libraryCard?.password = passwordTextField.text!
            }
            else {
                if(libraryCardImageView.image == nil || isChangePhoto == false){
                    insertLibraryCard(library_id_data: setLibrary, library_name_data: libraryNameTextField.text!, code_data: codeTextField.text!, password_data: passwordTextField.text!)
                }
                else{
                    insertLibraryCardWithImage(imagePhoto: libraryCardImageView.image!, library_id_data: setLibrary, library_name_data: libraryNameTextField.text!, code_data: codeTextField.text!, password_data: passwordTextField.text!)
                }
            }
        }
        isChangePhoto = false
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "alert_library_card_title".localized, message: "alert_library_card_message".localized, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "alert_library_card_button".localized, style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func callDelegateShowSendData(){
        print("CCCCCC")
        if self.delegateShow != nil {
            self.delegateShow?.sendShowData(libraryCardDelegateData: self.libraryCard!)
            //dismiss the modal
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func callDelegateSendData(){
        if self.delegate != nil {
            self.delegate?.sendData(libraryCardDelegateData: self.libraryCard!, isFromShowing: self.isFromShowing)
            //dismiss the modal
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func callDelegateSendUpdateData(){
        if self.delegate != nil {
            self.delegate?.sendUpdateData(libraryCardDelegateData: self.libraryCard!, updateId: self.updateId, updatePath: self.updatePath, updateIsInDatabase: Int16(self.updateIsInDatabase))
            //dismiss the modal
            self.dismiss(animated: true, completion: nil)
//            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        print("a toto hladan")
        textField.resignFirstResponder()
        return true
    }
}
