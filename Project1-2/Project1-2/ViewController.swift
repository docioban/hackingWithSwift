//
//  ViewController.swift
//  Project1-2
//
//  Created by Macbook Pro on 10/26/20.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Countries"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cel = tableView.dequeueReusableCell(withIdentifier: "countriCell", for: indexPath)
        cel.textLabel?.text = countries[indexPath.row]
        cel.imageView?.image = UIImage(named: countries[indexPath.row])
        return cel
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if let cel = storyboard?.instantiateViewController(withIdentifier: "detailView") as? DetailViewController {
            cel.nameSend = countries[indexPath.row]
            navigationController?.pushViewController(cel, animated: true)
        }
    }

}

