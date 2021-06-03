//
//  DriversVC.swift
//  Formula1
//
//  Created by Daniil Kim on 01.06.2021.
//

import UIKit

class DriversVC: UITableViewController {
    
    // MARK: - Properties
    
    var drivers = [Driver]()
    var races = [Race]()
    
    let currentYear = Calendar.current.component(.year, from: Date())
    
    var years: [String] {
        var years = [String]()
        
        guard currentYear > 1950 else { return years }
        
        for year in (1950...currentYear).reversed() {
            years.append(String(year))
        }
        return years
    }
    
    var positions: [String] {
        var positions = [String]()
        
        for pos in 1...20 {
            positions.append(String(pos))
        }
        return positions
    }
    
    // MARK: - UIViews
    
    lazy var pickerView = UIPickerView()
    
    lazy var yearTextField = UITextField()
    lazy var positionTextField = UITextField()
    
    var chosenYear: String?
    var chosenPosition: String?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickerView()
        setupPickerViewToolbar()
        
        if navigationController?.tabBarItem.tag == K.Tags.firstScreen {
            title = String(currentYear) + " Winners"
            getCurrentWinners()
        } else {
            setupLabels()
        }
    }
    
    // MARK: - Private Methods
    
    private func setupPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
        
        yearTextField.inputView = pickerView
        positionTextField.inputView = pickerView
        
        yearTextField.tintColor = .clear
        positionTextField.tintColor = .clear
        
        pickerView(pickerView, didSelectRow: 0, inComponent: 0)
        pickerView(pickerView, didSelectRow: 0, inComponent: 1)
    }
    
    private func setupPickerViewToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelButton, flexSpace, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        yearTextField.inputAccessoryView = toolbar
        positionTextField.inputAccessoryView = toolbar
    }
    
    private func getCurrentWinners() {
        ErgastAPI.shared.getCurrentWinners { result in
            switch result {
            case .failure(let error):
                print("*** Error getting drivers: ", error)
            case .success(let jsonResponse):
                print("Got response")
                let details = jsonResponse.getDetails()
                for detail in details {
                    self.drivers.append(detail.driver)
                    self.races.append(detail.race)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func getDrivers(at position: String, year: String) {
        ErgastAPI.shared.getDrivers(at: position,
                                    year: year) { result in
            switch result {
            case .failure(let error):
                print("*** Error getting drivers year: \(year) at position: \(position): ", error)
            case .success(let jsonResponse):
                print("Got response")
                let details = jsonResponse.getDetails()
                for detail in details {
                    self.drivers.append(detail.driver)
                    self.races.append(detail.race)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func setupLabels() {
        let labelsContainer = UIStackView(arrangedSubviews: [yearTextField, positionTextField])
        
        labelsContainer.axis = .horizontal
        labelsContainer.alignment = .center
        labelsContainer.spacing = 20
        
        yearTextField.placeholder = "year"
        yearTextField.borderStyle = .roundedRect
        
        positionTextField.placeholder = "pos"
        positionTextField.borderStyle = .roundedRect
        
        navigationItem.titleView = labelsContainer
    }
    
    // MARK: - Selector Methods
    
    @objc
    private func cancel() {
        yearTextField.resignFirstResponder()
        positionTextField.resignFirstResponder()
    }
    
    @objc
    private func done() {
        drivers = []
        races = []
        
        if let year = chosenYear,
           let position = chosenPosition {
            
            yearTextField.text = chosenYear
            positionTextField.text = chosenPosition
            
            getDrivers(at: position, year: year)
        }
        
        yearTextField.resignFirstResponder()
        positionTextField.resignFirstResponder()
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return drivers.count
    }
    
    override func tableView(_ tableView: UITableView,
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
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let raceDetailsVC = RaceDetailsVC()
        raceDetailsVC.race =  races[indexPath.row]
        navigationController?.pushViewController(raceDetailsVC, animated: true)
    }
    
}

// MARK: - Picker View

extension DriversVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return years.count
        } else {
            return positions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if component == 0 {
            return years[row]
        } else {
            return positions[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        if component == 0 {
            chosenYear = years[row]
        } else {
            chosenPosition = positions[row]
        }
    }
    
}
