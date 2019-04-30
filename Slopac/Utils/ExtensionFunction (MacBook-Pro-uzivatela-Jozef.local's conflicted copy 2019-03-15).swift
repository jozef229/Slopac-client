//
//  ExtensionFunction.swift
//  Slopac
//
//  Created by Jozef Varga on 21/12/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

import UIKit
import MapKit
import SystemConfiguration

private var kBundleKey: UInt8 = 0

public class InternetTest {
    class func isConnectedToNetwork() -> Bool {
        var address = sockaddr_in()
        address.sin_len = UInt8(MemoryLayout.size(ofValue: address))
        address.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &address) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

class BundleEx: Bundle {
    
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = objc_getAssociatedObject(self, &kBundleKey) {
            return (bundle as! Bundle).localizedString(forKey: key, value: value, table: tableName)
        }
        return super.localizedString(forKey: key, value: value, table: tableName)
    }
    
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat, shiftY: CGFloat, shiftX: CGFloat, longLeftSide: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0 - shiftX, y: 0 - shiftY, width: frame.width + 10 + longLeftSide, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0 - shiftX, y: frame.height - thickness + shiftY, width: frame.width + 10, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        addSublayer(border)
    }
}




extension UIViewController {
    func reloadViewFromNib() {
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view) // This line causes the view to be reloaded
    }
}

func isValid(text: String, regex: String) -> Bool {
    let emailTest = NSPredicate(format:"SELF MATCHES %@", regex)
    return emailTest.evaluate(with: text)
}

func setLoadingScreen(loadingView: UIView, loadingLabel: UILabel, spinner: UIActivityIndicatorView, tableView: UITableView, navigationController: UINavigationController, text: String ) {
    
    // Sets the view which contains the loading text and the spinner
    let width: CGFloat = 190
    let height: CGFloat = 30
    let x = (tableView.frame.width / 2) - (width / 2)
    let y = (tableView.frame.height / 2) - (height / 2) - (navigationController.navigationBar.frame.height)
    loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
    loadingView.backgroundColor = COLOR_THEME_DARK
    loadingView.isHidden = false
    loadingView.layer.cornerRadius = 5
    
    // Sets loading text
    loadingLabel.textColor = .gray
    loadingLabel.textAlignment = .center
    loadingLabel.text = text
    loadingLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
    
    // Sets spinner
    spinner.style = .white
    spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    spinner.startAnimating()
    
    // Adds text and spinner to the view
    loadingView.addSubview(spinner)
    loadingView.addSubview(loadingLabel)
    tableView.isUserInteractionEnabled = false
    tableView.addSubview(loadingView)
    
}

// Remove the activity indicator from the main view
func removeLoadingScreen(loadingView: UIView, loadingLabel: UILabel, spinner: UIActivityIndicatorView, tableView: UITableView) {
    spinner.stopAnimating()
    spinner.isHidden = true
    loadingLabel.isHidden = true
    loadingView.isHidden = true
    tableView.isUserInteractionEnabled = true
}

func setLoadingScreenOnView(loadingView: UIView, loadingLabel: UILabel, spinner: UIActivityIndicatorView, actualView: UIView, navigationController: UINavigationController, text: String ) {
    
    // Sets the view which contains the loading text and the spinner
    let width: CGFloat = 190
    let height: CGFloat = 30
    let x = (actualView.frame.width / 2) - (width / 2)
    let y = (actualView.frame.height / 2) - (height / 2) - (navigationController.navigationBar.frame.height)
    loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
    loadingView.backgroundColor = COLOR_THEME_GREY  //
    loadingView.isHidden = false
    loadingView.layer.cornerRadius = 5
    
    // Sets loading text
    loadingLabel.textColor = .white //
    loadingLabel.textAlignment = .center
    loadingLabel.text = text
    loadingLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
    
    // Sets spinner
    spinner.style = .white
    spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    spinner.startAnimating()
    
    // Adds text and spinner to the view
    loadingView.addSubview(spinner)
    loadingView.addSubview(loadingLabel)
    actualView.isUserInteractionEnabled = false
    actualView.addSubview(loadingView)
    
}

// Remove the activity indicator from the main view
func removeLoadingScreenOnView(loadingView: UIView, loadingLabel: UILabel, spinner: UIActivityIndicatorView, actualView: UIView) {
    spinner.stopAnimating()
    spinner.isHidden = true
    loadingLabel.isHidden = true
    loadingView.isHidden = true
    actualView.isUserInteractionEnabled = true
}



extension Bundle {
    
    static let once: Void = {
        object_setClass(Bundle.main, type(of: BundleEx()))
    }()
    
    class func setLanguage(_ language: String?) {
        Bundle.once
        let isLanguageRTL = Bundle.isLanguageRTL(language)
        if (isLanguageRTL) {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        UserDefaults.standard.set(isLanguageRTL, forKey: "AppleTextDirection")
        UserDefaults.standard.set(isLanguageRTL, forKey: "NSForceRightToLeftWritingDirection")
        UserDefaults.standard.synchronize()
        
        let value = (language != nil ? Bundle.init(path: (Bundle.main.path(forResource: language, ofType: "lproj"))!) : nil)
        objc_setAssociatedObject(Bundle.main, &kBundleKey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    class func isLanguageRTL(_ languageCode: String?) -> Bool {
        return (languageCode != nil && Locale.characterDirection(forLanguage: languageCode!) == .rightToLeft)
    }
    
}

//extension UITabBar: UITabBarControllerDelegate {
//    private func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        //for blocking double tap on 3rd tab only
//        let indexOfNewVC = tabBarController.viewControllers?.index(of: viewController)
//        return ((indexOfNewVC != 2) ||
//            (indexOfNewVC != tabBarController.selectedIndex))
//    }
//}

extension NSMutableData {
    
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}



 






extension UIButton{
    func customButton(){
        self.setTitleColor(COLOR_THEME_WHITE, for: .normal)
        self.layer.cornerRadius = 5
        self.backgroundColor = COLOR_THEME_DARK
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.numberOfLines = 0
        //        self.contentEdgeInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
        //        self.titleEdgeInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)  ffffffff
        //        self.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        //        self.contentEdgeInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)//UIEdgeInsets(top: 50,left: 20,bottom: 50,right: 20)
    }
    
    func customNoBorderButton(){
        self.setTitleColor(COLOR_THEME_WHITE, for: .normal)
        self.layer.cornerRadius = 5
        self.backgroundColor = COLOR_THEME
        self.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.numberOfLines = 0
    }
    
    func setIconLeft(_ image: UIImage) {
        self.setImage(image, for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
//        self.imageView?.tintColor = COLOR_THEME_WHITE
        self.tintColor = COLOR_THEME_WHITE
    }
    
}

extension UILabel{
    func customLabel(){
        self.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        self.textColor = COLOR_THEME_WHITE
        self.numberOfLines = 0;
        self.lineBreakMode =  .byWordWrapping
        self.font = UIFont.systemFont(ofSize: 16)
        self.numberOfLines = 0;
    }
    
    func customBoldLabel(){
        self.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        self.textColor = COLOR_THEME_WHITE
        self.numberOfLines = 0;
        self.font = UIFont.boldSystemFont(ofSize: self.font.pointSize)
        self.lineBreakMode =  .byWordWrapping
        self.font = UIFont.systemFont(ofSize: 16)
    }
    
    func customValidationLabel(){
        self.textColor = RED
        self.lineBreakMode =  .byWordWrapping
        self.font = UIFont.systemFont(ofSize: 16)
        self.numberOfLines = 0;
    }
    
    func customCellTableLabel(text: String){
        self.text = text
        self.textColor = COLOR_THEME_WHITE
        self.lineBreakMode =  .byWordWrapping
        self.font = UIFont.systemFont(ofSize: 16)
        self.numberOfLines = 0;
    }
    
    func customSmallCellTableLabel(text: String){
        self.text = text
        self.textColor = UIColor.gray
        self.lineBreakMode =  .byWordWrapping
        self.font = UIFont.systemFont(ofSize: 13)
        self.numberOfLines = 0;
    }
    
    
}

extension UITableView{
    func customTableView(){
        self.backgroundColor = COLOR_THEME_DARK
    }
}

extension UITextView {
    func customTextView(){
        self.backgroundColor = COLOR_THEME
        self.textColor = COLOR_THEME_WHITE
        self.layer.backgroundColor = COLOR_THEME.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.shadowColor = COLOR_THEME_GREY.cgColor
        self.autocorrectionType = .no
        self.tintColor = COLOR_THEME_GREY
        self.font = UIFont.systemFont(ofSize: 16)
//        self.sizeToFit()
    }
    
    
}

extension UITextField {
    
    func customTextfield() {
        self.backgroundColor = COLOR_THEME
        self.textColor = COLOR_THEME_WHITE
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.backgroundColor = COLOR_THEME.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.shadowColor = COLOR_THEME_GREY.cgColor
        self.autocorrectionType = .no
        self.tintColor = COLOR_THEME_GREY
        
//        self.sizeToFit()
        
        self.font = UIFont.systemFont(ofSize: 16)
        //        self.setValue(COLOR_THEME_GREY, forKeyPath: "_placeholderLabel.textColor")
        
    }
    
    func setIconLeft(_ image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 2, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    
    func customSetText(text: String) {
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

//extension Progress {
//    func customProgressBar(){
//        self.
//    }
//}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        
        return renderer
    }
}

extension UIImageView {
    func loadPicture(isbn: String) {
        
        let queryParams = ["multi":"{\"isbn\":\"\(isbn)\"}", "encsigla":ENCSIGLA_CODE]
        var components = URLComponents()
        components.scheme = COMPONENTS_SCHEME
        components.host = COMPONENTS_HOST
        components.path = COMPONENTS_PATH
        
        components.queryItems = queryParams.map {
            URLQueryItem(name: $0,
                         value: $1.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)
        }
        let url = components.url
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if(image.size.width == 1 && image.size.height == 1){
                            self?.backgroundColor = COLOR_THEME_DARK
//                            self?.tintColor = COLOR_THEME_DARK
//                            self?.col
                            self?.image = UIImage(named: "default_photo_book_1")
                            //                            EditBookViewController.showAlert
                        }
                        else{
                            self?.image = image
                        }
                    }
                }
            }
        }
    }
    
    
    func loadPictureWithLoadingScreen(isbn: String, loadingView: UIView, loadingLabel: UILabel, spinner: UIActivityIndicatorView, actualView: UIView, navigationController: UINavigationController, text: String) {
        
        setLoadingScreenOnView(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner, actualView: actualView, navigationController: navigationController, text: text)
        
        let queryParams = ["multi":"{\"isbn\":\"\(isbn)\"}", "encsigla":ENCSIGLA_CODE]
        var components = URLComponents()
        components.scheme = COMPONENTS_SCHEME
        components.host = COMPONENTS_HOST
        components.path = COMPONENTS_PATH
        
        components.queryItems = queryParams.map {
            URLQueryItem(name: $0,
                         value: $1.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)
        }
        let url = components.url
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if(image.size.width == 1 && image.size.height == 1){
                            self?.backgroundColor = COLOR_THEME_DARK
                            //                            self?.tintColor = COLOR_THEME_DARK
                            //                            self?.col
                            self?.image = UIImage(named: "default_photo_book_1")
                            //                            EditBookViewController.showAlert
                            removeLoadingScreenOnView(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner, actualView: actualView)
                        }
                        else{
                            self?.image = image
                            removeLoadingScreenOnView(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner, actualView: actualView)
                            showBasicAlert(title: "teraz sa nepodarilo", message: "stiahnut", title_button: "co chces")
                        }
                    }
                }
            }
        }
    }
}

func DistancePlace(latitude1: Double, longitude1: Double, latitude2: Double, longitude2: Double) -> Double{
    return CLLocation(latitude: latitude1, longitude: longitude1).distance(from: CLLocation(latitude: latitude2, longitude: longitude2))
}


func validIsbn13(isbn: String) -> Bool{
    let weight = [1, 3]
    var checksum = 0
    for i in 0..<12 {
        if let intCharacter = Int(String(isbn[isbn.index(isbn.startIndex, offsetBy: i)])) {
            checksum += weight[i % 2] * intCharacter
        }
    }
    if let check = Int(String(isbn[isbn.index(isbn.startIndex, offsetBy: 12)])) {
        return (check - ((10 - (checksum % 10)) % 10) == 0)
    }
    return false
}

func showBasicAlert(title: String, message: String, title_button: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    
    alert.addAction(UIAlertAction(title: title_button, style: UIAlertAction.Style.default, handler: { _ in
        //Cancel Action
    }))
    self.present(alert, animated: true, completion: nil)
}

