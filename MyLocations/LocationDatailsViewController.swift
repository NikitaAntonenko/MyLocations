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

    // MARK: - Outlets ==============================
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    // =========================================
    
    // MARK: - Variables ==============================
    // MARK: For Location ---
    var descriptionText = ""
    var categoryName = "No Category"
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    var date = Date()
    var image: UIImage? {
        didSet {
            if let theImage = image {
                show(image: theImage)
            }
        }
    }
    // MARK: Anouther ---
    // Stores the reference to the observer of "NotificationCenter" named "UIApplicationDidEnterBackground",
    // which is necessary to unregister it later.
    var observer: Any!
    // I know how translate "Data()" to string
    // And I can configurate myself with closure help (Dop. init)
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    // MARK: For Core Data ---
    var managedObjectContext: NSManagedObjectContext! // need for to do something with Core Data
    
    // MARK: For Edit Location ---
    var locationToEdit: Location? {
        didSet{
            if let location = locationToEdit {
                descriptionText = location.locationDescription
                categoryName = location.category
                coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                placemark = location.placemark
                date = location.date
            }
        }
    }
    // ========================================
    
    // MARK: - Actions =================================
    deinit {
        // Remove the observer of "NotificationCenter" named "UIApplicationDidEnterBackground"
        NotificationCenter.default.removeObserver(observer)
    }
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func done() {
        // 1. Create Location object for save
        let location: Location
        // 2. Show Tagged View
        let hudView = HudView.hud(inView: navigationController!.view, animated: true)
        // 3. Configure the Tagged View and the locatiol "let" variable
        if let temp = locationToEdit {
            hudView.text = "Updated"
            location = temp
        } else {
            hudView.text = "Tagged"
            location = Location(context: managedObjectContext)
        }
        // 4. Fill the location object
        location.locationDescription = descriptionTextView.text
        location.category = categoryName
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.date = date
        location.placemark = placemark
        // 5. Try to save the location
        do{
            try managedObjectContext.save()
            
            afterDelay(0.5) {
                self.dismiss(animated: true, completion: nil)
            }
        } catch {
            fatalCoreDataError(error)
        }
        
        
    }
    @IBAction func categoryPickerDidPickCategory (_ segue: UIStoryboardSegue) {
        let controller = segue.source as! CategoryPickerViewController
        categoryName = controller.selectedCategoryName
        categoryLabel.text = categoryName
    }
    // =========================================
    
    // MARK: - Functions ===============================
    
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
    
    // I can show the image on a proper cell
    func show(image: UIImage) {
        imageView.image = image
        imageView.isHidden = false
        imageView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width,
                                 height: view.bounds.size.width * image.size.height / image.size.width)
        addPhotoLabel.isHidden = true
    }
    
    func listenForBackgroundNotification() {
        observer = NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationDidEnterBackground, object: nil, queue: .main) {
             [weak self] _ in
            // 1. If there is an active any of the screens (image picker or action sheet), I dismiss it
            if let strongSelf = self {
                if strongSelf.presentedViewController != nil {
                    strongSelf.dismiss(animated: true, completion: nil)
                }
                // 2. Hide the keyboard if the text view was active
                strongSelf.descriptionTextView.resignFirstResponder()
            }
        }
    }
    // =========================================

    // MARK: - Override functions ======================
    
    override func viewDidLoad() {
        // phase one
        super.viewDidLoad()
        if locationToEdit != nil {
            title = "Edit Location"
        }
        // 1. Set first section
        descriptionTextView.text = descriptionText
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
        
        listenForBackgroundNotification()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITAbleViewDelegate ---
    
    // I known how tall each cell is.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0,0): // Description label
            return 88
        case (1,0): // Image cell
            return imageView.isHidden ? 44 : imageView.bounds.size.height
        case (2,2): // Address label
            // 1. Storyboard parametrs
            // 2. Change the current width
            addressLabel.frame.size = CGSize(width: view.bounds.size.width - 115, height: 10_000)
            // 3. Set the height
            addressLabel.sizeToFit()
            // 4. Change the current x position
            addressLabel.frame.origin.x = view.bounds.size.width - addressLabel.frame.size.width - 15
            // Return seting parametrs with boards (10 at the top and at the end)
            return addressLabel.frame.size.height + 20
        default:
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // If section of indexPath no zero or one didSelectRowAt delegate won't execute !!!
        if indexPath.section == 0 || indexPath.section == 1 { return indexPath }
        else { return nil }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            descriptionTextView.becomeFirstResponder()
        case(1,0):
            tableView.deselectRow(at: indexPath, animated: true)
            pickPhoto()
        default:
            break
        }
    }
    
    // MARK: Table view data source ---

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

    // MARK: Navigation ---

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

// MARK: - The photo picker
extension LocationDatailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Use Camera
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    // Use Library
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    // Show the photo menu
    func showPhotoMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: {_ in self.takePhotoWithCamera()})
        let chooseFromLibraryAction = UIAlertAction(title: "Choose From Library", style: .default, handler: {_ in self.choosePhotoFromLibrary()})
        // Set actions
        alertController.addAction(cancelAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(chooseFromLibraryAction)
        
        present(alertController, animated: true, completion: nil)
    }
    // If camera is enabled
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    // MARK: For delegate ---
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        image = info[UIImagePickerControllerEditedImage] as? UIImage
        tableView.reloadData() // Very important row
        dismiss(animated: true, completion: nil)
    }
    
    
}

















































