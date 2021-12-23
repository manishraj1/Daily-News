//
//  Apicaller.swift
//  click
//
//  Created by Manish raj(MR) on 22/12/21.
//

import Foundation

final class Apicaller {
    
    static let shared = Apicaller()
    
    struct Constants {
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/everything?q=Apple&from=2021-12-22&sortBy=popularity&apiKey=6c22689c26344a2e8759d538b9abf27d")
        static let searchUrlString = "https://newsapi.org/v2/everything?from=2021-12-22&sortBy=popularity&apiKey=6c22689c26344a2e8759d538b9abf27d&q="
    }
    
    private init() {
        
    }
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let  error = error{
                completion(.failure(error))
            }
            else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIResponce.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    public func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        let urlString = Constants.searchUrlString + query
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let  error = error{
                completion(.failure(error))
            }
            else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIResponce.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}

struct APIResponce: Codable{
    let articles: [Article]
}

struct Article: Codable{
    let source: Source
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
}

struct Source: Codable{
    let name: String
}
