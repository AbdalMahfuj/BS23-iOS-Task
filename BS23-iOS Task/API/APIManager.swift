//
//  APIManager.swift
//  BS23-iOS Task
//
//  Created by MAHFUJ on 23/11/23.
//

import UIKit


class APIManager: NSObject {
    
    static let shared = APIManager()
    
    private override init() { }
    
    
    func callService(urlString: String, method: String, body: [String: Any]?, onComplete: @escaping ((Data?)->())) {
        
        guard let url = URL(string: urlString) else {
            onComplete(nil)
            return
        }
        
        print(urlString)
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, _, error) in
            
            #if DEBUG
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                
                if let json = json {
                    let string = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                    print(json)
                }
                else {
                    print("no data")
                }
            }
                
            #endif
            
            onComplete(data)
        })
        
        task.resume()
    }
}
