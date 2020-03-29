//
//  UpcomingViewController.swift
//  Time Arrangement
//
//  Created by sunan xiang on 2020/3/18.
//  Copyright © 2020 sunan xiang. All rights reserved.
//

import Foundation
import UIKit

//
// MARK: class for section data
//

class Upcomings {
    var futureDate: Date!
    var tasks: [Task]!
    init(futureDate: Date, tasks: [Task]) {
        self.futureDate = futureDate
        self.tasks = tasks
    }
}

class UpcomingViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    //
    // MARK: Properties
    //
    
    @IBOutlet weak var upcomingTable: UITableView!
    
    let dataManager = DataManager.sharedInstance
    var upcomingTasks = [Upcomings]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.upcomingTable.dataSource = self
        self.upcomingTable.delegate = self
        self.upcomingTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        upcomingTable.tableFooterView = UIView()
        self.upcomingTable.rowHeight = 60
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "🗓Upcoming"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var days = Date()
        upcomingTasks = [Upcomings]()
        
        for _ in 0..<7 {
            days.addTimeInterval(TimeInterval(24*60*60))
            let tasks = self.dataManager.fetchData(forDate: days)
            if tasks.count > 0 {
                let upcoming = Upcomings.init(futureDate: days, tasks: tasks)
                upcomingTasks.append(upcoming)
            }
        }
        upcomingTable.reloadData()
    }
    
    //
    // MARK: Setup table view
    //
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        print("section\(upcomingTasks.count)")
        return upcomingTasks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // print("row\(upcomingTasks[section].tasks)")
        return upcomingTasks[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = upcomingTable.dequeueReusableCell(withIdentifier: "futureTask", for: indexPath) as! FutureTaskCell
        cell.taskTitle!.text = upcomingTasks[indexPath.section].tasks[indexPath.row].title!
        cell.taskTime!.text = "\(Int(60*(upcomingTasks[indexPath.section].tasks[indexPath.row].duration!)))min"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0,y: 0, width: upcomingTable.bounds.size.width, height: 200))

        headerView.backgroundColor = UIColor(named: "Color")
        let day = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height:30))
        let weekDay = UILabel(frame: CGRect(x: 60, y: 15, width: 200, height:30))
        let lineView = UIView(frame: CGRect(x: 42, y: 8, width: UIScreen.main.bounds.width-20, height: 1.5))
        lineView.layer.borderWidth = 1.5
        lineView.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1).cgColor
        
        self.view.addSubview(lineView)
        
        let date = upcomingTasks[section].futureDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date!)
        
        /* modify day label*/
        day.text = "\(Calendar.current.component( .day, from: date!))"
        day.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        /* modify day label*/
        weekDay.text = dayInWeek
        weekDay.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        weekDay.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        
        headerView.addSubview(day)
        headerView.addSubview(weekDay)
        headerView.addSubview(lineView)

        return headerView
    }
    
    
}
