//
//  LocationDatailsViewController.swift
//  MyLocations
//
//  Created by getTrickS2 on 1/13/18.
//  Copyright © 2018 Nik's. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class LocationDatailsViewController: UITableViewController {

    // Outlets ==============================
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    // =========================================
    
    // Variables ==============================
    // For Location ---
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    var categoryName = "No Category"
    var date = Date()
    
    private let dateFormatter: DateFormatter = { // I know how translate "Data()" to string
        let formatter = DateFormatter()          // And I can configurate myself with closure help (Dop. init)
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    // For Core Data ---
    var managedObjectContext: NSManagedObjectContext! // need for to do something with Core Data
    // ========================================
    
    // Actions =================================
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func done() {
        // Show Tagged View ---
        let hudView = HudView.hud(inView: navigationController!.view, animated: true)
        hudView.text = "Tagged"
        
        // Save in Core Data ---
        // 1. Create Location object
        let location = Location(context: managedObjectContext)
        // 2. Set location object
        location.locationDescription = descriptionTextView.text
        location.category = categoryName
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.date = date
        location.placemark = placemark
        // 3. Try to save
        do{
            try managedObjectContext.save()
            
            afterDelay(0.5) {
                self.dismiss(animated: true, completion: nil)
            }
        } catch {
            fatalError("Error: \(error)")
        }
        
        
    }
    @IBAction func categoryPickerDidPickCategory (_ segue: UIStoryboardSegue) {
        let controller = segue.source as! CategoryPickerViewController
        categoryName = controller.selectedCategoryName
        categoryLabel.text = categoryName
    }
    // =========================================
    
    // Functions ===============================
    
    // Placemark translator
    func string(from placemark: CLPlacemark) -> String {
        var text = ""
        if let s = placemark.subThoroughfare { text += s + " " } // street number
        if let s = placemark.thoroughfare { text += s + ","} // street name
        if let s = placemark.locality { text += s + "," } // the city
        if let s = placemark.administrativeArea { text += s + "," } // the state or province
        if let s = placemark.postalCode { text += s + ","} // zip code
        if let s = placemark.country { text += s } // country
        
        return text
    }
    
    // I can translate date object into string with dateFormatter help
    func format(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    // I can hide the keyboard. I will execute whenewer the user taps somewhere in the viev (set in viewDidLoad())
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        if let indexPath = indexPath,
            indexPath.section == 0 && indexPath.row == 0 {
            return
        }
        
        descriptionTextView.resignFirstResponder()
    }
    // =========================================

    // Override functions ======================
    
    override func viewDidLoad() {
        // phase one
        super.viewDidLoad()
        // 1. Set first section
        descriptionTextView.text = ""
        categoryLabel.text = categoryName
        // 2. Set third section
        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        if let placemark = placemark { addressLabel.text = string(from: placemark) }
        else { addressLabel.text = "No Address Found" }
        dateLabel.text = format(date: date)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -UITAbleViewDelegate
    
    // I known how tall each cell is.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 { return 88 } // Description label
        else if indexPath.section == 2 && indexPath.row == 2 { // Address label
            // 1. Storyboard parametrs
            // 2. Change the current width
            addressLabel.frame.size = CGSize(width: view.bounds.size.width - 115, height: 10_000)
            // 3. Set the height
            addressLabel.sizeToFit()
            // 4. Change the current x position
            addressLabel.frame.origin.x = view.bounds.size.width - addressLabel.frame.size.width - 15
            // Return seting parametrs with boards (10 at the top and at the end)
            return addressLabel.frame.size.height + 20
        } else { return 44 } // Remaining labels
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // If section of indexPath no zero or one didSelectRowAt delegate won't execute !!!
        if indexPath.section == 0 || indexPath.section == 1 { return indexPath }
        else { return nil }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            descriptionTextView.becomeFirstResponder()
        }
    }
    
    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "PickCategory" {
            let controller = segue.destination as! CategoryPickerViewController
            
            controller.selectedCategoryName = categoryName
        }
    }
    // =========================================
    

}
