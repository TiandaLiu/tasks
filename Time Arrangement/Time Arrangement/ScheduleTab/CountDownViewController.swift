//
//  CountDownViewController.swift
//  Time Arrangement
//
//  Created by TIANDA LIU on 3/16/20.
//  Copyright © 2020 sunan xiang. All rights reserved.
//

import Foundation
import UIKit

class CountDownViewController: UIViewController {
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var backButton: UIBarButtonItem!
    
    var dataManager = DataManager.sharedInstance
    var task: Task!
    var timeInSec: Int!
    var countDown: Int!
    var timer: Timer?
    
    //
    // MARK: Setup
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUiDesign()
        setupItems()
    }
    
    
    func setupItems() {
        self.countDown = self.timeInSec
        self.timeLabel.text = self.convertSecToMin(self.timeInSec)
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        self.cancelButton.addTarget(self, action: #selector(self.cancelAction(_:)), for: .touchUpInside)
    }
    
    func setupUiDesign() {
        self.timeLabel.layer.cornerRadius = 100
        self.timeLabel.layer.shadowColor = UIColor.gray.cgColor
        self.timeLabel.layer.shadowOpacity = 0.5
        self.timeLabel.layer.shadowOffset = .zero
        self.timeLabel.layer.shadowRadius = 10
        self.timeLabel.layer.backgroundColor = CGColor(srgbRed: 146/255, green: 207/255, blue: 158/255, alpha: 1)

        self.cancelButton.layer.cornerRadius = 5
        self.cancelButton.layer.shadowColor = UIColor.gray.cgColor
        self.cancelButton.layer.shadowOpacity = 0.5
        self.cancelButton.layer.shadowOffset = .zero
        self.cancelButton.layer.shadowRadius = 5
    }
    
    //
    // MARK: Actions
    //
    
    @objc func onTimerFires() {
        self.countDown -= 1
        self.countDown = max(0, self.countDown)
        self.timeLabel.text = self.convertSecToMin(self.countDown)
        
        if self.countDown <= 0 {
            self.updateTask()
            // terminate timer
            self.showAlert()
            self.timer?.invalidate()
            self.timer = nil
        }
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        print("cancel")
        self.timer?.invalidate()
        self.timer = nil
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //
    // MARK: Functions
    //
    
    func updateTask() {
        let today = Date().dateOnly()
        if self.task.distribution!.keys.contains(today.dateOnly()) {
            self.task.distribution![today.dateOnly()]! += self.timeInSec/60
        } else {
            self.task.distribution![today.dateOnly()] = self.timeInSec/60
        }
        let finishPart = self.task.finishedPart! + Double(self.timeInSec/60)
        self.task.finishedPart = finishPart
        self.dataManager.updateTask(self.task)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Finished", message: "Good Job!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.finished()}))
        self.present(alert, animated: true)
    }
    
    func finished() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func convertSecToMin(_ num: Int) -> String {
        var min = String(num / 60)
        var sec = String(num % 60)
        if min.count < 2 {
            min = "0" + min
        }
        if sec.count < 2 {
            sec = "0" + sec
        }
        return min + ":" + sec
    }
}
