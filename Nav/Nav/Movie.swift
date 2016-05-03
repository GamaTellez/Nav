//
//  Movie.swift
//  Nav
//
//  Created by Gamaliel Tellez on 5/2/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import Foundation
import UIKit
struct Movie {
    var title:String?
    var overView:String?
    var releaseDate:String?
    var votesAverage:Int?
    var movieID:Int?
    //var votesCount:Int?
    var image:UIImage?
    
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
                        self.image = UIImage(data: imageData)
                    } else {
                        //print("no image available);
                    }
            }
        } else {
            self.image = UIImage(named: "film")
        }
        
        if let movieReleaseDate = infoDictionary.valueForKey("release_date") as? String {
            self.releaseDate = movieReleaseDate
        } else {
            self.releaseDate = "No realease date available"
        }
        
        if let movieVotesAverage = infoDictionary.valueForKey("vote_average") as? Int {
            self.votesAverage = movieVotesAverage
        } else {
            self.votesAverage = 0
        }
        
        if let movieid = infoDictionary.valueForKey("id") as? Int {
                self.movieID = movieid
        }
    }
}