//
//  CheckBookViewController.swift
//  Slopac
//
//  Created by Jozef Varga on 03/03/2019.
//  Copyright © 2019 Jozef Varga. All rights reserved.
//

import UIKit

/// Checking lent book
class CheckBookViewController: UIViewController, ScanISBNDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var borderImageView: UIImageView!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var iconStatusButton: UIButton!
    @IBOutlet weak var statusInformationLabel: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    
    // MARK: - Delegate function
    
    /// Delegate Isbn for write
    ///
    /// - Parameter isbnText: isbn text
    func writeISBN(isbnText: String) {
        isbnLabel.text = "ISBN: \(isbnText)"
        _ = navigationController?.popViewController(animated: true)
        controlBook(isbn: isbnText)
    }
    
    // MARK: - Start function, text and UX settup
    override func viewDidLoad() {
        super.viewDidLoad()
        scanButton.sendActions(for: .touchUpInside)
        setUX()
        setText()
    }
    
    func setUX(){
        view.backgroundColor = COLOR_THEME
        isbnLabel.isHidden = true
        statusInformationLabel.isHidden = true
        borderImageView.isUserInteractionEnabled = false
        scanButton.customButton()
        isbnLabel.customBoldLabel()
        statusInformationLabel.customLabel()
        iconStatusButton.setImage(UIImage(named: "scanner")!, for: .normal)
        borderImageView.layer.borderColor = COLOR_THEME_GREY.cgColor
        iconStatusButton.tintColor = COLOR_THEME_GREY
        borderImageView.layer.borderWidth = 3.0
        borderImageView.layer.cornerRadius = 15
        statusInformationLabel.textAlignment = .center
        isbnLabel.textAlignment = .center
    }
    
    func setText(){
        self.navigationItem.title = "existence_of_the_rent".localized
        statusInformationLabel.text = "the_book_was_not_borrowed_yet".localized
        iconStatusButton.setTitle("", for: .normal)
        scanButton.setIconLeft(UIImage(named: "icon_barcode_scanner_white")!)
        scanButton.setTitle("take_the_barcode".localized, for: .normal)
    }
    
    /// Control lent books
    ///
    /// - Parameter isbn: isbn string for check book lent
    func controlBook(isbn: String){
        if !InternetTest.isConnectedToNetwork(){
            iconStatusButton.setImage(UIImage(named: "scanner")!, for: .normal)
            borderImageView.layer.borderColor = COLOR_THEME_GREY.cgColor
            iconStatusButton.tintColor = COLOR_THEME_GREY
            self.alert(message: "alert_internet_message".localized, title: "alert_internet_title".localized, buttonTitle: "alert_internet_button".localized)
        }
        else{
            let fraction = Float.random(in: 0 ..< 1)
            print(fraction)
//            if(fraction > 0.5){
            if(isbn != "9788022205627" ){
                iconStatusButton.setImage(UIImage(named: "no")!, for: .normal)
                statusInformationLabel.text = "the_book_was_not_borrowed_yet".localized
                borderImageView.layer.borderColor = RED.cgColor
                iconStatusButton.tintColor = RED
            }
            else{
                iconStatusButton.setImage(UIImage(named: "yes")!, for: .normal)
                statusInformationLabel.text = "the_book_has_already_been_borrowed".localized
                borderImageView.layer.borderColor = GREEN.cgColor
                iconStatusButton.tintColor = GREEN
            }
            isbnLabel.isHidden = false
            iconStatusButton.isHidden = false
            statusInformationLabel.isHidden = false
        }
    }
    
    // MARK: - Click function
    @IBAction func imageButtonClick(_ sender: Any) {
        scanButton.sendActions(for: .touchUpInside)
    }
    
    // MARK: - Prepare function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scanISBN" {
            let vc : BarcodeScannerViewController = segue.destination as! BarcodeScannerViewController
            vc.delegate = self
        }
    }
    
}
