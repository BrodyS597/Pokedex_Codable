//
//  NetworkingController.swift
//  Pokedex_Codable
//
//  Created by Karl Pfister on 2/7/22.
//

import Foundation
import UIKit.UIImage

class NetworkingController {
    
    private static let baseURLString = "https://pokeapi.co"
    
    static func fetchPokedex(completion: @escaping (Result<Pokedex, ResultError>) -> Void) {
        
        guard let baseURL = URL(string: baseURLString) else {return}
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = "/api/v2/pokemon"

        guard let finalURL = urlComponents?.url else {return}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { dTaskData, _, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            
            guard let pokemonData = dTaskData else {
                completion(.failure(.noData))
                return }
            
            do {
                let pokedex = try JSONDecoder().decode(Pokedex.self, from: pokemonData)
                completion(.success(pokedex))
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    
//    static func fetchImage(for pokemon: Pokemon, completetion: @escaping (UIImage?) -> Void) {
//        guard let imageURL = URL(string: pokemon.spritePath) else {return}
//
//        URLSession.shared.dataTask(with: imageURL) { data, _, error in
//            if let error = error {
//                print("There was an error", error.localizedDescription)
//                completetion(nil)
//            }
//            guard let data = data else {
//                return
//            }
//            let pokemonImage = UIImage(data: data)
//            completetion(pokemonImage)
//        }.resume()
//    }
}// end
