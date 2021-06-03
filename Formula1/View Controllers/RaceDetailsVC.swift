//
//  RaceDetailsVC.swift
//  Formula1
//
//  Created by Daniil Kim on 01.06.2021.
//

import UIKit

class RaceDetailsVC: UITableViewController {

    // MARK: - Properties
    
    var race: Race!
    var drivers = [Driver]()
    var times = [String]()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Details"
        
        ErgastAPI.shared.getResults(of: race) { result in
            switch result {
            case .failure(let error):
                print("*** Error getting race results: ", error)
            case .success(let jsonResponse):
                print("Got race results")
                if let details = jsonResponse.getRaceDetails() {
                    self.drivers = details.drivers
                    self.times = details.times
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        drivers = race.getAllDrivers()
        times = race.getTimes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        return drivers.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Results"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return 88 }
        return 66
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        if indexPath.section == 0 {
            let title = race.season + " - " + race.round
            cell.fill(subtitle: race.raceName + "   " + race.date, fontSizeMod: 4, text: (value: title, isBold: true))
            cell.accessoryType = .disclosureIndicator
        } else {
            let driver = drivers[indexPath.row]
            
            var number = ""
            if let permanentNumber = driver.permanentNumber {
                number = permanentNumber + " "
            }
            let fullName = driver.givenName + " " + driver.familyName
            
            cell.fill(subtitle: times[indexPath.row],
                      text: (number, isBold: true), (fullName, isBold: false))
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            showWebPage(urlString: race.url)
        } else {
            let driver = drivers[indexPath.row]
            showWebPage(urlString: driver.url)
        }
    }
    
    // MARK: - Private Methods
    
    private func showWebPage(urlString: String) {
        if let url = URL(string: urlString) {
            let webPageVC = WebPageVC(url: url)
            navigationController?.pushViewController(webPageVC, animated: true)
        }
    }
}
