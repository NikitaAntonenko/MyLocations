//
//  Location+CoreDataProperties.swift
//  MyLocations
//
//  Created by getTrickS2 on 1/25/18.
//  Copyright © 2018 Nik's. All rights reserved.
//
//

import Foundation
import CoreData
import CoreLocation


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }
    
    @NSManaged public var locationDescription: String
    @NSManaged public var category: String
    
    @NSManaged public var photoID: NSNumber?
    
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var placemark: CLPlacemark?
    @NSManaged public var date: Date

    // MARK: - Functions ===========================
    
    // =============================================
}
