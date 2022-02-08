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
    
    static var initialURL: URL? {
        guard let baseURL = URL(string: baseURLString) else { return nil }
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = "/api/v2/pokemon"
        
        guard let finalURL = urlComponents?.url else { return nil }
        print(finalURL)
        return finalURL
    }
    
    static func fetchPokedex(with url: URL, completion: @escaping (Result<Pokedex, ResultError>) -> Void) {

        
        URLSession.shared.dataTask(with: url) { dTaskData, _, error in
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
    
    static func fectchPokemonDetails(with urlString: String, completion: @escaping (Result<PokemonData, ResultError>) -> Void) {
        
        guard let pokemonURL = URL(string: urlString) else {
            completion(.failure(.invalidURL(urlString)))
            return }
        
        URLSession.shared.dataTask(with: pokemonURL) { data, _, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            guard let pokemonData = data else {
                completion(.failure(.noData))
                return }
            
            do {
                let pokemon = try JSONDecoder().decode(PokemonData.self, from: pokemonData)
                completion(.success(pokemon))
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchImage(for pokemonImageString: String, completion: @escaping (Result<UIImage, ResultError>) -> Void) {
            guard let imageURL = URL(string: pokemonImageString) else {return}
    
            URLSession.shared.dataTask(with: imageURL) { data, _, error in
                if let error = error {
                    print("There was an error", error.localizedDescription)
                    completion(.failure(.thrownError(error)))
                }
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                guard let pokemonImage = UIImage(data: data) else {
                    completion(.failure(.unableToDecode))
                    return
                }
                completion(.success(pokemonImage))
            }.resume()
        }
}// end
