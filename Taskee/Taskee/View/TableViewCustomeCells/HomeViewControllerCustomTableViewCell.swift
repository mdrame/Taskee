//
//  HomeViewControllerCustomTableViewCell.swift
//  Taskee
//
//  Created by Mohammed Drame on 10/1/20.
//  Copyright © 2020 Mo Drame. All rights reserved.
//

import UIKit

class HomeViewControllerCustomTableViewCell: UITableViewCell {
    static var cellIdentifier: String! = "CustomCell"
    // Views
    func viewSetup() {
        addSubview(colorView)
        addSubview(taskLabelLabel)
        addSubview(projectTitleLabel)
        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.115),
            colorView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            colorView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            colorView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            taskLabelLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.35),
            taskLabelLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            taskLabelLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 20),
            taskLabelLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            projectTitleLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 20),
            projectTitleLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            projectTitleLabel.topAnchor.constraint(equalTo: taskLabelLabel.bottomAnchor, constant: 5),
           
        ])
    }
    
    lazy var colorView: UIView = {
        let colorView = UIView()
//        colorView.backgroundColor = .blue
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.layer.cornerRadius = 10
        colorView.clipsToBounds = true
        return colorView
    }()
    let taskLabelLabel: UILabel = {
        let taskLabelLabel = UILabel()
        taskLabelLabel.translatesAutoresizingMaskIntoConstraints = false
        return taskLabelLabel
    }()
    let projectTitleLabel: UILabel = {
        let projectTitleLabel = UILabel()
        projectTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return projectTitleLabel
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        contentView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        contentView.layer.cornerRadius = 10
        viewSetup()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // Inside UITableViewCell subclass
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    
    
}
