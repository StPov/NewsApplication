//
//  UIKit+Extension.swift
//  News
//
//  Created by Stanislav Povolotskiy on 31.03.2020.
//  Copyright © 2020 Stanislav Povolotskiy. All rights reserved.
//

import UIKit

extension UIImage {
  var decompressedImage: UIImage {
    UIGraphicsBeginImageContextWithOptions(size, true, 0)
    draw(at: CGPoint.zero)
    guard let decompressedImage = UIGraphicsGetImageFromCurrentImageContext() else {
      return UIImage()
    }
    UIGraphicsEndImageContext()
    return decompressedImage
  }
}
