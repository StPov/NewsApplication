//
//  NewsTableViewCell.swift
//  News
//
//  Created by Stanislav Povolotskiy on 01.04.2020.
//  Copyright © 2020 Stanislav Povolotskiy. All rights reserved.
//

import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: NewsTableViewCell.self)

    @IBOutlet var newsDescription: UILabel!
    @IBOutlet var newsTitle: UILabel!
    @IBOutlet var newsPhoto: UIImageView!
    
    var article: Article? {
        didSet {
            if let article = article {
                guard let imageUrl = article.urlToImage, let url = URL(string: imageUrl) else {
                    newsPhoto.image = UIImage(named: "no_image")
                    return
                }
                newsPhoto.sd_imageIndicator = SDWebImageActivityIndicator.gray
                newsPhoto.sd_setImage(with: url, completed: nil)
                newsTitle.text = article.title
                newsDescription.text = article.description
            }
        }
    }
}
