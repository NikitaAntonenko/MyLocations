//
//  LocationsViewControllerTableViewController.swift
//  MyLocations
//
//  Created by getTrickS2 on 1/28/18.
//  Copyright © 2018 Nik's. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class LocationsViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: - Variables =============================================
    var managedObjectContext: NSManagedObjectContext!
    var locations = [Location]()
    lazy var fetchResultsController: NSFetchedResultsController<Location> = { // I have the locations
        // 1. Create the object that discribes which object you're going to fetch from the data store
        let fetchRequest = NSFetchRequest<Location>()
        // 2. Configure the "fetchRequest" object
        // Tell the fetch request that I'm looking for "Locations" entitys
        fetchRequest.entity = Location.entity()
        // Sort on the objects in ascending order and by categories
        let sortDescriptor1 = NSSortDescriptor(key: "category", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        // How many objects you will be fetched at a time
        fetchRequest.fetchBatchSize = 20
        // 3. Create the "FetchedResultsController" object
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.managedObjectContext,
                                                                  sectionNameKeyPath: "category", cacheName: "Locations")
        // 4. Configure the "FetchedResultsController" object
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    // ===============================================================
    
    // MARK: - Functions =============================================
    func performFetch() {
        do {
            try fetchResultsController.performFetch()
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    deinit {
        // Now object can't get any more notification
        fetchResultsController.delegate = nil
    }
    // ===============================================================
    
    // MARK: - Override functions ====================================
    override func viewDidLoad() {
        super.viewDidLoad()
        // Some Description !!!
        performFetch()
        navigationItem.rightBarButtonItem = editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Table view data source ---

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchResultsController.sections!.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchResultsController.sections![section].name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sectionInfo = fetchResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1. Create the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        // 2. Create the location
        let location = fetchResultsController.object(at: indexPath)
        // 3. Configure the cell...
        cell.configure(for: location)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 1. Delete the row from the data source
            let location = fetchResultsController.object(at: indexPath)
            managedObjectContext.delete(location)
            // 2. Try to save changes
            do {
                try managedObjectContext.save()
            } catch {
                fatalCoreDataError(error)
            }
        }
    }
    

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
        if segue.identifier == "EditLocation" {
            // 1. Create controller ---
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.viewControllers[0] as! LocationDatailsViewController
            // 2. If "indexPath" of "sender" is exists than we set the controller ---
            if let indexPaht = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.managedObjectContext = managedObjectContext
                controller.locationToEdit = fetchResultsController.object(at: indexPaht)
                
            }
        }
    }
    // ===============================================================
    
    // MARK: - NSFetchedResultsControllerDelegate ====================
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    // For rows
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .update:
            if let cell = tableView.cellForRow(at: indexPath!) as? LocationCell {
                let location = controller.object(at: indexPath!) as! Location
                cell.configure(for: location)
            }
        }
    }
    // For sections
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    // ===============================================================

}































