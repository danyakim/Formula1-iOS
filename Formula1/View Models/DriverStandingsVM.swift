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
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Methods
    
    func getCurrentWinners() {
        ErgastAPI.shared.getCurrentWinners().subscribe { result in
            parse(result)
        } onError: { error in
            parse(error)
        }.disposed(by: disposeBag)
    }
    
    func getDrivers(at position: String, year: String) {
        ErgastAPI.shared.getDrivers(at: position, year: year).subscribe { result in
            parse(result)
        } onError: { error in
            parse(error)
        }.disposed(by: disposeBag)
    }
    
    // MARK: - Private Methods
    
    private func parse(_ response: ErgastResponse) {
        let details = response.getPositions()
        if details.isEmpty {
            print("*** Got empty response")
            gotNoResponse.accept("No Results")
        } else {
            print("*** Got response")
        }
        self.positions.accept(details)
    }
    
    private func parse(_ error: Error) {
        print("*** Error getting drivers: ", error)
        gotNoResponse.accept("Error")
    }
    
}
