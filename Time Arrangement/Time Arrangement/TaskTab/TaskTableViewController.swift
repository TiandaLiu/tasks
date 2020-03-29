//
//  TaskTableViewController.swift
//  Time Arrangement
//
//  Created by sunan xiang on 2020/3/5.
//  Copyright © 2020 sunan xiang. All rights reserved.
//

import Foundation
import UIKit
import StoreKit


class TaskTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableReloadDelegate {
    
    //
    // MARK: - Properties
    //
    @IBOutlet var taskTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar! {
        didSet { searchBar.delegate = self }
    }
    
    var defaults = UserDefaults.standard
    var dataManager = DataManager.sharedInstance
    var allTasks = [Task]()
    var tasks = [Task]()

    //
    // MARK: - Set up view
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        self.taskTableView.rowHeight = 80
        self.taskTableView.dataSource = self
        self.taskTableView.delegate = self
        self.title = "📝 To Do List"
        
        
        // app store rating
        if self.dataManager.timesOfLaunched == 3 {
            SKStoreReviewController.requestReview()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // load data
        self.dataManager.loadData()
        self.allTasks = self.dataManager.tasks
        self.tasks = self.allTasks
        taskTableView.tableFooterView = UIView()
        taskTableView.reloadData()
    }
    

    //
    // MARK: - Set up table view
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        cell.taskTitle.text = self.tasks[indexPath.row].title ?? "No Name"
        cell.cellRootView.layer.cornerRadius = 5
        cell.cellRootView.layer.shadowColor = UIColor.gray.cgColor
        cell.cellRootView.layer.shadowOpacity = 0.5
        cell.cellRootView.layer.shadowOffset = .zero
        cell.cellRootView.layer.shadowRadius = 5
        
        /* Progree View*/
        let progress = getProgress(task: self.tasks[indexPath.row])
        cell.progressView.setProgress(progress, animated: true)
        cell.progressText.text = "\(Int(progress*100))%"
        cell.progressView.layer.cornerRadius = 5
        cell.progressView.clipsToBounds = true
        cell.progressView.layer.sublayers![1].cornerRadius = 5
        cell.progressView.subviews[1].clipsToBounds = true
        cell.progressView.tintColor = UIColor(red: 146/255, green: 207/255, blue: 158/255, alpha: 1)
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    /* Swipe acction */
    /// leading swipe to rename the task
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = self.tasks[indexPath.row]
        let editAction = UIContextualAction(style: .normal, title: "Edit",
          handler: { (action, view, completionHandler) in
            self.updateTask(task: task, indexPath: indexPath)
        })
        
        let configuration = UISwipeActionsConfiguration(actions: [editAction])

        return configuration
    }
    
    /// trailing swipe to delete the task
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = self.tasks[indexPath.row]
        let deleteAction = UIContextualAction(style: .normal, title: "Delete",
          handler: { (action, view, completionHandler) in
          self.deleteTask(task: task, indexPath: indexPath)

        })
        
        deleteAction.image = UIImage(systemName: "bin.xmark")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    

    /* update the task's name*/
    func updateTask(task: Task, indexPath: IndexPath){
        let alert = UIAlertController(title: "Rename", message: "Rename your task", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) {(action) in
            guard let textField = alert.textFields?.first else {
                return
            }
            if let textToEdit = textField.text {
                if textToEdit.count == 0 {
                    return
                }
                self.dataManager.renameTask(self.tasks[indexPath.row], newTitle: textToEdit)
                self.viewWillAppear(true)
            }
        }
        alert.addTextField()
        guard (alert.textFields?.first) != nil else {
            return
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated:true)
    }
    
    /* delete the task*/
    func deleteTask(task: Task, indexPath: IndexPath){
        let alert = UIAlertController(title: "Delete", message: "Do you really want to delete the task?",preferredStyle: UIAlertController.Style.alert)
        let delete = UIAlertAction(title: "Yes", style: .default){ (action) in
            self.dataManager.deleteTask(self.tasks[indexPath.row])
            self.viewWillAppear(true)
        }
        
        let cancel = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true)
    }

   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if let destination = segue.destination as? ProgressTrackerViewController {
           let rownum = self.taskTableView.indexPathForSelectedRow?.row
           destination.task = DataManager.sharedInstance.tasks[rownum!]
       }

   }
    
    func reloadTaskTable() {
        self.taskTableView.reloadData()
    }
    
    func filterContainsWithSearchText(_ text: String) {
        guard !text.isEmpty else {
            self.tasks = self.allTasks
          return
        }
        self.tasks = self.allTasks.filter{$0.title!.lowercased().contains(text.lowercased())}
    }

    /// calculate the progress of the task
    func getProgress(task: Task) -> Float{
        var count: Int!
        switch task.type {
        case .Once:
            count = 1
        case .Day:
            count = Calendar.current.dateComponents([.day], from: task.startDate!, to: task.endDate!).day
        case .Week:
            count = Calendar.current.dateComponents([.weekOfYear], from: task.startDate!, to : task.endDate!).weekOfYear
        case .Month:
            count = Calendar.current.dateComponents([.month], from: task.startDate!, to : task.endDate!).month
            
        case .none:
            count = 0
        }
        count += 1
        let total = Double (count*60) * Double (task.duration!)
        let progress = Float (task.finishedPart!/total)
        return progress
    }
 
}

extension TaskTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        self.filterContainsWithSearchText(searchText)
        self.taskTableView.reloadData()
        
    }
    
}

//Hide keyboard when user touches outside keyboard
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
