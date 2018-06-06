//
//  CategoryViewController.swift
//  Todoey
//
//  Created by David Viñaras on 30/5/18.
//  Copyright © 2018 AppWeb. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    
    private var categoryArray:[Category] = [Category]()
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
        
        tableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  super.tableView(tableView, cellForRowAt: indexPath)

        if let categorySel = categories?[indexPath.row] {
            // Si categorias es nil mostramos la siguiente cadena
            cell.textLabel?.text =  categorySel.name ?? "No Categories Add"

            let colorCell = categorySel.colorCategory ?? UIColor.randomFlat.hexValue()
            
            if  categorySel.colorCategory == nil {
                categories?[indexPath.row].colorCategory = colorCell
            }else {
                guard let categoryColour = UIColor(hexString: colorCell) else {fatalError()}
                cell.backgroundColor = categoryColour
                cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
            }
            
            
        }
//        if let colorCell = categories?[indexPath.row].colorCategory {
//            cell.backgroundColor = UIColor(hexString:  colorCell)
//        } else {
//            categories?[indexPath.row].colorCategory = UIColor.randomFlat.hexValue()
//            cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].colorCategory)
//
//        }
        
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
            print("color Original: \(navigationController?.navigationBar.barTintColor?.hexValue())")
            let tlv = segue.destination as! TodoListViewController
            tlv.colourBarOriginal = (navigationController?.navigationBar.barTintColor?.hexValue())!
            
            if let indexPath = tableView.indexPathForSelectedRow {
                //tlv.category = categoryArray[indexPath.row]
                tlv.category = categories?[indexPath.row]
            }
        }
    }


    @IBAction func addCategoryBarButtonPressed(_ sender: UIBarButtonItem) {
            
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category",message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if textField.text != "" {
                
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.colorCategory = UIColor.randomFlat.hexValue()
                
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
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            }catch {
                print("Error deleting Category, \(error)")
            }
        }
    }
    
    //MARK: - Data Manipulation Methods
    
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

