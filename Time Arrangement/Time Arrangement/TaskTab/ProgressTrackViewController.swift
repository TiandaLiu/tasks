//
//  ProgressTrackViewController.swift
//  Time Arrangement
//
//  Created by sunan xiang on 2020/3/16.
//  Copyright © 2020 sunan xiang. All rights reserved.
//

import Foundation
import UIKit


class ProgressTrackerViewController: UIViewController{
    
    //
    // MARK: - Properties
    //
    
    @IBOutlet weak var barChart: BasicBarChart!
    @IBOutlet weak var goalVal: UILabel!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskType: UILabel!
    @IBOutlet weak var taskDuration: UILabel!
    @IBOutlet weak var taskDate: UILabel!
    
    var numEntry: Int!
    var task: Task!
    var distribution:[Date: Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* set up the basic information*/
        distribution = self.task?.distribution
        let startDate = self.task!.startDate
        let endDate = self.task!.endDate
        self.taskTitle.text = self.task.title!
        self.taskDuration.text = "\(self.task.duration ?? 0)h"
        var diff:DateComponents!
        self.taskDate.text = "\(startDate!.convertToString(dateformat: DateFormatType.date)) to \(endDate!.convertToString(dateformat: DateFormatType.date))"
        switch self.task?.type {
        case .Once:
            self.numEntry = 1;
            self.taskType.text = "Once"
            break
        case .Day:
            diff = Calendar.current.dateComponents( [.day], from: startDate!, to: endDate!)
            self.numEntry = diff.day!+1
            self.taskType.text = "Every Day"
        case .Week:
            diff = Calendar.current.dateComponents( [.weekOfYear], from: startDate!, to: endDate!)
            self.numEntry = diff.weekOfYear!+1
            self.taskType.text = "Every Week"

        case .Month:
            diff = Calendar.current.dateComponents( [.month], from: startDate!, to: endDate!)
            self.numEntry = diff.month!+1
            self.taskType.text = "Every Month"

        case .none:
            self.numEntry = 20
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        let goal = Int(60*(self.task.duration!))
        self.goalVal.text = "Goal: \(goal)" + " min"
        var dataEntries = generateEmptyDataEntries()
        barChart.updateDataEntries(dataEntries: dataEntries, animated: false)
        dataEntries = self.generateDataEntries()
        self.barChart.updateDataEntries(dataEntries: dataEntries, animated: true)
        
    }

    //
    // MARK: - Prepare DataEntries
    //
    
    func generateEmptyDataEntries() -> [DataEntry] {
        var result: [DataEntry] = []
        Array(0..<self.numEntry).forEach {_ in
            result.append(DataEntry(color: UIColor.clear, height: 0, textValue: "0", title: ""))
        }
        return result
    }

    func generateDataEntries() -> [DataEntry] {
        let colors = [ #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)]
        var result: [DataEntry] = []
        for i in 0..<self.numEntry {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            
            var date = self.task?.startDate

            /* based on different frequency of the task's type, design different horizontal axis*/
            if (self.task!.type == Frequency.Day){
                date!.addTimeInterval(TimeInterval(24*60*60*i))
            } else if (self.task!.type == Frequency.Week) {
                date!.addTimeInterval(TimeInterval(7*24*60*60*i))
            } else {
                let calendar = Calendar.autoupdatingCurrent
                let curday = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: date!)
                

                let cur = calendar.date(from: curday)
                let nextMonth = calendar.date(byAdding: .month, value: i, to: cur!, wrappingComponents: false)
                
                date = nextMonth
            }
            
            var value: Int = 0
            var textValue: String = ""
            var height: Double = 0
            var colorLevel: Int = 0
            let duration: Double = self.task.duration!
            for (countDate, time) in self.task.distribution! {
                if (isSameDay(date1: date!, date2: countDate)) {
                    value = time
                    textValue = "\(value)" + " min"
                    height = Double(value)/(120*duration)
                    if (value >= Int(90 * duration)) {
                        colorLevel = 2
                    } else if (value >= Int(60 * duration)) {
                        colorLevel = 1
                    }
                }
            }
           
            result.append(DataEntry(color: colors[colorLevel], height: height, textValue: textValue, title: formatter.string(from: date!)))
        }
        return result
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let day1 = Calendar.current.dateComponents([.day, .month], from: date1)
        let day2 = Calendar.current.dateComponents([.day, .month], from: date2)
        print(day1)
        print(day2)
        if day1.day == day2.day && day1.month == day2.month{
            return true
        } else {
            return false
        }
    }
    
}



