//
//  CategoryViewController.swift
//  Todoey
//
//  Created by David Viñaras on 30/5/18.
//  Copyright © 2018 AppWeb. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    
    private var categoryArray:[Category] = [Category]()
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
        //print("Numero de registro categorias \(categories?.count ?? 0)")
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

//        let category = categoryArray[indexPath.row]
//        cell.textLabel?.text = category.name
        // En el caso categorias es nill mostramos la siguiente cadena
        let nombre = categories?[indexPath.row].name ?? "No Categories Add"
        print(nombre)
        cell.textLabel?.text = nombre
        
        return cell
    }
 
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categories != nil {
            performSegue(withIdentifier: "goToItems", sender: self)
        }else{
            print("no hay categorias para add tareas")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let tlv = segue.destination as! TodoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                //tlv.category = categoryArray[indexPath.row]
                tlv.category = categories?[indexPath.row]
            }
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


    @IBAction func addCategoryBarButtonPressed(_ sender: UIBarButtonItem) {
            
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category",message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if textField.text != "" {
                
                let newCategory = Category()
                newCategory.name = textField.text!
                
                //self.categoryArray.append(newCategory)
                
                self.saveCategory(category: newCategory)
                
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert,animated: true, completion: nil)
        
    }
    
    func saveCategory(category: Category) {
        do{
            try! realm.write {
                realm.add(category)
            }
        }catch let error as NSError {
            print("Could not save Category. \(error), \(error.userInfo)")
        }
        self.tableView.reloadData()
    }
    
    func refresh() {
        
       categories = realm.objects(Category.self)
       
       tableView.reloadData()
        
//        let request = Category.fetchRequest() as NSFetchRequest<Category>
//
////        if !query.isEmpty {
////            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", query)
////        }
//
//        let sort = NSSortDescriptor(key: #keyPath(Category.name),ascending:true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
//        request.sortDescriptors = [sort]
//
//        do{
//            categoryArray =  try context.fetch(request)
//        }catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
    }
}
