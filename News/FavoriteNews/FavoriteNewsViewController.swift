//
//  FavoriteNewsViewController.swift
//  News
//
//  Created by Stanislav Povolotskiy on 02.04.2020.
//  Copyright © 2020 Stanislav Povolotskiy. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteNewsViewController: UIViewController {
    
    var expandedLabel: UILabel!
    var indexOfCellToExpand: Int!
    var expended = false
    
    private var timer: Timer?
    var networkDataFetcher = NetworkDataFetcher()
    var currentPage = 1
    let realm = try! Realm()
    
    var savedArticles: Results<ArticleObject>!
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indexOfCellToExpand = -1
        self.title = "All News"
        TapLabelToScrollToTheTop(font: UIFont.systemFont(ofSize: 17, weight: .semibold), textColor: UIColor.black, backgroundColor: UIColor.clear)
        savedArticles = realm.objects(ArticleObject.self)
    }
    
    @objc func expandCell(sender: UITapGestureRecognizer) {
        let label = sender.view as! UILabel
        
        let cell = tableView.cellForRow(at: IndexPath(row: label.tag, section: 0)) as! NewsTableViewCell
        let article = self.savedArticles[label.tag]
        let description = article.description
        if !expended {
            cell.newsDescription.sizeToFit()
            expended = true
        } else {
            cell.newsDescription.frame = CGRect(x: cell.newsDescription.frame.minX, y: cell.newsDescription.frame.minY, width: cell.newsDescription.frame.width, height: cell.bounds.height - expandedLabel.frame.height + 38)
            expended = false
        }
        cell.newsDescription.text = description
        expandedLabel = cell.newsDescription
        indexOfCellToExpand = label.tag
        tableView.reloadRows(at: [IndexPath(row: label.tag, section: 0)], with: .fade)
        tableView.scrollToRow(at: IndexPath(row: label.tag, section: 0), at: .top, animated: true)
    }
    
    func TapLabelToScrollToTheTop(font: UIFont, textColor: UIColor, backgroundColor: UIColor) {
            let titlelabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
            titlelabel.text = self.navigationItem.title
            titlelabel.textColor = textColor
            titlelabel.font = font
            titlelabel.backgroundColor = backgroundColor
            titlelabel.textAlignment = .center
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped))
            tapGestureRecognizer.numberOfTapsRequired = 1
            titlelabel.addGestureRecognizer(tapGestureRecognizer)
            titlelabel.isUserInteractionEnabled = true
            self.navigationItem.titleView = titlelabel
        }
        
    @objc func labelTapped(_ sender: UITapGestureRecognizer) { //Press the navigation label to go at the top
            let topOffest = CGPoint(x: 0, y: -(self.tableView?.contentInset.top ?? 0))
            self.tableView?.setContentOffset(topOffest, animated: true)
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension FavoriteNewsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier) as! NewsTableViewCell
        
        cell.article = savedArticles[indexPath.row].article
        cell.newsDescription.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(NewsViewController.expandCell(sender:)))
        cell.newsDescription.addGestureRecognizer(tap)
        cell.newsDescription.isUserInteractionEnabled = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if savedArticles.count != 0 {
            return savedArticles.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == indexOfCellToExpand
        {
            return 170 + expandedLabel.frame.height - 38
        }
        return 170
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let save = UIAction(title: "Delete", image: UIImage(named: "delete")) { action in
                try! self.realm.write {
                    let editingRow = self.savedArticles[indexPath.row]
                    self.realm.delete(editingRow)
                    tableView.reloadData()
                }
            }
            return UIMenu(title: "", children: [save])
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editingRow = savedArticles[indexPath.row]
                
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { _,_ in
            try! self.realm.write {
                self.realm.delete(editingRow)
                tableView.reloadData()
            }
        }
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: self.tableView.frame.width,
                                              height: 2))
        footerView.backgroundColor = .clear
        
        return footerView
    }
}
