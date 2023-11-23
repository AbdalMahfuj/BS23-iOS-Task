//
//  APIManager.swift
//  BS23-iOS Task
//
//  Created by MAHFUJ on 23/11/23.
//

import UIKit


enum RequestMethod : String, CustomStringConvertible {
    case get
    case post
    case put
    case delete

    var description: String {
        self.rawValue.uppercased()
    }
}


class APIManager: NSObject {
    
    static let shared = APIManager()
    private let session : URLSession
 
    
    private override init() {
        session = URLSession.shared
        super.init()
    }
    
    
    func fetchMovies(page: Int, queryString: String, method: RequestMethod,  body: [String: Any]?, onComplete: @escaping (([MovieModel]?, _ totatPages: Int?)->())) {
        let apiString = "https://api.themoviedb.org/3/search/movie?api_key=\(APIConstant.apiKey)&query=\(queryString)&page=\(page)"
        
        guard let url = URL(string: apiString) else {
            onComplete(nil, nil)
            return
        }
        
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = method.description
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, _, error) in
            
            #if DEBUG
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                
                if let json = json {
                    let _ = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                    print(json)
                }
                else {
                    print("no data")
                }
            }
            
            #endif
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let results  = try decoder.decode(MovieResponse.self, from: data)
                    if let movies = results.movies, movies.count > 0 {
                        onComplete(results.movies, results.totalPages)
                    } else {
                        onComplete(nil, nil)
                    }
                }
                catch {
                    print(error)
                }
                print("task ok")
            } else {
                onComplete(nil, nil)
            }
        })
        task.resume()
    }
}
