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
    
    var refControl = UIRefreshControl()
    var expandedLabel: UILabel!
    var indexOfCellToExpand: Int!
    var expended = false
    
    private var timer: Timer?
    let network = NetworkManager.sharedInstance
    var networkDataFetcher = NetworkDataFetcher()
    var currentPage = 1
    
    var articles = [Article]()
    var searchedTopic: String? = "Sevastopol"
    var searchingTopic: String = "Sevastopol"
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indexOfCellToExpand = -1
        fetchArticles(for: searchedTopic ?? "")
        setupRefControl()
        title = "All News"
        tableView.backgroundView = UIImageView(image: UIImage(named: "tableview_background1"))
        TapLabelToScrollToTheTop(font: UIFont.systemFont(ofSize: 17, weight: .semibold), textColor: UIColor.black, backgroundColor: UIColor.clear)
        network.reachability.whenUnreachable = { reachability in
            self.showOfflinePage()
        }
    }
        
        private func showOfflinePage() -> Void {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "NetworkUnavailable", sender: self)
            }
        }
    
    private func setupRefControl() {
        refControl.tintColor = UIColor.white
        refControl.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refControl)
    }
    
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        DispatchQueue.global().async {
            
            self.articles.removeAll()
            self.fetchArticles(for: self.searchingTopic)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                refreshControl.endRefreshing()
            }
        }
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
            print("Expended")
        } else {
            cell.newsDescription.frame = CGRect(x: cell.newsDescription.frame.minX,
                                                y: cell.newsDescription.frame.minY,
                                                width: cell.newsDescription.frame.width,
                                                height: expandedLabel.frame.height - 100)
            expended = false
            print("Not expended")
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
            return 400 + expandedLabel.frame.height - 38
        }
        return 400
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let save = UIAction(title: "Save", image: UIImage(named: "save")) { action in
                
                let realmObject = ArticleObject()
                let news = self.articles[indexPath.row]
                realmObject.article = Article(source: news.source, author: news.author,
                                              title: news.title, description: news.description,
                                              url: news.url, urlToImage: news.urlToImage,
                                              publishedAt: news.publishedAt, content: news.content)
                DBManager.sharedInstance.addData(object: realmObject)
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
                self.searchingTopic = searchText
                self.currentPage = 1
                self.articles.removeAll()
                self.fetchArticles(for: searchText)
                self.tableView.reloadData()
            })
        }
    }
}
