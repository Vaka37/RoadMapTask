//
//  NetworkService.swift
//  roadMapTask
//
//  Created by Kalandarov Vakil on 09.11.2023.
//

import Foundation
import UIKit



final class NetworkService {
    static let shared = NetworkService()
    var arrayFavorites: [Results] = []

    func add(results: Results) {
        var index = arrayFavorites.firstIndex{ $0.id == results.id }
        self.arrayFavorites.append(results)
        arrayFavorites.forEach { item in
            if item.id == results.id{
                guard let index else {return}
                arrayFavorites.remove(at: index)
            }
        }
        
    }
    func getInfoCharacters(http: String, complition: @escaping(Result<CharactersModel,Error>) -> Void){
        guard let url = URL(string: http) else {return}
        URLSession.shared.dataTask(with: url){data, response, error in
            if let error = error{
                complition(.failure(error))
                return
            }
            guard let data = data else {return }
            do{
                let text = try JSONDecoder().decode(CharactersModel.self, from: data)
                complition(.success(text))
            }catch let jsonError{
                complition(.failure(jsonError))
            }
        }.resume()
    }
    
    func getEpisode(http: String, complition: @escaping(Result<Episode, Error>)-> Void) {
        guard let url = URL(string: http) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                complition(.failure(error))
                print(error)
                return
            }
            guard let data = data else { return }
            do {
                let text = try JSONDecoder().decode(Episode.self, from: data)
                complition(.success(text))
            } catch let jsonError {
                complition(.failure(jsonError))
            }
        }.resume()
    }
    
}
