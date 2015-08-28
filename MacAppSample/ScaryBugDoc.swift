//
//  ScaryBugDoc.swift
//  MacAppSample
//
//  Created by Mohsin on 28/08/2015.
//  Copyright (c) 2015 Mohsin. All rights reserved.
//

import Foundation
import AppKit

class ScaryBugDoc: NSObject {
    var data: ScaryBugData
    var thumbImage: NSImage?
    var fullImage: NSImage?
    
    override init() {
        self.data = ScaryBugData()
    }
    
    init(title: String, rating: Double, thumbImage: NSImage?, fullImage: NSImage?) {
        self.data = ScaryBugData(title: title, rating: rating)
        self.thumbImage = thumbImage
        self.fullImage = fullImage
    }
}