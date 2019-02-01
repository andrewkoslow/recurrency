//
//  RowUpdates.swift
//  Recurrency
//
//  Created by Andrew Koslow on 02/02/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import Foundation

struct RowUpdates {
    
    var deleteRowIndexPaths: [IndexPath]
    var insertRowIndexPaths: [IndexPath]
    var moveRowIndexPaths: [(from: IndexPath, to: IndexPath)]
    
}

extension RowUpdates {
    
    init<T: Equatable>(oldValues: [T], newValues: [T]) {
        var moveIndexes: [(Int, Int)] = []
        var newItems = Array(newValues.enumerated())
        
        for oldItem in oldValues.enumerated() {
            let index = newItems.firstIndex { (item) -> Bool in
                return item.element == oldItem.element
            }
            
            guard let newIndex = index else { continue }
            
            let newItem = newItems[newIndex]
            
            if newItem.offset != oldItem.offset {
                moveIndexes.append((oldItem.offset, newItem.offset))
            }
            
            newItems.remove(at: newIndex)
        }

        
        var oldValues = oldValues
        
        let deleteItems = oldValues.enumerated().filter { (item) -> Bool in
            return newValues.contains(item.element) == false
        }
        
        deleteItems.reversed().forEach { (item) in
            oldValues.remove(at: item.offset)
        }
        
        
        let insertItems = newValues.enumerated().filter { (item) -> Bool in
            return oldValues.contains(item.element) == false
        }
        
        insertItems.forEach { (item) in
            oldValues.insert(item.element, at: item.offset)
        }
        
        
        deleteRowIndexPaths = deleteItems.map { IndexPath(row: $0.offset, section: 0) }
        insertRowIndexPaths = insertItems.map { IndexPath(row: $0.offset, section: 0) }
        moveRowIndexPaths = moveIndexes.map { (from: IndexPath(row: $0.0, section: 0), to: IndexPath(row: $0.1, section: 0)) }
    }
    
}
