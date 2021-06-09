//
//  RaceDetailsVM.swift
//  Formula1
//
//  Created by Daniil Kim on 06.06.2021.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

typealias SectionOfResult = SectionModel<String, CellModel>

enum CellModel {
    case title(race: Race)
    case position(result: DriverResult)
}

struct RaceDetailsVM {
    
    // MARK: - Properties
    
    let sections = PublishSubject<[SectionOfResult]>()
    private let disposeBag = DisposeBag()
    
    // MARK: - Methods
    
    func getDetails(of race: Race) {
        let titleSection = SectionModel(model: "Race", items: [CellModel.title(race: race)])
        self.sections.onNext([titleSection])
        
        ErgastAPI.shared.getResults(of: race).subscribe { ergastResponse in
            guard let driversResults = ergastResponse.getDriversResults() else { return }
            print("*** Got race results")
            let results = driversResults.map { driverResult in
                CellModel.position(result: driverResult)
            }
            let resultsSection = SectionModel(model: "Results", items: results)
            self.sections.onNext([titleSection, resultsSection])
        } onError: { error in
            print("*** Error getting race results: ", error)
        }.disposed(by: disposeBag)
    }
    
}
