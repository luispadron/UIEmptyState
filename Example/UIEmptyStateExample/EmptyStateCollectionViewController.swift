//
//  EmptyStateCollectionViewController.swift
//  UIEmptyStateExample
//
//  Created by Luis Padron on 2/5/17.
//  Copyright © 2017 Luis Padron. All rights reserved.
//

import UIKit
import UIEmptyState

private let reuseIdentifier = "collectionViewCell"

class EmptyStateCollectionViewController: UICollectionViewController, UIEmptyStateDelegate, UIEmptyStateDataSource {

    var caughtPokemon = [String]()
    
    override func viewDidLoad() {
        self.title = "CollectionView Example"
        super.viewDidLoad()

        // Set delegate and data source
        self.emptyStateDelegate = self
        self.emptyStateDataSource = self
        // Set the inital state of the collectionview
        self.reloadEmptyState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return caughtPokemon.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EmptyStateCollectionViewCell
        cell.pokemonLabel.text = caughtPokemon[indexPath.row]
        return cell
    }

    // MARK: UICollectionViewDelegate

    // MARK: - Helper Methods
    
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
        self.collectionView?.reloadData()
        // Remember to call this to reload the empty state view after every data change
        self.reloadEmptyState()
    }

}
