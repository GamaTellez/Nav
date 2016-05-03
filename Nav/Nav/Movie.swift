//
//  Movie.swift
//  Nav
//
//  Created by Gamaliel Tellez on 5/2/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import Foundation

struct Movie {
    var title:String?
    var overView:String?
    var releaseDate:String?
    var votesAverage:Int?
    var votesCount:Int?
    var posterData:NSData?
    
    init(from infoDictionary:NSDictionary) {
        if let movieTitle = infoDictionary.valueForKey("title") as? String {
            self.title = movieTitle
        } else {
            self.title = "No title available"
        }
        if let movieOverview = infoDictionary.valueForKey("overview") as? String {
            if movieOverview == "" {
                self.overView = "No overview available"
            }
            self.overView = movieOverview
        } else {
            self.overView = "No overview available"
        }
        if let moviePosterPath = infoDictionary.valueForKey("poster_path") as? String {
                if let imageURL = NSURL(string:"https://image.tmdb.org/t/p/w500" + moviePosterPath) {
                    if let imageData = NSData(contentsOfURL: imageURL) {
                        self.posterData = imageData
                    }
            }
        if let movieReleaseDate = infoDictionary.valueForKey("release_Date") as? String {
            self.releaseDate = movieReleaseDate
        } else {
            self.releaseDate = "No realease date available"
        }
        if let movieVotesAverage = infoDictionary.valueForKey("vote_average") as? Int {
            self.votesAverage = movieVotesAverage
        } else {
            self.votesAverage = 0
        }
        if let movieVotesTotal = infoDictionary.valueForKey("vote_count") as? Int {
            self.votesCount = movieVotesTotal
        } else {
            self.votesCount = 0
        }
     }
    }
}