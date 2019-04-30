//
//  showLibraryCardViewController.swift
//  Slopac
//
//  Created by Jozef Varga on 06/02/2019.
//  Copyright © 2019 Jozef Varga. All rights reserved.
//

import UIKit
//import Foundation

protocol ShowLibraryCardDelegate {
    func sendDataFromDetail(libraryCardDelegateData: LibraryCardCoreData, isFromShowing: Bool)
}

class ShowLibraryCardViewController: UIViewController, EditLibraryCardShowDelegate {

    
    var delegate : ShowLibraryCardDelegate?
    
    func sendShowData(libraryCardDelegateData: LibraryCardCoreData) {
        DispatchQueue.main.async {
            self.libraryCard = libraryCardDelegateData
            self.setText()
        }
        
        setText()
        _ = navigationController?.popViewController(animated: true)
        
        callDelegateSendData()
    }
    
    
//    func sendUpdateData(libraryCardDelegateData: LibraryCardCoreData, updateId: Int32, updatePath: String, updateIsInDatabase: Int16) {
//
//    }
    
    
    var libraryCard: LibraryCardCoreData?
    var usersData : [UsersCoreData]?
    
//    func sendData(libraryCardDelegateData: LibraryCardCoreData, isFromShowing: Bool) {
//        print("Ale nie")
//
//        DispatchQueue.main.async {
//            self.libraryCard = libraryCardDelegateData
//            self.setText()
//        }
//        _ = navigationController?.popViewController(animated: true)
//
//    }
    
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var showLibraryCardScrollView: UIScrollView!
    @IBOutlet weak var showLibraryCardViewOnScrollView: UIView!
    @IBOutlet weak var libraryNameLabel: UILabel!
    @IBOutlet weak var libraryNameValueLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var codeValueLabel: UILabel!
    @IBOutlet weak var codePictureLabel: UILabel!
    @IBOutlet weak var codePictureImageView: UIImageView!
    @IBOutlet weak var photoPictureLabel: UILabel!
    @IBOutlet weak var photoPictureImageView: UIImageView!
    @IBOutlet weak var showPictureImageView: UIImageView!
 
    @IBOutlet weak var libraryCardLabel: UILabel!
    @IBOutlet weak var libraryCardValueLabel: UILabel!
    
    
    @IBOutlet weak var libraryValueTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var libraryNameStaticTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var libraryNameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var codeStaticTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var codeValueTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var pictureStaticValueTopConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateValueLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUX()
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTappedCode(tapGestureRecognizer:)))
        codePictureImageView.isUserInteractionEnabled = true
        codePictureImageView.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTappedShow(tapGestureRecognizer:)))
        showPictureImageView.isUserInteractionEnabled = true
        showPictureImageView.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTappedCover(tapGestureRecognizer:)))
        photoPictureImageView.addGestureRecognizer(tapGestureRecognizer3)
        
        showPictureImageView.isHidden = true
        setText()
    }
    
    func setUX(){
        view.backgroundColor = COLOR_THEME
        showLibraryCardViewOnScrollView.backgroundColor = COLOR_THEME
        editBarButtonItem.image = UIImage(named: "icon_edit_white")
        libraryNameLabel.customBoldLabel()
        libraryNameValueLabel.customLabel()
        codeLabel.customBoldLabel()
        codeValueLabel.customLabel() 
        libraryCardLabel.customBoldLabel()
        libraryCardValueLabel.customLabel()
        
        dateLabel.customBoldLabel()
        dateValueLabel.customLabel()
        codePictureLabel.customBoldLabel()
        photoPictureLabel.customBoldLabel()
        
        codePictureImageView.contentMode = .scaleAspectFit
        showPictureImageView.contentMode = .scaleAspectFit
        photoPictureImageView.contentMode = .scaleAspectFit
    }
    
    func setText(){
        self.navigationItem.title = "detail_of_the_card".localized
        libraryNameLabel.text = "name_of_license".localized
        codeLabel.text = "the_code_of_the_card".localized
//        codeLabel.text = "ahoj"
        codePictureLabel.text = "the_barcode_of_the_card".localized
        photoPictureLabel.text = "photo_of_the_card".localized
        libraryCardLabel.text = "library_name".localized
        var library = DatabaseHandler.fetchDataLibrariesFromId(id: String((libraryCard?.library_id)!))
        
        
        
//        libraryCardValueLabel.text = library?[0].library_name
        
//        codeValueLabel.text = libraryCard?.code
        
//        codeValueLabel.backgroundColor = RED
//        print(libraryCard)
        
        
//        codeValueLabel.text = "asdklaklsd"
//        print("jjjjjjjjjjjjjjjjjjjjjjjj")
//        print(codeValueLabel.text)
        
//        print(libraryCard)
//
//        print(library)
//
//        codeValueLabel.text = "code"
//        libraryCardValueLabel.text = "card"
//        libraryNameValueLabel.text  = "namv"
//        print(library?[0].library_name)
//        print(libraryCard?.code)
//        print(libraryCard?.library_name)
        libraryCardValueLabel.text = library?[0].library_name
        codeValueLabel.text = libraryCard?.code
        libraryNameValueLabel.text = libraryCard?.library_name
        
        dateLabel.text = "date_expiration".localized
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        if((libraryCard?.date) != nil){
            dateValueLabel.text = dateFormatter2.string(from: (libraryCard?.date)!)
        }
        else{
            dateValueLabel.text = "undefined".localized
        }
//        libraryValueTopConstraint.constant = 5
//        libraryNameStaticTopConstraint.constant = 20
//        libraryNameTopConstraint.constant = 5
//        codeStaticTopConstraint.constant = 20
//        codeValueTopConstraint.constant = 5
//        pictureStaticValueTopConstraint.constant = 50
//
//
//        libraryCardValueLabel.backgroundColor = RED
//        codeValueLabel.backgroundColor = RED
//        libraryNameValueLabel.backgroundColor = RED
        
//        codeValueLabel.contentMode = .scaleToFill
//        libraryNameValueLabel.contentMode = .scaleToFill
//        libraryCardValueLabel.contentMode = .scaleToFill
        
        dateLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
        codeLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
        codePictureLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5 , shiftX: 5, longLeftSide: 0)
        photoPictureLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
        libraryNameLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
//        libraryNameValueLabel.text  = "namv"
        
//        libraryCardValueLabel.text = library?[0].library_name
//        codeValueLabel.text = libraryCard?.code
//        libraryNameValueLabel.text = libraryCard?.library_name
        
        if((libraryCard?.picture?.isEmpty) ?? true){
            photoPictureImageView.isHidden = true
            photoPictureLabel.isHidden = true
//            photoPictureLabel.isHidden = true
            showLibraryCardScrollView.isScrollEnabled = false
            photoPictureImageView.isUserInteractionEnabled = false
        }
        else{
            imageRotate(imagePhoto: UIImage(data:(libraryCard?.picture)!,scale:1.0)!)
            photoPictureImageView.isHidden = false
            photoPictureLabel.isHidden = false
//            photoPictureLabel.isHidden = false
            
            showLibraryCardScrollView.isScrollEnabled = true
            photoPictureImageView.isUserInteractionEnabled = true
        }
        codePictureImageView.image = createBarcode(from: (libraryCard?.code)!)
    }
    
    func createBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    @objc func imageTappedCode(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        showPictureImageView.image = codePictureImageView.image
        isHiddenForm(value: true)
        imageRotateShow(image: codePictureImageView.image!)
    }
    
    @objc func imageTappedShow(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        isHiddenForm(value: false)
    }
    
    @objc func imageTappedCover(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        imageRotateShow(image: photoPictureImageView.image!)
        isHiddenForm(value: true)
    }

    func imageRotateShow(image: UIImage){
        if(image.size.width < image.size.height){
            showPictureImageView.image = image
        }else{
            showPictureImageView.image = image.rotate(radians: .pi + .pi/2)
        }
    }
    
    func imageRotate(imagePhoto: UIImage){
        if(imagePhoto.size.width < imagePhoto.size.height){
            photoPictureImageView.image = imagePhoto.rotate(radians: .pi/2)
        }else{
            photoPictureImageView.image = imagePhoto
        }
    }
    
    func isHiddenForm(value: Bool){
        libraryNameLabel.isHidden = value
        libraryNameValueLabel.isHidden = value
        codeLabel.isHidden = value
        codeValueLabel.isHidden = value
        codePictureLabel.isHidden = value
        codePictureImageView.isHidden = value
        if((libraryCard?.picture?.isEmpty) ?? true){
            photoPictureImageView.isHidden = true
            photoPictureLabel.isHidden = true
        }else{
            photoPictureLabel.isHidden = value
            photoPictureImageView.isHidden = value
        }
        showPictureImageView.isHidden = !value
        libraryCardLabel.isHidden = value
        libraryCardValueLabel.isHidden = value
        
        dateLabel.isHidden = value
        dateValueLabel.isHidden = value
        if(value == true){
            showLibraryCardViewOnScrollView.backgroundColor = UIColor.black
        }
        else{
            showLibraryCardViewOnScrollView.backgroundColor = COLOR_THEME
        }
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "EditLibraryCardDetail":
            guard let libraryCardEditViewController = segue.destination as? EditLibraryCardViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            libraryCardEditViewController.libraryCard = libraryCard
            libraryCardEditViewController.usersData = usersData
            libraryCardEditViewController.isFromShowing = true
            print("p")
//            libraryCardEditViewController.datePickerTextField.text =
            
            libraryCardEditViewController.dateFromShow = dateValueLabel.text ?? ""
            print("pp")
//            libraryCardEditViewController.isChangePhoto = false
            libraryCardEditViewController.delegateShow = self
            
            
//            let vc : EditLibraryCardViewController = segue.destination as! EditLibraryCardViewController
//            vc.delegate = self
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    func callDelegateSendData(){
        if self.delegate != nil {
            self.delegate?.sendDataFromDetail(libraryCardDelegateData: self.libraryCard!, isFromShowing: true)
            //dismiss the modal
//            self.dismiss(animated: true, completion: nil)
        }
    }
}
