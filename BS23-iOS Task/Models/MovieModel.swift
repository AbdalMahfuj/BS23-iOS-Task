//
//  Model.swift
//  BS23-iOS Task
//
//  Created by MAHFUJ on 23/11/23.
//

import Foundation

struct MovieResponse: Codable {
    let page: Int?
    let movies: [MovieModel]?
    let totalPages: Int?
    let totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieModel: Codable {
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
}
