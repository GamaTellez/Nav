//
//  MovieDetailVC.swift
//  Nav
//
//  Created by Gamaliel Tellez on 5/2/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit
import Cosmos

class MovieDetailVC: UIViewController, UIScrollViewDelegate {
    var moviewSelected:Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
        self.addReturnBarButtonItem()
    }
    
    func addReturnBarButtonItem(){
        let returnHome = UIBarButtonItem(title: "New Search", style: .Plain, target: self, action: #selector(MovieDetailVC.returnToHomeView))
        self.navigationItem.rightBarButtonItem = returnHome
    }
    
    func returnToHomeView() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func setUpViews() {
        if let movieTitle = self.moviewSelected?.title {
            self.title = movieTitle
        }
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        //ImageView
        let movieImageView = UIImageView()
        if let movieURL = self.moviewSelected?.urlForImage {
            if let imageData = NSData(contentsOfURL: movieURL) {
                if let image = UIImage(data: imageData) {
                    movieImageView.image = image
                    movieImageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
                    movieImageView.center.x = self.view.frame.width / 2
                    movieImageView.contentMode = .Top
                    movieImageView.clipsToBounds = true
                }
            }
        }

        scrollView.addSubview(movieImageView)
        
        //star rating view
        let ratingView = CosmosView(frame: CGRect(x: 0, y: movieImageView.frame.height + 10, width: self.view.frame.width, height: 50))
        ratingView.settings.totalStars = 10
        ratingView.settings.fillMode = .Precise
        ratingView.settings.starSize = 32
        ratingView.settings.filledColor = UIColor.yellowColor()
        ratingView.settings.updateOnTouch = false
        if let totalStars = self.moviewSelected?.votesAverage {
            ratingView.rating = Double(totalStars)
        } else {
            ratingView.rating = 0
        }
        scrollView.addSubview(ratingView)
        
        //ReleaseDateLabel
        let releaseDateLabel = UILabel(frame: CGRect(x: 0, y: movieImageView.frame.height +  ratingView.frame.height + 30, width: self.view.frame.width, height: 30))
        releaseDateLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        if let movieReleaseDate = self.moviewSelected?.releaseDate {
            releaseDateLabel.text = String(format: "Release date: %@",movieReleaseDate)
        }
        scrollView.addSubview(releaseDateLabel)
        
        //TrailerButton
        let viewTrailerButton = UIButton(frame: CGRect(x: 10, y: releaseDateLabel.frame.height + 35 + movieImageView.frame.height + ratingView.frame.height , width: self.view.frame.width - 20, height: 30))
        viewTrailerButton.setTitle("View Trailer", forState: .Normal)
        viewTrailerButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        viewTrailerButton.layer.cornerRadius = 5
        viewTrailerButton.layer.borderColor = UIColor.blackColor().CGColor
        viewTrailerButton.layer.borderWidth = 1
        viewTrailerButton.addTarget(self, action: #selector(MovieDetailVC.viewTrailerButtonTapped), forControlEvents: .TouchUpInside)
        scrollView.addSubview(viewTrailerButton)
        
        //SynopsisLabel
        let synopsisLabel = UILabel(frame: CGRect(x: 0, y: movieImageView.frame.height + releaseDateLabel.frame.height + viewTrailerButton.frame.height + ratingView.frame.height + 45 , width: self.view.frame.width, height: 300))
        synopsisLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        if let movieSummary = self.moviewSelected?.overView {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10
            paragraphStyle.alignment = .Center
            synopsisLabel.attributedText = NSAttributedString(string: String(format: "Synopsys:\n %@", movieSummary), attributes: [NSParagraphStyleAttributeName:paragraphStyle])
            synopsisLabel.numberOfLines = 0
            synopsisLabel.sizeToFit()
            }
        scrollView.addSubview(synopsisLabel)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: movieImageView.frame.height + releaseDateLabel.frame.height + viewTrailerButton.frame.height + synopsisLabel.frame.height + ratingView.frame.height + 60)
    }
    
    func viewTrailerButtonTapped() {
        if let movieID = self.moviewSelected?.movieID {
            MovieDBController.apiController.getMovieTrailer(String(format:"%d", movieID), completion: { (result) in
                if result.isKindOfClass(NSError) {
                    if let resultError = result as? NSError {
                            self.classAlertViewController("Oops, something went wrong!", message: resultError.localizedDescription, actionTitle: "Continue")
                    }
                } else if result.isKindOfClass(NSHTTPURLResponse) {
                    if let resultResponse = result as? NSHTTPURLResponse {
                            self.classAlertViewController("Oops, something went wrong", message: String(format: "Error: %d", resultResponse.statusCode), actionTitle: "Continue")
                    }
                } else {
                    if let resultsDict = result.objectForKey("results") as? [NSDictionary] {
                        if resultsDict.isEmpty {
                                self.classAlertViewController("Sorry!", message: "There is no trailer available for this movie", actionTitle: "Continue")
                        } else {
                        let infoDict = resultsDict[0]
                        if let trailerKey = infoDict.valueForKey("key") as? String {
                            if let trailerSite = infoDict.valueForKey("site") as? String {
                             self.playTrailer(trailerKey, trailerSite: trailerSite)
                                }
                            }
                        }
                    }
                }
            })
        }
    }
    
    func playTrailer(trailerKey:String, trailerSite:String) {
        switch trailerSite {
            case "YouTube":
                if let trailerURL = NSURL(string: "https://www.youtube.com/watch?v=" + trailerKey) {
                UIApplication.sharedApplication().openURL(trailerURL)
            }
            default:
                //no other sites were found
                print(trailerSite)
            break
        }
    }
    
    func classAlertViewController(title:String, message:String, actionTitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .Default, handler: nil))
        dispatch_async(dispatch_get_main_queue()) { 
         self.navigationController?.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
