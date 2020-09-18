//
//  Car+CoreDataProperties.swift
//  Core Data
//
//  Created by Air on 9/17/20.
//  Copyright © 2020 Anton Serdyuk. All rights reserved.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var model: String?
    @NSManaged public var year_of_ssue: Int16
    @NSManaged public var manufacturer: String?
    @NSManaged public var body_type: String?

}
