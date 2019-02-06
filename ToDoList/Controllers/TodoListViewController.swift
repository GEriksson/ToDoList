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
    
    let dataPathFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")


    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataPathFilePath!)
        
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
        saveUserData()
        
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
            self.saveUserData()

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
    
    func saveUserData() {

        let encoder = PropertyListEncoder()
        
        do {
            
            let data = try encoder.encode(itemArray)
            try data.write(to: dataPathFilePath!)
            
        } catch {
            print("Error encoding data \(error.localizedDescription)")
        }
        
    }
    
    
    func getStoredData() {

        if let data = try? Data(contentsOf: dataPathFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray =  try decoder.decode([Item].self, from: data)
                
            } catch {
                print("Error decoding Items \(error.localizedDescription)")
            }
        }
    }
    
    

}
