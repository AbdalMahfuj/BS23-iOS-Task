//
//  APIManager.swift
//  BS23-iOS Task
//
//  Created by MAHFUJ on 23/11/23.
//

import UIKit

 
typealias HttpStatus = Int


enum ResponseStatus : Int, Codable {
    case valid = 200
    case error = 1
    case invalidToken = 401
}

enum RequestMethod : String, CustomStringConvertible {
    case get
    case post
    case put
    case delete

    var description: String {
        self.rawValue.uppercased()
    }
}

enum RequestContent : String, CustomStringConvertible {
    case json
    case formURLEncoded
    case formData

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
    
    func fetchMovies(page: Int, queryString: String, method: RequestMethod,  body: [String: Any]?, onComplete: @escaping (([Movie]?, _ totatPages: Int?)->())) {
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



extension APIManager {
    private func request(_ urlString: String,
                         method: RequestMethod,
                         parameters: [String: Any] = [:],
                         headers: [String: String] = [:],
                         contentType: RequestContent = .formURLEncoded,
                         timeOut: Double = APIConstant.timeOut,
                         completion: @escaping((Data?, HttpStatus?)->())) {
        
        print("\nparameters: \(parameters)\n")
        guard var url = URL(string: urlString) else {
            completion(nil, -1)
            return
        }
        
        
        var requestData: Data?

        if (method == .get || contentType == .formURLEncoded), parameters.count > 0 {
            guard var components = URLComponents(string: urlString) else {
                completion(nil, -1)
                return
            }
            
            components.queryItems = parameters.compactMap { parm -> URLQueryItem? in
                if let value = parm.value as? String {
                    return URLQueryItem(name: parm.key, value: value)
                }
                else {
                    return URLQueryItem(name: parm.key, value: (parm.value as AnyObject) .description)
                }
            }
            
            guard let _url = components.url else {
                completion(nil, -1)
                return
            }
            
            
            if method == .get  {
                url = _url
            }
            else {
                requestData = components.query?.data(using: .utf8)
            }
        }
        else if contentType == .formData, parameters.count > 0 {
            var infos = [String]()
            
            for(key, value) in parameters {
                infos.append(key + "=\(value)")
            }
            
            requestData = infos.map { String($0) }.joined(separator: "&").data(using: .utf8)
        }
        
        
              
        
        var request = URLRequest(url: url)
        
        request.timeoutInterval = timeOut
        request.httpMethod = method.description
        request.addValue(contentType == .formURLEncoded ? "application/x-www-form-urlencoded" : "application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(contentType == .formURLEncoded ? "application/x-www-form-urlencoded" : "application/json", forHTTPHeaderField: "Content-Type")

        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
                
        if let requestData {
            request.httpBody = requestData
        }
        else if method != .get {
            requestData = jsonDataFrom(dic: parameters)
            request.httpBody = requestData
        }
        
        logRequest(url: request.url!, headers: headers, jsonData: requestData)
        
        let task = session.dataTask(with: request) { data, response, error in
            self.logResponse(data: data)
            
            DispatchQueue.main.async {
                completion(data, (response as? HTTPURLResponse)?.statusCode)
            }
        }
        
        task.resume()
    }
    
    
    
    private func jsonDataFrom(dic: Any)->Data? {
        try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
    }
    
    private func jsonFrom(data: Data)->Any? {
        try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
    }
    
    private func logRequest(url: URL, headers: [String: String],  jsonData: Data?){
        #if DEBUG
        print("\nREQUEST ::>>>\n")
        print("URL: ", url)
        
        print("Headers: ", headers)
        
        if let jsonData = jsonData, let reqJson = jsonFrom(data: jsonData) {
            print("\nBody : \n", reqJson)
        }
        #endif
    }
    
    
    private func logResponse(data: Data?) {
        #if DEBUG
        print("\n\n****   RESPONSE   ****\n")
        
        if let data = data {
            if let json = self.jsonFrom(data: data) {
                print("JSON : \n", json)
            }
            else if let responseString = String.init(data: data, encoding: .utf8) {
                print("String : \n", responseString)
            }
            else {
                print("Non formatted data")
            }
        }
        else {
            print("No Data Found")
        }
        
        print("\n-----  =======   -----\n\n")
        #endif
    }
}
