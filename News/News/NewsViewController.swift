//
//  NewsViewController.swift
//  News
//
//  Created by Stanislav Povolotskiy on 01.04.2020.
//  Copyright © 2020 Stanislav Povolotskiy. All rights reserved.
//

import UIKit
import RealmSwift

class NewsViewController: UIViewController {
    
    var expandedLabel: UILabel!
    var indexOfCellToExpand: Int!
    var expended = false
    
    private var timer: Timer?
    var networkDataFetcher = NetworkDataFetcher()
    var currentPage = 1
    
    var articles = [Article]()
    var searchedTopic: String? = "Sevastopol"
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indexOfCellToExpand = -1
        fetchArticles(for: searchedTopic ?? "")
        title = "All News"
    }
    
    private func fetchArticles(for searchText: String) {
        networkDataFetcher.fetchArticlesEverything(for: searchText, page: currentPage) { [weak self] (searchArticles) in
            guard let fetchedArticles = searchArticles else { return }
            if (self?.articles.isEmpty)! {
                self?.articles = fetchedArticles.articles
            } else {
                self?.articles += fetchedArticles.articles
            }
            self?.tableView.reloadData()
        }
    }
    
    @objc func expandCell(sender: UITapGestureRecognizer) {
        let label = sender.view as! UILabel
        
        let cell = tableView.cellForRow(at: IndexPath(row: label.tag, section: 0)) as! NewsTableViewCell
        let article = self.articles[label.tag]
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
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier) as! NewsTableViewCell
        cell.article = articles[indexPath.row]
        cell.newsDescription.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(NewsViewController.expandCell(sender:)))
        cell.newsDescription.addGestureRecognizer(tap)
        cell.newsDescription.isUserInteractionEnabled = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
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
            let save = UIAction(title: "Save", image: UIImage(named: "save")) { action in
                let realm = try! Realm()
                try! realm.write {
                    let realmObject = ArticleObject()
                    let news = self.articles[indexPath.row]
                    realmObject.article = Article(source: news.source, author: news.author,
                                                  title: news.title, description: news.description,
                                                  url: news.url, urlToImage: news.urlToImage,
                                                  publishedAt: news.publishedAt, content: news.content)
                    realm.add(realmObject)
                }
            }
            return UIMenu(title: "", children: [save])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = articles.count - 3
        if indexPath.row == lastItem {
            currentPage += 1
            fetchArticles(for: searchedTopic ?? "")
        }
    }
}

//MARK: UISearchBarDelegate
extension NewsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.currentPage = 1
            self.articles.removeAll()
            self.fetchArticles(for: "Russia")
            self.tableView.reloadData()
        } else {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
                self.currentPage = 1
                self.articles.removeAll()
                self.fetchArticles(for: searchText)
                self.tableView.reloadData()
            })
        }
    }
}
