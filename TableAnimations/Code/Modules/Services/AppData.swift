//
//  AppData.swift
//  TableAnimations
//
//  Created by Marko Nedeljkovic on 4/9/21.
//  Copyright © 2021 Marko Nedeljkovic. All rights reserved.
//

import UIKit

struct AppData {
    var originalCellData: [CellModel] = [
        CellModel(color: UIColor.systemRed, id: 0),
        CellModel(color: UIColor.systemOrange, id: 1),
        CellModel(color: UIColor.systemBlue, id: 2),
        CellModel(color: UIColor.systemPurple, id: 3),
        CellModel(color: UIColor.systemGreen, id: 4),
        CellModel(color: UIColor.systemTeal, id: 5),
        CellModel(color: UIColor.systemYellow, id: 6),
        CellModel(color: UIColor.systemIndigo, id: 7),
        CellModel(color: UIColor.systemGray, id: 8),
    ]
    
    var cellData: [CellModel] = []
    
    init() {
        self.cellData = originalCellData
    }
    
    // MARK:- functions
    mutating func refetchData() -> [CellModel] {
        self.originalCellData.shuffle()
        return self.originalCellData
    }
    
    mutating func removeData(cell: CellModel) -> [CellModel] {
        self.cellData =  self.cellData.filter{$0.id != cell.id }
        return self.cellData
    }
    
    func fetchData() -> [CellModel] {
        return self.cellData
    }
}
