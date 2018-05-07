//
//  File.swift
//  MovieRoulette2
//
//  Created by Marta Krawiec on 4/15/17.
//  Copyright © 2017 Marta Krawiec. All rights reserved.
//

import Foundation

class Movie {
    var title: String
    var image: String
    var overview: String
    var imageUrl: String
    var youtube: String
    var vote: Double
    
    init(title: String, image: String, overview: String, imageUrl: String, youtube: String, vote: Double) {
        self.title = title
        self.image = image
        self.overview = overview
        self.imageUrl = imageUrl
        self.youtube = youtube
        self.vote = vote
    
    }

}
