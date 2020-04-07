//
//  ViewController.swift
//  News
//
//  Created by Stanislav Povolotskiy on 31.03.2020.
//  Copyright © 2020 Stanislav Povolotskiy. All rights reserved.
//

import UIKit

class SourceCollectionViewController: UICollectionViewController {
    
    private var sources = [Source]()
    
    var networkDataFetcher = NetworkDataFetcher()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        title = NSLocalizedString("News Applicaton", comment: "Title for bars")
        
        fetchSources()
        setupCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .black
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if Core.share.isNewUser() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "welcome") as? WelcomeViewController {
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
            }
        }
    }

    private func fetchSources() {
        self.networkDataFetcher.fetchSources { [weak self] (searchSources) in
            guard let fetchedSources = searchSources else { return }
            self?.sources = fetchedSources.sources
            self?.collectionView.reloadData()
        }
    }
    
    private func setupCollectionView() {
        collectionView?.backgroundColor = .clear
        collectionView?.decelerationRate = .fast
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailedSource" {
            if let vc = segue.destination as? DetailedSourceViewController {
                let source = sender as? Source
                vc.source = source
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension SourceCollectionViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return sources.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell (
        withReuseIdentifier: SourceCollectionViewCell.reuseIdentifier, for: indexPath)
      as? SourceCollectionViewCell else {
        return UICollectionViewCell()
    }
    cell.source = sources[indexPath.item]
    let randomNumber = Int.random(in: 1...10)
    cell.imageView.image = UIImage(named: "news\(randomNumber)")
    return cell
  }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let source = sources[indexPath.item]
        self.performSegue(withIdentifier: "showDetailedSource", sender: source)
    }
}
