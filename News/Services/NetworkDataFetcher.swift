//
//  NetworkDataFetcher.swift
//  News
//
//  Created by Stanislav Povolotskiy on 31.03.2020.
//  Copyright © 2020 Stanislav Povolotskiy. All rights reserved.
//

import UIKit

class NetworkDataFetcher {
    
    var networkService = NetworkService()
    
    func fetchSources(completion: @escaping (SearchSources?) -> ()) {
        networkService.requestSources { (data, error) in
            if let error = error {
                print("Error hanled: \(error.localizedDescription)")
                self.showAlert(title: "Error received", message: error.localizedDescription)
                completion(nil)
            }
            let decode = self.decodeJSON(type: SearchSources.self, from: data)
            completion(decode)
        }
    }
    
    func fetchArticlesHeadlines(from source: String, completion: @escaping (SearchArticles?) -> ()) {
        networkService.requestTopHeadlines(from: source) { (data, error) in
            if let error = error {
                print("Error hanled: \(error.localizedDescription)")
                self.showAlert(title: "Error received", message: error.localizedDescription)
                completion(nil)
            }
            let decode = self.decodeJSON(type: SearchArticles.self, from: data)
            completion(decode)
            
        }
    }
    
    func fetchArticlesEverything(from source: String, page: Int, completion: @escaping (SearchArticles?) -> ()) {
        networkService.requestEverything(from: source, page: page) { (data, error) in
            if let error = error {
                print("Error hanled: \(error.localizedDescription)")
                self.showAlert(title: "Error received", message: error.localizedDescription)
                completion(nil)
            }
            let decode = self.decodeJSON(type: SearchArticles.self, from: data)
            completion(decode)
            
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        alert.present(alert, animated: true)
    }
}
