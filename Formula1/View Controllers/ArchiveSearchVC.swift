//
//  ArchiveSearchVC.swift
//  Formula1
//
//  Created by Daniil Kim on 05.06.2021.
//

import UIKit

class ArchiveSearchVC: UIViewController {

    // MARK: - UIViews
    
    private let tableView = UITableView()
    
    private let pickerView = UIPickerView()
    private let yearTextField = UITextField()
    private let positionTextField = UITextField()
    
    // MARK: - Properties
    
    private let dataSource = DriversTableViewDataSource()
    
    private let currentYear = Calendar.current.component(.year, from: Date())
    
    private var chosenYear: String?
    private var chosenPosition: String?
    
    private var years: [String] {
        guard currentYear > 1950 else { return [] }
        
        var years = [String]()
        for year in (1950...currentYear).reversed() {
            years.append(String(year))
        }
        return years
    }
    
    private var positions: [String] {
        var positions = [String]()
        for pos in 1...20 {
            positions.append(String(pos))
        }
        return positions
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupLabels()
        setupPickerView()
        setupPickerViewToolbar()
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        dataSource.presenter = navigationController
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
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
    
    private func setupLabels() {
        
        let seasonLabel = UILabel()
        seasonLabel.text = "Season:"
        seasonLabel.font = .boldSystemFont(ofSize: 18)
        yearTextField.borderStyle = .roundedRect
        yearTextField.placeholder = String(currentYear)
        let seasonStack = UIStackView(arrangedSubviews: [seasonLabel, yearTextField])
        seasonStack.configure(axis: .horizontal, alignment: .center, spacing: 10)
        
        let positionLabel = UILabel()
        positionLabel.text = "P"
        positionLabel.font = .boldSystemFont(ofSize: 18)
        positionTextField.borderStyle = .roundedRect
        positionTextField.placeholder = "1"
        let positionStack = UIStackView(arrangedSubviews: [positionLabel, positionTextField])
        positionStack.configure(axis: .horizontal, alignment: .center, spacing: 10)
        
        let labelsContainer = UIStackView(arrangedSubviews: [seasonStack, positionStack])
        labelsContainer.configure(axis: .horizontal, alignment: .center, spacing: 20)
        
        navigationItem.titleView = labelsContainer
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
                    self.dataSource.drivers.append(detail.driver)
                    self.dataSource.races.append(detail.race)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Selector Methods
    
    @objc
    private func cancel() {
        yearTextField.resignFirstResponder()
        positionTextField.resignFirstResponder()
    }
    
    @objc
    private func done() {
        dataSource.drivers = []
        dataSource.races = []
        
        if let year = chosenYear,
           let position = chosenPosition {
            
            yearTextField.text = chosenYear
            positionTextField.text = chosenPosition
            
            getDrivers(at: position, year: year)
        }
        
        yearTextField.resignFirstResponder()
        positionTextField.resignFirstResponder()
    }
    
}

// MARK: - Picker View

extension ArchiveSearchVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
