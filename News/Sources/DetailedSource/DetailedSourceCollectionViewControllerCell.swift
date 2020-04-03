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
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var publishedAtLabel: UILabel!
    
    @IBOutlet private weak var headerLabel: UILabel!
        
    var article: Article? {
        didSet {
            if let article = article {
                
                headerLabel.text = article.source.name
                
                guard let imageUrl = article.urlToImage, let url = URL(string: imageUrl) else {
                    imageView.image = UIImage(named: "no_image")
                    return
                }
                imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                imageView.sd_setImage(with: url, completed: nil)
                titleLabel.text = article.title
                descriptionLabel.text = article.description
                
                publishedAtLabel.text = String(article.publishedAt.prefix(10))
                
                authorLabel.text = "" //this field is "empty" because of request answer may contant url-link, which is not appropriate to UX
            }
        }
    }
}
