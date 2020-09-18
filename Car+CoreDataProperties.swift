//
//  Car+CoreDataProperties.swift
//  Cars_test_task
//
//  Created by Air on 9/18/20.
//  Copyright © 2020 Anton Serdyuk. All rights reserved.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var body_type: String?
    @NSManaged public var manufacturer: String?
    @NSManaged public var model: String?
    @NSManaged public var production_year: Int16

}
