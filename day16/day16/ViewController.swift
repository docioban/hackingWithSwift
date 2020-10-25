//
//  ViewController.swift
//  day16
//
//  Created by Macbook Pro on 10/25/20.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pictures"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)

        for item in items {
            if item.hasSuffix(".jpg") {
                pictures.append(item)
            }
        }
        print(pictures)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cel = tableView.dequeueReusableCell(withIdentifier: "foto", for: indexPath)
        cel.textLabel?.text = pictures[indexPath.row]
        return cel
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "foto") as? FotoViewController {
            vc.fotoDetail = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

