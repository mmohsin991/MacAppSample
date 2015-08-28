//
//  ScaryBugData.swift
//  MacAppSample
//
//  Created by Mohsin on 28/08/2015.
//  Copyright (c) 2015 Mohsin. All rights reserved.
//

import Foundation

class ScaryBugData: NSObject {
    var title: String
    var rating: Double
    
    override init() {
        self.title = String()
        self.rating = 0.0
    }
    
    init(title: String, rating: Double) {
        self.title = title
        self.rating = rating
    }
}