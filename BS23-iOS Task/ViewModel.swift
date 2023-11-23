//
//  ViewModel.swift
//  BS23-iOS Task
//
//  Created by MAHFUJ on 23/11/23.
//

import UIKit

class MovieViewModel: NSObject {
    private(set) var movies : [Movie]
    
    
    init(data: [Movie]) {
        self.movies = data
        super.init()
    }
    
   /*
    func getProfile(onFetch: @escaping (()->())){
        APIManager.shared.fetchMovies(page: currentPage, queryString: query, method: .get, body: nil) { results, totatPages in
            if let results = results {
                self.movies = results
            }
            
        }
        self.apiService.getUserProfileData { (profileData) in
            if let profileData {
                print("\n\nProfileData fetched: \n \(profileData)\n\n")
                self.userProfileData = profileData
            }
            onFetch()
        }
    } */

}
