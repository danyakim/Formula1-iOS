//
//  ArchiveSearchVC.swift
//  Formula1
//
//  Created by Daniil Kim on 05.06.2021.
//

import UIKit
import RxSwift
import RxCocoa

class ArchiveSearchVC: UIViewController {

    // MARK: - UIViews
    
    private let pickerView = UIPickerView()
    private let yearTextField = UITextField()
    private let positionTextField = UITextField()
    
    // MARK: - Driver Standings Properties
    
    internal let tableView = UITableView()
    internal let driversVM = DriverStandingsVM()
    internal let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    private var chosenYear: String?
    private var chosenPosition: String?
    
    private var years: [String] {
        guard driversVM.currentYear > 1950 else { return [] }
        
        var years = [String]()
        for year in (1950...driversVM.currentYear).reversed() {
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
        
        setupReactiveTableView()
        setupAlerts()
        
        setupLabels()
        setupPickerView()
        setupPickerViewToolbar()
    }
    
    // MARK: - Setup Views
    
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
        yearTextField.placeholder = String(driversVM.currentYear)
        let seasonStack = UIStackView(arrangedSubviews: [seasonLabel, yearTextField])
        seasonStack.configure(axis: .horizontal, alignment: .center, spacing: 5)
        
        let positionLabel = UILabel()
        positionLabel.text = "P"
        positionLabel.font = .boldSystemFont(ofSize: 18)
        positionTextField.borderStyle = .roundedRect
        positionTextField.placeholder = "1"
        let positionStack = UIStackView(arrangedSubviews: [positionLabel, positionTextField])
        positionStack.configure(axis: .horizontal, alignment: .center, spacing: 5)
        
        let labelsContainer = UIStackView(arrangedSubviews: [seasonStack, positionStack])
        labelsContainer.configure(axis: .horizontal, alignment: .center, spacing: 15)
        
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
        if let year = chosenYear,
           let position = chosenPosition {
            
            yearTextField.text = chosenYear
            positionTextField.text = chosenPosition
            
            driversVM.getDrivers(at: position, year: year)
        }
        
        yearTextField.resignFirstResponder()
        positionTextField.resignFirstResponder()
    }
    
}

// MARK: - Driver Standings TableView

extension ArchiveSearchVC: DriverStandingsTableView { }

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
