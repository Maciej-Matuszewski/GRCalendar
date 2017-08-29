//
//  GRCalendarView.swift
//
//  Created by Maciej Matuszewski on 26.08.2017.
//  Copyright © 2017 Maciej Matuszewski. All rights reserved.
//

import Cocoa

open class GRCalendarView: NSView {

    fileprivate let scrollView = NSScrollView.init()
    fileprivate let collectionView = NSCollectionView.init()
    fileprivate let dateProvider: GRCalendarDateProvider
    open var delegate: GRCalendarViewDelegate?
    
    fileprivate let overHeader = GRCalendarHeader.init(frame: NSRect.init(origin: CGPoint.zero, size: CGSize.init(width: 400, height: 80)))
    
    public init(startDate: Date, endDate: Date) {
        
        self.dateProvider = GRCalendarDateProvider.init(startDate: startDate, endDate: endDate)
        super.init(frame: NSRect.zero)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.white.cgColor
        
        self.configureLayout()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureLayout() {
        
        self.widthAnchor.constraint(equalToConstant: 400).isActive = true
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: 400).isActive = true
        
        let collectionViewLayout = NSCollectionViewFlowLayout.init()
        collectionViewLayout.itemSize = NSSize.init(width: 40, height: 40)
        collectionViewLayout.sectionInset = EdgeInsets.init(top: 6, left: 16, bottom: 6, right: 16)

        self.collectionView.collectionViewLayout = collectionViewLayout
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.isSelectable = true
        self.collectionView.register(GRCalendarItem.self, forItemWithIdentifier: "item")
        self.collectionView.register(GRCalendarHeader.self, forSupplementaryViewOfKind: NSCollectionElementKindSectionHeader, withIdentifier: "header")
        self.collectionView.backgroundColors = [NSColor.clear]
        
        self.scrollView.drawsBackground = false
        self.scrollView.documentView = self.collectionView
        self.scrollView.automaticallyAdjustsContentInsets = false
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.scrollerInsets.right -= 20
        
        let contentView = self.scrollView.contentView
        contentView.postsBoundsChangedNotifications = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.collectionViewDidScroll), name: NSNotification.Name.NSViewBoundsDidChange, object: contentView)
        
        self.addSubview(self.scrollView)
        self.scrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.scrollView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        
        self.overHeader.configure("", year: "")
        self.overHeader.wantsLayer = true
        self.overHeader.layer?.backgroundColor = NSColor.white.cgColor
        self.overHeader.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.overHeader)
        self.overHeader.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.overHeader.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.overHeader.widthAnchor.constraint(equalToConstant: 400).isActive = true
        self.overHeader.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    public func select(date: Date) {
        let indexPath = self.dateProvider.indexPathFor(date)
        self.collectionView(collectionView, didSelectItemsAt: [indexPath])
        self.collectionView.selectionIndexPaths.insert(indexPath)
        self.collectionView.animator().scrollToItems(at: [indexPath], scrollPosition: NSCollectionViewScrollPosition.centeredVertically)
        self.collectionViewDidScroll()
    }
    
    public func showToday() {
        self.select(date: Date())
    }
    
    override open func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        self.perform(#selector(self.showToday), with: nil, afterDelay: 0)
        self.perform(#selector(self.collectionViewDidScroll), with: nil, afterDelay: 0.1)
    }
    
    @objc private func collectionViewDidScroll() {
        let y = self.scrollView.contentView.documentVisibleRect.minY
        let sectionHeight: CGFloat = 382
        let section = y / sectionHeight
        let sizeInSection = y.truncatingRemainder(dividingBy: sectionHeight) / sectionHeight
        let indexPath = IndexPath.init(item: 0, section: Int(section))
        let headerValues = self.dateProvider.valueForHeaderAt(indexPath)
        self.overHeader.configure(headerValues.month, year: headerValues.year)
        self.overHeader.alphaValue = sizeInSection < 0.6 ? 1 : 4 - sizeInSection * 5
    }
    
}

extension GRCalendarView: NSCollectionViewDataSource {
    
    public func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return self.dateProvider.numberOfSections()
    }
    
    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(withIdentifier: "item", for: indexPath) as! GRCalendarItem
        let date = self.dateProvider.dateFor(indexPath)
        
        let isSelected = collectionView.selectionIndexPaths.contains(indexPath)
        
        cell.configure(
            isSelected ? .selected : self.dateProvider.stateForItem(with: date, indexPath: indexPath),
            dayOfMonth: self.dateProvider.dayOfMonthFor(date)
        )
        
        return cell
    }
    
    public func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> NSView {
        let header = collectionView.makeSupplementaryView(ofKind: NSCollectionElementKindSectionHeader, withIdentifier: "header", for: indexPath) as! GRCalendarHeader
        let headerValues = self.dateProvider.valueForHeaderAt(indexPath)
        header.configure(headerValues.month, year: headerValues.year)
        return header
    }
}

extension GRCalendarView: NSCollectionViewDelegate{
    public func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
        let indexPath = indexPaths.first ?? IndexPath.init()
        
        guard
            let date = self.dateProvider.dateFor(indexPath)
        else{
            return
        }
        
        let currentState = self.dateProvider.stateForItem(with: date, indexPath: indexPath)
        
        if currentState == .outsideMonth {
            self.select(date: date)
            collectionView.selectionIndexPaths.remove(indexPath)
            return
        }
        
        let item = collectionView.item(at: indexPath) as? GRCalendarItem
        item?.configure(.selected)
        self.delegate?.calendarView(self, didSelectItemWith: date)
    }
    
    public func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        collectionView.reloadItems(at: indexPaths)
    }
}

extension GRCalendarView : NSCollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: 400, height: 80)
    }
}


public protocol GRCalendarViewDelegate {
    func calendarView(_ calendarView: GRCalendarView, didSelectItemWith date: Date?)
}


