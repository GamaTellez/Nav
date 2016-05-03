//
//  MovieDetailVC.swift
//  Nav
//
//  Created by Gamaliel Tellez on 5/2/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

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
        
        let movieImageView = UIImageView(frame: CGRect(x: 0, y:0, width: self.view.frame.width, height: 400))
        movieImageView.contentMode = UIViewContentMode.Redraw
        if let movieImage = self.moviewSelected?.image {
            movieImageView.image = movieImage
        }
        scrollView.addSubview(movieImageView)
        
        let releaseDateLabel = UILabel(frame: CGRect(x: 0, y: movieImageView.frame.height + 10, width: self.view.frame.width, height: 50))
        releaseDateLabel.backgroundColor = UIColor.greenColor()
        if let movieReleaseDate = self.moviewSelected?.releaseDate {
            releaseDateLabel.text = String(format: "Release date: %@",movieReleaseDate)
        }
        scrollView.addSubview(releaseDateLabel)
        
        let viewTrailerButton = UIButton(frame: CGRect(x: 0, y: releaseDateLabel.frame.height + 20 + movieImageView.frame.height, width: self.view.frame.width, height: 50))
        viewTrailerButton.setTitle("View Trailer", forState: .Normal)
        viewTrailerButton.backgroundColor = UIColor.blueColor()
        scrollView.addSubview(viewTrailerButton)
       
        let synopsisLabel = UILabel(frame: CGRect(x: 0, y: movieImageView.frame.height + 10 + releaseDateLabel.frame.height + viewTrailerButton.frame.height + 10 , width: self.view.frame.width, height: 300))
        if let movieSummary = self.moviewSelected?.overView {
            synopsisLabel.text = String(format: "Synopsys:\n\n %@", movieSummary)
            synopsisLabel.numberOfLines = 0
            synopsisLabel.textAlignment = .Center
        }
        scrollView.addSubview(synopsisLabel)
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: movieImageView.frame.height + releaseDateLabel.frame.height + viewTrailerButton.frame.height + synopsisLabel.frame.height + 30)

    }
    
}
