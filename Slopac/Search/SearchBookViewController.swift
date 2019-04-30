//
//  SearchBookViewController.swift
//  Slopac
//
//  Created by Jozef Varga on 11/11/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

import UIKit

class SearchBookViewController: UIViewController, UITextFieldDelegate, ScanISBNDelegate {
    
    func writeISBN(isbnText: String) {
        isbnTextField.text = isbnText
        _ = navigationController?.popViewController(animated: true)
        
        //_ = navigationController?.popToRootViewController(animated: true)
    }
    
    @IBOutlet weak var nameLibraryLabel: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isbnTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchDownConstraint: NSLayoutConstraint!
    @IBOutlet weak var showImageLabel: UILabel!
    @IBOutlet weak var showImageSwitch: UISwitch!
    
    @IBOutlet weak var SearchScrollView: UIScrollView!
    @IBOutlet weak var SearchViewOnScrollView: UIView!
    
//    var selectLibraryId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if(self.tabBarController?.selectedIndex == 2){
//            performSegue(withIdentifier: "booksSearch", sender: nil)
////            dismissViewControllerAnimated(true, completion: nil)
//        }
        
        
        setText()
        setUX()
        print(LIBRARYID)
        print(LIBRARY_ID_SELECT_FOR_SEARCH)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
//        if(self.tabBarController?.selectedIndex == 2){
////            performSegue(withIdentifier: "booksSearch", sender: nil)
////            dismiss(animated: true, completion: nil)
//        }
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
        
        searchDownConstraint.constant = keyboardHeight + 44
    }
    
    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        searchDownConstraint.constant = 100.0
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setText()
//    }
    
    func setUX(){
        SearchViewOnScrollView.backgroundColor = COLOR_THEME
        view.backgroundColor = COLOR_THEME
        isbnLabel.customLabel()
        authorLabel.customLabel()
        titleLabel.customLabel()
        nameLibraryLabel.customBoldLabel()
        showImageLabel.customLabel()
        authorTextField.customTextfield()
        titleTextField.customTextfield()
        isbnTextField.customTextfield()
        searchButton.customButton()
        self.titleTextField.delegate = self
        self.authorTextField.delegate = self
        self.isbnTextField.delegate = self
        showImageSwitch.tintColor = GREEN
        showImageSwitch.thumbTintColor = COLOR_THEME_WHITE
        showImageSwitch.onTintColor = GREEN
    }
    
     
    
    func setText() {
        self.navigationItem.title = "search_book".localized
        isbnLabel.text = "isbn".localized
        isbnTextField.customSetText(text: "enter_the_ISBN".localized)
        authorLabel.text = "author".localized
        authorTextField.customSetText(text: "enter_the_author".localized)
        titleLabel.text = "title".localized
        titleTextField.customSetText(text: "enter_the_title".localized)
        showImageLabel.text = "show_image_search".localized
        searchButton.setTitle("search_button".localized, for: .normal)
        var libraryForName = DatabaseHandler.fetchDataLibrariesFromId(id: String(LIBRARY_ID_SELECT_FOR_SEARCH))
        nameLibraryLabel.text = libraryForName?[0].library_name
    }
    
    var tbAccessoryView : UIToolbar?
    var curTag = 0
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        SearchScrollView.setContentOffset(CGPoint(x: 0, y: (textField.frame.origin.y) - (view.bounds.size.height / 3)), animated: true)
        if(textField == titleTextField){curTag = 0}
        if(textField == authorTextField){curTag = 1}
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        print("a toto hladan")
        textField.resignFirstResponder()
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
    
    @objc func doBtnPrev() {
        // decrement or roll over
        
        if(curTag > 0){
            curTag = curTag - 1
        }
        print(curTag)
        if(curTag == 0){titleTextField.becomeFirstResponder()}
        if(curTag == 1){authorTextField.becomeFirstResponder()}
        if(curTag == 2){isbnTextField.becomeFirstResponder()}
    }
    
    @objc func doBtnNext() {
        if(curTag < 2){
            curTag = curTag + 1
        }
        print(curTag)
        if(curTag == 0){titleTextField.becomeFirstResponder()}
        if(curTag == 1){authorTextField.becomeFirstResponder()}
        if(curTag == 2){isbnTextField.becomeFirstResponder()}
    }
    
    @objc func doBtnSubmit() {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "booksSearch"{
            if let destination = segue.destination as? BookTableViewController{
    //            print(selectLibraryId, " hovadina")
    //            destination.selectLibraryId = selectLibraryId
                if(showImageSwitch.isOn == true){
                    destination.showImage = true
                }
                else{
                    destination.showImage = false
                }
                destination.passedAuthor = authorTextField.text!
                destination.passedTitle = titleTextField.text!
                destination.passedIsbn = isbnTextField.text!
            }
        }
        if segue.identifier == "scanISBN" {
            print("AAAAAAAAAAAAAA")
            let vc : BarcodeScannerViewController = segue.destination as! BarcodeScannerViewController
            vc.delegate = self
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == "scanISBN"){
            return true
        }
        if(identifier == "booksSearch"){
            if !InternetTest.isConnectedToNetwork(){
                self.alert(message: "alert_internet_message".localized, title: "alert_internet_title".localized, buttonTitle: "alert_internet_button".localized)
                return false
            }
            
            if(authorTextField.text == "" && titleTextField.text == "" && isbnTextField.text == ""){
                showAlert(title: "alert_search_title".localized, message: "alert_search_message".localized, title_button: "alert_search_button".localized)
                return false
            }
            else{
                return true
            }
            
        }
        else{
            return false
        }
    }
    
    @IBAction func showImageSwitchChangedValue(_ sender: Any) {
    }
    
    func showAlert(title: String, message: String, title_button: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: title_button, style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
