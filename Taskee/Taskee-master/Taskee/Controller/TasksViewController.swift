//
//  TasksViewController.swift
//  Taskee
//
//  Created by Mohammed Drame on 10/7/20.
//  Copyright © 2020 Mo Drame. All rights reserved.
//

import UIKit
import CoreData

class TasksViewController: UIViewController {
    
    var project: Project?
    var store: CoreDataStack!
    var task: Task!
    let dateFormat = DateFormatter()
    
    // ⁉️ refactor code
    private func setUpNavBar() {
        title = project?.name
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
    }
    @objc func addTask() {
        let vc = NewEditTaskViewController()
        vc.store = store
        vc.project = project
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private let toDoCompleteSegment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: "Todo", at: 0, animated: true)
        segment.insertSegment(withTitle: "Done", at: 1, animated: true)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(switchTasksStatus), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    @objc func switchTasksStatus() {
        switch toDoCompleteSegment.selectedSegmentIndex {
        case 0:
            fetchTodoTasks()
            tasksTableView.reloadData()
        default:
            fetchDoneTasks()
            tasksTableView.reloadData()
        }
    }
    private let tasksTableView: UITableView = {
        let table = UITableView()
        table.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.cellIdentifier)
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    private func setUpSubViews() {
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        view.addSubview(toDoCompleteSegment)
        view.addSubview(tasksTableView)
        NSLayoutConstraint.activate([
            toDoCompleteSegment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            toDoCompleteSegment.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            toDoCompleteSegment.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            toDoCompleteSegment.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            tasksTableView.topAnchor.constraint(equalTo: toDoCompleteSegment.bottomAnchor, constant: 20),
            tasksTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tasksTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpSubViews()
        setUpNavBar()
        fetchTodoTasks()
        tasksTableView.reloadData()
    }
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        let fetchResult: NSFetchRequest<Task> = Task.fetchRequest()
        let sortResults = NSSortDescriptor(key: "due", ascending: true)
        fetchResult.sortDescriptors = [sortResults]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchResult, managedObjectContext: store.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private func fetchTodoTasks(){
        let projectPredicate = NSPredicate(format: "project = %@", project!)
        let statusTodoPredicate = NSPredicate(format: "status = false")
        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [projectPredicate, statusTodoPredicate])
        do{
            try fetchedResultsController.performFetch()
        }catch{
            print(error)
        }
    }
    
    private func fetchDoneTasks(){
        let projectPredicate = NSPredicate(format: "project = %@", project!)
        let statusDonePredicate = NSPredicate(format: "status = true")
        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [projectPredicate, statusDonePredicate])
        do{
            try fetchedResultsController.performFetch()
        }catch{
            print(error)
        }
    }
    private func configureCell(cell: UITableViewCell, for indexPath: IndexPath) {
        guard let cell = cell as? TaskTableViewCell else { return }
        let task = fetchedResultsController.object(at: indexPath)
        cell.taskLabel.text = task.title
        cell.status = task.status
        dateFormat.dateFormat = "MM/dd/yyyy"
        guard let date = task.due else { return }
        let dueDate = dateFormat.string(from: date)
        cell.dueDateLabel.text = "Due by: \(dueDate)"
        if task.status {
            cell.checkBoxButton.backgroundColor = .green
        } else {
            cell.checkBoxButton.backgroundColor = .clear
        }
    }
    
    
    
    
}

extension TasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.cellIdentifier, for: indexPath) as! TaskTableViewCell
        configureCell(cell: cell, for: indexPath)
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = fetchedResultsController.object(at: indexPath)
        let vc = NewEditTaskViewController()
        vc.project = project
        vc.task = task
        vc.store = store
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            store.mainContext.delete(fetchedResultsController.object(at: indexPath))
            store.saveContext()
        }
    }
}

extension TasksViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tasksTableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tasksTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tasksTableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = tasksTableView.cellForRow(at: indexPath!) as! TaskTableViewCell
            configureCell(cell: cell, for: indexPath!)
        case .move:
            tasksTableView.deleteRows(at: [indexPath!], with: .automatic)
            tasksTableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tasksTableView.endUpdates()
    }
}

extension TasksViewController: TaskTableViewCellDelegate {
    func taskTableViewCell(_ index: IndexPath) {
        task = fetchedResultsController.object(at: index)
        if task.status {
            task.status = false
            store.saveContext()
            tasksTableView.reloadData()
        } else {
            task.status = true
            store.saveContext()
            tasksTableView.reloadData()
        }
    }
}
