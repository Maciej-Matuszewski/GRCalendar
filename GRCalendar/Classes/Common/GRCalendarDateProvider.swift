//
//  GRCalendarDateProvider.swift
//
//  Created by Maciej Matuszewski on 26.08.2017.
//  Copyright © 2017 Maciej Matuszewski. All rights reserved.
//

import Foundation

class GRCalendarDateProvider: NSObject {
    
    fileprivate let calendar = Calendar.current
    fileprivate let dateFormatter = DateFormatter.init()
    fileprivate let startDate: Date
    fileprivate let endDate: Date
    
    init(startDate: Date, endDate: Date) {
        
        self.startDate = self.calendar.startOfDay(for: startDate)
        self.endDate = self.calendar.startOfDay(for: endDate)
        
        super.init()
    }
    
    func numberOfSections() -> Int {
        
        let monthsBetween: Int = (self.calendar.dateComponents([Calendar.Component.month], from: self.startDate, to: self.endDate).month ?? 0 ) + 1
        return monthsBetween
    }
    
    func dateFor(_ indexPath: IndexPath) -> Date? {
        
        var components = self.calendar.dateComponents([Calendar.Component.year, Calendar.Component.month], from: self.startDate)
        components.month = indexPath.section + (components.month ?? 0)
        
        var startOfMonth: Date = Date()
        var lengthOfMonth: TimeInterval = 0
        _ = self.calendar.dateInterval(of: Calendar.Component.month, start: &startOfMonth, interval: &lengthOfMonth, for: self.calendar.date(from: components)!)
        
        var firstWeekdayOfMonth = self.calendar.component(.weekday, from: startOfMonth) - 1
        if firstWeekdayOfMonth == 0 {
            firstWeekdayOfMonth = 7
        }
        
        components.day = indexPath.item - firstWeekdayOfMonth + 2
        let date = self.calendar.date(from: components)
        
        return date
        
    }
    
    func dayOfMonthFor(_ date: Date?) -> Int? {
        guard
            let date = date
        else {
            return nil
        }
        
        return self.calendar.component(.day, from: date)
    }
    
    func stateForItem(with date: Date?, indexPath: IndexPath) -> GRCalendarItemState {
        
        guard
            let date = date
        else {
            return .outsideMonth
        }
        
        var components = self.calendar.dateComponents([Calendar.Component.year, Calendar.Component.month], from: self.startDate)
        components.month = indexPath.section + (components.month ?? 0)
        
        var startOfMonth: Date = Date()
        var lengthOfMonth: TimeInterval = 0
        _ = self.calendar.dateInterval(of: Calendar.Component.month, start: &startOfMonth, interval: &lengthOfMonth, for: self.calendar.date(from: components)!)
        
        let endOfMonth = Date.init(timeInterval: lengthOfMonth - 1, since: startOfMonth)
        
        if date.compare(endOfMonth) == ComparisonResult.orderedDescending || date.compare(startOfMonth) == ComparisonResult.orderedAscending {
            return .outsideMonth
        }
        
        if self.calendar.isDateInToday(date) {
            return .today
        }
        
        if self.calendar.isDateInWeekend(date) {
            return .weekend
        }
        
        return .weekday
    }
    
    func valueForHeaderAt(_ indexPath: IndexPath) -> GRCalendarHeaderStruct {
        
        var components = self.calendar.dateComponents([Calendar.Component.year, Calendar.Component.month], from: self.startDate)
        components.month = indexPath.section + (components.month ?? 0)
        
        guard
            let date = self.calendar.date(from: components)
        else{
            return GRCalendarHeaderStruct.init(month: "", year: "")
        }
        
        var month: String?
        
        switch self.calendar.component(.month, from: date) {
        case 1:
            month = NSLocalizedString("january", comment: "january")
            break
        case 2:
            month = NSLocalizedString("february", comment: "february")
            break
        case 3:
            month = NSLocalizedString("march", comment: "march")
            break
        case 4:
            month = NSLocalizedString("april", comment: "april")
            break
        case 5:
            month = NSLocalizedString("may", comment: "may")
            break
        case 6:
            month = NSLocalizedString("june", comment: "june")
            break
        case 7:
            month = NSLocalizedString("july", comment: "july")
            break
        case 8:
            month = NSLocalizedString("august", comment: "august")
            break
        case 9:
            month = NSLocalizedString("september", comment: "september")
            break
        case 10:
            month = NSLocalizedString("october", comment: "october")
            break
        case 11:
            month = NSLocalizedString("november", comment: "november")
            break
        case 12:
            month = NSLocalizedString("december", comment: "december")
            break
        default:
            break
        }
        
        let year = self.calendar.component(.year, from: date).description
        return GRCalendarHeaderStruct.init(month: month ?? "", year: year)
    }
    
    func indexPathFor(_ date: Date) -> IndexPath {
        let section: Int = self.calendar.dateComponents([.month], from: self.startDate, to: self.calendar.startOfDay(for: date)).month!
        
        var startOfMonth: Date = Date()
        var lengthOfMonth: TimeInterval = 0
        _ = self.calendar.dateInterval(of: Calendar.Component.month, start: &startOfMonth, interval: &lengthOfMonth, for: date)
        var firstWeekdayOfMonth = self.calendar.component(.weekday, from: startOfMonth) - 1
        if firstWeekdayOfMonth == 0 {
            firstWeekdayOfMonth = 7
        }
        
        let item = firstWeekdayOfMonth + self.calendar.component(.day, from: date) - 2
        return IndexPath.init(item: item, section: section)
    }
    
}

enum GRCalendarItemState {
    case today
    case selected
    case weekday
    case weekend
    case outsideMonth
}

struct GRCalendarHeaderStruct{
    let month: String
    let year: String
}
