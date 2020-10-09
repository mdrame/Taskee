//
//  EditProjectViewController.swift
//  Taskee
//
//  Created by Mohammed Drame on 10/7/20.
//  Copyright © 2020 Mo Drame. All rights reserved.
//

import UIKit

class EditProjectViewController: UIViewController {
    
    // Global Variables
    var store: CoreDataStack?
    var project: Project?
    var collectionCellBackgroundColour: [UIColor] = [.red, .brown, .green, .purple, .systemPink]
    var selectedColor: UIColor = .brown
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        ViewControllerViewCode(allow: true, text: "New Project or Edit")
        setupView()
        
    }
    // View Code
    private func ViewControllerViewCode(allow: Bool, text string: String?) {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = string!
        // Navigationbarbutton
        let saveProjectButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveProject))
        navigationItem.rightBarButtonItem = saveProjectButton
    }
    @objc func saveProject() {
        if project == nil {
            let newProject = Project(context: store!.mainContext)
            newProject.name = newEditTextField.text
            newProject.color = selectedColor
            store?.saveContext()
        } else {
            project?.name = newEditTextField.text
            project?.color = selectedColor
            store?.saveContext()
        }
        self.navigationController?.popViewController(animated: true)
    }
    /// This vew addes uikit views to viewcontroller view, that includes constraints
    private func setupView() {
        view.addSubview(newEditTextField)
        view.addSubview(mainCollectionView)
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        NSLayoutConstraint.activate([
            newEditTextField.heightAnchor.constraint(equalToConstant: 50),
            newEditTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            newEditTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            newEditTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            mainCollectionView.topAnchor.constraint(equalTo: newEditTextField.bottomAnchor, constant: 20),
            mainCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            mainCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            mainCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    lazy var newEditTextField: UITextField = {
        let newEditTextField = UITextField()
        newEditTextField.textAlignment = .left
        newEditTextField.placeholder = "Name your project"
        newEditTextField.translatesAutoresizingMaskIntoConstraints = false
        return newEditTextField
    }()
    lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mainCollectionView.backgroundColor = .clear
        mainCollectionView.register(newEditCustomColorCollectionViewCell.self, forCellWithReuseIdentifier: newEditCustomColorCollectionViewCell.identifier)
        return mainCollectionView
    }()
    
}


extension EditProjectViewController: UICollectionViewDelegate {
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        let cell = collectionView.cellForItem(at: indexPath)
    //        let gray = UIColor.lightGray
    //        cell?.isSelected = true
    //        cell?.layer.borderColor = gray.cgColor
    //        cell?.layer.borderWidth = 10
    //        chosenColor = colors[indexPath.row]
    //    }
    
    //    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    //        let cell = collectionView.cellForItem(at: indexPath)
    //        let clear = UIColor.clear
    //        cell?.isSelected = false
    //        cell?.layer.borderColor = clear.cgColor
    //    }
}

extension EditProjectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionCellBackgroundColour.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newEditCustomColorCollectionViewCell.identifier, for: indexPath) as! newEditCustomColorCollectionViewCell
        cell.backgroundColor =  collectionCellBackgroundColour[indexPath.row]
        cell.layer.cornerRadius = cell.frame.size.width/2
        return cell
    }
    
    
}

extension EditProjectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize (width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}
