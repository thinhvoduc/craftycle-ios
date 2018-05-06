//
//  BasicDataSource.swift
//  Craftycle
//
//  Created by Thinh Vo on 05/05/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit

/**
 This abstract class represent the loaded data for the UITableView.
 */
class BasicDataSource<E: RawRepresentable>: NSObject where E.RawValue == Int {
    
    private var sections: [BasicDataSourceSection] = []
    
    var numberOfSections: Int {
        return sections.count
    }
    
    /// Add a section
    func addSection(_ section: BasicDataSourceSection, at index: E) {
        let raw = index.rawValue
        
        if raw >= sections.count {
            sections.append(section)
        } else {
            sections.insert(section, at: index.rawValue)
        }
    }
    
    /// Section at index
    func sectionAtIndex(_ index: Int) -> BasicDataSourceSection? {
        guard index < numberOfSections else { return nil }
        
        return sections[index]
    }
    
}

class BasicDataSourceSection: NSObject {
    private var rows: [BasicDataSourceRow] = []
    
    init(_ data: [BasicDataSourceRow]) {
        super.init()
        
        rows = data
    }
    
    var numberOfRows: Int {
        return rows.count
    }
    
    func rowAt(_ index: Int) -> BasicDataSourceRow {
        return rows[index]
    }
    
    func data() -> Any {
        return rows
    }
}

class BasicDataSourceRow: NSObject {
    var data: Any?
    
    init(_ rowData: Any?) {
        data = rowData
        super.init()
    }
    
    
}
