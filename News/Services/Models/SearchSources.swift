//
//  SearchSources.swift
//  News
//
//  Created by Stanislav Povolotskiy on 31.03.2020.
//  Copyright © 2020 Stanislav Povolotskiy. All rights reserved.
//

import Foundation

struct SearchSources: Decodable {
    let sources: [Source]
}

struct Source: Decodable {
    let id: String?
    let name: String
    let description: String
    let url: String
    let category: String
    let language: String
    let country: String
}
