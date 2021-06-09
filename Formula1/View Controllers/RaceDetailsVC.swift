//
//  RaceDetailsVC.swift
//  Formula1
//
//  Created by Daniil Kim on 01.06.2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RaceDetailsVC: UIViewController {
    
    // MARK: - UIViews
    
    private let tableView = UITableView()
    
    // MARK: - Properties
    
    private var race: Race
    private var raceDetailsVM = RaceDetailsVM()
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    
    required init(race: Race) {
        self.race = race
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Details"
        setupReactiveTableView()
        raceDetailsVM.getDetails(of: race)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Reactive Table View
    
    private func setupReactiveTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        setupDataSource()
        setupTapHandling()
    }
    
    private func setupDataSource() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfResult>(
            configureCell: { [weak self] _, _, indexPath, cellModel in
                
                guard let self = self else { return UITableViewCell() }
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                
                switch cellModel {
                case .title(let race):
                    self.configureTitle(cell: cell, with: race)
                case .position(let result):
                    self.configureDriverResult(cell: cell,
                                               driver: result.driver,
                                               time: result.time,
                                               row: indexPath.row)
                }
                
                return cell
            }, titleForHeaderInSection: { dataSource, index in
                return dataSource.sectionModels[index].model
            })
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        raceDetailsVM.sections.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    private func setupTapHandling() {
        tableView.rx.modelSelected(CellModel.self).subscribe { [weak self] cellModel in
            guard let self = self else { return }
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
            
            switch cellModel.element {
            case .title(let race):
                self.showWebPage(urlString: race.url)
            case .position(let driverResult):
                self.showWebPage(urlString: driverResult.driver.url)
            default:
                print("Unknown case of CellModel")
            }
        }.disposed(by: disposeBag)
    }
    
    // MARK: - Private Methods
    
    private func showWebPage(urlString: String) {
        if let url = URL(string: urlString) {
            let webPageVC = WebPageVC(show: url)
            navigationController?.pushViewController(webPageVC, animated: true)
        }
    }
    
    private func configureTitle(cell: UITableViewCell, with race: Race) {
        let title = race.season + " - " + race.round
        TableViewHelper.updateCell(cell: cell,
                                   subtitle: self.race.raceName + "   " + race.date,
                                   fontSizeMod: 4,
                                   text: (value: title, isBold: true))
        cell.accessoryType = .disclosureIndicator
    }
    
    private func configureDriverResult(cell: UITableViewCell, driver: Driver, time: String, row: Int) {
        let position = "P\(row + 1)"
        
        var number = ""
        if let permanentNumber = driver.permanentNumber {
            number = permanentNumber + " "
        }
        let fullName = driver.givenName + " " + driver.familyName
        
        TableViewHelper.updateCell(cell: cell,
                                   subtitle: time,
                                   text: (position, isBold: true), (fullName, isBold: false), (number, isBold: true))
    }
    
}

extension RaceDetailsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return 88 }
        return 66
    }
    
}
