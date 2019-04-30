//
//  MapViewController.swift
//  Slopac
//
//  Created by Jozef Varga on 16/12/2018.
//  Copyright © 2018 Jozef Varga. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var latitudeLibrary = 48.207031
    var longitudeLibrary = 16.979679
    var setupTitle = ""
    var setupSubtitle = ""
    let locationManager = CLLocationManager()
    var previousLocation: CLLocation?
    var directionsArray: [MKDirections] = []
    
    let spinner = UIActivityIndicatorView()
    let loadingView = UIView()
    
    let loadingLabel = UILabel()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoadingScreenOnView(loadingView: loadingView, loadingLabel: loadingLabel, spinner: spinner, actualView: self.view, navigationController: navigationController!, text: "loading".localized)
        checkLocationServices()
        getDirections()
        distanceLabel.backgroundColor = COLOR_THEME_GREY
        timeLabel.backgroundColor = COLOR_THEME_GREY
        distanceLabel.customLabel()
        timeLabel.customLabel()
    }
    
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as CLLocationManagerDelegate
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
    
    func  getDirections() {
        guard let location = locationManager.location?.coordinate else {
            //TODO: Inform user we don't have their current location
            
            print("oooô")
            return
        }
        
        
        let request = createDirectionsRequest(from: location)
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
        
        directions.calculate { [unowned self] (response, error) in
            //TODO: Handle error if needed
            guard let response = response else { return } //TODO: Show response not available in an alert
            print("aaaaaaa")
            print(response.routes.distance(from: 0, to: 1000000000))
             print("aaaaaaa")
            var i = 0
            for route in response.routes {
                i = i + 1
                
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
            }
            print("final " , i)
            print("ale toto je koniec")
            DispatchQueue.main.async { // Make sure you're on the main thread here
                removeLoadingScreenOnView(loadingView: self.loadingView, loadingLabel: self.loadingLabel, spinner: self.spinner, actualView: self.view)
            }
        }
        
        
        print("rezerva")
//        print(directions.)
        print("rezerva")
        print("ahoj konci2")
        print("ahoj konci2")
    }
    
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        let destinationCoordinate = getCenterLocation(for: mapView).coordinate
        print("ale nie")
        print(latitudeLibrary)
        print(longitudeLibrary)
        
        let pin =  MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: latitudeLibrary , longitude: longitudeLibrary)
        pin.title =  setupTitle
        pin.subtitle = setupSubtitle
        self.mapView.addAnnotation(pin)
        
        
        let startingLocation = MKPlacemark(coordinate: coordinate)
        
        var distance = 0.0
        let sourceDistance  = MKMapItem( placemark: MKPlacemark(
            coordinate: CLLocationCoordinate2DMake(startingLocation.coordinate.latitude, startingLocation.coordinate.longitude),
            addressDictionary: nil))
        let destinationDistance  = MKMapItem(placemark: MKPlacemark(
            coordinate: CLLocationCoordinate2DMake(latitudeLibrary, longitudeLibrary),
            addressDictionary: nil))
        
        let directionsRequestDistance = MKDirections.Request()
        directionsRequestDistance.source = sourceDistance
        directionsRequestDistance.destination = destinationDistance
        
        let directionsDistance = MKDirections(request: directionsRequestDistance)
        
        directionsDistance.calculate { (response, error) -> Void in
            distance = response!.routes.first!.distance // meters
            print("\(distance / 1000)km")
            
            
            
            
            
            
            
            DispatchQueue.main.async { // Make sure you're on the main thread here
                print(distance)
                let km = distance / 1000
                let meter = distance - (floor(km) * 1000)
                let hour = (distance / 5000)
                let min = (hour - floor(hour)) * 60
                var time = ""
                if (floor(hour) > 0){time = String(Int(floor(hour))) + " h "}
                if (min < 1){ time = time + " <1 min" }
                else{
                    time = time + String(Int(floor(min))) + " min"
                }
                var distanceText = ""
                if(distance >= 1000){
                    distanceText = String(Int(floor(km))) + " km "
                }
                distanceText = distanceText + String(Int(floor(meter))) + " m "
                
                
                self.distanceLabel.text = "  " + distanceText //"distance = \(distance) m"
                self.timeLabel.text = time + "\t"
            }
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//
//        let distance = CLLocation(latitude: latitudeLibrary, longitude: longitudeLibrary).distance(from: CLLocation(latitude: startingLocation.coordinate.latitude, longitude: startingLocation.coordinate.longitude))
        
        
        
        print("ahoj zacina")
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = false
        print("ahoj konci")
        
        return request
    }
    
    func resetMapView(withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
    }
    
    
}


