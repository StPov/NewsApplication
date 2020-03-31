//
//  DetailedSourceCollectionViewControllerCell.swift
//  News
//
//  Created by Stanislav Povolotskiy on 31.03.2020.
//  Copyright © 2020 Stanislav Povolotskiy. All rights reserved.
//

import UIKit
import SDWebImage

class DetailedArticleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var sourceAndAuthorLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var publishedAtLabel: UILabel!
    
    @IBOutlet private weak var headerLabel: UILabel!
        
    var article: Article? {
        didSet {
            if let article = article {
                
                headerLabel.text = article.source.name
                
                guard let imageUrl = article.urlToImage, let url = URL(string: imageUrl) else {
                    return
                }
                imageView.sd_setImage(with: url, completed: nil)
                titleLabel.text = article.title
                descriptionLabel.text = article.description
                
                publishedAtLabel.text = article.publishedAt
                
                guard let author = article.author else {
                    sourceAndAuthorLabel.text = "\(article.source)"
                    return
                }
                sourceAndAuthorLabel.text = "\(article.source), \(author)"
            }
        }
    }
}
