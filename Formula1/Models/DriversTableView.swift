//
//  DriversTableView.swift
//  Formula1
//
//  Created by Daniil Kim on 05.06.2021.
//

import UIKit

class DriversTableViewDataSource: NSObject {
    
    var drivers = [Driver]()
    var races = [Race]()
    var presenter: UINavigationController?
    
}

extension DriversTableViewDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return drivers.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        
        let driver = drivers[indexPath.row]
        let race = races[indexPath.row]
        cell.fill(subtitle: race.raceName,
                  text: (driver.givenName, isBold: false),
                  (driver.familyName, isBold: false),
                  (driver.permanentNumber ?? "", isBold: true))
        
        return cell
    }
    
}

extension DriversTableViewDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let raceDetailsVC = RaceDetailsVC()
        raceDetailsVC.race =  races[indexPath.row]
        presenter?.pushViewController(raceDetailsVC, animated: true)
    }
    
}
