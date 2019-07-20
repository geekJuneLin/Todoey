//
//  ViewController.swift
//  Todoey
//
//  Created by Junyu Lin on 18/07/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //var declaration
    var items = [Item]()
    var selectedCategory : Category? {
        //this code will happen as soon as the selectedCategory been set
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist"))
        loadItems()
        searchBar.delegate = self
    }
    
    
    //MARK: - UITable view datasource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTableCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        cell.accessoryType = items[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    
    //MARK: - UITable view delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let it = items[indexPath.row]
        
        it.done = !it.done
        
        saveData()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add item button pressed func
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Something", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Something", style: .default) {
            (action) in
            let it = Item(context: self.context)
            it.title = textField.text!
            it.done = false
            it.parentCategory = self.selectedCategory
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
    
    //MARK: - Data Model methods
    
    private func saveData(){
        //create propertyList encoder and write the data into the plist file
        do{
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    //method contains internal and external para, and default value will be set when para is not provided
    private func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),
                           predicate: NSPredicate? = nil) {
        let catePredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let addPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catePredicate, addPredicate])
        } else {
            request.predicate = catePredicate
        }
        do{
            items = try context.fetch(request)
        } catch {
            print("Error fetching context \(error)")
        }
        
        tableView.reloadData()
    }
    
}

//MARK: - search delegate methods

extension ViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()

        let pred = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = pred
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadItems(with: request, predicate: pred)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

