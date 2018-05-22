//
//  ViewController.swift
//  MyTableView
//
//  Created by Baddili, Nethaji on 15/05/18.
//  Copyright © 2018 Baddili, Nethaji. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var lstItems = [MyItem]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //let userDefaultData = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        loadItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel?.text = lstItems[indexPath.row].itemname
        if lstItems[indexPath.row].done == true
        {
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    //Table View Delegates.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        lstItems[indexPath.row].done = !lstItems[indexPath.row].done
        saveItems()
        //tableView.reloadData()
       // tableView.cellForRow(at: indexPath)?.accessoryType = lstItems[indexPath.row].done == true ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Barbutton Add Action
    @IBAction func btnAdd(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title:"Add New Item", message:"", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let item = MyItem()
            item.itemname = textField.text!
            item.done = false
            self.lstItems.append(item)
          
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems()
    {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.lstItems)
            try data.write(to: self.dataFilePath!)
        }
        catch{
            print("Error while encoding item!.")
        }
          self.tableView.reloadData()
    }
    
    func loadItems()
    {
        if let data = try? Data(contentsOf: dataFilePath!){
        
        let decoder = PropertyListDecoder()

        do {
            lstItems = try decoder.decode([MyItem].self, from: data)
        }
        catch{
            print("Error while decoding items!.")
        }
        self.tableView.reloadData()
        }
        
    }
    
}

