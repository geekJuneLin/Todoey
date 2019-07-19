//
//  ViewController.swift
//  Todoey
//
//  Created by Junyu Lin on 18/07/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    let defaults = UserDefaults.standard
    
    //var declaration
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let i1 = Item()
        i1.toDo = "Do homework"
        items.append(i1)
        
        let i2 = Item()
        i2.toDo = "Do house work"
        items.append(i2)
        
        let i3 = Item()
        i3.toDo = "Cook dinner"
        items.append(i3)
        
        if let itemArr = defaults.array(forKey: "toDoList") as? [Item]{
            items = itemArr
        }
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
            self.defaults.set(self.items, forKey: "toDoList")
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
}

