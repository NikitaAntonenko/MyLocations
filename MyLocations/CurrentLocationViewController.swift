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
    // =========================================

    // Variables ============================
    // For location managet ---
    let locationManager = CLLocationManager() // That is the object that will give you the GPS coordinates.
    var location: CLLocation? // Will store the most recent update of user's location.
    var updatingLocation = false // Flag.
    var lastLocationError: Error? // Save the last error.
    // =========================================
    
    // Override functions ======
    override func viewDidLoad() {
        // phase one ---
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        // 1. Update screen ---
        updateLabels()
        configureGetButton()
        // 2. Check status ---
        let authStatus = CLLocationManager.authorizationStatus()
        // If authStatus did not determinate we set it (in the first run app only one time)
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    // =========================
    
    // Actions =================
    @IBAction func getLocation() {
        // Stop or Start?
        if updatingLocation {
            // Stop ---
            stopLocationManager()
        } else {
            // Start ---
            // Now we already have a determinated status
            let authStatus = CLLocationManager.authorizationStatus()
            
            // If authStatus do not allow to Get Locations
            if authStatus == .denied || authStatus == .restricted {
                showLocationServicesDeniedAlert()
                return
            }
            // Get new locations
            location = nil
            lastLocationError = nil
            startLocationManager()
        }
        
        // Update screen ---
        updateLabels()
        configureGetButton()
        
    }
    // =========================
    
    // Functions ===============
    // Alert for situation when we do not have enable to the location services ---
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert,animated: true,completion: nil)
    }
    // Update labels ---
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
            
            // Fill message ---
            var statusMessage: String
            if let error = (lastLocationError as NSError?) {
                if error.code == CLError.denied.rawValue &&
                    error.domain == kCLErrorDomain {
                    statusMessage = "Location Services Disabled"
                } else {
                    statusMessage = "Error Getting Location"
                }
            } else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Services Disabled"
            } else if updatingLocation {
                statusMessage = "Searching..."
            } else {
                statusMessage = "Tap 'Get My Location' to start"
            }
            // -----------------
            
            messageLabel.text = statusMessage
        }
    }
    // Start Location Manager ---
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }
    // Stop Location Manager ---
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
    // Configure Get Button ---
    func configureGetButton() {
        if updatingLocation {
            getButton.setTitle("Stop", for: .normal)
        } else {
            getButton.setTitle("Get My Location", for: .normal)
        }
    }
    // =========================
    
    // CLLocationManegerDelegate ===========
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 1. Print error
        print("didFailWithError \(error)")
        // 2. If an error can't get any location information. We are trying until we find a location.
        if (error as NSError).code == CLError.locationUnknown.rawValue { return }
        // 3. More sirious error we store into a new instance variable
        lastLocationError = error
        // 4. Stop Location Manager
        stopLocationManager()
        // 5. Update screen
        updateLabels()
        configureGetButton()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        
        // Control --------------------
        // 1. We'll simply ignore these cached locations if they are too old
        if newLocation.timestamp.timeIntervalSinceNow < -5 { return }
        // 2. To determine wether new readings are more accurate than previous ones
        if newLocation.horizontalAccuracy < 0 { return }
        // 3. if the new reading is more useful than the privious one
        if location == nil || newLocation.horizontalAccuracy < location!.horizontalAccuracy {
            // Go next
            // Wipe the old error code
            lastLocationError = nil
            // Save location
            location = newLocation
            updateLabels()
            
            // if the new location's accuracy is equal to or better then the disire accuracy
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("*** We're done!")
                stopLocationManager()
                configureGetButton()
            }
        }
        // ---------------------------
    }
    // =====================================

}



























