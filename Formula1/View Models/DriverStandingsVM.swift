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
    
    private func parse(_ result: Result<ErgastResponse, Error>) {
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

// MARK: - Driver Standings Table View Protocol

protocol DriverStandingsTableView: UIViewController {
    var tableView: UITableView { get }
    var driversVM: DriverStandingsVM { get }
    var disposeBag: DisposeBag { get }
}

// MARK: - Default Implementation

extension DriverStandingsTableView {
    
    func setupReactiveTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        setupCellConfiguration()
        setupCellTapHandling()
    }
    
    func setupAlerts() {
        driversVM.gotNoResponse.subscribe { reason in
            guard let text = reason.element,
                  !text.isEmpty else { return }
            self.showAlert(text: text)
        }.disposed(by: disposeBag)

    }
    
    private func setupCellConfiguration() {
        driversVM.positions.bind(to: tableView.rx.items) { _, _, position in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.accessoryType = .disclosureIndicator
            
            let driver = position.driver
            let race = position.race
            
            cell.fill(subtitle: race.raceName,
                      text: (driver.givenName, isBold: false),
                      (driver.familyName, isBold: false),
                      (driver.permanentNumber ?? "", isBold: true))
            return cell
        }.disposed(by: disposeBag)
    }
    
    private func setupCellTapHandling() {
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            self.tableView.deselectRow(at: indexPath, animated: true)
            
            let race = self.driversVM.positions.value[indexPath.row].race
            let raceDetailsVC = RaceDetailsVC(race: race)
            self.navigationController?.pushViewController(raceDetailsVC, animated: true)
        }).disposed(by: disposeBag)
    }
    
}
