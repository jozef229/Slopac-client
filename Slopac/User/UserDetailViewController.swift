//
//  UserDetailViewController.swift
//  Slopac
//
//  Created by Jozef Varga on 24/12/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

import UIKit
import os.log

class UserDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var languageTableView: UITableView!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstNameValueLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var surnameValueLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailValueLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var informationValue1Label: UILabel!
    @IBOutlet weak var informationValue2Label: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    var isTableVisible = false
    var userData : [UsersCoreData]?
    var libraryCardData : [LibraryCardCoreData]?
    var booksData : [BooksCoreData]?
    
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated:true);
        super.viewDidLoad()
        userData = DatabaseHandler.fetchDataUsers()!
        addLanguages()
        setUX()
        setText()
        setTextInformation()
        languageTableView.delegate = self
        languageTableView.dataSource = self
        self.languageTableView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        setTextInformation()
    }
    
    func setUX(){
        view.backgroundColor = COLOR_THEME
        logOutButton.customButton()
        languageButton.customButton()
        firstNameLabel.customBoldLabel()
        firstNameValueLabel.customLabel()
        languageButton.setIconLeft(UIImage(named: "icon_language_white")!)
        surnameLabel.customBoldLabel()
        surnameLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
        surnameValueLabel.customLabel()
        emailLabel.customBoldLabel()
        emailLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
        emailValueLabel.customLabel()
        informationLabel.customBoldLabel()
        informationLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
        informationValue1Label.customLabel()
        informationValue2Label.customLabel()
        languageTableView.customTableView()
    }
    
    func setText(){
        self.navigationItem.title = "account_slopac".localized
        languageButton.setTitle("choice_language".localized , for: .normal)
        firstNameLabel.text = "name".localized
        surnameLabel.text = "surname".localized
        emailLabel.text = "e-mail".localized
        informationLabel.text = "information".localized
        logOutButton.setTitle("log_out".localized, for: .normal)
    }
    
    func setTextInformation(){
        booksData = DatabaseHandler.fetchDataBookWithoutDelete()
        libraryCardData = DatabaseHandler.fetchDataLibraryCardWithoutDelete()
        if((userData?.count)! > 0){
            firstNameValueLabel.text = userData?[0].first_name
            surnameValueLabel.text = userData?[0].last_name
            emailValueLabel.text = userData?[0].email
            informationValue1Label.text = "number_of_licenses".localized + " : " + "\(libraryCardData?.count ?? 0)"
            informationValue2Label.text = "number_of_favorites".localized + " : " + "\(booksData?.count ?? 0)"
        }
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
        setText()
        self.dismiss(animated: true, completion: nil)
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
        logOutButton.isHidden = value
        firstNameLabel.isHidden = value
        firstNameValueLabel.isHidden = value
        surnameLabel.isHidden = value
        surnameValueLabel.isHidden = value
        emailLabel.isHidden = value
        emailValueLabel.isHidden = value
        informationLabel.isHidden = value
        informationValue1Label.isHidden = value
        informationValue2Label.isHidden = value
        self.isTableVisible = value
    }
    
    @IBAction func logOutClick(_ sender: Any) {
        if(!DatabaseHandler.cleanDataUsers()){
            os_log("Error clean data cleanDataUsers logOutClick - UserDetailViewController", log: OSLog.default, type: .debug)
        }
        if(!DatabaseHandler.cleanDataLibraryCard()){
            os_log("Error clean data cleanDataLibraryCard logOutClick - UserDetailViewController", log: OSLog.default, type: .debug)
        }
        if(!DatabaseHandler.cleanDataBooks()){
            os_log("Error clean data cleanDataBooks logOutClick - UserDetailViewController", log: OSLog.default, type: .debug)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
