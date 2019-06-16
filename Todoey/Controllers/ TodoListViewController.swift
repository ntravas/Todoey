//
//  ViewController.swift
//  Todoey
//
//  Created by Neven Travaš on 18/02/2019.
//  Copyright © 2019 Neven Travaš. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let newItem = Item()
//        newItem.title = "Milk"
//        itemArray.append(newItem)
//
//        let newItem1 = Item()
//        newItem1.title = "Bread"
//        itemArray.append(newItem1)
//        
//        let newItem2 = Item()
//        newItem2.title = "Butter"
//        itemArray.append(newItem2)
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }
        // Do any additional setup after loading the view, typically from a nib.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK:  - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title
        
            cell.accessoryType = item.done == true ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items added"
        }
        
        // same as commented out code below
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }
//
//        else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }
            catch {
                print("Error saving done status \(error) ")
            }

        }
        
        tableView.reloadData()
        
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done // same as the if else statements commented below
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }
//
//        else {
//            itemArray[indexPath.row].done = false
//        }
        
//        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey Item", message: "" , preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
           
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//
//            self.itemArray.append(newItem)
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                    
                } catch {
                    print("Error saving context \(error)")
                    
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model manipulation methods
    
    
    
//    func loadItems(){
//        if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            }
//            catch {
//                print("Error decoding item array, \(error)")
//            }
//        }
//    }
    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let  additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
//        }
//        else {
//            request.predicate = categoryPredicate
//        }
////        let compaundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
////
////        request.predicate = compaundPredicate
//
//        do {
//           itemArray = try context.fetch(request)
//        }
//        catch {
//            print("Error fetching data from context \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    }
}

//MARK: - Search bar Methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData() 
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                }
            }
        }
    }

