//
//  LunchTableRowView.swift
//  Studentenfutter
//
//  Created by Hans Knoechel on 01.03.17.
//  Copyright © 2017 Hans Knoechel. All rights reserved.
//

import Cocoa

class LunchTableCellView: NSTableCellView {

    @IBOutlet weak var titleLabel: NSTextField!
    
    @IBOutlet weak var additivesLabel: NSTextField!
    
    @IBOutlet weak var priceLabel: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
