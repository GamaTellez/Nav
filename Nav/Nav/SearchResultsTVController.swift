//
//  SearchResultsTVController.swift
//  Nav
//
//  Created by Gamaliel Tellez on 5/2/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

class SearchResultsTVController: UITableViewController {
    var movieResults:[Movie] = []
    let cellID = "movieCell"
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieResults.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(self.cellID) as? MovieCell {
            let movieAtIndex = movieResults[indexPath.row]
            if let movieTitle = movieAtIndex.title {
                cell.movieTitleLabel.text = movieTitle
            } else {
                cell.movieTitleLabel.text = "No title available"
            }
            if let movieOverview = movieAtIndex.overView {
                cell.moviewOverviewLabel.text = movieOverview
            } else {
                cell.moviewOverviewLabel.text = "No overview available"
            }
            if let image = movieAtIndex.image {
                cell.movieImage.image = image
            }
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
}
