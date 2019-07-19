//
//  ViewController.swift
//  Todoey
//
//  Created by Junyu Lin on 18/07/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    //get the file path of the plist that we need to create
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    //var declaration
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    
    //MARK: UITable view datasource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTableCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].toDo
        cell.accessoryType = items[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    
    //MARK: UITable view delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let it = items[indexPath.row]
        
        it.done = !it.done
        
        saveData()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: Add item button pressed func
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Something", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Something", style: .default) {
            (action) in
            let it = Item()
            it.toDo = textField.text!
            self.items.append(it)
            self.saveData()
            self.tableView.reloadData()
        }
        alert.addTextField {
            (textfield) in
            textfield.placeholder = "Please enter something!"
            textField = textfield
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Data Model methods
    
    private func saveData(){
        //create propertyList encoder and write the data into the plist file
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(items)
            try data.write(to: filePath!)
        } catch {
            print("Error occurs \(error)")
        }
    }
    
    private func loadData(){
        if let data = try? Data(contentsOf: filePath!){
            let decoder = PropertyListDecoder()
            do{
                items = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error occurs \(error)")
            }
        }
    }
}

