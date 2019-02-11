//
//  CategoryTableViewController.swift
//  ToDoList
//
//  Created by Göran Macbook Air on 2019-02-09.
//  Copyright © 2019 gemeDesign. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()


    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
        
    }

    //MARK: - TableView Delegate Method
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItem" {
            let dvc = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
              dvc.selectedCategory = categoryArray[indexPath.row]
            }

            
        }
    }
    
    
    //MARK: - Delete Row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // 1. Delete context 2. delete Catagory at indexpath.row. 3. delete row in tableview. 4. save context
            context.delete(categoryArray[indexPath.row])
            categoryArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            saveCatagory()
        }
    }

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let myAlert = UIAlertController(title: "Add New Todo Category", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            self.saveCatagory()
            
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
    
    
    func loadCategory() {
        
        let request: NSFetchRequest = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error load Category \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    
    func saveCatagory() {
        
        do {
            try context.save()
            
        } catch {
            print("Error saving Category \(error.localizedDescription)")
        }
    }
    
    
}
