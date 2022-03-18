//
//  Show.swift
//  AppIos
//
//  Created by user214997 on 3/15/22.
//

import Foundation

struct Show : Decodable{
    var id: Int?
    var posterPath: String?
    var name: String?
    var overview: String?
    var firstAirDate: String?
    var voteAverage: Double?
    var originalCountry: [String]? = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case name = "name"
        case overview
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case originalCountry = "origin_country"
    }
}

struct ShowResult : Decodable {
    let page: Int?
    let results: [Show]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
