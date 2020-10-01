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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        contentView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        contentView.layer.cornerRadius = 10
      
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
