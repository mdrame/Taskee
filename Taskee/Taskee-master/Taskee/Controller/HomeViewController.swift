//
//  HomeViewController.swift
//  Taskee
//
//  Created by Mohammed Drame on 10/7/20.
//  Copyright © 2020 Mo Drame. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    // Storage
    var store = CoreDataStack(modelName: "Taskee")
    lazy var fetchedResultsController: NSFetchedResultsController<Project> = {
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        fetchRequest.sortDescriptors = []
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: store.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    private func fetchResults() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    // Views
    private func setUpNavBar(with titlle: String, and text: Bool) {
        title = titlle;        self.navigationController?.navigationBar.prefersLargeTitles = text
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreateProjectViewController))
    }
    @objc func goToCreateProjectViewController() {
        let vc = AddProjectViewController()
        vc.store = store
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private let projectsTableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 100
        table.register(ProjectTableViewCell.self, forCellReuseIdentifier: ProjectTableViewCell.cellIdentifier)
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    private func supViewsSetup() {
        projectsTableView.dataSource = self
        projectsTableView.delegate = self
        view.addSubview(projectsTableView)
        NSLayoutConstraint.activate([
            projectsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            projectsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            projectsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            projectsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    // Engine
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        supViewsSetup()
        setUpNavBar(with: "Project", and: true)
        fetchResults()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchResults()
        projectsTableView.reloadData()
    }
    private func configureCell(cell: UITableViewCell, for indexPath: IndexPath) {
        guard let cell = cell as? ProjectTableViewCell else { return }
        let project = fetchedResultsController.object(at: indexPath)
        var count = 0
        cell.projectTitle.text = project.name
        guard let color = project.color else {
            return cell.projectColorView.backgroundColor = nil
        }
        cell.projectColorView.backgroundColor = color
        guard let tasks = project.tasks else { return }
        for _ in tasks {
            count += 1
        }
        cell.taskLabel.text = "\(count) tasks"
    }
    
   
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    // Delegate and Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectTableViewCell.cellIdentifier, for: indexPath) as! ProjectTableViewCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = fetchedResultsController.object(at: indexPath)
        let vc = TasksViewController()
        vc.store = store
        vc.project = project
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            store.mainContext.delete(fetchedResultsController.object(at: indexPath))
            store.saveContext()
        }
    }
}

extension HomeViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        projectsTableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            projectsTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            projectsTableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = projectsTableView.cellForRow(at: indexPath!) as! ProjectTableViewCell
            configureCell(cell: cell, for: indexPath!)
        case.move:
            projectsTableView.deleteRows(at: [indexPath!], with: .automatic)
            projectsTableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        projectsTableView.endUpdates()
    }
}

