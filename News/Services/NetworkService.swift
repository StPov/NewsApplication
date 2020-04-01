//
//  NetworkService.swift
//  News
//
//  Created by Stanislav Povolotskiy on 31.03.2020.
//  Copyright © 2020 Stanislav Povolotskiy. All rights reserved.
//

import Foundation

class NetworkService {
    
    // MARK: HeadLines
    func requestTopHeadlines(from source: String, completion: @escaping (Data?, Error?) -> Void)  {
        let parameters = self.prepareParametersForTopHeadlines(from: source)
        let url = self.urlTopHeadlines(params: parameters)
        var request = URLRequest(url: url)
        print("URL: \(url)")
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func prepareParametersForTopHeadlines(from source: String?) -> [String: String] {
        var parameters = [String: String]()
        parameters["apiKey"] = "8c66ce1dfb9245cf9fe9be0a484d713e"
        parameters["sources"] = source
        return parameters
    }
    
    private func urlTopHeadlines(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = "/v2/top-headlines"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
        return components.url!
    }
    
    // MARK: Everything
    func requestEverything(from source: String, page: Int, completion: @escaping (Data?, Error?) -> Void)  {
        let parameters = self.prepareParametersForEverything(from: source, page: page)
        let url = self.urlEverything(params: parameters)
        print("URL: \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    func requestEverything(for searchText: String, page: Int, completion: @escaping (Data?, Error?) -> Void)  {
//        let parameters = self.prepareParametersForEverything(from: searchText, page: page)
        let parameters = self.prepareParametersForEverything(for: searchText, page: page)
        let url = self.urlEverything(params: parameters)
        var request = URLRequest(url: url)
        print("URL: \(url)")
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func prepareParametersForEverything(from source: String?, page: Int) -> [String: String] {
        var parameters = [String: String]()
        parameters["apiKey"] = "8c66ce1dfb9245cf9fe9be0a484d713e"
        parameters["page"] = String(page)
        parameters["sources"] = source
        return parameters
    }
    
    private func prepareParametersForEverything(for searchText: String?, page: Int) -> [String: String] {
        var parameters = [String: String]()
        parameters["apiKey"] = "8c66ce1dfb9245cf9fe9be0a484d713e"
        parameters["page"] = String(page)
        parameters["q"] = searchText
        return parameters
    }
    
    private func urlEverything(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = "/v2/everything"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
        return components.url!
    }
    
    // MARK: Sources
    func requestSources(completion: @escaping (Data?, Error?) -> Void)  {
        let parameters = self.prepareParametersForSources()
        let url = self.urlSources(params: parameters)
        var request = URLRequest(url: url)
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func prepareParametersForSources() -> [String: String] {
        var parameters = [String: String]()
        parameters["apiKey"] = "8c66ce1dfb9245cf9fe9be0a484d713e"
        return parameters
    }
    
    private func urlSources(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = "/v2/sources"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
        return components.url!
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data? , Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}

