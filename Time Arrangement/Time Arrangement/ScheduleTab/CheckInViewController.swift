//
//  ScheduleViewController.swift
//  Time Arrangement
//
//  Created by sunan xiang on 2020/3/7.
//  Copyright © 2020 sunan xiang. All rights reserved.
//

import Foundation
import UIKit

class CheckInViewController: UIViewController {
    @IBOutlet var timeSlider: UISlider!
    @IBOutlet var taskPicker: UIPickerView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var checkinButton: UIButton!
    
    let defaults = UserDefaults.standard
    let dataManager = DataManager.sharedInstance
    var tasks = [Task]()
    var titles = [String]()
    var selectedTask: Int!
    var selectedMin: Int!
    
    //
    // MARK: Setup
    //
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(named: "Color")
        setUpView()
        setupUIDesigh()
    }
    
    func setUpView() {
        // initial value
        self.taskPicker.delegate = self
        self.taskPicker.dataSource = self
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "⭐️ Today"
        self.selectedTask = 0
        self.selectedMin = 0
        self.taskPicker.backgroundColor = UIColor(named: "Color")
        self.taskPicker.setValue(UIColor(named: "textColor"), forKeyPath: "textColor")
        // load data
        let today = Date()
        self.dataManager.loadData()
        self.tasks = self.dataManager.fetchData(forDate: today)
        self.titles = [String]()
        for i in 0..<self.tasks.count {
            self.titles.append(self.tasks[i].title!)
        }
        
        // button
        if self.tasks.count == 0 {
            self.checkinButton.isUserInteractionEnabled = false
            self.checkinButton.alpha = 0.5
        } else {
            self.checkinButton.isUserInteractionEnabled = true
            self.checkinButton.alpha = 1
        }
        
        // setup timeslider and label
        self.timeSlider.backgroundColor = UIColor(named: "Color")
        self.timeSlider.value = 0
        self.timeSlider.addTarget(self, action: #selector(didSlided), for: .valueChanged)
        self.timeLabel.text = "00:00"
        self.timeLabel.textColor = UIColor(named: "textColor")
    }
    
    func setupUIDesigh() {
        // button
        self.checkinButton.layer.cornerRadius = 5
        self.checkinButton.layer.shadowColor = UIColor.gray.cgColor
        self.checkinButton.layer.shadowOpacity = 0.5
        self.checkinButton.layer.shadowOffset = .zero
        self.checkinButton.layer.shadowRadius = 5
    }

    //
    // MARK: Actions
    //
    
    @objc func didSlided(_ sender: UISlider) {
        self.selectedMin = Int(sender.value / 10) * 10
        if sender.value.truncatingRemainder(dividingBy: 10) >= 5
        {
            self.selectedMin += 5
        }
        if String(self.selectedMin).count < 2 {
            self.timeLabel.text = "0" + String(self.selectedMin) + ":00"
        } else {
            self.timeLabel.text = String(self.selectedMin) + ":00"
        }
    }
    
    //
    // MARK: Segue Navigation
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenCountDown" {
            let vc = segue.destination as! CountDownViewController
            vc.task = self.tasks[self.selectedTask]
            vc.timeInSec = self.selectedMin * 60
        }
    }
}


//
// MARK: PickerView
//

extension CheckInViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.tasks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.titles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedTask = row
    }
}
