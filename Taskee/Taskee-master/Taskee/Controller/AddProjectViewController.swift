//
//  AddProjectViewController.swift
//  Taskee
//
//  Created by Mohammed Drame on 10/7/20.
//  Copyright © 2020 Mo Drame. All rights reserved.
//

import UIKit


class AddProjectViewController: UIViewController {
    
    var project: Project?
    var store: CoreDataStack?
    let collectionViewCellBackGroundColors: [UIColor] = [.brown, .systemYellow, .blue, .systemPink, .red, .blue, .black]
    var selectedColor: UIColor?
    
    private func setUpNavBar(with titlle: String, and text: Bool) {
        title = titlle;        self.navigationController?.navigationBar.prefersLargeTitles = text
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveProject))
    }
    @objc func saveProject() {
        if project == nil {
            let newProject = Project(context: store!.mainContext)
            newProject.name = projectNameTextField.text
            newProject.color = selectedColor
            store?.saveContext()
        } else {
            project?.name = projectNameTextField.text
            project?.color = selectedColor
            store?.saveContext()
        }
        self.navigationController?.popViewController(animated: true)
    }
    private let projectNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Name your project"
        return textField
    }()
    private let colorCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ColorCollectionViewCell")
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private func setUpSubViews() {
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        view.addSubview(projectNameTextField)
        view.addSubview(colorCollectionView)
        NSLayoutConstraint.activate([
            projectNameTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            projectNameTextField.heightAnchor.constraint(equalToConstant: 50),
            projectNameTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            projectNameTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
          
            colorCollectionView.topAnchor.constraint(equalTo: projectNameTextField.bottomAnchor, constant: 20),
            colorCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            colorCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            colorCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpSubViews()
        setUpNavBar(with: "New Project or Edit", and: true)
    }
}


extension AddProjectViewController:UICollectionViewDelegate,  UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionViewCellBackGroundColors.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath)
        cell.backgroundColor = collectionViewCellBackGroundColors[indexPath.row]
        cell.layer.cornerRadius = cell.frame.size.width/2
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        selectedColor = collectionViewCellBackGroundColors[indexPath.row]
        let gray = UIColor.lightGray
        cell?.isSelected = true
        cell?.layer.borderWidth = 9
        cell?.layer.borderColor = gray.cgColor
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let clear = UIColor.clear
        cell?.isSelected = false
        cell?.layer.borderColor = clear.cgColor
    }
}

extension AddProjectViewController: UICollectionViewDelegateFlowLayout {
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

