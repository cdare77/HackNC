//
//  DetailViewController.swift
//  Project10
//
//  Created by Chris Dare on 10/11/15.
//  Copyright © 2015 Chris Dare. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var textField: UITextField?
    
    var detailItem: [Person]? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    var indexItem: Int? {
        didSet {
            self.configureView()
        }
    }
    func configureView() {
        if self.isViewLoaded() == false {
            return
        }
        
        if let currentDetailPerson = self.detailItem?[indexItem!] {
                let currentImage = currentDetailPerson.image
                imageView?.image = currentImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let changedText = NSString(string: textField.text!).stringByReplacingCharactersInRange(range, withString: string)
        detailItem?[indexItem!].notedescription = changedText
        //DataController.save(detailItem!)
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        detailItem?[indexItem!].notedescription = textField.text
        DataController.save(detailItem!)
    }
    
    func textViewDidChange() {
        
    }
}
