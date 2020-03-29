//
//  DataManager.swift
//  Time Arrangement
//
//  Created by TIANDA LIU on 3/15/20.
//  Copyright © 2020 sunan xiang. All rights reserved.
//

import Foundation

struct Task: Codable {
    var title: String?
    var type: Frequency?
    var startDate: Date?
    var endDate: Date?
    var duration: Double? // unit: hour
    var finishedPart: Double?
    var distribution: [Date: Int]? // unit: min
}

enum Frequency: Int, Codable {
    case Once, Day, Week, Month
}

class DataManager {
    public static let sharedInstance = DataManager()
    fileprivate init() {}
    
    var timesOfLaunched: Int = 0
    var tasks = [Task]()
    var defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    func loadTimesOfLaunched() {
        self.timesOfLaunched = 0
        if let loadedData = self.defaults.integer(forKey: "TimesOfLaunched") as Int? {
            self.timesOfLaunched = loadedData
        }
    }
    
    func increaseTimesOfLaunched() {
        self.timesOfLaunched += 1
        self.defaults.set(self.timesOfLaunched, forKey: "TimesOfLaunched")
    }
    
    func updateUserDefaults() {
        if let encoded = try? self.encoder.encode(self.tasks) {
            self.defaults.set(encoded, forKey: "SavedTasks")
        }
    }
    
    func loadData() {
        // initial userdefault
        self.tasks = [Task]()
        if let savedTasks = self.defaults.object(forKey: "SavedTasks") as? Data {
            self.tasks = try! self.decoder.decode([Task].self, from: savedTasks)
        }
    }
    
    func addTask(_ task: Task) {
        self.tasks.append(task)
        self.updateUserDefaults()
    }
    
    func fetchData(forDate date: Date) -> [Task] {
        var res = [Task]()
        for task in self.tasks {
            switch task.type {
            case .Once:
                if task.startDate?.convertToString(dateformat: .date) == date.convertToString(dateformat: .date) && date <= task.endDate! {
                    res.append(task)
                }
            case .Day:
                if date <= task.endDate! {
                    res.append(task)
                }
            case .Week:
                if Calendar.current.component(.weekday, from: task.startDate!) == Calendar.current.component(.weekday, from: date) && date <= task.endDate! {
                    res.append(task)
                }
            case .Month:
                if Calendar.current.component(.day, from: task.startDate!) == Calendar.current.component(.day, from: date) && date <= task.endDate!{
                        res.append(task)
                }
            default:
                print("None")
            }
        }
        return res
    }
    
    func updateTask(_ task: Task) {
        for i in 0..<self.tasks.count {
            if self.tasks[i].title == task.title {
                self.tasks[i] = task
                print(self.tasks[i])
                break
            }
        }
        self.updateUserDefaults()
        
    }
    
    func renameTask(_ task: Task, newTitle: String) {
        for i in 0..<self.tasks.count {
            if self.tasks[i].title == task.title {
                self.tasks[i].title = newTitle
                break
            }
        }
        self.updateUserDefaults()
    }
    
    func deleteTask(_ task: Task) {
        self.tasks = self.tasks.filter { $0.title != task.title }
        self.updateUserDefaults()
    }
    
}
