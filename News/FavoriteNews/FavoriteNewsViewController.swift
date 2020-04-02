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
    
    private var timer: Timer?
    var networkDataFetcher = NetworkDataFetcher()
    var currentPage = 1
    let realm = try! Realm()
    
    var savedArticles: Results<ArticleObject>!
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indexOfCellToExpand = -1
        title = "All News"
        savedArticles = realm.objects(ArticleObject.self)
    }
    
    @objc func expandCell(sender: UITapGestureRecognizer) {
        let label = sender.view as! UILabel
        
        let cell = tableView.cellForRow(at: IndexPath(row: label.tag, section: 0)) as! NewsTableViewCell
        let article = self.savedArticles[label.tag]
        let description = article.description
        cell.newsDescription.sizeToFit()
        cell.newsDescription.text = description
        expandedLabel = cell.newsDescription
        indexOfCellToExpand = label.tag
        tableView.reloadRows(at: [IndexPath(row: label.tag, section: 0)], with: .fade)
        tableView.scrollToRow(at: IndexPath(row: label.tag, section: 0), at: .top, animated: true)
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
}
