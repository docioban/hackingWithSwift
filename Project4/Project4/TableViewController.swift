//
//  TableViewController.swift
//  Project4
//
//  Created by Macbook Pro on 10/26/20.
//

import UIKit

class TableViewController: UITableViewController {

//    var sites = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(sites.count)
//        sites = ["apple.com", "youtube.com", "nothing.com"]
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "siteCell", for: indexPath)
        cell.textLabel?.text = sites[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Site") as? ViewController {
            vc.uploadIndex = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
