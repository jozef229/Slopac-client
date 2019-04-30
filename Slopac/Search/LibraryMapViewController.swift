//
//  LibraryMapViewController.swift
//  Slopac
//
//  Created by Jozef Varga on 09/04/2019.
//  Copyright © 2019 Jozef Varga. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

import Foundation

class LibraryMapViewController: UIViewController , MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    var latitudeLibrary = 48.207031
    var longitudeLibrary = 16.979679
    var setupTitle = ""
    var setupSubtitle = ""
    let locationManager = CLLocationManager()
    var previousLocation: CLLocation?
    var directionsArray: [MKDirections] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("asd");
        self.navigationItem.title = "maps_of_library".localized
        checkLocationServices()
        setupLocation()
        // Do any additional setup after loading the view.
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuthorization()
        } else {
            
            print("oookl")
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if let location = locationManager.location?.coordinate {
                let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
                mapView.setRegion(region, animated: true)
            }
            locationManager.startUpdatingLocation()
            previousLocation = getCenterLocation(for: mapView)
        case .denied:
            print("ooo")
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            print("ooo+")
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("oooé")
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            
            print("ooop")
            break
        }
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        return CLLocation(latitude: CLLocationDegrees(latitudeLibrary), longitude: CLLocationDegrees(longitudeLibrary))
    }
    
    func setupLocation(){
        
        var locationDataFull : [LibraryLocationsCoreData]?
        locationDataFull = DatabaseHandler.fetchDataLibraryLocations()
        
        for locationsData in locationDataFull! {
            var libraryData = DatabaseHandler.fetchDataLibrariesFromId(id: String(locationsData.library_id))
            var addressData = DatabaseHandler.fetchDataAddressFromId(id: String(locationsData.address_id))
            
            let pin =  MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2D(latitude: (addressData?[0].latitude)! , longitude: (addressData?[0].longtitude)!)
            pin.title = libraryData?[0].library_name
            pin.subtitle = locationsData.location_name
//            pin.call
            
            self.mapView.addAnnotation(pin)
        }
        
    }
    
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation {return nil}
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            let calloutButton = UIButton(type: .contactAdd)//.detailDisclosure)
//            calloutButton.ima .image = UIImage(named: "icon_edit_white")
            pinView!.rightCalloutAccessoryView = calloutButton
            pinView!.sizeToFit()
        }
        else {
            pinView!.annotation = annotation
        }
        
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
//            view.
            let libraryData = DatabaseHandler.fetchDataLibraries()
            for library in libraryData! {
                if(view.annotation?.title == library.library_name){ 
                    LIBRARY_ID_SELECT_FOR_SEARCH = Int(library.id)
                    LIBRARY_NAME_SELECT_FOR_SEARCH = library.library_name!
                    let searchBook = self.storyboard?.instantiateViewController(withIdentifier: "SearchBookViewController") as! SearchBookViewController
                    
                    print("AAAAAAA")
                    self.navigationController?.pushViewController(searchBook, animated: true)
                }
            }
            print()
            print("button tapped")
        }
    }
    
    func resetMapView(withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
    }

}
