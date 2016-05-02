//
//  MovieCell.swift
//  Nav
//
//  Created by Gamaliel Tellez on 5/2/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet var movieImage: UIImageView!
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var moviewOverviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.movieTitleLabel.textAlignment = .Left
        self.movieTitleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        self.moviewOverviewLabel.numberOfLines = 3
        self.moviewOverviewLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        self.moviewOverviewLabel.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 16)
    }
    
    

}
