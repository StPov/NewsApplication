//
//  SearchArticles.swift
//  News
//
//  Created by Stanislav Povolotskiy on 31.03.2020.
//  Copyright © 2020 Stanislav Povolotskiy. All rights reserved.
//

import Foundation

struct SearchArticles: Decodable {
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable {
    let source: ArticleSource!
    let author: String?
    let title: String
    let description: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct ArticleSource: Decodable {
    let id: String?
    let name: String
}
