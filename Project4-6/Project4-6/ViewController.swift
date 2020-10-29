//
//  ViewController.swift
//  Project4-6
//
//  Created by Macbook Pro on 10/29/20.
//

import UIKit

class ViewController: UITableViewController {

    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProduct))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(shareList))
    }
    
    @objc func addProduct() {
        let ac = UIAlertController(title: "New Product", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Add", style: .default) {
            [weak ac] _ in
            if let answerd = ac?.textFields![0] {
                self.shoppingList.insert(answerd.text!, at: 0)
                let index = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [index], with: .automatic)
            }
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    @objc func shareList() {
        let items = [shoppingList.joined(separator: "\n")]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
}

