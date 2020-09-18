//
//  ViewController.swift
//  Cars_test_task
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
    

    // Implementing the addItem IBAction
    
    @IBAction func addItem(_ sender: Any) {
        
        // Create alert
        let alert = UIAlertController(title: "New Car", message: "Add a new car",
                                      preferredStyle: .alert)
        // Add TextFields in alert
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        
        // Set hints and input types
        alert.textFields![0].placeholder = "Manufacturer"
        alert.textFields![1].placeholder = "Model"
        alert.textFields![2].placeholder = "Body type"
        alert.textFields![3].placeholder = "Production year"
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            
            
            // Crate a item oject
            let newItem = Car(context: self.context)
            
            // Set properties
            newItem.manufacturer = alert.textFields?[0].text ?? ""
            newItem.model = alert.textFields?[1].text ?? ""
            newItem.body_type = alert.textFields?[2].text ?? ""
            
            // Checking int value
            let year = alert.textFields?[3].text ?? ""
            var number = Int(year)
            if number == nil{
                number = 0
            }
            newItem.production_year = Int16(number!)
            
            
            // Save the data
            do{
                try self.context.save()
            }
            catch{
                
            }
            
            // Re-fetch the data
            self.fetchCars()
            
                    
                
       
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
             
             
               alert.addAction(saveAction)
               alert.addAction(cancelAction)
             
               present(alert, animated: true)
    }
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
    
        // Get item from the array and set the label
        let item = self.items![indexPath.row]
        
        // Put data in cell
        cell.textLabel?.text = item.manufacturer! + " " + item.model! + " " + item.body_type! + " " + String(item.production_year)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Select Item
        let item = self.items![indexPath.row]
        
        // Create alert
        let alert = UIAlertController(title: "Edit Car", message: "Edit model", preferredStyle: .alert)
        
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()

        
        alert.textFields![0].text = item.manufacturer
        alert.textFields![1].text = item.model
        alert.textFields![2].text = item.body_type
        alert.textFields![3].text = String(item.production_year)
        
        // Configurate button handler
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            
            // Edit property of item object
            item.manufacturer = alert.textFields?[0].text ?? ""
            item.model = alert.textFields?[1].text ?? ""
            item.body_type = alert.textFields?[2].text ?? ""
            
            // Checking int value
            let year = alert.textFields?[3].text ?? ""
            var number = Int(year)
            if number == nil{
                number = 0
            }
            item.production_year = Int16(number!)
            
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


