//
//  Model.swift
//  BS23-iOS Task
//
//  Created by MAHFUJ on 23/11/23.
//

import Foundation

struct MovieResponse: Codable {
    let page: Int?
    let movies: [Movie]?
    let totalPages: Int?
    let totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable {
    let adult: Bool?
    let backdrop_path: String?
    let genre_ids: [Int]?
    let id: Int
    let overview: String?
    let popularity: Double?
    let poster_path: String?
    let release_date: String?
    let title: String?
    let vote_average: Double?
    let vote_count: Int?
    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case adult
//        case backdropPath = "backdrop_path"
//        case = "genre_ids"
//        case overview
//        case popularity
//        case poster_path
//        case release_date
//        case title
//        case vote_average
//        case vote_count
//    }
}
