//
//  RegistrationViewController.swift
//  Slopac
//
//  Created by Jozef Varga on 23/12/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

import UIKit
import os.log

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordValidationLabel: UILabel!
    @IBOutlet weak var emailValidationLabel: UILabel!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registrationButton: UIButton!
    
    @IBOutlet weak var registrationScrollView: UIScrollView!
    @IBOutlet weak var registrationViewOnScrollView: UIView!
    @IBOutlet weak var registrationButtomConstrain: NSLayoutConstraint!
    
    var tbAccessoryView : UIToolbar?
    var curTag = 0
    var keyboardHeightSave = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUX()
        self.emailValidationLabel.isHidden = true
        self.passwordValidationLabel.isHidden = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        setText()
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
        keyboardHeightSave = keyboardHeight
        registrationButtomConstrain.constant = keyboardHeight + 44
    }
    
    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        registrationButtomConstrain.constant = 60
    }
    
    func setUX(){
        registrationViewOnScrollView.backgroundColor = COLOR_THEME
        view.backgroundColor = COLOR_THEME
        firstNameLabel.customLabel()
        surnameLabel.customLabel()
        emailLabel.customLabel()
        passwordLabel.customLabel()
        passwordValidationLabel.customValidationPasswordLabel()
        emailValidationLabel.customValidationLabel()
        firstNameTextField.customTextfield()
        surnameTextField.customTextfield()
        emailTextField.customTextfield()
        emailTextField.setIconLeft(UIImage(named: "icon_email_white")!)
        passwordTextField.customTextfield()
        passwordTextField.setIconLeft(UIImage(named: "icon_password_white")!)
        registrationButton.customButton()
        self.firstNameTextField.delegate = self
        self.surnameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    func setText(){
        self.navigationItem.title = "registration".localized
        
        firstNameLabel.text = "name".localized + " *"
        surnameLabel.text = "surname".localized + " *"
        emailLabel.text = "e-mail".localized + " *"
        passwordLabel.text = "password".localized + " *"
        passwordValidationLabel.text = "password_validation".localized
        
        firstNameTextField.customSetText(text: "enter_your_name".localized)
        surnameTextField.customSetText(text: "enter_your_surname".localized)
        emailTextField.customSetText(text: "enter_your_email".localized)
        passwordTextField.customSetText(text: "enter_your_password".localized)
        
        self.firstNameTextField.delegate = self
        self.surnameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        registrationButton.setTitle("registration".localized, for: .normal)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        registrationScrollView.setContentOffset(CGPoint(x: 0, y: (textField.frame.origin.y) - (view.bounds.size.height / 3)), animated: true)
        if(textField == firstNameTextField){curTag = 0}
        if(textField == surnameTextField){curTag = 1}
        if(textField == emailTextField){curTag = 2}
        if(textField == passwordTextField){curTag = 3}
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
    
    @objc func doBtnPrev() {
        if(curTag > 0){
            curTag = curTag - 1
        }
        if(curTag == 0){firstNameTextField.becomeFirstResponder()}
        if(curTag == 1){surnameTextField.becomeFirstResponder()}
        if(curTag == 2){emailTextField.becomeFirstResponder()}
        if(curTag == 3){passwordTextField.becomeFirstResponder()}
    }
    
    @objc func doBtnNext() {
        if(curTag < 3){
            curTag = curTag + 1
        }
        if(curTag == 0){firstNameTextField.becomeFirstResponder()}
        if(curTag == 1){surnameTextField.becomeFirstResponder()}
        if(curTag == 2){emailTextField.becomeFirstResponder()}
        if(curTag == 3){passwordTextField.becomeFirstResponder()}
    }
    
    @objc func doBtnSubmit() {
        self.view.endEditing(true)
    }
    
    @IBAction func firstNameTextFieldBegin(_ sender: Any) {
    }
    
    @IBAction func surnameTextFieldBegin(_ sender: Any) {
    }
    
    @IBAction func emailTextFieldBegin(_ sender: Any) {
    }
    
    @IBAction func passwordTextFieldBegin(_ sender: Any) {
    }
    
    
    @IBAction func emailTextFieladChanged(_ sender: Any) {
        if(isValid(text: emailTextField.text!, regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}") && isValid(text: passwordTextField.text!, regex: "^[A-Za-z0-9.-]*$")){
            emailTextField.layer.shadowColor = GREEN.cgColor
        }
        else {
            emailTextField.layer.shadowColor = RED.cgColor
        }
    }
    
    @IBAction func passwordTextFieldChanged(_ sender: Any) {
        var i = 0
        if(isValid(text: passwordTextField.text!, regex: ".{8}.*")){
            i = i + 1
        }
        if(isValid(text: passwordTextField.text!, regex: ".*[A-Z].*")){
            i = i + 1
        }
        if(isValid(text: passwordTextField.text!, regex: ".*[0-9].*")){
            i = i + 1
        }
        if(!isValid(text: passwordTextField.text!, regex: "^[A-Za-z0-9.-]*$")){
            i = 1
        }
        if(i==0 || i == 1){
            passwordTextField.layer.shadowColor = RED.cgColor
        }
        if(i == 2){
            passwordTextField.layer.shadowColor = ORANGE.cgColor
        }
        if(i == 3){
            passwordTextField.layer.shadowColor = GREEN.cgColor
        }
    }
    
    
    
    func RegistrationFunction(emailUser: String, passwordUser: String, firstNameUser: String, lastNameUser: String){
        let task: URLSessionDataTask?
        guard let url = URL(string: URL_CREATE_USER) else {
            os_log("Bad URL RegistrationFunction - RegistrationViewController", log: OSLog.default, type: .debug)
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let email = "email"
        let password = "password"
        let first_name = "first_name"
        let last_name = "last_name"
        let postDict : [String: Any] = [first_name: firstNameUser,
                                        last_name: lastNameUser,
                                        email: emailUser,
                                        password: passwordUser]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else {
            return
        }
        urlRequest.httpBody = postData
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        task = session.dataTask(with: urlRequest){
            data, response, error in
            guard let data = data, error == nil else {return}
            if let value = String(data: data, encoding: .utf8){
                if let jsonData = value.data(using: .utf8){
                    do{
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                        let guid = json["guid"] as? String ?? ""
                        let token = json["token"] as? String ?? ""
                        let id = json["id"] as? Int32 ?? 0
                        if(!DatabaseHandler.saveDataUsers(guid: guid, auth: token, email: emailUser, first_name: firstNameUser, id: id, last_name: lastNameUser, version_book: Date(), version_library_card: Date())){
                            os_log("Error save saveDataUsers RegistrationFunction - RegistrationViewController", log: OSLog.default, type: .debug)
                        }
                        else{
                            self.dismiss(animated: true, completion: nil)
                        }
                    }catch{
                        os_log("Unable to Parse JSON RegistrationFunction - RegistrationViewController", log: OSLog.default, type: .debug)
                    }
                }
            }
        }
        task?.resume()
    }
    
    
    @IBAction func registrationClick(_ sender: Any) {
        var email = ""
        var password = ""
        var last_name = ""
        var first_name = ""
        if(firstNameTextField.text?.count == 0){
            firstNameTextField.layer.shadowColor = RED.cgColor
        }
        else {
            first_name = firstNameTextField.text!
        }
        if(surnameTextField.text?.count == 0){
            surnameTextField.layer.shadowColor = RED.cgColor
        }
        else {
            last_name = surnameTextField.text!
        }
        emailValidationLabel.isHidden = true
//        passwordValidationLabel.isHidden = true
        if(emailTextField.text?.count == 0){
            emailValidationLabel.isHidden = false
            emailValidationLabel.text = "please_enter_email".localized
        }
        else if(!isValid(text: emailTextField.text!, regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")){
            emailValidationLabel.isHidden = false
            emailValidationLabel.text = "please_enter_valid_email".localized
        }else {
            email = emailTextField.text!
        }
        if(passwordTextField.text?.count == 0){
//            passwordValidationLabel.isHidden = false
//            passwordValidationLabel.text = "please_enter_password".localized
        }
        else if(
            !isValid(text: passwordTextField.text!, regex: ".{8}.*") || !isValid(text: passwordTextField.text!, regex: ".*[A-Z].*") || !isValid(text: passwordTextField.text!, regex: ".*[0-9].*") || !isValid(text: passwordTextField.text!, regex: "^[A-Za-z0-9.-]*$")
            ){
//            passwordValidationLabel.isHidden = false
//            passwordValidationLabel.text = "please_enter_strong_password".localized
        }else {
            password = passwordTextField.text!
        }
        if(first_name != "" && last_name != "" && password != "" && email != ""){
            if !InternetTest.isConnectedToNetwork(){
                self.alert(message: "alert_internet_message".localized, title: "alert_internet_title".localized, buttonTitle: "alert_internet_button".localized)
            }
            else{
                RegistrationFunction(emailUser: email, passwordUser: password, firstNameUser: first_name, lastNameUser: last_name)
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {  
        textField.resignFirstResponder()
        return true
    }
}
