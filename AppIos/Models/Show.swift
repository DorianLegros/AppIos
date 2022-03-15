//
//  Show.swift
//  AppIos
//
//  Created by user214997 on 3/15/22.
//

import Foundation

struct Show : Decodable{
    var id: Int
    var posterPath: String
    var title: String
    var overview: String
    var firstAirDate: String
    var voteAverage: Double
    
    init(id: Int, posterPath:String, title:String, overview:String, firstAirDate: String, voteAverage: Double){
        self.id = id
        self.posterPath = posterPath
        self.title = title
        self.overview = overview
        self.firstAirDate = firstAirDate
        self.voteAverage = voteAverage
    }
}
