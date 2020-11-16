//
//  ViewController.swift
//  Project19-21
//
//  Created by Macbook Pro on 11/15/20.
//

import UIKit

class ViewController: UITableViewController {
    
    let path = Bundle.main.url(forResource: "Notes", withExtension: "json")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"

        if path != nil {
            do {
                let jsonData = try Data(contentsOf: path!)
                if let jsonResult = try? JSONDecoder().decode([Note].self, from: jsonData) {
                    notes = jsonResult
                }
            } catch {
                print(error)
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
    }
    
    @objc func addNote() {
        if let st = storyboard?.instantiateViewController(identifier: "DetailView") as? DetailViewController {
            st.index = notes.count
            navigationController?.pushViewController(st, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoteTableViewCell
        
        cell.titleLabel.text = notes[indexPath.row].title
        cell.subtitleLabel.text = notes[indexPath.row].body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let st = storyboard?.instantiateViewController(identifier: "DetailView") as? DetailViewController {
            st.index = indexPath.row
            navigationController?.pushViewController(st, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        save()
    }
    
    func save() {
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(notes)
            try jsonData.write(to: path!)
        } catch {
            print(error)
        }
        print("saved")
    }
}
