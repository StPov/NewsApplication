//
//  SearchArticles.swift
//  News
//
//  Created by Stanislav Povolotskiy on 31.03.2020.
//  Copyright © 2020 Stanislav Povolotskiy. All rights reserved.
//

import Foundation
import RealmSwift

//public protocol Persistable {
//    associatedtype ManagedObject: RealmSwift.Object
//
//    init(managedObject: ManagedObject)
//    func managedObject() -> ManagedObject
//}

struct SearchArticles: Codable {
    let totalResults: Int
    let articles: [Article]
}

struct Article: Codable {
    let source: ArticleSource!
    let author: String?
    let title: String
    let description: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct ArticleSource: Codable {
    let id: String?
    let name: String
}
//
//class RealmArticle: Object {
//    dynamic var source: RealmArticleSource!
//    dynamic var author: String?
//    dynamic var title: String = ""
//    dynamic var articleDescription: String = ""
//    dynamic var url: String = ""
//    dynamic var urlToImage: String? = ""
//    dynamic var publishedAt: String = ""
//    dynamic var content: String? = ""
//
//    override static func primaryKey() -> String? {
//        return "url"
//    }
//}
//
//class RealmArticleSource: Object {
//    dynamic var id: String?
//    dynamic var name: String = ""
//
//    override static func primaryKey() -> String? {
//        return "name"
//    }
//}

//extension Article: Persistable {
//
//    public init(managedObject: RealmArticle) {
//        source = managedObject.source
//        author = managedObject.author
//        title = managedObject.title
//        description = managedObject.articleDescription
//        url = managedObject.url
//        urlToImage = managedObject.urlToImage
//        publishedAt = managedObject.publishedAt
//        content = managedObject.content
//    }
//
//    public func managedObject() -> RealmArticle {
//        let article = RealmArticle()
//
//        article.source = source
//        article.author = author
//        article.title = title
//        article.articleDescription = description
//        article.url = url
//        article.urlToImage = urlToImage
//        article.publishedAt = publishedAt
//        article.content = content
//
//        return article
//    }
//}
//
//extension ArticleSource: Persistable {
//
//    public init(managedObject: RealmArticleSource) {
//        name = managedObject.name
//        id = managedObject.id
//    }
//
//    public func managedObject() -> RealmArticleSource {
//        let articleSource = RealmArticleSource()
//
//        articleSource.name = name
//        articleSource.id = id
//        return articleSource
//    }
//}

class ArticleObject : Object {

    @objc private dynamic var structData: Data? = nil

    var article : Article? {
        get {
            if let data = structData {
                return try? JSONDecoder().decode(Article.self, from: data)
            }
            return nil
        }
        set {
            structData = try? JSONEncoder().encode(newValue)
        }
    }
}
