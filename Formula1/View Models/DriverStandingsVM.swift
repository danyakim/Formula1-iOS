//
//  DriverStandingsVM.swift
//  Formula1
//
//  Created by Daniil Kim on 05.06.2021.
//

import Foundation
import RxSwift
import RxCocoa

struct DriverStandingsVM {
    
    // MARK: - Properties
    
    let currentYear = Calendar.current.component(.year, from: Date())
    var positions: BehaviorRelay<[Position]> = BehaviorRelay(value: [])
    var gotNoResponse: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    // MARK: - Methods

    func getCurrentWinners() {
        ErgastAPI.shared.getCurrentWinners { result in
            parse(result)
        }
    }
    
    func getDrivers(at position: String, year: String) {
        ErgastAPI.shared.getDrivers(at: position, year: year) { result in
            parse(result)
        }
    }
    
    // MARK: - Private Methods
    
    private func parse(_ result: ErgastResult) {
        switch result {
        case .failure(let error):
            print("*** Error getting drivers: ", error)
            gotNoResponse.accept("Error")
        case .success(let jsonResponse):
            let details = jsonResponse.getPositions()
            if details.isEmpty {
                print("*** Got empty response")
                gotNoResponse.accept("No Results")
            } else {
                print("*** Got response")
            }
            self.positions.accept(details)
        }
    }
    
}
