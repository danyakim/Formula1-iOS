//
//  WinnersVC.swift
//  Formula1
//
//  Created by Daniil Kim on 01.06.2021.
//

import UIKit

class WinnersVC: UIViewController {
    
    // MARK: - UIViews
    
    private let tableView = UITableView()
    
    // MARK: - Properties
    
    private let dataSource = DriversTableViewDataSource()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        getCurrentWinners()
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        dataSource.presenter = navigationController
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    private func getCurrentWinners() {
        ErgastAPI.shared.getCurrentWinners { result in
            switch result {
            case .failure(let error):
                print("*** Error getting drivers: ", error)
            case .success(let jsonResponse):
                print("Got response")
                let details = jsonResponse.getDetails()
                guard !details.isEmpty else { return }
                for detail in details {
                    self.dataSource.drivers.append(detail.driver)
                    self.dataSource.races.append(detail.race)
                }
                DispatchQueue.main.async {
                    self.title = details.first!.race.season + " Winners"
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}
