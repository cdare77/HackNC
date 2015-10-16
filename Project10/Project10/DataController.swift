//
//  DataController.swift
//  Project10
//
//  Created by Chris Dare on 10/11/15.
//  Copyright © 2015 Chris Dare. All rights reserved.
//

import UIKit
import Foundation

class DataController {
    class func save(people: [Person]) {
            //        let plistPeople = NSArray(array: people)
            let archived = NSKeyedArchiver.archivedDataWithRootObject(people)
            NSUserDefaults.standardUserDefaults().setObject(archived, forKey: keyVar)
            NSUserDefaults.standardUserDefaults().synchronize()
    }
//    class func save(person: Person) {
//        let archived = NSKeyedArchiver.archivedDataWithRootObject(Person)
//        NSUserDefaults.standardUserDefaults().setObject(archived, forKey: keyVar)
//        NSUserDefaults.standardUserDefaults().synchronize()
//    }
    class func load() -> [Person]{
        guard let data = NSUserDefaults.standardUserDefaults().dataForKey(keyVar) else {
            return []
        }
        let array = NSKeyedUnarchiver.unarchiveObjectWithData(data)
        if let loadedData = array as? [Person] {
            return loadedData
        }
        return []
    }
}
