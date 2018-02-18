//
//  Question+CoreDataProperties.swift
//  study
//
//  Created by Shipu Wang on 2/17/18.
//  Copyright © 2018 Shipu Wang. All rights reserved.
//
//

import Foundation
import CoreData


extension Question {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question")
    }

    @NSManaged public var answer: Int16
    @NSManaged public var category: String?
    @NSManaged public var id: String?
    @NSManaged public var myAnswer: Int16
    @NSManaged public var option: NSObject?
    @NSManaged public var question: String?

}
