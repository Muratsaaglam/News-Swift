//
//  APICaller.swift
//  News
//
//  Created by Murat Sağlam on 6.11.2022.
//

import Foundation

final class APICaller
{
    static let shared = APICaller()
    
    struct Constants
    {
        static let topHeadLinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=TR&apiKey=8549c57c277f4c19a4fadb8b1ff48c38")
    }
    
    private init() {}
    
    public func getTopStroies(completion: @escaping (Result<[Article], Error>) -> Void)
    {
        guard let url = Constants.topHeadLinesURL else
        {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url)
        {   data, _, error in
            if let error = error
            {
                completion(.failure(error))
            }
            else if let data = data
            {
                do
                {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print(result.articles.count)
                    completion(.success(result.articles))
                }
                catch
                {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
}

// Models
struct APIResponse : Codable
{
    let articles: [Article]
}

struct Article: Codable
{
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable
{
    let name : String
}

