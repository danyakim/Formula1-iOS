//
//  ErgastAPI.swift
//  Formula1
//
//  Created by Daniil Kim on 01.06.2021.
//

import Foundation
import RxSwift
import RxCocoa

enum APIError: Error {
    case incorrectResponse
    case noData
    case errorParsingJSON
}

typealias ErgastResult = Observable<ErgastResponse>

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
        guard let url = URL(string: urlString) else {
            fatalError("*** Can't create url from string: '\(urlString)'")
        }
        
        return URLSession.shared.rx.response(request: URLRequest(url: url))
            .map { result in
                guard result.response.statusCode == 200 else {
                    throw APIError.noData
                }
                
                let data = result.data
                let decoder = JSONDecoder()
                if let jsonResponse = try? decoder.decode(ErgastResponse.self, from: data) {
                    return jsonResponse
                }
                throw APIError.errorParsingJSON
            }.asObservable()
    }
    
}
