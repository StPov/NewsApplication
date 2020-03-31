//
//  SourceCollectionViewCell.swift
//  News
//
//  Created by Stanislav Povolotskiy on 31.03.2020.
//  Copyright © 2020 Stanislav Povolotskiy. All rights reserved.
//

import UIKit

class SourceCollectionViewCell: UICollectionViewCell {
  static let reuseIdentifier = String(describing: SourceCollectionViewCell.self)
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet private weak var imageCoverView: UIView!
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var categoryAndLanguageLabel: UILabel!
  @IBOutlet private weak var descriptionLabel: UILabel!
    
  var source: Source? {
    didSet {
      if let source = source {
        imageView.backgroundColor = .black
        nameLabel.text = source.name
        categoryAndLanguageLabel.text = "\(source.category), \(source.language)"
        descriptionLabel.text = source.description
      }
    }
  }
  
  override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
    
    let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
    let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
    
    let delta = 1 - ((featuredHeight - frame.height) / (featuredHeight - standardHeight))
    
    let minAlpha: CGFloat = 0.3
    let maxAlpha: CGFloat = 0.75
    
    imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
    
    let scale = max(delta, 0.5)
    nameLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
    
    categoryAndLanguageLabel.alpha = delta
    descriptionLabel.alpha = delta
  }
}
