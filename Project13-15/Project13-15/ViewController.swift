//
//  ViewController.swift
//  Project13-15
//
//  Created by Macbook Pro on 11/8/20.
//

import UIKit

class ViewController: UITableViewController {

    var allData = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let path = Bundle.main.url(forResource: "country", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: path)
                if let jsonResult = try? JSONDecoder().decode(Countries.self, from: jsonData) {
                    allData = jsonResult.countries
                }
                print(allData)
            } catch {
                print(error)
            }
        }
        title = "Countries"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = allData[indexPath.row].nameCountry
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let view = storyboard?.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController {
            view.detail = allData[indexPath.row]
            navigationController?.pushViewController(view, animated: true)
        }
    }
}

