//
//  DetailedSourceViewController.swift
//  News
//
//  Created by Stanislav Povolotskiy on 31.03.2020.
//  Copyright © 2020 Stanislav Povolotskiy. All rights reserved.
//

import UIKit

class DetailedSourceViewController: UIViewController {
    
    @IBOutlet private var backgroundImageView: UIImageView!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var segmentedControl: UISegmentedControl!
    
    var networkDataFetcher = NetworkDataFetcher()
    var currentPage = 1
    
    var source: Source?
    
    var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        
        fetchArticlesHeadlines()
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        
        if UIScreen.main.bounds.size.height == 568.0 {
            let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.itemSize = CGSize(width: 250.0, height: 330.0)
        }
    }
    
    private func fetchArticlesHeadlines() {
        networkDataFetcher.fetchArticlesHeadlines(from: source?.id ?? "") { [weak self] (searchArticles) in
            guard let fetchedArticles = searchArticles else { return }
            self?.articles = fetchedArticles.articles
            self?.collectionView.reloadData()
        }
    }
    
    private func fetchArticlesEverything(from page: Int) {
        networkDataFetcher.fetchArticlesEverything(from: source?.id ?? "", page: page) { [weak self] (searchArticles) in
            guard let fetchedArticles = searchArticles else { return }
            if (self?.articles.isEmpty)! {
                self?.articles = fetchedArticles.articles
            } else {
                self?.articles += fetchedArticles.articles
            }
            self?.collectionView.reloadData()
        }
    }
    
    private func setupBackground() {
        backgroundImageView.image = UIImage(named: "background")
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        collectionView.backgroundColor = .clear
    }
    
    @objc func segmentedControlChanged(_ segmentedControl: UISegmentedControl) {
       switch (segmentedControl.selectedSegmentIndex) {
          case 0:
            articles.removeAll()
            collectionView.reloadData()
            fetchArticlesHeadlines()
          case 1:
            articles.removeAll()
            collectionView.reloadData()
            fetchArticlesEverything(from: currentPage)
          default:
          print("Unknown case happened")
       }
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension DetailedSourceViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DetailedArticleCollectionViewCell
            
        cell.article = articles[indexPath.row]
            
        cell.layer.cornerRadius = 4.0
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = articles.count - 3
        if indexPath.item == lastItem {
            currentPage += 1
            fetchArticlesEverything(from: currentPage)
        }
    }
}
