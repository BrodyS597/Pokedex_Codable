//
//  pokeDexTableViewCell.swift
//  Pokedex_Codable
//
//  Created by Brody Sears on 2/8/22.
//

import UIKit

class pokeDexTableViewCell: UITableViewCell {

    // MARK: -IBOutlets
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonIDLabel: UILabel!
    @IBOutlet weak var pokemonSpriteImageView: UIImageView!
    
    func updateViews(pokemonURLString: String) {
        NetworkingController.fectchPokemonDetails(with: pokemonURLString) { result in
            switch result {
            case.success(let pokemon):
                self.fetchImage(with: pokemon)
            case.failure(let error):
                print("There was an error!", error.errorDescription!)
            }
        }
    }

    func fetchImage(with pokemon: PokemonData) {
        NetworkingController.fetchImage(for: pokemon.sprites.frontShiny) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.pokemonSpriteImageView.image = image
                    self.pokemonNameLabel.text = pokemon.name
                    self.pokemonIDLabel.text = "ID #: \(pokemon.id)"
                }
            case .failure(let error):
                print("There was an error!", error.errorDescription!)

            }
        }
    }
}
