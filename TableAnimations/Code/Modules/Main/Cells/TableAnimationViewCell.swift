//
//  TableAnimationViewCell.swift
//  TableAnimations
//
//  Created by Marko Nedeljkovic on 4/9/21.
//  Copyright © 2021 Marko Nedeljkovic. All rights reserved.
//

import UIKit

class TableAnimationViewCell: UITableViewCell {
    
    // MARK:- outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cellLabel: UILabel!
    
    // MARK:- variables
    override class func description() -> String {
        return "TableAnimationViewCell"
    }
    
    var tableViewHeight: CGFloat = 80
    
    var color = UIColor.white {
        didSet {
            self.containerView.backgroundColor = color
        }
    }
    
    // MARK:- lifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        DispatchQueue.main.async {
            self.containerView.layer.cornerRadius = 4
        }
    }
    
    // MARK:- functions
    func setupCell(row: Int) {
        self.cellLabel.text = "Cell \(row)"
    }
}
