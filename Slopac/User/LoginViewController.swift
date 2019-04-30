//
//  LoginViewController.swift
//  Slopac
//
//  Created by Jozef Varga on 20/12/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

import UIKit
import os.log

class LoginViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    @IBOutlet weak var languageTableView: UITableView!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var emailStaticLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordStaticLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailValidationMessageLabel: UILabel!
    @IBOutlet weak var passwordValidationMessageLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var loginViewOnScrollView: UIView!
    @IBOutlet weak var registrationButtomConstrain: NSLayoutConstraint!
    
    var isTableVisible = false
    var userData : [UsersCoreData]? 
    var tbAccessoryView : UIToolbar?
    var curTag = 0
    var keyboardHeightSave = CGFloat(0)
    
    override func viewDidLoad() {
        addLanguages()
        setUX()
        setText()
        view.backgroundColor = COLOR_THEME
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);
        userData = DatabaseHandler.fetchDataUsers()!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        registrationButtomConstrain.constant += keyboardHeight + 44
    }
    
    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        registrationButtomConstrain.constant -= (keyboardHeightSave + 44)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        loginScrollView.setContentOffset(CGPoint(x: 0, y: (textField.frame.origin.y) - (view.bounds.size.height / 3)), animated: true)
        if(textField == emailTextField){curTag = 0}
        if(textField == passwordTextField){curTag = 1}
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
        if(curTag == 0){emailTextField.becomeFirstResponder()}
        if(curTag == 1){passwordTextField.becomeFirstResponder()}
    }
    
    @objc func doBtnNext() {
        if(curTag < 1){
            curTag = curTag + 1
        }
        if(curTag == 0){emailTextField.becomeFirstResponder()}
        if(curTag == 1){passwordTextField.becomeFirstResponder()}
    }
    
    @objc func doBtnSubmit() {
        self.view.endEditing(true)
    }
    
    func setUX(){
        loginViewOnScrollView.backgroundColor = COLOR_THEME
        view.backgroundColor = COLOR_THEME
        emailTextField.customTextfield()
        if #available(iOS 12.0, *) {
            emailTextField.textContentType = .oneTimeCode
            passwordTextField.textContentType = .oneTimeCode
        } else {
            emailTextField.textContentType = .init(rawValue: "")
            passwordTextField.textContentType = .init(rawValue: "")
        }
        emailTextField.setIconLeft(UIImage(named: "icon_email_white")!)
        passwordTextField.customTextfield()
        passwordTextField.setIconLeft(UIImage(named: "icon_password_white")!)
        loginButton.customButton()
        languageButton.customButton()
        languageButton.setIconLeft(UIImage(named: "icon_language_white")!)
        registrationButton.customNoBorderButton()
        emailStaticLabel.customLabel()
        passwordStaticLabel.customLabel()
        languageTableView.customTableView()
        emailValidationMessageLabel.customValidationLabel()
        passwordValidationMessageLabel.customValidationLabel()
        emailValidationMessageLabel.isHidden = true
        passwordValidationMessageLabel.isHidden = true
        languageTableView.delegate = self
        languageTableView.dataSource = self
        self.languageTableView.isHidden = true
        self.passwordTextField.delegate = self
        self.emailTextField.delegate = self
    } 
    
    func setText(){
        self.navigationItem.title = "login".localized
        languageButton.setTitle("choice_language".localized, for: .normal)
        emailStaticLabel.text = "e-mail".localized
        emailTextField.customSetText(text: "enter_your_email".localized)
        passwordStaticLabel.text = "password".localized
        passwordTextField.customSetText(text: "enter_your_password".localized)
        registrationButton.setTitle("registration".localized, for: .normal)
        loginButton.setTitle("login".localized, for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LANGUAGES.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "language")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "language")
        }
        cell?.textLabel?.text = LANGUAGES[indexPath.row].name
        cell?.backgroundColor = COLOR_THEME
        cell?.textLabel?.textColor = COLOR_THEME_WHITE
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.languageTableView.isHidden = true
        self.isTableVisible = false
        isHiddenLoginForm(value: false)
        Bundle.setLanguage(LANGUAGES[indexPath.row].code) 
        languageButton.setTitle("choice_language".localized, for: .normal)
        setText()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func emailTextFieldBegin(_ sender: Any) {
                loginScrollView.setContentOffset(CGPoint(x: 0, y: (emailTextField.frame.origin.y) - (view.bounds.size.height / 3)), animated: true)
    }
    
    @IBAction func passwordTextFieldBegin(_ sender: Any) {
        loginScrollView.setContentOffset(CGPoint(x: 0, y: (passwordTextField.frame.origin.y) - (view.bounds.size.height / 3)), animated: true)
    }
    
    @IBAction func loginUserFunction(_ sender: Any) {
        let bottomOffset = CGPoint(x: 0, y: loginScrollView.contentSize.height - loginScrollView.bounds.size.height)
        loginScrollView.setContentOffset(bottomOffset, animated: true)
        var email = ""
        var password = ""
        emailValidationMessageLabel.isHidden = true
        passwordValidationMessageLabel.isHidden = true
        if(emailTextField.text?.count == 0){
            emailValidationMessageLabel.isHidden = false
            emailValidationMessageLabel.text = "please_enter_email".localized
        }
        else if(!isValid(text: emailTextField.text!, regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")){
            emailValidationMessageLabel.isHidden = false
            emailValidationMessageLabel.text = "please_enter_valid_email".localized
        }else {
            email = emailTextField.text!
        }
        if(passwordTextField.text?.count == 0){
            passwordValidationMessageLabel.isHidden = false
            passwordValidationMessageLabel.text = "please_enter_password".localized
        }
        else if(
            !isValid(text: passwordTextField.text!, regex: ".{8}.*") || !isValid(text: passwordTextField.text!, regex: ".*[A-Z].*") || !isValid(text: passwordTextField.text!, regex: ".*[0-9].*") || !isValid(text: passwordTextField.text!, regex: "^[A-Za-z0-9.-]*$")
            ){
            passwordValidationMessageLabel.isHidden = false
            passwordValidationMessageLabel.text = "please_enter_strong_password".localized
        }else {
            password = passwordTextField.text!
        }
        if(email != "" && password != ""){
            if !InternetTest.isConnectedToNetwork(){
                self.alert(message: "alert_internet_message".localized, title: "alert_internet_title".localized, buttonTitle: "alert_internet_button".localized)
            }
            else{
                loginGetFunction(emailUser: email, passwordUser: password)
            }
            
        }
        //        ^                         Start anchor
        //        (?=.*[A-Z].*[A-Z])        Ensure string has one uppercase letters.
        //        (?=.*[!@#$&*])            Ensure string has one special case letter.
        //        (?=.*[0-9].*[0-9])        Ensure string has one digits.
        //        .{8}                      Ensure string is of length 8.
        //        $                         End anchor.
    }
    
    
    let spinner = UIActivityIndicatorView()
    let loadingView = UIView()
    let loadingLabel = UILabel()
    
    func loginGetFunction(emailUser: String, passwordUser: String){
        setLoadingScreenOnView(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner, actualView: self.view, navigationController: navigationController!, text: "loading".localized)
        let task: URLSessionDataTask?
        guard let url = URL(string: URL_LOGIN_USER) else {
            os_log("Bad URL loginGetFunction - LoginViewController", log: OSLog.default, type: .debug)
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let email = "email"
        let password = "password"
        let postDict : [String: Any] = [email: emailUser,
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
                        print(json)
                        DispatchQueue.main.async { // Make sure you're on the main thread here
                            removeLoadingScreenOnView(loadingView: self.loadingView, loadingLabel: self.loadingLabel, spinner: self.spinner, actualView: self.view)
                        }
                        let error = json["errMessage"] as? String ?? ""
                        if(error != ""){
                            DispatchQueue.main.async { // Make sure you're on the main thread here
                                self.passwordValidationMessageLabel.isHidden = false
                                self.passwordValidationMessageLabel.text = "email_or_password_is_wrong".localized
                            }
                        }
                        else{
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                            let version = dateFormatter.date(from: "1999-11-11T11:11:11.111Z")
                            let email = json["email"] as? String ?? ""
                            let id = json["id"] as? Int32 ?? 0
                            let last_name = json["last_name"] as? String ?? ""
                            let first_name = json["first_name"] as? String ?? ""
                            let guid = json["guid"] as? String ?? ""
                            let token = json["token"] as? String ?? ""
                            
                            if(!DatabaseHandler.saveDataUsers(guid: guid, auth: token, email: email, first_name: first_name, id: id, last_name: last_name, version_book: version!, version_library_card: version!)){
                                
                                os_log("Error save saveDataUsers loginGetFunction - LoginViewController", log: OSLog.default, type: .debug)
                            }
                            else{
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }catch{
                        os_log("Unable to parse JSON loginGetFunction - LoginViewController", log: OSLog.default, type: .debug)
                        self.passwordValidationMessageLabel.isHidden = false
                        self.passwordValidationMessageLabel.text = "email_or_password_is_wrong".localized
                    }
                }
            }
        }
        task?.resume()
    }
    
    @IBAction func emailTextFieldChange(_ sender: Any) {
        if(isValid(text: emailTextField.text!, regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}") && isValid(text: passwordTextField.text!, regex: "^[A-Za-z0-9.-]*$")){
            emailTextField.layer.shadowColor = GREEN.cgColor
        }
        else {
            emailTextField.layer.shadowColor = RED.cgColor
        }
    }
    
    @IBAction func passwordTextFieldChange(_ sender: Any) {
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
    
    
    @IBAction func languageClick(_ sender: Any) {
        if self.isTableVisible == false {
            addLanguages()
            isHiddenLoginForm(value: true)
            self.languageTableView.isHidden = false
            languageTableView.frame = CGRect(x: languageTableView.frame.origin.x, y: languageTableView.frame.origin.y, width: languageTableView.frame.size.width, height: languageTableView.contentSize.height)
            languageTableView.reloadData()
        } else {
            isHiddenLoginForm(value: false)
            self.languageTableView.isHidden = true
        }
    }
    
    func isHiddenLoginForm(value: Bool){
        passwordTextField.isHidden = value
        passwordStaticLabel.isHidden = value
        passwordValidationMessageLabel.isHidden = true
        emailValidationMessageLabel.isHidden = true
        emailStaticLabel.isHidden = value
        emailTextField.isHidden = value
        loginButton.isHidden = value
        registrationButton.isHidden = value
        self.isTableVisible = value
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
}
