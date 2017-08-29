//
//  GRCalendarHeader.swift
//
//  Created by Maciej Matuszewski on 26.08.2017.
//  Copyright © 2017 Maciej Matuszewski. All rights reserved.
//

import Cocoa

class GRCalendarHeader: NSView {
    
    fileprivate let monthLabel = NSTextField.init()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureLayout() {
        self.monthLabel.translatesAutoresizingMaskIntoConstraints = false
        self.monthLabel.stringValue = "kwiecień"
        self.monthLabel.font = NSFont.systemFont(ofSize: 30, weight: 5)
        self.monthLabel.textColor = NSColor.textColor
        self.monthLabel.alignment = .center
        self.monthLabel.isBezeled = false
        self.monthLabel.drawsBackground = false
        self.monthLabel.isEditable = false
        self.monthLabel.isSelectable = false
        self.addSubview(self.monthLabel)
        
        self.monthLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        self.monthLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -6).isActive = true
        self.monthLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        
        let stackView = NSStackView.init(
            views: [
                self.labelForLetter("M"),
                self.labelForLetter("T"),
                self.labelForLetter("W"),
                self.labelForLetter("T"),
                self.labelForLetter("F"),
                self.labelForLetter("S"),
                self.labelForLetter("S"),
                ]
        )
        
        stackView.distribution = .fillEqually
        stackView.orientation = .horizontal
        self.addSubview(stackView)
        
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
    }
    
    func configure(_ month: String, year: String){
        let attributedString = NSMutableAttributedString.init(string: "\(month) ", attributes: [NSFontAttributeName : NSFont.systemFont(ofSize: 30, weight: 5)])
        attributedString.append(NSAttributedString.init(string: year, attributes: [NSFontAttributeName : NSFont.systemFont(ofSize: 30, weight: 0)]))
        self.monthLabel.attributedStringValue = attributedString
    }
    
    fileprivate func labelForLetter(_ letter: String) -> NSTextField {
        let textField = NSTextField.init(labelWithString: letter)
        textField.alignment = .center
        textField.textColor = NSColor.lightGray
        return textField
    }
}
