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
    var items = ["Buy food", "Do reaserch on 374", "Finish 361 assi"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let itemArr = defaults.array(forKey: "toDoList") as? [String]{
            items = itemArr
        }
    }
    
    
    //MARK: UITable view datasource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTableCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    
    //MARK: UITable view delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: Add item button pressed func
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Something", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Something", style: .default) {
            (action) in
            self.items.append(textField.text!)
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

