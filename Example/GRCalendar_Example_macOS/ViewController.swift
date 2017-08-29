//
//  ViewController.swift
//  GRCalendar_Example_macOS
//
//  Created by Maciej Matuszewski on 29.08.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Cocoa
import GRCalendar

class ViewController: NSViewController {
    
    override func loadView() {
        let calendarView = GRCalendarView.init(startDate: Date(), endDate: Date.init(timeIntervalSinceNow: 315360000))
        calendarView.delegate = self
        self.view = calendarView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: GRCalendarViewDelegate {
    func calendarView(_ calendarView: GRCalendarView, didSelectItemWith date: Date?) {
        
        guard
            let date = date
        else{
            return
        }
        
        Swift.print("\(date) has been selected!")
    }
}
