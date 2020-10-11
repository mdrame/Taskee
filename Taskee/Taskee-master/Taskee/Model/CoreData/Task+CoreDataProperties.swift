//
//  EditProjectViewController.swift
//  Taskee
//
//  Created by Mohammed Drame on 10/7/20.
//  Copyright © 2020 Mo Drame. All rights reserved.
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }
    @NSManaged public var status: Bool
    @NSManaged public var due: Date?
    @NSManaged public var title: String?
    @NSManaged public var projectrelation: NSObject?
    @NSManaged public var project: Project?
}

extension Task : Identifiable {

}
