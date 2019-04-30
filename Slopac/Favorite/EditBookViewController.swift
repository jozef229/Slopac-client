//
//  EditBookViewController.swift
//  Slopac
//
//  Created by Jozef Varga on 15/12/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

import UIKit
import os.log

protocol EditBookDelegate {
    func sendData(bookDelegateData: BooksCoreData, isFromShowing: Bool)
    func sendUpdateData(bookDelegateData: BooksCoreData, updateId: Int32, updatePath: String, updateIsInDatabase: Int16)
}

protocol EditBookShowDelegate {
    func sendShowData(bookDelegateData: BooksCoreData)
}

class EditBookViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, ScanISBNDelegate{
    
    var delegate : EditBookDelegate?
    var delegateShow : EditBookShowDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var isbnTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var tagSegmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var editionLabel: UILabel!
    @IBOutlet weak var editionTextField: UITextField!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var publisherTextField: UITextField!
    @IBOutlet weak var publicationLabel: UILabel!
    @IBOutlet weak var publicationTextField: UITextField!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var feedbackSlider: UISlider!
    @IBOutlet weak var feedbackValueLabel: UILabel!
    @IBOutlet weak var editBookScrollView: UIScrollView!
    @IBOutlet weak var editBookViewOnScrollView: UIView!
    @IBOutlet weak var isbnPhotoButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var photoWithIsbnButton: UIButton!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var showBookImageView: UIImageView! 
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var noteTextViewButtomConstrain: NSLayoutConstraint!
    
    
    var updateId = Int32(0)
    var updatePath = ""
    var updateIsInDatabase = -1
    
    var isbnScan = ""
    var isExist = false
    var isChangePhoto = false
    var book: BooksCoreData?
    var usersData : [UsersCoreData]?
    var isFromShowing = false
    let spinner = UIActivityIndicatorView()
    let loadingView = UIView()
    let loadingLabel = UILabel()
    
    //-----------------------------------------------------------------
    var tbAccessoryView : UIToolbar?
    var curTag = 0
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("ee")
        print(curTag)
        
        
        editBookScrollView.setContentOffset(CGPoint(x: 0, y: (textField.frame.origin.y) - (view.bounds.size.height / 3)), animated: true)
        if(textField == titleTextField){curTag = 0}
        if(textField == authorTextField){curTag = 1}
        if(textField == isbnTextField){curTag = 2}
        
        if(textField == languageTextField){curTag = 3}
        if(textField == yearTextField){curTag = 4}
        if(textField == editionTextField){curTag = 5}
        if(textField == publisherTextField){curTag = 6}
        if(textField == publicationTextField){curTag = 7}
        if tbAccessoryView == nil {
            tbAccessoryView = UIToolbar.init(frame:CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
            let bbiPrev = UIBarButtonItem.init(title: "previous".localized, style: .plain, target: self, action: #selector(doBtnPrev))
            let bbiNext = UIBarButtonItem.init(title: "next".localized, style: .plain, target: self, action: #selector(doBtnNext))
            let bbiSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let bbiSubmit = UIBarButtonItem.init(title: "hidden".localized, style: .plain, target: self, action: #selector(doBtnSubmit))
            tbAccessoryView?.items = [bbiPrev, bbiNext, bbiSpacer, bbiSubmit]
        }
//        imageForHeight
        textField.inputAccessoryView = tbAccessoryView
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("ee")
        print(curTag)
        editBookScrollView.setContentOffset(CGPoint(x: 0, y: (textView.frame.origin.y) - (view.bounds.size.height / 3) + (textView.frame.size.height)), animated: true)
        
        if(textView == noteTextView){curTag = 3}
        if tbAccessoryView == nil {
            tbAccessoryView = UIToolbar.init(frame:CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
            let bbiPrev = UIBarButtonItem.init(title: "Previous", style: .plain, target: self, action: #selector(doBtnPrev))
            let bbiNext = UIBarButtonItem.init(title: "Next", style: .plain, target: self, action: #selector(doBtnNext))
            let bbiSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let bbiSubmit = UIBarButtonItem.init(title: "Submit", style: .plain, target: self, action: #selector(doBtnSubmit))
            tbAccessoryView?.items = [bbiPrev, bbiNext, bbiSpacer, bbiSubmit]
        }
        textView.inputAccessoryView = tbAccessoryView
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if noteTextView.text == "enter_the_notes".localized {
            noteTextView.text = ""
            noteTextView.textColor = COLOR_THEME_WHITE
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if noteTextView.text == "" {
            noteTextView.text = "enter_the_notes".localized
            noteTextView.textColor = UIColor.gray
        }
    }
    
    @objc func doBtnPrev() {
        // decrement or roll over
        
        if(curTag > 0){
            curTag = curTag - 1
        }
        print(curTag)
        if(curTag == 0){titleTextField.becomeFirstResponder()}
        if(curTag == 1){authorTextField.becomeFirstResponder()}
        if(curTag == 2){isbnTextField.becomeFirstResponder()}
        if(curTag == 3){languageTextField.becomeFirstResponder()}
        if(curTag == 4){yearTextField.becomeFirstResponder()}
        if(curTag == 5){editionTextField.becomeFirstResponder()}
        if(curTag == 6){publisherTextField.becomeFirstResponder()}
        if(curTag == 7){publicationTextField.becomeFirstResponder()}
        if(curTag == 8){noteTextView.becomeFirstResponder()}
    }
    
    @objc func doBtnNext() {
        if(curTag < 8){
            curTag = curTag + 1
        }
        print(curTag)
        if(curTag == 0){titleTextField.becomeFirstResponder()}
        if(curTag == 1){authorTextField.becomeFirstResponder()}
        if(curTag == 2){isbnTextField.becomeFirstResponder()}
        if(curTag == 3){languageTextField.becomeFirstResponder()}
        if(curTag == 4){yearTextField.becomeFirstResponder()}
        if(curTag == 5){editionTextField.becomeFirstResponder()}
        if(curTag == 6){publisherTextField.becomeFirstResponder()}
        if(curTag == 7){publicationTextField.becomeFirstResponder()}
        if(curTag == 8){noteTextView.becomeFirstResponder()}
    }
    
    @objc func doBtnSubmit() {
        self.view.endEditing(true)
    }
    
    //-----------------------------------------------------------------
    
    
    @IBAction func feedbackValueChanged(_ sender: UISlider) {
        feedbackValueLabel.text = String(format: "%i",Int(100 * feedbackSlider.value))
    }
    
    func writeISBN(isbnText: String) {
        isbnTextField.text = isbnText
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        bookImageView.isUserInteractionEnabled = true
//        bookImageView.addGestureRecognizer(tapGestureRecognizer1)
//        
//        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(fullImageTapped(tapGestureRecognizer:)))
//        showBookImageView.isUserInteractionEnabled = true
//        showBookImageView.addGestureRecognizer(tapGestureRecognizer2)
        
        setUX()
        setText()
//        usersData = DatabaseHandler.fetchDataUsers()!
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        if(!isExist){
            if((book) != nil){
                isExist = true
                
                titleTextField.text = book?.title
                authorTextField.text = book?.author
                isbnTextField.text = book?.isbn
                editionTextField.text = book?.edition
                languageTextField.text = book?.language
                publicationTextField.text = book?.publication
                publisherTextField.text = book?.publisher
                yearTextField.text = book?.year
                tagSegmentedControl.selectedSegmentIndex = Int((book?.tags)!)
                
                if(book?.notes == ""){
                    noteTextView.textColor = UIColor.gray
                }
                else{
                    noteTextView.textColor = COLOR_THEME_WHITE
                    noteTextView.text = book?.notes
                }
                if(book?.cover != nil){
                    imageRotate(image: UIImage(data: ((book?.cover)!))!)
                }
                else{
                }
            }
            else{
                isExist = false
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    @objc
    func keyboardWillAppear(notification: NSNotification?) {
        
        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight: CGFloat
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        
        noteTextViewButtomConstrain.constant = keyboardHeight + 44
    }
    
    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        noteTextViewButtomConstrain.constant = 60.0
    }
    
    func setUX(){
        editBookViewOnScrollView.backgroundColor = COLOR_THEME
        view.backgroundColor = COLOR_THEME
        saveBarButtonItem.image = UIImage(named: "icon_save_white")
        titleLabel.customLabel()
        authorLabel.customLabel()
        isbnLabel.customLabel()
        noteLabel.customLabel()
        feedbackLabel.customLabel()
        feedbackValueLabel.customLabel()
        titleTextField.customTextfield()
        authorTextField.customTextfield()
        isbnTextField.customTextfield()
        noteTextView.customTextView()
        photoWithIsbnButton.customButton()
        photoButton.customButton()
        
        languageLabel.customLabel()
        languageTextField.customTextfield()
        yearLabel.customLabel()
        yearTextField.customTextfield()
        editionLabel.customLabel()
        editionTextField.customTextfield()
        publisherLabel.customLabel()
        publisherTextField.customTextfield()
        publicationLabel.customLabel()
        publicationTextField.customTextfield()
        
        
        bookImageView.contentMode = .scaleAspectFit
        showBookImageView.contentMode = .scaleAspectFit
        
        photoButton.setIconLeft(UIImage(named: "icon_camera_white")!)
        photoWithIsbnButton.setIconLeft(UIImage(named: "icon_download_resume_white")!)
        
        self.languageTextField.delegate = self
        self.yearTextField.delegate = self
        self.editionTextField.delegate = self
        self.publisherTextField.delegate = self
        self.publicationTextField.delegate = self
        
        self.titleTextField.delegate = self
        self.authorTextField.delegate = self
        self.isbnTextField.delegate = self
        self.noteTextView.delegate = self
        
//        bookImageView.tintColor = .black
        bookImageView.backgroundColor = COLOR_THEME_DARK
        
        editBookScrollView.layoutIfNeeded()
        editBookScrollView.isScrollEnabled = true
        editBookScrollView.contentSize = CGSize(width: self.view.frame.width, height: editBookScrollView.frame.size.height)

//        noteTextView.translatesAutoresizingMaskIntoConstraints = true
//        noteTextView.sizeToFit()
        noteTextView.isScrollEnabled = false
        
        noteTextView.layer.borderWidth = 0.5
        noteTextView.layer.borderColor = COLOR_THEME_GREY.cgColor// UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        noteTextView.layer.cornerRadius = 5.0
        
        
        
    }
    
    
    func setText(){
        self.navigationItem.title = "editing_information".localized
        showBookImageView.isHidden = true
        titleLabel.text = "title".localized + " *"
        authorLabel.text = "author".localized
        isbnLabel.text = "isbn".localized
        noteLabel.text = "notes".localized
        feedbackLabel.text = "rating".localized
        
        languageLabel.text = "language".localized
        yearLabel.text = "publish_year".localized
        editionLabel.text = "edition".localized
        publisherLabel.text = "publisher".localized
        publicationLabel.text = "publish_place".localized
        languageTextField.customSetText(text: "enter_the_language".localized)
        yearTextField.customSetText(text: "enter_the_publish_year".localized)
        editionTextField.customSetText(text: "enter_the_edition".localized)
        publisherTextField.customSetText(text: "enter_the_publisher".localized)
        publicationTextField.customSetText(text: "enter_the_publication".localized)
        
        titleTextField.customSetText(text: "enter_the_title".localized)
        authorTextField.customSetText(text: "enter_the_author".localized)
        isbnTextField.customSetText(text: "enter_the_ISBN".localized)
        noteTextView.text = "enter_the_notes".localized
        noteTextView.textColor = UIColor.gray
        bookImageView.image = UIImage(named: "default_photo_book_1")
        
        photoWithIsbnButton.setTitle("download_cover_from_isbn".localized, for: .normal)
        photoButton.setTitle("take_a_photo_of_the_cover_book".localized, for: .normal)
        
        
        tagSegmentedControl.setTitle("other".localized, forSegmentAt: 0)
        tagSegmentedControl.setTitle("i_will_read".localized, forSegmentAt: 1)
        tagSegmentedControl.setTitle("i_reading".localized, forSegmentAt: 2)
        tagSegmentedControl.setTitle("read_on".localized, forSegmentAt: 3)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "scanISBN" {
            let vc : BarcodeScannerViewController = segue.destination as! BarcodeScannerViewController
            vc.delegate = self
        }
    }
//    
//    private func textFieldShouldReturn(_ textField: UITextField) -> Bool {
////        self.view.endEditing(true)
//        return false
//    }
    
    @IBAction func takePhotoBookClick(_ sender: Any) {
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
            bookImageView.image = image
        }else{
            bookImageView.image = image.rotate(radians: .pi/2)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        showBookImageView.image = bookImageView.image
        showBookImageView.isHidden =  false
        isHiddenLibraryCardForm(value: true, table: false)
    }
    
    @objc func fullImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        
        showBookImageView.isHidden =  true
        isHiddenLibraryCardForm(value: false, table: false)
    }
    
    func isHiddenLibraryCardForm(value: Bool, table: Bool){
        
        titleLabel.isHidden = value
        titleTextField.isHidden = value
        authorLabel.isHidden = value
        authorTextField.isHidden = value
        isbnLabel.isHidden = value
        isbnTextField.isHidden = value
        noteTextView.isHidden = value
        noteLabel.isHidden = value
        feedbackLabel.isHidden = value
        feedbackSlider.isHidden = value
        feedbackValueLabel.isHidden = value
        isbnPhotoButton.isHidden = value
        photoButton.isHidden = value
        photoWithIsbnButton.isHidden = value
        bookImageView.isHidden = value
        languageLabel.isHidden = value
        languageTextField.isHidden = value
        yearLabel.isHidden = value
        yearTextField.isHidden = value
        editionLabel.isHidden = value
        editionTextField.isHidden = value
        publisherLabel.isHidden = value
        publisherTextField.isHidden = value
        publicationLabel.isHidden = value
        publicationTextField.isHidden = value
        
        if(value == true){
            editBookViewOnScrollView.backgroundColor = UIColor.black
        }
        else{
            editBookViewOnScrollView.backgroundColor = COLOR_THEME
        }
    }
    
    func updateBookWithImage(id_data: Int32, imagePhoto: UIImage, title_data: String, author_data: String, notes_data: String, feedback_data: Int, isbn_data: String, language_data: String, year_data: String, edition_data: String, publisher_data: String, publication_data: String , tags: Int16){
        
        
        self.updateIsInDatabase = WITHOUT_UPDATE_WITH_PICTURE_DATABASE
        
        if(self.book?.isInDatabase == Int16(WITHOUT_SAVE_DATABASE) || self.book?.isInDatabase == Int16(WITHOUT_SAVE_WITH_PICTURE_DATABASE)){
            self.updateIsInDatabase = WITHOUT_SAVE_WITH_PICTURE_DATABASE
        }
        if((usersData?.count)! < 1){
            if(!DatabaseHandler.updateDataBooksWithPicture(booksCoreData: self.book!, cover: imagePhoto, author: author_data, cover_path: "", feedback: Int16(feedback_data), isbn: isbn_data, notes: notes_data, title: title_data, user_id: -1, language: language_data, year: year_data, edition: edition_data, publisher: publisher_data, publication: publication_data, tags: tags, isInDatabase: Int16(self.updateIsInDatabase))){
                print("error create library card")
            }
            callDelegateShowSendData()
            return
        }
        else{
            
            if(!DatabaseHandler.updateDataBooksWithPicture(booksCoreData: self.book!, cover: imagePhoto, author: author_data, cover_path: "", feedback: Int16(feedback_data), isbn: isbn_data, notes: notes_data, title: title_data, user_id: (usersData?[0].id)!, language: language_data, year: year_data, edition: edition_data, publisher: publisher_data, publication: publication_data, tags: tags, isInDatabase: Int16(self.updateIsInDatabase))){
                print("error create library card")
            }
            callDelegateShowSendData()
        }
        
        if(self.book?.id == -1 || self.updateIsInDatabase == WITHOUT_SAVE_WITH_PICTURE_DATABASE){
            print("Nema id")
            return
        }
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
            "year"        : new_year_data ,
            "edition"     : edition_data,
            "publisher"   : publisher_data,
            "publication" : publication_data,
            "id"          : String(id_data)
        ]
        
        let boundary = generateBoundaryString()
        let token = (usersData?[0].auth)!
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        let imageData = bookImageView.image?.jpegData(compressionQuality: 0.50)
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
                        print(json)
                        let version = json["data"] as? Dictionary<String, Any> ?? [:]
                        let picture = json["picture"] as? Dictionary<String, Any> ?? [:]
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let versionTime = dateFormatter.date(from: version["versionTime"] as? String ?? "")
                        self.updatePath = picture["imageName"] as?  String ?? ""
                        self.updateId = (self.book?.id)!
                        self.updateIsInDatabase = OK_DATABASE
                        
                        if(!DatabaseHandler.updateDataBooksDatabaseType(booksCoreData: self.book!, isInDatabase: Int16(self.updateIsInDatabase))){
                            os_log("Error updateDataLibraryCardDatabaseType", log: OSLog.default, type: .debug)
                        }
                        
                        if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (self.usersData?[0])!, version_book: (self.usersData?[0].version_book)!, version_library_card: versionTime!)){
                            print("error update user")
                        }
                        self.callDelegateSendUpdateData()
                    }catch{
                        print("Unable to Parse JSON")
                    }
                }
            }
        }
        task.resume()
    }
    
    func insertBookWithImage(imagePhoto: UIImage, title_data: String, author_data: String, notes_data: String, feedback_data: Int, isbn_data: String, language_data: String, year_data: String, edition_data: String, publisher_data: String, publication_data: String, tags: Int16 ){
        self.updateIsInDatabase = WITHOUT_SAVE_WITH_PICTURE_DATABASE
        print("X")
        if((usersData?.count)! < 1){
            book = DatabaseHandler.saveDataBooksWithPictureReturn(author: author_data, cover: imagePhoto, cover_path: "", feedback: Int16(feedback_data), id: -1, isbn: isbn_data, notes: notes_data, title: title_data, user_id: -1, language: language_data, year: year_data, edition: edition_data, publisher: publisher_data, publication: publication_data, tags: tags, isInDatabase: Int16(self.updateIsInDatabase))
//            if(!DatabaseHandler.saveDataBooksWithPicture(author: author_data, cover: imagePhoto, cover_path: "", feedback: Int16(feedback_data), id: -1, isbn: isbn_data, notes: notes_data, title: title_data, user_id: -1, isInDatabase: Int16(self.updateIsInDatabase))){
//                print("error create library card")
//            }
            callDelegateSendData()
            return
        }
        else{
            book = DatabaseHandler.saveDataBooksWithPictureReturn(author: author_data, cover: imagePhoto, cover_path: "", feedback: Int16(feedback_data), id: -1, isbn: isbn_data, notes: notes_data, title: title_data, user_id: (usersData?[0].id)!, language: language_data, year: year_data, edition: edition_data, publisher: publisher_data, publication: publication_data, tags: tags, isInDatabase: Int16(self.updateIsInDatabase))
//            if(!DatabaseHandler.saveDataBooksWithPicture(author: author_data, cover: imagePhoto, cover_path: "", feedback: Int16(feedback_data), id: -1, isbn: isbn_data, notes: notes_data, title: title_data, user_id: (usersData?[0].id)!, isInDatabase: Int16(self.updateIsInDatabase))){
//                print("error create library card")
//            }
            callDelegateSendData()
        }
        
        print("XX")
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
                        self.updateId = version["id"] as? Int32 ?? 0
                        self.updateIsInDatabase = OK_DATABASE
                        self.updatePath = picture["imageName"] as?  String ?? ""
                        if(!DatabaseHandler.updateDataBooksWithPictureIdDatabaseTypeAndPicturePath(booksCoreData: self.book!, id: self.updateId, cover_path: self.updatePath, isInDatabase: Int16(self.updateIsInDatabase))){
                            os_log("Error updateDataLibraryCardDatabaseType", log: OSLog.default, type: .debug)
                        }
                        
                        
//                        if(!DatabaseHandler.saveDataBooksWithPicture(author: author_data, cover: imagePhoto, cover_path: self.updatePath, feedback: Int16(feedback_data), id: self.updateId, isbn: isbn_data, notes: notes_data, title: title_data, user_id: (self.usersData?[0].id)!, isInDatabase: Int16(self.updateIsInDatabase))){
//                            print("error create library card")
//                        }
                        if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (self.usersData?[0])!, version_book: (self.usersData?[0].version_book)!, version_library_card: versionTime!)){
                            print("error update user")
                        }
                        self.book?.id = self.updateId
                        self.book?.isInDatabase = Int16(self.updateIsInDatabase)
                        self.book?.cover_path = self.updatePath
                        self.callDelegateSendUpdateData()
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
    
    func insertBook(title_data: String, author_data: String, notes_data: String, feedback_data: Int, isbn_data: String, language_data: String, year_data: String, edition_data: String, publisher_data: String, publication_data: String, tags: Int16 ){
        
        self.updateIsInDatabase = WITHOUT_SAVE_DATABASE
        if((usersData?.count)! < 1){
            print("without userData")
            book = DatabaseHandler.saveDataBooksReturn(author: author_data, cover_path: "", feedback: Int16(feedback_data), id: -1, isbn: isbn_data, notes: notes_data, title: title_data, user_id: -1, language: language_data, year: year_data, edition: edition_data, publisher: publisher_data, publication: publication_data, tags: tags, isInDatabase: Int16(self.updateIsInDatabase))
            callDelegateSendData()
            return
        }
        else{
            print("with userData")
            book = DatabaseHandler.saveDataBooksReturn(author: author_data, cover_path: "", feedback: Int16(feedback_data), id: -1, isbn: isbn_data, notes: notes_data, title: title_data, user_id: (usersData?[0].id)!, language: language_data, year: year_data, edition: edition_data, publisher: publisher_data, publication: publication_data, tags: tags, isInDatabase: Int16(self.updateIsInDatabase))
            
            callDelegateSendData()
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
                        
                        let version = json["data"] as? Dictionary<String, Any> ?? [:]
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let versionTime = dateFormatter.date(from: version["versionTime"] as? String ?? "")
                        self.updateId = version["id"] as? Int32 ?? 0
                        self.updateIsInDatabase = OK_DATABASE
                        print("?//////////////////////////")
                        print(json)
                        
                        print("?a//////////////////////////")
                        print(self.usersData!)
                        
                        print("?//////////////////////////")
                        if(!DatabaseHandler.updateDataBooksDatabaseTypeAndId(booksCoreData: self.book!, isInDatabase: Int16(self.updateIsInDatabase), id: self.updateId)){
                            os_log("Error updateDataLibraryCardDatabaseTypeAndId", log: OSLog.default, type: .debug)
                        }
                        if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (self.usersData?[0])!, version_book: (self.usersData?[0].version_book)!, version_library_card: versionTime!)){
                            print("error update user")
                        }
                        self.book?.id = self.updateId
                        self.book?.isInDatabase = Int16(self.updateIsInDatabase)
                        self.callDelegateSendUpdateData()
                    }catch{
                        print("Unable to Parse JSON")
                    }
                }
            }
        }
        task?.resume()
    }
    
    func updateBook(id_data: Int32, path_data: String, title_data: String, author_data: String, notes_data: String, feedback_data: Int, isbn_data: String, language_data: String, year_data: String, edition_data: String, publisher_data: String, publication_data: String, tags: Int16 ){
        
        self.updateIsInDatabase = WITHOUT_UPDATE_DATABASE
        if(self.book?.isInDatabase == Int16(WITHOUT_SAVE_DATABASE)){
            self.updateIsInDatabase = WITHOUT_SAVE_DATABASE
        }
        if(self.book?.isInDatabase == Int16(WITHOUT_SAVE_WITH_PICTURE_DATABASE)){
            self.updateIsInDatabase = WITHOUT_SAVE_WITH_PICTURE_DATABASE
        }
        if(self.book?.isInDatabase == Int16(WITHOUT_UPDATE_WITH_PICTURE_DATABASE)){
            self.updateIsInDatabase = WITHOUT_UPDATE_WITH_PICTURE_DATABASE
        }
        if((usersData?.count)! < 1){
            if(!DatabaseHandler.updateDataBooks(booksCoreData: self.book!, author: author_data, cover_path: path_data, feedback: Int16(feedback_data), isbn: isbn_data, notes: notes_data, title: title_data, user_id: -1, language: language_data, year: year_data, edition: edition_data, publisher: publisher_data, publication: publication_data, tags: tags, isInDatabase: Int16(self.updateIsInDatabase))){
            }
            callDelegateShowSendData()
            return
        }
        else{
            if(!DatabaseHandler.updateDataBooks(booksCoreData: self.book!, author: author_data, cover_path: path_data, feedback: Int16(feedback_data), isbn: isbn_data, notes: notes_data, title: title_data, user_id: (usersData?[0].id)!, language: language_data, year: year_data, edition: edition_data, publisher: publisher_data, publication: publication_data, tags: tags, isInDatabase: Int16(self.updateIsInDatabase))){
            }
            callDelegateShowSendData()
        }
        if(self.book?.id == -1 || self.updateIsInDatabase != Int16(WITHOUT_UPDATE_DATABASE)){
            print("Nema id")
            return
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
                        print(json)
                        
                        let version = json["data"] as? Dictionary<String, Any> ?? [:]
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let versionTime = dateFormatter.date(from: version["versionTime"] as? String ?? "")
                        self.updateId = (self.book?.id)!
                        self.updateIsInDatabase = OK_DATABASE
                        self.updatePath = (self.book?.cover_path)!
                        
                        if(!DatabaseHandler.updateDataBooksDatabaseType(booksCoreData: self.book!, isInDatabase: Int16(self.updateIsInDatabase))){
                            os_log("Error updateDataLibraryCardDatabaseType", log: OSLog.default, type: .debug)
                        }
                        
                        if(!DatabaseHandler.updateDataUsersVersion(usersCoreData: (self.usersData?[0])!, version_book: (self.usersData?[0].version_book)!, version_library_card: versionTime!)){
                            print("error update user")
                        }
                        self.callDelegateSendUpdateData()
                    }catch{
                        print("Unable to Parse JSON")
                    }
                }
            }
        }
        task?.resume()
    }
    
    
    
    @IBAction func saveButtonClick(_ sender: Any) {
        if(noteTextView.text == "enter_the_notes".localized){
            noteTextView.text = ""
        }
        if(titleTextField.text! == ""){
            showAlert(title: "alert_book_title".localized, message: "alert_book_message".localized, title_button: "alert_book_button".localized )
        }
        else{
            if(isExist == true){
                
                //                if(libraryCardImageView.image == ){}
                if(bookImageView.image == nil || isChangePhoto == false){
                    updateBook(id_data: (book?.id)!, path_data: book?.cover_path ?? "", title_data: titleTextField.text!, author_data: authorTextField.text!, notes_data: noteTextView.text!, feedback_data: Int(feedbackValueLabel.text!)!, isbn_data: isbnTextField.text!, language_data: languageTextField.text!, year_data: yearTextField.text!, edition_data: editionTextField.text! , publisher_data: publisherTextField.text!, publication_data: publicationTextField.text!, tags: Int16(tagSegmentedControl!.selectedSegmentIndex) )
                }
                else{
                    
                    if(bookImageView.image == UIImage(named: "default_photo_book_1")){
                        updateBook(id_data: (book?.id)!, path_data: book?.cover_path ?? "", title_data: titleTextField.text!, author_data: authorTextField.text!, notes_data: noteTextView.text!, feedback_data: Int(feedbackValueLabel.text!)!, isbn_data: isbnTextField.text!, language_data: languageTextField.text!, year_data: yearTextField.text!, edition_data: editionTextField.text! , publisher_data: publisherTextField.text!, publication_data: publicationTextField.text!, tags: Int16(tagSegmentedControl!.selectedSegmentIndex) )
                    }
                    else{
                        updateBookWithImage(id_data: (book?.id)!, imagePhoto: bookImageView.image!, title_data: titleTextField.text!, author_data: authorTextField.text!, notes_data: noteTextView.text!, feedback_data: Int(feedbackValueLabel.text!)!, isbn_data: isbnTextField.text!, language_data: languageTextField.text!, year_data: yearTextField.text!, edition_data: editionTextField.text! , publisher_data: publisherTextField.text!, publication_data: publicationTextField.text!, tags: Int16(tagSegmentedControl!.selectedSegmentIndex) )
                    }
                    
                    
                }
            }
            else {
                if(bookImageView.image == nil || isChangePhoto == false){
                    print("nie")
                    insertBook(title_data: titleTextField.text!, author_data: authorTextField.text!, notes_data: noteTextView.text!, feedback_data: Int(feedbackValueLabel.text!)!, isbn_data: isbnTextField.text!, language_data: languageTextField.text!, year_data: yearTextField.text!, edition_data: editionTextField.text! , publisher_data: publisherTextField.text!, publication_data: publicationTextField.text!, tags: Int16(tagSegmentedControl!.selectedSegmentIndex) )
                }
                else{
                    
                    if(bookImageView.image == UIImage(named: "default_photo_book_1")){
                        insertBook(title_data: titleTextField.text!, author_data: authorTextField.text!, notes_data: noteTextView.text!, feedback_data: Int(feedbackValueLabel.text!)!, isbn_data: isbnTextField.text!, language_data: languageTextField.text!, year_data: yearTextField.text!, edition_data: editionTextField.text! , publisher_data: publisherTextField.text!, publication_data: publicationTextField.text!, tags: Int16(tagSegmentedControl!.selectedSegmentIndex) )
                    }
                    else{
                        insertBookWithImage(imagePhoto: bookImageView.image!, title_data: titleTextField.text!, author_data: authorTextField.text!, notes_data: noteTextView.text!, feedback_data: Int(feedbackValueLabel.text!)!, isbn_data: isbnTextField.text!, language_data: languageTextField.text!, year_data: yearTextField.text!, edition_data: editionTextField.text! , publisher_data: publisherTextField.text!, publication_data: publicationTextField.text!, tags: Int16(tagSegmentedControl!.selectedSegmentIndex) )
                        print("ine")
                    }
                    
                    print("ano")
                }
            }
            isChangePhoto = false
//            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func photoWithIsbnClick(_ sender: Any) {
        //        ?"8596978560193"
        
        print((isbnTextField.text?.count)!)
        if((isbnTextField.text?.count)! > 1){
            DispatchQueue.main.async {
                self.bookImageView.loadPictureWithLoadingScreen(isbn: self.isbnTextField.text!, loadingView: self.loadingView, loadingLabel: self.loadingLabel, spinner: self.spinner, actualView: self.view, navigationController: self.navigationController!, text: "loading".localized, actualViewController: self)
            }
            
            
            isChangePhoto = true
            //            }
        }
        else{
            showAlert(title: "alert_book_isbn_title".localized, message: "alert_book_isbn_message".localized, title_button: "alert_book_isbn_button".localized)
        }
    }
    
    func showAlert(title: String, message: String, title_button: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: title_button, style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func callDelegateShowSendData(){
        print("CCCCCC")
        if self.delegateShow != nil {
            self.delegateShow?.sendShowData(bookDelegateData: self.book!)
            //dismiss the modal
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func callDelegateSendData(){
        if self.delegate != nil {
            self.delegate?.sendData(bookDelegateData: self.book!, isFromShowing: self.isFromShowing)
            //dismiss the modal
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func callDelegateSendUpdateData(){
        if self.delegate != nil {
            self.delegate?.sendUpdateData(bookDelegateData: self.book!, updateId: self.updateId, updatePath: self.updatePath, updateIsInDatabase: Int16(self.updateIsInDatabase))
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
