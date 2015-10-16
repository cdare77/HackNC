//
//  Person.swift
//  Project10
//
//  Created by Chris Dare on 10/10/15.
//  Copyright © 2015 Chris Dare. All rights reserved.
//

import UIKit

private struct PersonKeys {
    static let Name = "Name"
    static let ImagePath = "ImagePath"
    static let Image = "Image"
    static let Descripion = "Description"
}

class Person: NSObject, NSCoding {

    var name: String?
    var imagePath: String?
    var image: UIImage?
    var notedescription: String?
    
    init(name: String, imagePath: String, image: UIImage, notedescription: String) {
        self.name = name
        self.imagePath = imagePath
        self.image = image
        self.notedescription = notedescription
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey(PersonKeys.Name) as? String
        self.imagePath = aDecoder.decodeObjectForKey(PersonKeys.ImagePath) as? String
        self.image = aDecoder.decodeObjectForKey(PersonKeys.Image) as? UIImage
        self.notedescription = aDecoder.decodeObjectForKey(PersonKeys.Descripion) as? String
        super.init()
    }
    func encodeWithCoder(aCoder: NSCoder) {
        if let image = self.image {
            aCoder.encodeObject(UIImagePNGRepresentation(image), forKey: PersonKeys.Image)
        }

        if let name = self.name {
            aCoder.encodeObject(name, forKey: PersonKeys.Name)
        }
        
        if let path = self.imagePath {
            aCoder.encodeObject(path, forKey: PersonKeys.ImagePath)
        }
        
        if let thisdescription = self.notedescription {
            aCoder.encodeObject(thisdescription, forKey: PersonKeys.Descripion)
        }
    }
}
