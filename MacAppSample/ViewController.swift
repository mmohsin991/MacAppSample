//
//  ViewController.swift
//  MacAppSample
//
//  Created by Mohsin on 28/08/2015.
//  Copyright (c) 2015 Mohsin. All rights reserved.
//

import Cocoa
import Quartz


class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, EDStarRatingProtocol{

    
    var bugs = [ScaryBugDoc]()

    @IBOutlet weak var bugsTableView: NSTableView!
    @IBOutlet weak var txtBugTitle: NSTextField!
    @IBOutlet weak var bugImageView: NSImageView!
    @IBOutlet weak var bugRating: EDStarRating!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.setupSampleBugs()
        

        self.bugRatingInit()
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    func setupSampleBugs() {
        let bug1 = ScaryBugDoc(title: "Potato Bug", rating: 4.0,
            thumbImage:NSImage(named: "potatoBugThumb"), fullImage: NSImage(named: "potatoBug"))
        let bug2 = ScaryBugDoc(title: "House Centipede", rating: 3.0,
            thumbImage:NSImage(named: "centipedeThumb"), fullImage: NSImage(named: "centipede"))
        let bug3 = ScaryBugDoc(title: "Wolf Spider", rating: 5.0,
            thumbImage:NSImage(named: "wolfSpiderThumb"), fullImage: NSImage(named: "wolfSpider"))
        let bug4 = ScaryBugDoc(title: "Lady Bug", rating: 1.0,
            thumbImage:NSImage(named: "ladybugThumb"), fullImage: NSImage(named: "ladybug"))
        
        bugs = [bug1, bug2, bug3, bug4]
    }
    
    
    func updateDetailInfo(doc: ScaryBugDoc?) {
        var title = ""
        var image: NSImage?
        var rating = 0.0
        
        if let scaryBugDoc = doc {
            title = scaryBugDoc.data.title
            image = scaryBugDoc.fullImage
            rating = scaryBugDoc.data.rating
        }
        
        self.txtBugTitle.stringValue = title
        self.bugImageView.image = image
        self.bugRating.rating = Float(rating)
    }
    
    
    func selectedBugDoc() -> ScaryBugDoc? {
        let selectedRow = self.bugsTableView.selectedRow;
        if selectedRow >= 0 && selectedRow < self.bugs.count {
            return self.bugs[selectedRow]
        }
        return nil
    }
    
    
    func bugRatingInit(){
        self.bugRating.starImage = NSImage(named: "star")
        self.bugRating.starHighlightedImage = NSImage(named: "shockedface2_full")
        self.bugRating.starImage = NSImage(named: "shockedface2_empty")
        
        self.bugRating.delegate = self
        
        self.bugRating.maxRating = 5
        self.bugRating.horizontalMargin = 12
        self.bugRating.editable = true
        self.bugRating.displayMode = UInt(EDStarRatingDisplayFull)
        
        self.bugRating.rating = Float(0.0)

    }
    
    
    
    // MARK: NSTableView delegates
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        return self.bugs.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // 1
        var cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        
        // 2
        if tableColumn!.identifier == "BugColumn" {
            // 3
            let bugDoc = self.bugs[row]
            cellView.imageView!.image = bugDoc.thumbImage
            cellView.textField!.stringValue = bugDoc.data.title
            return cellView
        }
        
        return cellView
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let selectedDoc = selectedBugDoc()
        updateDetailInfo(selectedDoc)
    }

    
    func reloadSelectedBugRow() {
        let indexSet = NSIndexSet(index: self.bugsTableView.selectedRow)
        let columnSet = NSIndexSet(index: 0)
        self.bugsTableView.reloadDataForRowIndexes(indexSet, columnIndexes: columnSet)
        
    }
    
    
    func pictureTakerDidEnd(picker: IKPictureTaker, returnCode: NSInteger, contextInfo: UnsafePointer<Void>) {
        let image = picker.outputImage()
        
        if image != nil && returnCode == NSModalResponseOK {
            self.bugImageView.image = image
            if let selectedDoc = selectedBugDoc() {
                selectedDoc.fullImage = image
                selectedDoc.thumbImage = image.imageByScalingAndCroppingForSize(CGSize(width: 44, height: 44))
                reloadSelectedBugRow()
            }
        }
    }
    
    
    @IBAction func addBug(sender: NSButton) {
        // 1. Create a new ScaryBugDoc object with a default name
        let newDoc = ScaryBugDoc(title: "New Bug", rating: 0.0, thumbImage: nil, fullImage: nil)
        
        // 2. Add the new bug object to our model (insert into the array)
        self.bugs.append(newDoc)
        let newRowIndex = self.bugs.count - 1
        
        // 3. Insert new row in the table view
        self.bugsTableView.insertRowsAtIndexes(NSIndexSet(index: newRowIndex), withAnimation: NSTableViewAnimationOptions.EffectGap)
        
        // 4. Select the new bug and scroll to make sure it's visible
        self.bugsTableView.selectRowIndexes(NSIndexSet(index: newRowIndex), byExtendingSelection:false)
        self.bugsTableView.scrollRowToVisible(newRowIndex)
    }
    
    @IBAction func deleteBug(sender: NSButton) {
        // 1. Get selected doc
        if let selectedDoc = selectedBugDoc() {
            // 2. Remove the bug from the model
            self.bugs.removeAtIndex(self.bugsTableView.selectedRow)
            
            // 3. Remove the selected row from the table view
            self.bugsTableView.removeRowsAtIndexes(NSIndexSet(index:self.bugsTableView.selectedRow),
                withAnimation: NSTableViewAnimationOptions.SlideRight)
            
            // 4. Clear detail info
            updateDetailInfo(nil)
        }
    }
    
    @IBAction func bugTitleDidEndEdit(sender: NSTextField) {
        if let selectedDoc = selectedBugDoc() {
            selectedDoc.data.title = self.txtBugTitle.stringValue
            reloadSelectedBugRow()
        }
    }
    
    @IBAction func changePicture(sender: NSButton) {
        if let selectedDoc = selectedBugDoc() {
            IKPictureTaker().beginPictureTakerSheetForWindow(self.view.window,
                withDelegate: self,
                didEndSelector: "pictureTakerDidEnd:returnCode:contextInfo:",
                contextInfo: nil)
        }
    }
}

