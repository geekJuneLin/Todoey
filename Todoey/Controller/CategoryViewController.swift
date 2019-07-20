//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Junyu Lin on 20/07/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    //MARK: - const
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - variables
    var cate = [Category]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }
    
    //MARK: - Table view datasource methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cate.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel!.text = cate[indexPath.row].name
        return cell
    }
    
    //MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desVC = segue.destination as! ViewController
        
        if let index = tableView.indexPathForSelectedRow{
            desVC.selectedCategory = cate[index.row]
        }
    }
    
    //MARK: - Data Manipulation methods
    private func saveCategory(){
        do{
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    private func loadCategory(with request:NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            cate = try context.fetch(request)
        } catch {
            print("Error fetching context \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - IBAction methods

    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var cateTextField =  UITextField()
        let alert = UIAlertController(title: "Add category", message: "", preferredStyle: .alert)
        alert.addTextField {
            (textField) in
            textField.placeholder = "Please enter the category!"
            cateTextField = textField
        }
        let action = UIAlertAction(title: "Add category", style: .default) {
            (action) in
            let item = Category(context: self.context)
            item.name = cateTextField.text!
            self.cate.append(item)
            self.saveCategory()
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
