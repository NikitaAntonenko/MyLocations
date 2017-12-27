//
//  FirstViewController.swift
//  MyLocations
//
//  Created by getTrickS2 on 12/27/17.
//  Copyright © 2017 Nik's. All rights reserved.
//

import UIKit

class CurrentLocationViewController: UIViewController {
    
    // Outlets ==============================
    @IBOutlet weak var massageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    // =========================================
    
    // Actions =================
    @IBAction func getLocation() {
        // do nothing yet
        print("Hello")
    }
    // =========================
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

