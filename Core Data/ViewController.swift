//
//  ViewController.swift
//  Core Data
//
//  Created by Air on 9/17/20.
//  Copyright © 2020 Anton Serdyuk. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    // Referense to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Data of the table
    var items:[Car]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Get items from the Core data
        fetchCars()
        
        // The title
        title = "The list of cars"
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
    }
    
    func fetchCars() {
        // Fetch data from Core data to display in the tabeview
        do{
            self.items = try context.fetch(Car.fetchRequest())
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//      super.viewWillAppear(animated)
//
//      //1
//      guard let appDelegate =
//        UIApplication.shared.delegate as? AppDelegate else {
//          return
//      }
//
//      let managedContext =
//        appDelegate.persistentContainer.viewContext
//
//      //2
//      let fetchRequest =
//        NSFetchRequest<NSManagedObject>(entityName: "Person")
//
//      //3
//      do {
//        people = try managedContext.fetch(fetchRequest)
//      } catch let error as NSError {
//        print("Could not fetch. \(error), \(error.userInfo)")
//      }
//    }
    
    // Implementing the addItem IBAction
    
    
    @IBAction func addItem(_ sender: Any) {
         // Create alert
        let alert = UIAlertController(title: "New Car", message: "Add a new car",
                                      preferredStyle: .alert)
        alert.addTextField()
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            
            // Get the text field
            let textfield = alert.textFields![0]
            
            // Crate a item oject
            let newItem = Car(context: self.context)
            newItem.model = textfield.text
            newItem.body_type = "default_body_type"
            newItem.manufacturer = "default_manufacturer"
            newItem.year_of_ssue = 0
            
            // Save the data
            do{
                try self.context.save()
            }
            catch{
                
            }
            
            // Re-fetch the data
            self.fetchCars()
            
                    
                
        //            guard let textField = alert.textFields?.first,
        //                let itemToSave = textField.text else {
        //                    return
        //            }
        //
        //            //self.save(item: itemToSave)
        //            self.tableView.reloadData()
                }
        let cancelAction = UIAlertAction(title: "Cancel",
                                              style: .cancel)
             
             
               alert.addAction(saveAction)
               alert.addAction(cancelAction)
             
               present(alert, animated: true)
    }
    
    
//    func save(name: String) {
//
//      guard let appDelegate =
//        UIApplication.shared.delegate as? AppDelegate else {
//        return
//      }
//
//      // 1
//      let managedContext =
//        appDelegate.persistentContainer.viewContext
//
//      // 2
//      let entity =
//        NSEntityDescription.entity(forEntityName: "Person",
//                                   in: managedContext)!
//
//      let person = NSManagedObject(entity: entity,
//                                   insertInto: managedContext)
//
//      // 3
//      person.setValue(name, forKeyPath: "name")
//
//      // 4
//      do {
//        try managedContext.save()
//        people.append(person)
//      } catch let error as NSError {
//        print("Could not save. \(error), \(error.userInfo)")
//      }
//    }
    
    

}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
    // Return the numer of items
    return self.items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
        //Get item from the array and set the label
        let item = self.items![indexPath.row]
    
        cell.textLabel?.text = item.model
   // cell.textLabel?.text =
     // person.value(forKeyPath: "name") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Select Item
        let item = self.items![indexPath.row]
        
        // Create alert
        let alert = UIAlertController(title: "Edit Car", message: "Edit model", preferredStyle: .alert)
        alert.addTextField()
        
        let textfield = alert.textFields![0]
        textfield.text = item.model
        
        // Configurate buttan handler
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            // Get the textfield for the alert
            let textfield = alert.textFields![0]
            
            // Edit property of item object
            item.model = textfield.text
            
            // Save the data
            do{
                try self.context.save()
            }
            catch{
                
            }
            
            // Re-fetch the data
            self.fetchCars()
        }
        
        // Add Button
        alert.addAction(saveButton)
        
        // Show alert
        self.present(alert, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Create swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, comletionHendler) in
            
            // Witch item to remove
            let itemToRemove = self.items![indexPath.row]
            
            // Remove the item
            self.context.delete(itemToRemove)
            
            // Save the data
            do{
                try self.context.save()
            }
            catch{
                
            }
            
            // Re-fetch the data
            self.fetchCars()
        }
        
        // Return swipe action
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}


