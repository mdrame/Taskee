//
//  ViewController.swift
//  Taskee
//
//  Created by Mohammed Drame on 9/17/20.
//  Copyright © 2020 Mo Drame. All rights reserved.
//

import UIKit

class Home: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ViewControllerViewCode(allow: true, text: "Projects")
        view.addSubview(homeTableView)
        homeTableViewConstrain()
        homeTableView.delegate = self
        homeTableView.dataSource = self
    }
    
    
    // View Code
    func ViewControllerViewCode(allow: Bool, text string: String?) {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = string!
    }
    
    
    // Table View controller setup
    
    lazy var homeTableView: UITableView = {
        let homeTableView = UITableView(frame: .zero)
        homeTableView.translatesAutoresizingMaskIntoConstraints = false
        homeTableView.register(HomeViewControllerCustomTableViewCell.self, forCellReuseIdentifier: HomeViewControllerCustomTableViewCell.cellIdentifier)
        homeTableView.separatorStyle = .none
        return homeTableView
    }()
    
    func homeTableViewConstrain() {
        NSLayoutConstraint.activate([
            homeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            homeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    
    
    
    
    
    
    // Delegate and DataSource for tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 3
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewControllerCustomTableViewCell.cellIdentifier, for: indexPath) as! HomeViewControllerCustomTableViewCell as HomeViewControllerCustomTableViewCell
//        cell.viewSetup()
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(130)
    }
    
   
    
    
    
    
       
    


}

