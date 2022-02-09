//
//  PokeDexTableViewController.swift
//  Pokedex_Codable
//
//  Created by Brody Sears on 2/8/22.
//

import UIKit

class PokeDexTableViewController: UITableViewController {
    
    //Source of Truth.
    var pokedexResults: [PokedexResult] = []
    var pokedex: Pokedex?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkingController.fetchPokedex(with: NetworkingController.initialURL!) { result in
            switch result {
            case .success(let pokedex):
                self.pokedexResults = pokedex.results
                self.pokedex = pokedex
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("There wasn an error, \(error.errorDescription!)")
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pokedexResults.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pokedexCell", for: indexPath) as? pokeDexTableViewCell else { return UITableViewCell() }
        
        let pokemon = pokedexResults[indexPath.row]
        cell.updateViews(pokemonURLString: pokemon.url)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastPokedexIndex = pokedexResults.count - 1
        
        guard let pokedex = pokedex, let nextURL = URL(string: pokedex.next) else { return }
        if indexPath.row == lastPokedexIndex {
            NetworkingController.fetchPokedex(with: nextURL) { result in
                switch result {
                case .success(let nextPokedex):
                    self.pokedex = nextPokedex
                    self.pokedexResults.append(contentsOf: nextPokedex.results)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("There was an error!", error.errorDescription!)
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toDetailVC" {
            if let destination = segue.destination as? PokemonViewController {
                
                guard let indexPath = tableView.indexPathForSelectedRow else { return }
                
                let pokemonToSend = pokedexResults[indexPath.row]
                NetworkingController.fectchPokemonDetails(with: pokemonToSend.url) { result in
                    switch result {
                    case .success(let pokemon):
                        DispatchQueue.main.async {
                            destination.pokemon = pokemon
                        }
                    case .failure(let error):
                        print("There was an error!, \(error.errorDescription!)")
                    }
                }
            }
        }
    }
}

