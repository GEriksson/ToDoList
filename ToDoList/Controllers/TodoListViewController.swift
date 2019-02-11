//
//  ViewController.swift
//  ToDoList
//
//  Created by Göran Macbook Air on 2019-01-28.
//  Copyright © 2019 gemeDesign. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let dataPathFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        
    }


    //MARK: - TableView Datasource Method
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
        
        if item.done == false {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
        
        return cell
        
    }

    // MARK: - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveUserData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }
    
    //MARK: - Delete Row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
    // 1. Delete context 2. delete itemArray at indexpath.row. 3. delete row in tableview. 4. save context
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            saveUserData()
        }
    }
    
    
    
    //MARK: - Add button pressed
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let myAlert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
        
        do {
           try context.save()
            
        } catch {
            print("Error saving Context \(error.localizedDescription)")
        }
        
    }
    
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil)  {

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        // Om search rutan används skall både categoryPredicate och additionalPredicate(kommer från sökrutans input) användas
        if let additionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        
        } else {
            // Om ingen additionPredicate finns används endast Catogory för att visa alla i vald category
            request.predicate = categoryPredicate
        }

        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error read CoreData \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    
}


//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: request.predicate)
    }
    
    
    
    //
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}
