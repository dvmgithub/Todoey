//
//  TodoListViewController.swift
//  Todoey
//
//  Created by David Viñaras on 24/5/18.
//  Copyright © 2018 AppWeb. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

//    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Domogorgon","a","b","c","d","e","f","g","j","k","l","m","n","o","p","q"]
    
    var items:[CheckListItem]
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //inicializar la class
    required init?(coder aDecoder: NSCoder) {
        items = [CheckListItem]()
        
        let row0Item = CheckListItem()
        row0Item.title = "Walk the dog"
        row0Item.checked = true
        items.append(row0Item)
        
        let row1Item = CheckListItem()
        row1Item.title = "Brush my teeth"
        row1Item.checked = false
        items.append(row1Item)
        
        let row2Item = CheckListItem()
        row2Item.title = "Learn IOS developper"
        row2Item.checked = true
        items.append(row2Item)
        
        let row3Item = CheckListItem()
        row3Item.title = "Soccer practice"
        row3Item.checked = false
        items.append(row3Item)
        
        let row4Item = CheckListItem()
        row4Item.title = "Eat ice cream"
        row4Item.checked = false
        items.append(row4Item)
        
        let row5Item = CheckListItem()
        row5Item.title = "Read Ios app"
        row5Item.checked = false
        items.append(row5Item)
        
        let row6Item = CheckListItem()
        row6Item.title = "Watch Game of Thrones"
        row6Item.checked = false
        items.append(row6Item)
        
        super.init(coder: aDecoder)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
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
        
        configureText(for: cell,with: item)
        configureCheckmark(for: cell, with: item)
        
        //cell.textLabel?.text = itemArray[indexPath.row]

        return cell
    }
    
    // MARK: - Table view Delegate Methods
    
    //TODO: Seleccionamos una cell:
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let item = items[indexPath.row]
            
            item.toogleChecked()
            
            configureCheckmark(for: cell, with: item)
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
                
                let newItem = CheckListItem()
                newItem.title = textField.text!
                newItem.checked = false
                self.items.append(newItem)
                //self.itemArray.append(textField.text!)
            
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
    
    func configureText(for cell: UITableViewCell, with item: CheckListItem){
        cell.textLabel?.text = item.title
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: CheckListItem){
        
        cell.accessoryType = item.checked ? .checkmark : .none
        
//        if item.checked{
//            cell.accessoryType = .checkmark
//            //label.text = "√"
//        }else{
//            cell.accessoryType = .none
//            //label.text = ""
//        }
    }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath!)
        }catch {
            print("Error enconding item \(error)")
        }
    }
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                items = try decoder.decode([CheckListItem].self, from: data)
            }catch {
                print("Error Denconding item \(error)")
            }
        }
    }
}
