//
//  GRCalendarItem.swift
//
//  Created by Maciej Matuszewski on 26.08.2017.
//  Copyright © 2017 Maciej Matuszewski. All rights reserved.
//

import Cocoa

class GRCalendarItem: NSCollectionViewItem {

    fileprivate let dateLabel = NSTextField.init()
    
    override func loadView() {
        self.view = NSView.init()
        
        self.configureLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func configureLayout() {
        
        self.view.wantsLayer = true
        self.view.layer?.cornerRadius = 20
        self.view.layer?.masksToBounds = true
        
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dateLabel.stringValue = "30"
        self.dateLabel.font = NSFont.systemFont(ofSize: 18)
        self.dateLabel.textColor = NSColor.textColor
        self.dateLabel.alignment = .center
        self.dateLabel.isBezeled = false
        self.dateLabel.drawsBackground = false
        self.dateLabel.isEditable = false
        self.dateLabel.isSelectable = false
        self.view.addSubview(self.dateLabel)
        
        self.dateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.dateLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.dateLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
    func configure(_ state: GRCalendarItemState, dayOfMonth: Int?) {
        
        if let day = dayOfMonth{
            self.dateLabel.stringValue = day.description
        } else {
            self.dateLabel.stringValue = ""
        }
        
        configure(state)
    }
    
    func configure(_ state: GRCalendarItemState) {
        switch state {
        case .outsideMonth:
            self.dateLabel.textColor = NSColor.lightGray
            self.view.layer?.backgroundColor = NSColor.clear.cgColor
            return
        case .today:
            self.dateLabel.textColor = NSColor.white
            self.view.layer?.backgroundColor = NSColor.red.cgColor
        case .selected:
            self.dateLabel.textColor = NSColor.white
            self.view.layer?.backgroundColor = NSColor.black.cgColor
        case .weekend:
            self.dateLabel.textColor = NSColor.red
            self.view.layer?.backgroundColor = NSColor.clear.cgColor
        case .weekday:
            self.dateLabel.textColor = NSColor.textColor
            self.view.layer?.backgroundColor = NSColor.clear.cgColor
            return
        }
    }
    
}
