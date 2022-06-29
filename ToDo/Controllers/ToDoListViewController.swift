//
//  ViewController.swift
//  ToDo
//
//  Created by Tanaka Mawoyo on 09.06.22.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    //pass category of the selected category
    var selectedCategory: Category? {
        didSet{
            loadItems()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color {
            title = selectedCategory!.name
            
            guard let navBar = navigationController?.navigationBar else {fatalError("no navigation controller exists")}
            navBar.barTintColor = UIColor(hexString: colorHex)
        }
    }
    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let items = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = items.title
            
            // make color gradient using Chameleon API
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)){
                cell.backgroundColor = color
                
                //color contrast for the text to the background color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            
            //ternary operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = items.done == true ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems? [indexPath.row]{
            do{
                try realm.write{
                    // realm.delete(item)
                    item.done  = !item.done
                }
            }catch{
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happens when user clicks add item button on the UIAlert
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write(){
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch  {
                    print("error saving category \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        //add textfield in the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new task"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Model Manipulation methods (CRUD)
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(item)
                }
            }catch{
                print("error deleting item, \(error)")
            }
        }
    }
}

//MARK: - SearchBar Delegate Methods
extension ToDoListViewController:  UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
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



