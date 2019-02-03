//
//  ViewController.swift
//  ToDoList
//
//  Created by Göran Macbook Air on 2019-01-28.
//  Copyright © 2019 gemeDesign. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [String]()
    var itemChecked  = [Bool]()
    
    var defaults = UserDefaults.standard
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        cell.textLabel?.text = itemArray[indexPath.row]
        
        if itemChecked[indexPath.row] == false {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
        
        return cell
        
    }

    // MARK - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if itemChecked[indexPath.row] == false {
            itemChecked[indexPath.row] = true

        } else {
            itemChecked[indexPath.row] = false
        }

//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        saveUserDefault()
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }
    
    
    //MARK - Add button pressed
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let myAlert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            self.itemArray.append(textField.text!)
            self.itemChecked.append(false)

            self.saveUserDefault()
            
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
    
    func saveUserDefault() {
        self.defaults.set(self.itemArray, forKey: "TodoListArray")
        self.defaults.set(self.itemChecked, forKey: "CheckedArray")
        
    }
    
    
    func getStoredData() {
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
    }
        if let checkedArray = defaults.array(forKey: "CheckedArray") as? [Bool] {
            itemChecked = checkedArray
        }
        
    }
    
    
}

