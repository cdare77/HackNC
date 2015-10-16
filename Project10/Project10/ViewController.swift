//
//  ViewController.swift
//  Project10
//
//  Created by Chris Dare on 10/10/15.
//  Copyright © 2015 Chris Dare. All rights reserved.
//

import UIKit


let keyVar: String = "myKey"

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var people: [Person] = [Person]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var inediting = false {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        people = DataController.load()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewPerson")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editButtonPressed")
        
        for item in self.collectionView!.visibleCells() as! [PersonCell] {
            let indexPath: NSIndexPath = self.collectionView!.indexPathForCell(item as PersonCell)!
            let cell: PersonCell = self.collectionView!.cellForItemAtIndexPath(indexPath) as! PersonCell
            
            let close: UIButton = cell.viewWithTag(100) as! UIButton
            close.hidden = true
            self.collectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Person", forIndexPath: indexPath) as! PersonCell
        
        let person = people[indexPath.item]
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().stringByAppendingPathComponent(person.imagePath!)
        cell.imageView.image = UIImage(contentsOfFile: path)
        people[indexPath.item].image = (UIImage(contentsOfFile: path))!
        
        cell.closeButton.hidden = !inediting
        
        cell.closeButton?.layer.setValue(indexPath.row, forKey: "index")
        cell.closeButton?.addTarget(self, action: "deletePhoto:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).CGColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if inediting {
            //let person = people[indexPath.item]
        
            let ac = UIAlertController(title: "Rename title", message: nil, preferredStyle: .Alert)
            ac.addTextFieldWithConfigurationHandler(){ textField in
                textField.placeholder = "Title"
            }
        
            ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
            ac.addAction(UIAlertAction(title: "Ok", style: .Default) { [unowned self, ac] _ in
                let newName = ac.textFields![0]
                self.people[indexPath.item].name = newName.text!
            
                self.collectionView.reloadData()
            })
            presentViewController(ac, animated: true, completion: nil)
        }
            
    }
    
    func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        let imageName = NSUUID().UUIDString
        let imagePath = getDocumentsDirectory().stringByAppendingPathComponent(imageName)
        
        if let jpegData = UIImageJPEGRepresentation(newImage, 80) {
            jpegData.writeToFile(imagePath, atomically: true)
        }
        let person = Person(name: "Unknown", imagePath: imageName, image: newImage, notedescription: "")
        people.append(person)
        collectionView.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func doneButtonPressed() {
        inediting = false
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editButtonPressed")
        self.navigationItem.rightBarButtonItems = [editButton]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewPerson")
        
        for item in self.collectionView!.visibleCells() as! [PersonCell] {
            let indexPath: NSIndexPath = self.collectionView!.indexPathForCell(item as PersonCell)!
            let cell: PersonCell = self.collectionView!.cellForItemAtIndexPath(indexPath) as! PersonCell
            
            let close: UIButton = cell.viewWithTag(100) as! UIButton
            close.hidden = inediting
        }
    }
    
    func editButtonPressed() {
        inediting = true
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneButtonPressed")
        self.navigationItem.rightBarButtonItems = [doneButton]
        
        self.navigationItem.leftBarButtonItems = []
        
        for item in self.collectionView!.visibleCells() as! [PersonCell] {
            let indexPath: NSIndexPath = self.collectionView!.indexPathForCell(item as PersonCell)!
            let cell: PersonCell = self.collectionView!.cellForItemAtIndexPath(indexPath) as! PersonCell
            
            let close: UIButton = cell.viewWithTag(100) as! UIButton
            close.hidden = inediting
        }
    }
    
    func deletePhoto(sender: UIButton) {
        let i : Int = (sender.layer.valueForKey("index")) as! Int
        people.removeAtIndex(i)
        self.collectionView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pushSegue" {
            if let indexPath = self.collectionView.indexPathForCell(sender as! UICollectionViewCell) {
                let controller = segue.destinationViewController as! DetailViewController
                controller.detailItem = people
                controller.indexItem = indexPath.row
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return !inediting
    }
    

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if inediting {
            return
        }
        DataController.save(people)
    }
    
    override func viewWillAppear(animated: Bool) {
        DataController.save(people)
        super.viewWillAppear(animated)
    }
}
