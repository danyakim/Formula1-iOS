//
//  WinnersVC.swift
//  Formula1
//
//  Created by Daniil Kim on 01.06.2021.
//

import UIKit
import RxSwift
import RxCocoa

class WinnersVC: UIViewController {
    
    // MARK: - DriverStandings Properties
    
    internal let tableView = UITableView()
    internal let driversVM = DriverStandingsVM()
    internal let disposeBag = DisposeBag()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(driversVM.currentYear) Winners"
        
        setupReactiveTableView()
        setupAlerts()
        driversVM.getCurrentWinners()
    }
    
}

// MARK: - Driver Standings Table View

extension WinnersVC: DriverStandingsTableView { }
