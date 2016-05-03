//
//  MovieDBController.swift
//  Nav
//
//  Created by Gamaliel Tellez on 5/1/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

class MovieDBController: NSObject {
    static let apiController = MovieDBController()
    private let APIKey = "0a6edf6d1edad4c700d2b8af3b6707cb"
    let session = NSURLSession.sharedSession()

    func newMovieSearch(with movieName:String, completion: (result:AnyObject) -> Void) {
        let formattedMovieName = movieName.stringByReplacingOccurrencesOfString(" ", withString: "+")
        if let movieSearchURL = NSURL(string: "https://api.themoviedb.org/3/search/movie?api_key=" + self.APIKey + "&query=" + formattedMovieName) {
            let dataTask = self.session.dataTaskWithURL(movieSearchURL, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
                if (error != nil) {
                    print(error?.localizedDescription)
                    if let errorProduced = error {
                         completion(result: errorProduced)
                    }
                    completion(result: error!)
                } else {
                    if let httpResponse = response as? NSHTTPURLResponse {
                        if httpResponse.statusCode != 200 {
                            completion(result: httpResponse)
                            //print(response.statusCode)
                        } else {
                            if let jsonData = data {
                                do {
                                    let jsonObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers)
                                    completion(result: jsonObject)
                                   //print(jsonObject)
                                } catch let error as NSError? {
                                    if let errorFromJson = error {
                                        print(errorFromJson.localizedDescription)
                                        completion(result: errorFromJson)
                                    }
                                }
                            }
                            
                        }
                    }
                }
            })
            dataTask.resume()
        }
    }
    
    func getMovieTrailer(movieID:String, completion:(result:AnyObject)-> Void) {
        if let trailerURL = NSURL(string: "http://api.themoviedb.org/3/movie/" + movieID + "/videos?api_key=" + self.APIKey) {
            let trailerDataTask = self.session.dataTaskWithURL(trailerURL, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
                if (error != nil) {
                  //  print(error?.localizedDescription)
                    if let errorProduced = error {
                        completion(result: errorProduced)
                    }
                } else {
                    if let httpResponse = response as? NSHTTPURLResponse {
                        if httpResponse.statusCode != 200 {
                            completion(result: httpResponse)
                        } else {
                            if let jsonData = data {
                                do {
                                    let jsonObj = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers)
                                   // print(jsonObj)
                                    completion(result: jsonObj)
                                } catch let errorSerialization as NSError {
                                    print(errorSerialization.localizedDescription)
                                    completion(result: errorSerialization)
                                    }
                                }
                            }
                        }
                    }
            })
              trailerDataTask.resume()
        }
    }
}





