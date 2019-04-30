//
//  ShowLibraryCardViewController.swift
//  Slopac
//
//  Created by Jozef Varga on 05/02/2019.
//  Copyright © 2019 Jozef Varga. All rights reserved.
//

import UIKit
import os.log
//import Social


protocol ShowBookDelegate {
    func sendDataFromDetail(bookDelegateData: BooksCoreData, isFromShowing: Bool)
}

class ShowFavoriteBookViewController: UIViewController ,EditBookShowDelegate, UITextViewDelegate {
    
    var delegate : ShowBookDelegate?
    
    func sendShowData(bookDelegateData: BooksCoreData) {
        DispatchQueue.main.async {
            self.favoriteBook = bookDelegateData
            self.setText()
        }
        
        setText()
        _ = navigationController?.popViewController(animated: true)
        
        callDelegateSendData()
    }
    
    var favoriteBook: BooksCoreData?
    var usersData : [UsersCoreData]?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorValueLabel: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var isbnValueLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingValueLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageValueLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var yearValueLabel: UILabel!
    @IBOutlet weak var editionLabel: UILabel!
    @IBOutlet weak var editionValueLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var publisherValueLabel: UILabel!
    @IBOutlet weak var publicationLabel: UILabel!
    @IBOutlet weak var publicationValueLabel: UILabel!
    
    @IBOutlet weak var searchBookInLibraryButton: UIButton!
    
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var tagImageView: UIImageView!
    
    
    
    
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookProgressView: UIProgressView!
    
    @IBOutlet weak var showFavoriteBookViewOnScrollView: UIView!
    @IBOutlet weak var showFavoriteBookScrollView: UIScrollView!
    
    
    @IBOutlet weak var languageLabelTopConstrain: NSLayoutConstraint!
    @IBOutlet weak var yearLabelTopConstrain: NSLayoutConstraint!
    @IBOutlet weak var editionLabelTopConstrain: NSLayoutConstraint!
    @IBOutlet weak var publisherLabelTopConstrain: NSLayoutConstraint!
    @IBOutlet weak var publicationLabelTopConstrain: NSLayoutConstraint!
    @IBOutlet weak var notesLabelTopConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var authorLabelTopConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var authorLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var authorStaticLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var isbnLabelTopConstrain: NSLayoutConstraint!
    @IBOutlet weak var ratingTopConstrain: NSLayoutConstraint!
    @IBOutlet weak var ratingValueTopConstrain: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUX()
        setText()
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//
//
//        setUX()
//        setText()
//    }
    
    func setUX(){
        view.backgroundColor = COLOR_THEME
        showFavoriteBookViewOnScrollView.backgroundColor = COLOR_THEME
        titleLabel.customLabel()
        editButton.customButton()
        searchBookInLibraryButton.customButton()
        authorLabel.customBoldLabel()
        authorValueLabel.customLabel()

        languageLabel.customBoldLabel()
        languageValueLabel.customLabel()
        yearLabel.customBoldLabel()
        yearValueLabel.customLabel()
        editionLabel.customBoldLabel()
        editionValueLabel.customLabel()
        publisherLabel.customBoldLabel()
        publisherValueLabel.customLabel()
        publicationLabel.customBoldLabel()
        publicationValueLabel.customLabel()
        
        
        isbnLabel.customBoldLabel()
        isbnValueLabel.customLabel()
        ratingLabel.customBoldLabel()
        ratingValueLabel.customLabel()
        notesLabel.customBoldLabel()
        notesTextView.customTextView()
        
        
//        notesTextView.translatesAutoresizingMaskIntoConstraints = true
//        notesTextView.sizeToFit()
        notesTextView.isScrollEnabled = false
        notesTextView.isEditable = false
//        notesTextView.layer.borderWidth = 0.5
//        notesTextView.layer.borderColor = COLOR_THEME_GREY.cgColor// UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
//        notesTextView.layer.cornerRadius = 5.0
        
//        notesValueLabel.customLabel()
        
//        bookImageView.tintColor = .black
//        showFavoriteBookScrollView.layoutIfNeeded()
//        showFavoriteBookScrollView.isScrollEnabled = true
//        showFavoriteBookScrollView.contentSize = CGSize(width: self.view.frame.width, height: showFavoriteBookScrollView.frame.size.height)
        
        
        self.notesTextView.delegate = self
        bookImageView.backgroundColor = COLOR_THEME_DARK
        bookImageView.contentMode = .scaleAspectFit
        shareBarButtonItem.image = UIImage(named: "icon_share_white")
//        notesTextView.isEditable = false
//        notesTextView.translatesAutoresizingMaskIntoConstraints = true
//        notesTextView.isScrollEnabled = false
    }
    
    func setText(){
        self.navigationItem.title = "detail_of_the_book".localized
        
        
        if(favoriteBook?.tags == 0){
            tagLabel.isHidden = true
            tagImageView.isHidden = true
        }
        else if(favoriteBook?.tags == 1){
            tagLabel.isHidden = false
            tagImageView.isHidden = false
            tagImageView.image = UIImage(named: "icon_tags_white")
            tagLabel.customTagLabel()
            tagLabel.text = "i_will_read".localized
            tagImageView.image = tagImageView.image!.imageWithColor(color: RED)
        }
        else if(favoriteBook?.tags == 2){
            tagLabel.isHidden = false
            tagImageView.isHidden = false
            tagImageView.image = UIImage(named: "icon_tags_white")
            tagLabel.customTagLabel()
            tagLabel.text = "i_reading".localized
            tagImageView.image = tagImageView.image!.imageWithColor(color: ORANGE)
        }
        else if(favoriteBook?.tags == 3){
            tagLabel.isHidden = false
            tagImageView.isHidden = false
            tagImageView.image = UIImage(named: "icon_tags_white")
            tagLabel.customTagLabel()
            tagLabel.text = "read_on".localized
            tagImageView.image = tagImageView.image!.imageWithColor(color: GREEN)
        }
        
        editButton.setTitle("edit_information".localized, for: .normal)
        editButton.setIconLeft(UIImage(named: "icon_edit_white")!)
        
        searchBookInLibraryButton.setTitle("search_in_library".localized, for: .normal)
        searchBookInLibraryButton.setIconLeft(UIImage(named: "icon_search_white")!)
        
        titleLabel.text = favoriteBook?.title
        if(favoriteBook?.author == ""){
            authorLabelTopConstraint.constant = -51
            authorLabel.isHidden = true
            authorValueLabel.isHidden = true
        }
        else{
            authorLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
            authorLabelTopConstrain.constant = 20
            authorLabel.isHidden = false
            authorValueLabel.isHidden = false
            authorLabel.text = "author".localized
            authorValueLabel.text = favoriteBook?.author
        }
        
        if(favoriteBook?.isbn == ""){
            
            isbnLabelTopConstrain.constant = -51
            //ratingTopConstrain.constant = -51
//            isbnLabelTopConstrain.isActive = false
//            isbnValueLabelTopConstrain.isActive = false
            isbnLabel.isHidden = true
            isbnValueLabel.isHidden = true
        }
        else{
            isbnLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
            isbnLabelTopConstrain.constant = 20
            //ratingTopConstrain.constant = 20
            isbnLabel.isHidden = false
            isbnValueLabel.isHidden = false
            isbnLabel.text = "isbn".localized
            isbnValueLabel.text = favoriteBook?.isbn
        }
        
        
        if(favoriteBook?.language == ""){
            languageLabelTopConstrain.constant = -51
            languageLabel.isHidden = true
            languageValueLabel.isHidden = true
        }
        else{
            languageLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
            languageLabelTopConstrain.constant = 20
            languageLabel.isHidden = false
            languageValueLabel.isHidden = false
            languageLabel.text = "language".localized
            languageValueLabel.text = favoriteBook?.language
        }
        
        if(favoriteBook?.year == ""){
            yearLabelTopConstrain.constant = -51
            yearLabel.isHidden = true
            yearValueLabel.isHidden = true
        }
        else{
            yearLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
            yearLabelTopConstrain.constant = 20
            yearLabel.isHidden = false
            yearValueLabel.isHidden = false
            yearLabel.text = "publish_year".localized
            yearValueLabel.text = favoriteBook?.year
        }
        
        if(favoriteBook?.edition == ""){
            editionLabelTopConstrain.constant = -51
            editionLabel.isHidden = true
            editionValueLabel.isHidden = true
        }
        else{
            editionLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
            editionLabelTopConstrain.constant = 20
            editionLabel.isHidden = false
            editionValueLabel.isHidden = false
            editionLabel.text = "edition".localized
            editionValueLabel.text = favoriteBook?.edition
        }
        
        
        if(favoriteBook?.publisher == ""){
            publicationLabelTopConstrain.constant = -51
            publisherLabel.isHidden = true
            publisherValueLabel.isHidden = true
        }
        else{
            publisherLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
            publisherLabelTopConstrain.constant = 20
            publisherLabel.isHidden = false
            publisherValueLabel.isHidden = false
            publisherLabel.text = "publisher".localized
            publisherValueLabel.text = favoriteBook?.publisher
        }
        
        if(favoriteBook?.publication == ""){
            publicationLabelTopConstrain.constant = -51
            publicationLabel.isHidden = true
            publicationValueLabel.isHidden = true
        }
        else{
            publicationLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
            publicationLabelTopConstrain.constant = 20
            publicationLabel.isHidden = false
            publicationValueLabel.isHidden = false
            publicationLabel.text = "publish_place".localized
            publicationValueLabel.text = favoriteBook?.publication
        }
        
        
        
        
//        languageLabel
//        languageValueLabel
//        yearLabel
//        yearValueLabel
//        editionLabel
//        editionValueLabel
//        publisherLabel
//        publisherValueLabel
//        publicationLabel
//        publicationValueLabel
//
//        languageLabelTopConstrain
//        yearLabelTopConstrain
//        editionLabelTopConstrain
//        publisherLabelTopConstrain
//        publicationLabelTopConstrain
//        notesLabelTopConstrain
//
        
        
        
        
        
        
        if(favoriteBook?.notes == ""){
            
            notesLabel.isHidden = true
            notesTextView.isHidden = true
        }
        else{
            notesLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
            notesLabel.isHidden = false
            notesTextView.isHidden = false
            notesLabel.text = "notes".localized
            notesTextView.text = favoriteBook?.notes
        }
        
        ratingLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 10)
        ratingValueLabel.layer.addBorder(edge: .top, color: COLOR_THEME_GREY, thickness: 0.3, shiftY: 5, shiftX: 5, longLeftSide: 0)
        ratingLabel.text = "rating".localized
        bookProgressView.progress = Float((favoriteBook?.feedback)!)/100
        ratingValueLabel.text = "\((favoriteBook?.feedback)!)"
        
        print("a he to tu") 
//        notesValueLabel.sizeToFit()
//        notesValueLabel.size
//        notesValueLabel.translatesAutoresizingMaskIntoConstraints = true
        if((favoriteBook?.cover?.isEmpty) ?? true){
            bookImageView.image = UIImage(named: "default_photo_book_1")
        }
        else{
            imageRotate(imagePhoto: UIImage(data:(favoriteBook?.cover)!,scale:1.0)!)
        }
    }
    
    func imageRotate(imagePhoto: UIImage){
        if(imagePhoto.size.width > imagePhoto.size.height){
            bookImageView.image = imagePhoto.rotate(radians: .pi/2)
        }else{
            bookImageView.image = imagePhoto
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
            
        case "EditFavoriteBook":
            guard let BookEditViewController = segue.destination as? EditBookViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            BookEditViewController.book = favoriteBook
            BookEditViewController.usersData = usersData
            BookEditViewController.isFromShowing = true
            //            libraryCardEditViewController.isChangePhoto = false
            BookEditViewController.delegateShow = self
            
        case "showLibraryForSearch":
            guard let SelectLibraryForSearchForViewController = segue.destination as? SelectLibraryForSearchViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            
            print("ppp0")
            
            print("ppp2")
            SelectLibraryForSearchForViewController.textNameOfFavoriteBook = favoriteBook?.title ?? "" 
//            SelectLibraryForSearchForViewController.
            
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
        
        
        
        let initValue = "share_book".localized
        let title1 = "title".localized + " :"
        let title2 = favoriteBook?.title ?? "undefined".localized
        let rating1 = "rating".localized + " :"
        let rating2 = favoriteBook?.feedback ?? 0
        let newLine = "\n"
        let newDoubleLine = "\n\n"
        var text = initValue + newDoubleLine + title1 + newLine + title2 + newDoubleLine + rating1 + newLine + String(rating2) + newDoubleLine
        
        
//        shareAll.
        if(favoriteBook?.author != ""){
            let author1 = "author".localized + " :"
            let author2 = favoriteBook?.author ?? "undefined".localized
            text = text + author1 + newLine + author2 + newDoubleLine
        }
        if(favoriteBook?.isbn != ""){
            let isbn1 = "isbn".localized + " :"
            let isbn2 = favoriteBook?.isbn ?? "undefined".localized
            text = text + isbn1 + newLine + isbn2 + newDoubleLine
        }
        if(favoriteBook?.language != ""){
            let language1 = "language".localized + " :"
            let language2 = favoriteBook?.language ?? "undefined".localized
            text = text + language1 + newLine + language2 + newDoubleLine
        }
        if(favoriteBook?.publisher != ""){
            let publisher1 = "publisher".localized + " :"
            let publisher2 = favoriteBook?.publisher ?? "undefined".localized
            text = text + publisher1 + newLine + publisher2 + newDoubleLine
        }
        
        if(favoriteBook?.publication != ""){
            let publish_place1 = "publish_place".localized + " :"
            let publish_place2 = favoriteBook?.publication ?? "undefined".localized
            text = text + publish_place1 + newLine + publish_place2 + newDoubleLine
        }
        if(favoriteBook?.edition != ""){
            let edition1 = "edition".localized + " :"
            let edition2 = favoriteBook?.edition ?? "undefined".localized
            text = text + edition1 + newLine + edition2 + newDoubleLine
        }
        if(favoriteBook?.year != ""){
            let publish_year1 = "publish_year".localized + " :"
            let publish_year2 = favoriteBook?.year ?? "undefined".localized
            text = text + publish_year1 + newLine + publish_year2 + newDoubleLine
        }
        if(favoriteBook?.notes != ""){
            let notes1 = "notes".localized + " :"
            let notes2 = favoriteBook?.notes ?? "undefined".localized
            text = text + notes1 + newLine + notes2 + newDoubleLine
        }
        
        let shareAll = [text] as [Any]
        
        print(shareAll)
        
        
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        
//        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
//
//            let tweetShare = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//            if let tweetShare = tweetShare {
//                tweetShare.setInitialText("Nice Tutorials of iOSDevCenters")
//                tweetShare.add(UIImage(named: "iOSDevCenters.jpg")!)
//                tweetShare.add(URL(string: "https://iosdevcenters.blogspot.com"))
//                self.present(tweetShare, animated: true, completion: nil)
//            }
//        } else {
//            print("Not Available")
//        }
    }
    
    
    func callDelegateSendData(){
        if self.delegate != nil {
            self.delegate?.sendDataFromDetail(bookDelegateData: self.favoriteBook!, isFromShowing: true)
            //dismiss the modal
            //            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
}
