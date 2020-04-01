//
//  NewsViewController.swift
//  News
//
//  Created by Stanislav Povolotskiy on 01.04.2020.
//  Copyright © 2020 Stanislav Povolotskiy. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    var expandedLabel: UILabel!
    var indexOfCellToExpand: Int!
    
    private var timer: Timer?
    var networkDataFetcher = NetworkDataFetcher()
    var currentPage = 1
    
    var articles = [Article]()
    var searchedTopic: String? = "Russia"
    
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
        let movie = self.articles[label.tag]
        let description = movie.description
        cell.newsDescription.sizeToFit()
        cell.newsDescription.text = description
        expandedLabel = cell.newsDescription
        indexOfCellToExpand = label.tag
        tableView.reloadRows(at: [IndexPath(row: label.tag, section: 0)], with: .fade)
        tableView.scrollToRow(at: IndexPath(row: label.tag, section: 0), at: .top, animated: true)
    }
}

//MARK: UITableViewDelegate & UITableViewDataSource
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
