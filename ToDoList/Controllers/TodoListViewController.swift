//
//  ViewController.swift
//  ToDoList
//
//  Created by Göran Macbook Air on 2019-01-28.
//  Copyright © 2019 gemeDesign. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()

    var defaults = UserDefaults.standard
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Läkarintyg"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Köp Lingonsylt"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Semester"
        itemArray.append(newItem3)
        
        getStoredData()
        
    }


    //MARK - TableView Datasource Method
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
//        cell.accessoryType = item.isChecked == true ? .checkmark : .none
        
        if item.isChecked == false {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
        
        return cell
        
    }

    // MARK - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }
    
    
    //MARK - Add button pressed
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let myAlert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            

            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
            
        }
        
        myAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
            
        }
        
        myAlert.addAction(action)
        print("Alert Added")
        present(myAlert, animated: true, completion: nil)

    }
    
    func saveUserDefault(newItem : Item) {

        
    }
    
    
    func getStoredData() {
        // Hämtar från Default array av Item objects
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            
            itemArray = items

        }
        
    }
    
    
    
}

