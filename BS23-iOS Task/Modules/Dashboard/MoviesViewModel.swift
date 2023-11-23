//
//  ViewModel.swift
//  BS23-iOS Task
//
//  Created by MAHFUJ on 23/11/23.
//

import Foundation

class MovieViewModel: NSObject {
    private(set) var movies : [MovieModel] = []
    private(set) var starting : Bool = false

    
    private(set) var isFetching: Bool = false
    private(set) var currentPage = 1
    private(set) var totalPages = 1
    
    var onFetchStart: (()->())? = nil
    var onFetchDone: (()->())? = nil

    override init() {
        super.init()
    }
    
    func clear(){
        
    }
    
 
    func fetchMovies(starting: Bool, query: String = "") {
        guard isFetching == false else { return }
        
        self.starting = starting
        
        if starting {
            currentPage = 1
            onFetchStart?()
        }
        
        isFetching = true
        
        let qry = query.isEmpty ? "marvel" : query
        
        APIManager.shared.fetchMovies(page: currentPage, queryString: qry, method: .get, body: nil) { movies, total_page in
            
            if let movies = movies {
                if starting {
                    self.movies = movies
                } else {
                    self.movies += movies
                }
                
                self.currentPage += 1
                self.totalPages = total_page ?? .max
                print("movies count: \(self.movies.count)")
            }
            
            self.isFetching = false
            
            DispatchQueue.main.async {
                self.onFetchDone?()
            }
        }
    }

}
