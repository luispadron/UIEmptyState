//
//  ViewController.swift
//  UIEmptyStateExample
//
//  Created by Luis Padron on 2/3/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//

import UIKit
import UIEmptyState

class EmptyStateTableViewController: UITableViewController, UIEmptyStateDelegate, UIEmptyStateDataSource {

    var caughtPokemon = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TableView Example"
        // Set the data source and delegate to self
        self.emptyStateDataSource = self
        self.emptyStateDelegate = self
        // Remove seperator lines from empty cells
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        // Initially call the reloadTableViewState to get the initial state
        self.reloadEmptyState(for: self.tableView)
        self.view.backgroundColor = UIColor(red: 0.518, green: 0.576, blue: 0.604, alpha: 1.00)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Some custom button stuff
        let button = (self.emptyStateView as? UIEmptyStateView)?.button
        button?.layer.cornerRadius = 5
        button?.layer.borderWidth = 1
        button?.layer.borderColor = UIColor.red.cgColor
        button?.layer.backgroundColor = UIColor.red.cgColor
    }
    
    // MARK: - Empty State Data Source
    
    var emptyStateImage: UIImage? {
        return #imageLiteral(resourceName: "emptyPokemon")
    }

    var emptyStateTitle: NSAttributedString {
        let attrs = [NSAttributedStringKey.foregroundColor: UIColor(red: 0.882, green: 0.890, blue: 0.859, alpha: 1.00),
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 22)]
        return NSAttributedString(string: "No Pokemon caught!", attributes: attrs)
    }
    
    var emptyStateButtonTitle: NSAttributedString? {
        let attrs = [NSAttributedStringKey.foregroundColor: UIColor.white,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
        return NSAttributedString(string: "Catch'em All", attributes: attrs)
    }

    
    // MARK: - Empty State Delegate
    
    func emptyStatebuttonWasTapped(button: UIButton) {
        // Add a pokemon
        let row = caughtPokemon.count == 0 ? 0 : caughtPokemon.count - 1
        addPokemon(at: IndexPath(row: row, section: 0))
    }
    
    
    // MARK: - TableView Delegation
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return caughtPokemon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exampleCell")!
        let pokemon = caughtPokemon[indexPath.row]
        cell.textLabel?.text = "Pokemon caught: \(pokemon)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row
            tableView.beginUpdates()
            caughtPokemon.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            // Call reload of empty state
            self.reloadEmptyState(for: self.tableView)
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        // Add pokemon
        let row = caughtPokemon.count == 0 ? 0 : caughtPokemon.count - 1
        addPokemon(at: IndexPath(row: row, section: 0))
    }

    // MARK: - Helper Methods

    let pokemon = ["Pikachu", "Charizard", "Charmander", "Caterpie", "Butterfree", "Mew", "MewTwo", "Growlithe", "Squirtle"]
    
    func randomPokemon() -> String {
        let index = arc4random_uniform(UInt32(pokemon.count))
        return pokemon[Int(index)]
    }
    
    func addPokemon(at path: IndexPath) {
        let newPokemon = randomPokemon()
        caughtPokemon.append(newPokemon)
        tableView.beginUpdates()
        tableView.insertRows(at: [path], with: .automatic)
        tableView.endUpdates()
        self.reloadEmptyState(for: self.tableView) // Make sure to call this to update the state of the tableview
    }
}

