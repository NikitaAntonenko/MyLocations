//
//  LocationCell.swift
//  MyLocations
//
//  Created by getTrickS2 on 1/29/18.
//  Copyright © 2018 Nik's. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    // MARK: - Variables ================================
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    // ==================================================
    
    // MARK: - Functions ================================
    func configure(for location: Location) {
        // 1 Set description label ---
        if location.locationDescription.isEmpty {
            descriptionLabel.text = "(No Description)"
        } else {
            descriptionLabel.text = location.locationDescription
        }
        // 2 Set address label ---
        if let placemark = location.placemark {
            var text = ""
            // Fill text variable
            if let s = placemark.subThoroughfare {text += s + " "}
            if let s = placemark.thoroughfare {text += s + ","}
            if let s = placemark.locality {text += s}
            // Set in
            addressLabel.text = text
        } else {
            addressLabel.text = String(format: "Lat: %.8f, Long: %.8f", location.latitude, location.longitude)
        }
    }
    // ==================================================
    
    // MARK: - Override functions =======================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // ==================================================
}
