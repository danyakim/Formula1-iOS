//
//  DriverStandingsViewController.swift
//  Formula1
//
//  Created by Daniil Kim on 08.06.2021.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - Driver Standings Table View Protocol

protocol DriverStandingsVC: UIViewController {
    var tableView: UITableView { get }
    var driversVM: DriverStandingsVM { get }
    var disposeBag: DisposeBag { get }
}

// MARK: - Default Implementation

extension DriverStandingsVC {
    
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
            
            TableViewHelper.updateCell(cell: cell,
                 subtitle: race.raceName,
                 text: (driver.givenName, isBold: false),
                 (driver.familyName, isBold: false),
                 (driver.permanentNumber ?? "", isBold: true))
            return cell
        }.disposed(by: disposeBag)
    }
    
    private func setupCellTapHandling() {
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.tableView.deselectRow(at: indexPath, animated: true)
            
            let race = self.driversVM.positions.value[indexPath.row].race
            let raceDetailsVC = RaceDetailsVC(race: race)
            self.navigationController?.pushViewController(raceDetailsVC, animated: true)
        }).disposed(by: disposeBag)
    }
    
}
