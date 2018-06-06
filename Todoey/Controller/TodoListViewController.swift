//
//  TodoListViewController.swift
//  Todoey
//
//  Created by David Viñaras on 24/5/18.
//  Copyright © 2018 AppWeb. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var category: Category! {
        didSet{
            refreshRealm()
        }
    }
    
    var colourBarOriginal: String = ""
    
    private var itemArray = [Item]()
    private var todoItems: Results<Item>?
    
    private var query = ""
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none

    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        // Poner el mismo color que el de la categoria seleccionada
        
        title = category.name
        
        guard let colourHex = category.colorCategory else { fatalError() }
        
        updateNavBar(withHexCode: colourHex)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("color lista: \(colourBarOriginal) y #2D7EC1")
        updateNavBar(withHexCode: colourBarOriginal)
    }
    
    func updateNavBar(withHexCode colourHexCode: String){
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller no exist.")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError()}
        
        navBar.barTintColor = navBarColour
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.check ? .checkmark : .none
            
            let pct = CGFloat(indexPath.row) / CGFloat(todoItems!.count)
            if let colour  = UIColor(hexString: category.colorCategory!)?.darken(byPercentage: pct) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
        }else {
            cell.textLabel?.text = "No items for Category"
        }
        
        //configureText(for: cell,with: item)
        //configureCheckmark(for: cell, with: item)

        //cell.textLabel?.text = itemArray[indexPath.row]

        return cell
    }
    
    // MARK: - Table view Delegate Methods
    
    //TODO: Seleccionamos una cell:
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            if let item = todoItems?[indexPath.row] {
                do{
                    try realm.write {
                        item.check = !item.check
                    }
                }catch let error as NSError {
                    print("Could not update check. \(error), \(error.userInfo)")
                }
                
            }
            //saveItems(item: item)
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // MARK: - Add New Items
    
    @IBAction func addItem(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: " Add New Todoey Item",message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if textField.text != "" {
                do{
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.check = false
                    newItem.dateCreated = Date()
                    //newItem.parentCategory = self.category.name
                    self.category.items.append(newItem)
                }
                }catch {
                    print("error saving new items")
                }
                self.tableView.reloadData()
               // self.saveItems(item: newItem)

            }
            
        }
        
        alert .addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert,animated: true, completion: nil)
    }
    
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeleting = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemForDeleting)
                }
            }catch {
                print("Error deleting Item, \(error)")
            }
        }
    }
    
    
    //MARK: Data Methods
    
    func saveItems(item: Item) {
        do{
            try! realm.write {
                realm.add(item)
            }
        }catch let error as NSError {
            print("Could not save Item. \(error), \(error.userInfo)")
        }
        self.tableView.reloadData()
    }
    
//    func saveItems(){
//
//        do{
//            try context.save()
//        }catch {
//            print("Error enconding item \(error)")
//        }
//    }
//    func loadItems(){
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        //let request = Item.fetchRequest() as NSFetchRequest>Item>
//
//        do {
//            items =  try context.fetch(request)
//        }catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//    }
    
    func refreshRealm(){
        todoItems = category.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

//    func refresh() {
//        let request = Item.fetchRequest() as NSFetchRequest<Item>
//
//        if !query.isEmpty {
//            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ AND parentCategory = %@ ", query, category)
//        }else {
//            request.predicate = NSPredicate(format: "parentCategory = %@", category)
//        }
//
//        //Otra opcion para anexar predicados
////        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", category.name)
////        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
////        request.predicate = compoundPredicate
//
//        let sort = NSSortDescriptor(key: #keyPath(Item.title),ascending:true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
//        request.sortDescriptors = [sort]
//
//        do{
//            items =  try context.fetch(request)
//        }catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//    }
    //    func configureText(for cell: UITableViewCell, with item: ){
    //        cell.textLabel?.text = item.title
    //    }
    
    //    func configureCheckmark(for cell: UITableViewCell, with item: Item){
    //
    //        cell.accessoryType = item.check ? .checkmark : .none
    //
    ////        if item.checked{
    ////            cell.accessoryType = .checkmark
    ////            //label.text = "√"
    ////        }else{
    ////            cell.accessoryType = .none
    ////            //label.text = ""
    ////        }
    //    }

}

// Search Bar Delegate
extension TodoListViewController:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let txt = searchBar.text else {
            return
        }
        query = txt
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", query).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
//        query = txt
//        refresh()
//        searchBar.resignFirstResponder()
//        //searchBar.setShowsCancelButton(true, animated: true)
//        tableView.reloadData()
    }
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        query = ""
//        searchBar.text = nil
//        searchBar.setShowsCancelButton(false, animated: true)
//        searchBar.resignFirstResponder()
//        tableView.reloadData()
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
          refreshRealm()
          //Multi-Hilo
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
//            query = ""
//            searchBar.resignFirstResponder()
//            refreshRealm()
//            tableView.reloadData()
        }
    }
    
    
    
}
