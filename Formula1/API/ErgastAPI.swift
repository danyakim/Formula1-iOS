//
//  ErgastAPI.swift
//  Formula1
//
//  Created by Daniil Kim on 01.06.2021.
//

import Foundation
import RxSwift

enum APIError: Error {
    
    case incorrectURL(String)
    case noData
    case errorParsingJSON
}

typealias ErgastResult = Single<ErgastResponse>

class ErgastAPI {
    
    static let shared = ErgastAPI()
    
    // MARK: - Methods
    
    public func getCurrentWinners() -> ErgastResult {
        let urlString = "https://ergast.com/api/f1/current/results/1.json"
        
        return fetchData(from: urlString)
    }
    
    public func getResults(of race: Race) -> ErgastResult {
        let urlString = "https://ergast.com/api/f1/\(race.season)/\(race.round)/results.json"
        
        return fetchData(from: urlString)
    }
    
    public func getDrivers(at position: String,
                           year: String) -> ErgastResult {
        let urlString = "https://ergast.com/api/f1/\(year)/results/\(position).json"
        
        return fetchData(from: urlString)
    }
    
    // MARK: - Private Methods
    
    private func fetchData(from urlString: String) -> ErgastResult {
        
        return ErgastResult.create { single in
            guard let url = URL(string: urlString) else {
                single(.failure(APIError.incorrectURL(urlString)))
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    return single(.failure(error))
                }
                
                guard let data = data else {
                    return single(.failure(APIError.noData))
                }
                
                let decoder = JSONDecoder()
                if let jsonResponse = try? decoder.decode(ErgastResponse.self, from: data) {
                    return single(.success(jsonResponse))
                }
                return single(.failure(APIError.errorParsingJSON))
            }
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
    
}
