//
//  ViewController.swift
//  Project7
//
//  Created by Macbook Pro on 10/29/20.
//

import UIKit

class ViewController: UITableViewController {
    
    var resultsData = [Result]()
    var resultsFilter = [Result]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString: String
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(dataCum))
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            print("First")
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            print("Second")
        }
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(data: data)
                resultsFilter = resultsData
                return
            }
        }
        
        alertError(title: "Error", message: "Can note download data, close app, check your internet connection, and try again")
    }
    
    @objc func dataCum() {
        let av = UIAlertController(title: "Data comes", message: "We The People API of the Whitehouse", preferredStyle: .alert)
        av.addTextField()
        
        let submitAction = UIAlertAction(title: "Ok", style: .default) {
            [weak self, weak av] _ in
            guard let word = av?.textFields?[0].text else {
                return
            }
            self!.resultsFilter = self!.resultsData.filter{
                result in
                return result.title.lowercased().contains(word.lowercased())
            }
            self!.tableView.reloadData()
        }
        av.addAction(submitAction)
        present(av, animated: true)
    }
    
    func alertError(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    func parse(data: Data) {
        let decoder = JSONDecoder()
        
        if let jsonResults = try? decoder.decode(Results.self, from: data) {
            resultsData = jsonResults.results
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsFilter.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let result = resultsFilter[indexPath.row]
        cell.textLabel?.text = result.title
        cell.detailTextLabel?.text = result.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = DatailViewController()
        detailView.result = resultsFilter[indexPath.row]
        navigationController?.pushViewController(detailView, animated: true)
    }

}

