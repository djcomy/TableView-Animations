//
//  MainViewController.swift
//  TableAnimations
//
//  Created by Marko Nedeljkovic on 4/9/21.
//  Copyright © 2021 Marko Nedeljkovic. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK:- outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    // MARK:- variables
    var appData: AppData = AppData()
    var tableViewHeaderText = ""
    
    var tableData: [CellModel] = []
    
    /// an enum of type TableAnimation - determines the animation to be applied to the tableViewCells
    var currentTableAnimation: TableAnimation = .fadeIn(duration: 0.35, delay: 0.03) {
        didSet {
            self.tableViewHeaderText = currentTableAnimation.getTitle()
        }
    }
    
    /// to hold rows that was already animated
    var animatedIndexPaths: [IndexPath] = []
    
    var animationDuration: TimeInterval = 0.85
    var delay: TimeInterval = 0.05
    var fontSize: CGFloat = 26
    
    // MARK:- lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableData = appData.fetchData()
        
        // registering the tableView
        self.tableView.register(UINib(nibName: TableAnimationViewCell.description(), bundle: nil), forCellReuseIdentifier: TableAnimationViewCell.description())
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isHidden = true
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // set the separatorStyle to none and set the Title for the tableView
        self.tableView.separatorStyle = .none
        self.tableViewHeaderText = self.currentTableAnimation.getTitle()
        
        // set the button1 as selected and reload the data of the tableView to see the animation
        button1.setImage(UIImage(systemName: "1.square.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    
    // MARK:- outlets & objc functions
    @IBAction func animationButtonPressed(_ sender: Any) {
        guard let senderButton = sender as? UIButton else { return }
        animatedIndexPaths.removeAll()
        self.tableData = self.appData.refetchData()
        
        /// set the buttons symbol to the default unselected circle
        button1.setImage(UIImage(systemName: "1.square", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
        button2.setImage(UIImage(systemName: "2.square", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
        button3.setImage(UIImage(systemName: "3.square", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
        button4.setImage(UIImage(systemName: "4.square", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
        
        /// based on the tag of the button, set the symbol of the associated button to show it's selected and set the currentTableAnimation.
        switch senderButton.tag {
        case 1: senderButton.setImage(UIImage(systemName: "1.square.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
            currentTableAnimation = TableAnimation.fadeIn(duration: animationDuration, delay: delay)
        case 2: senderButton.setImage(UIImage(systemName: "2.square.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
            currentTableAnimation = TableAnimation.moveUp(rowHeight: TableAnimationViewCell().tableViewHeight, duration: animationDuration, delay: delay)
        case 3: senderButton.setImage(UIImage(systemName: "3.square.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
            currentTableAnimation = TableAnimation.moveUpWithFade(rowHeight: TableAnimationViewCell().tableViewHeight, duration: animationDuration, delay: delay)
        case 4: senderButton.setImage(UIImage(systemName: "4.square.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
            currentTableAnimation = TableAnimation.moveUpBounce(rowHeight: TableAnimationViewCell().tableViewHeight, duration: animationDuration + 0.2, delay: delay)
        default: break
        }
        
        /// reloading the tableView to see the animation
        self.tableView.reloadData()
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableAnimationViewCell().tableViewHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableAnimationViewCell.description(), for: indexPath) as? TableAnimationViewCell {
            cell.color = tableData[indexPath.row].color
            cell.setupCell(row: indexPath.row + 1)
            return cell
        }
        fatalError()
    }
    
    // for displaying the headerTitle for the tableView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 42))
        headerView.backgroundColor = UIColor.systemBackground
        
        let label = UILabel()
        label.frame = CGRect(x: 24, y: 12, width: self.view.frame.width, height: 42)
        label.text = tableViewHeaderText
        label.textColor = UIColor.label
        label.font = UIFont.systemFont(ofSize: 26, weight: .medium)
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fetch the animation from the TableAnimation enum and initialze the TableViewAnimator class
        if (!animatedIndexPaths.contains(indexPath)) {
            let animation = currentTableAnimation.getAnimation()
            let animator = TableViewAnimator(animation: animation)
            animator.animate(cell: cell, at: indexPath, in: tableView)
            animatedIndexPaths.append(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 28, weight: .semibold, scale: .medium)
        
        let selectedCell = self.tableData[indexPath.row]
        
        let action = UIContextualAction(style: .destructive, title: "") { (action, view, completion) in
            self.tableData = self.appData.removeData(cell: selectedCell)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        var actionImage = UIImage(systemName: "trash.circle", withConfiguration: imageConfiguration)
        actionImage = actionImage?.withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
        action.image = actionImage
        action.backgroundColor = UIColor.systemBackground
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
}
