//
//  ErgastAPI.swift
//  Formula1
//
//  Created by Daniil Kim on 01.06.2021.
//

import Foundation

enum APIError: Error {
    
    case incorrectURL(String)
    case noData
    case errorParsingJSON
}

class ErgastAPI {
    
    static let shared = ErgastAPI()
    
    let defaultSession = URLSession(configuration: .default)
    
    // MARK: - Methods
    
    public func getCurrentWinners(completion: @escaping (Result<JSONResponse, Error>) -> Void) {
        let urlString = "https://ergast.com/api/f1/current/results/1.json"
        
        fetchData(from: urlString, completion: completion)
    }
    
    public func getResults(of race: Race,
                           completion: @escaping (Result<JSONResponse, Error>) -> Void) {
        let urlString = "https://ergast.com/api/f1/\(race.season)/\(race.round)/results.json"
        
        fetchData(from: urlString, completion: completion)
    }
    
    public func getDrivers(at position: String,
                           year: String,
                           completion: @escaping (Result<JSONResponse, Error>) -> Void) {
        let urlString = "https://ergast.com/api/f1/\(year)/results/\(position).json"
        
        fetchData(from: urlString, completion: completion)
    }
    
    // MARK: - Private Methods
    
    private func fetchData(from urlString: String, completion: @escaping (Result<JSONResponse, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(APIError.incorrectURL(urlString)))
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let data = data else {
                return completion(.failure(APIError.noData))
            }
            
            let decoder = JSONDecoder()
            if let jsonResponse = try? decoder.decode(JSONResponse.self, from: data) {
                return completion(.success(jsonResponse))
            }
            return completion(.failure(APIError.errorParsingJSON))
        }.resume()
    }
    
}
