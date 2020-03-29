//
//  NewTaskViewController.swift
//  Time Arrangement
//
//  Created by TIANDA LIU on 3/15/20.
//  Copyright © 2020 sunan xiang. All rights reserved.
//

import Foundation
import UIKit

class CreateTaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DatePickerDelegate {
    
    //
    // MARK: - Properties
    //
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var typeSelector: UISegmentedControl!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var durationStepper: UIStepper!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    var dataManager = DataManager.sharedInstance
    weak var delegate: TableReloadDelegate?
    
    /* Table View: inline picker*/
    var taskIndexPath: IndexPath!
    var datePickerIndexPath: IndexPath?
    var inputTexts: [String] = ["Start date", "End date"]
    var inputDates: [Date] = []
    
    //
    // MARK: - Set up Views
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        self.createButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.durationStepper.addTarget(self, action: #selector(stepperChanged), for: .valueChanged)
        
        /* Set initial values of the date picker*/
        addInitailValues()
        
        /* set up table view*/
        setupTableView()

        /* Set the property of the button*/
        setupButton()

    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: DateTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: DateTableViewCell.reuseIdentifier())
        tableView.register(UINib(nibName: DatePickerTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: DatePickerTableViewCell.reuseIdentifier())
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()

    }
    
    /* Set initial values of the date picker*/
    func addInitailValues() {
        inputDates = Array(repeating: Date(), count: inputTexts.count)
    }
    
    func indexPathToInsertDatePicker(indexPath: IndexPath) -> IndexPath {
        if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row < indexPath.row {
            return indexPath
        } else {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        }
    }
    
    func setupButton() {
        self.createButton.layer.cornerRadius = 5
        self.createButton.layer.shadowColor = UIColor.gray.cgColor
        self.createButton.layer.shadowOpacity = 0.5
        self.createButton.layer.shadowOffset = .zero
        self.createButton.layer.shadowRadius = 5
    }
    
    //
    // MARK: - Properties of Table view
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if datePickerIndexPath != nil {
            return inputTexts.count + 1
        } else {
            return inputTexts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if datePickerIndexPath == indexPath {
            let datePickerCell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.reuseIdentifier()) as! DatePickerTableViewCell
            datePickerCell.updateCell(date: inputDates[indexPath.row - 1], indexPath: indexPath)
            datePickerCell.delegate = self
            return datePickerCell
        } else {
            let dateCell = tableView.dequeueReusableCell(withIdentifier: DateTableViewCell.reuseIdentifier()) as! DateTableViewCell
            dateCell.updateText(text: inputTexts[indexPath.row], date: inputDates[indexPath.row])
            return dateCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.beginUpdates()

        if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row - 1 == indexPath.row {
            tableView.deleteRows(at: [datePickerIndexPath], with: .fade)
            self.datePickerIndexPath = nil
        } else {
            if let datePickerIndexPath = datePickerIndexPath {
                tableView.deleteRows(at: [datePickerIndexPath], with: .fade)
            }
            datePickerIndexPath = indexPathToInsertDatePicker(indexPath: indexPath)
            tableView.insertRows(at: [datePickerIndexPath!], with: .fade)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        tableView.layoutIfNeeded()
        tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height).isActive = true
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if datePickerIndexPath == indexPath {
            return DatePickerTableViewCell.cellHeight()
        } else {
            return DateTableViewCell.cellHeight()
        }
    }
    
    //
    // MARK: - Modify data
    //
    
    func didChangeDate(date: Date, indexPath: IndexPath) {
           inputDates[indexPath.row] = date
           tableView.reloadRows(at: [indexPath], with: .none)
           
       }
    
    @objc func stepperChanged(_ sender: UIStepper) {
        self.durationLabel.text = "⏳ Duration: " + String(Int(self.durationStepper.value)) + "h"
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let title = self.titleTextField.text
        let type = Frequency(rawValue: self.typeSelector.selectedSegmentIndex)
        let duration = self.durationStepper.value
        
        /* set the start date from the start of the dat which is 00:00*/
        var startDate = inputDates[0]
        startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: startDate)!
        /* set the end date to the end of the dat which is 23:59*/
        var endDate = inputDates[1]
        endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: endDate)!
        let newTask =
            Task(title: title, type: type, startDate: startDate, endDate: endDate, duration: duration, finishedPart: 0, distribution: [Date: Int]())
        self.dataManager.addTask(newTask)
        self.navigationController?.popViewController(animated: true)
    }

}

