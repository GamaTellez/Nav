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
//    @IBOutlet var movieImage: UIImageView!
//    @IBOutlet var movieReleaseDateLabel: UILabel!
//    @IBOutlet var movieOverviewTextview: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
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
      if let moviePoster = self.moviewSelected?.image {
            movieImageView.frame = CGRect(x: 0, y: 0, width: moviePoster.size.width, height: 400)
            movieImageView.center.x = self.view.frame.width / 2
            movieImageView.image = moviePoster
            movieImageView.contentMode = .Top
            movieImageView.clipsToBounds = true
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
        let releaseDateLabel = UILabel(frame: CGRect(x: 0, y: movieImageView.frame.height +  ratingView.frame.height + 20, width: self.view.frame.width, height: 50))
        releaseDateLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        if let movieReleaseDate = self.moviewSelected?.releaseDate {
            releaseDateLabel.text = String(format: "Release date: %@",movieReleaseDate)
        }
        scrollView.addSubview(releaseDateLabel)
        
        //TrailerButton
        let viewTrailerButton = UIButton(frame: CGRect(x: 0, y: releaseDateLabel.frame.height + 30 + movieImageView.frame.height + ratingView.frame.height , width: self.view.frame.width, height: 50))
        viewTrailerButton.setTitle("View Trailer", forState: .Normal)
        scrollView.addSubview(viewTrailerButton)
        
        //SynopsisLabel
        let synopsisLabel = UILabel(frame: CGRect(x: 0, y: movieImageView.frame.height + releaseDateLabel.frame.height + viewTrailerButton.frame.height + ratingView.frame.height + 40 , width: self.view.frame.width, height: 300))
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
    
}
