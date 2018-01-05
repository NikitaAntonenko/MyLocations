//
//  FirstViewController.swift
//  MyLocations
//
//  Created by getTrickS2 on 12/27/17.
//  Copyright © 2017 Nik's. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    // Outlets ==============================
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    // Variables ---
    let locationManager = CLLocationManager() // The CLLocationManager is the object that will give you the GPS coordinates.
    var location: CLLocation? // Will store the most recent update of user's location
    // =========================================
    
    // Override functions ======
    override func viewDidLoad() {
        // phase one
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        updateLabels()
        let authStatus = CLLocationManager.authorizationStatus()
        // If authStatus did not determinate we set it (in the first run app only one time)
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    // =========================
    
    // Actions =================
    @IBAction func getLocation() {
        // Now we already have a determinated status
        let authStatus = CLLocationManager.authorizationStatus()
        
        // If authStatus do not allow to Get Locations
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
    }
    // =========================
    
    // Functions ===============
    // Alert for situation when we do not have enable to the location services
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert,animated: true,completion: nil)
    }
    // Update labels
    func updateLabels() {
        if let location = location {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            tagButton.isHidden = false
            messageLabel.text = ""
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.isHidden = true
            messageLabel.text = "Tap 'Get My Location' to Start"
        }
    }
    // =========================
    
    // CLLocationManegerDelegate ===========
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last!
        print("didUpdateLocations \(location!)")
        updateLabels()
    }
    // =====================================

}



























