//
//  Document+CoreDataProperties.swift
//  ortbalsn-challenge-core-data
//
//  Created by Nathan Ortbals on 2/18/19.
//  Copyright © 2019 Nathan Ortbals. All rights reserved.
//
//

import Foundation
import CoreData


extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var rawDateModified: NSDate?
    @NSManaged public var rawSize: NSNumber?
}
