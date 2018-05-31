//
//  TodoListViewController.swift
//  Todoey
//
//  Created by David Viñaras on 24/5/18.
//  Copyright © 2018 AppWeb. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

//    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Domogorgon","a","b","c","d","e","f","g","j","k","l","m","n","o","p","q"]
    
    //var itemArray = [Item]()
    
    var category: Category! {
        didSet{
            refresh()
        }
    }
    
    var items = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    private var query = ""
    
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        refresh()
        
        
//        if let itemDefault = defaults.array(forKey: "TodoListArray") as? [CheckListItem] {
//          items = itemDefault
//        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //configureText(for: cell,with: item)
        //configureCheckmark(for: cell, with: item)
        
        cell.accessoryType = item.check ? .checkmark : .none
        //cell.textLabel?.text = itemArray[indexPath.row]

        return cell
    }
    
    // MARK: - Table view Delegate Methods
    
    //TODO: Seleccionamos una cell:
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let item = items[indexPath.row]
            
           // itemtoogleChecked()
            
            item.check = !item.check
            cell.accessoryType = item.check ? .checkmark : .none
            //configureCheckmark(for: cell, with: item)
            saveItems()
            
           // print("\(String(item)),\(String(describing: cell.textLabel?.text))")
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Add New Items
    
    @IBAction func addItem(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: " Add New Todoey Item",message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if textField.text != "" {
                
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.check = false
                newItem.parentCategory = self.category
                
                self.items.append(newItem)
                
                self.saveItems()

                self.tableView.reloadData()
            }
            
        }
        
        alert .addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert,animated: true, completion: nil)
    }
    
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
    
    func saveItems(){

        do{
            try context.save()
        }catch {
            print("Error enconding item \(error)")
        }
    }
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
    
    func refresh() {
        let request = Item.fetchRequest() as NSFetchRequest<Item>
        
        if !query.isEmpty {
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ AND parentCategory = %@ ", query, category)
        }else {
            request.predicate = NSPredicate(format: "parentCategory = %@", category)
        }
        
        //Otra opcion para anexar predicados
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", category.name)
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
//        request.predicate = compoundPredicate
        
        let sort = NSSortDescriptor(key: #keyPath(Item.title),ascending:true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        request.sortDescriptors = [sort]
        
        do{
            items =  try context.fetch(request)
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}

// Search Bar Delegate
extension TodoListViewController:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let txt = searchBar.text else {
            return
        }
        query = txt
        refresh()
        searchBar.resignFirstResponder()
        //searchBar.setShowsCancelButton(true, animated: true)
        tableView.reloadData()
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
            query = ""
            searchBar.resignFirstResponder()
            refresh()
            tableView.reloadData()
        }
    }
    
}