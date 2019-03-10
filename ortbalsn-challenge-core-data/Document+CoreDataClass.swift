//
//  Document+CoreDataClass.swift
//  ortbalsn-challenge-core-data
//
//  Created by Nathan Ortbals on 2/18/19.
//  Copyright © 2019 Nathan Ortbals. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Document)
public class Document: NSManagedObject {
    var dateModified: Date? {
        get {
            return rawDateModified as Date?
        }
        set {
            rawDateModified = newValue as NSDate?
        }
    }
    
    var size: Int? {
        get {
            return rawSize?.intValue
        }
        set {
            if let newValue = newValue {
                rawSize = NSNumber(value: newValue)
            }
            else {
                rawSize = nil
            }
        }
    }
    
    convenience init?(title: String?, content: String?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        self.init(entity: Document.entity(), insertInto: managedContext)
        
        self.title = title
        self.content = content
        
        if let content = content {
            self.size = content.utf8.count
        }
        
        let now = Date()
        self.dateModified = now
    }
}
