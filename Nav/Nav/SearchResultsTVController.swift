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
        if let cell = tableView.dequeueReusableCellWithIdentifier(self.cellID) {
            let movieAtIndex = movieResults[indexPath.row]
            if let movieTitle = movieAtIndex.title {
                cell.textLabel?.text = movieTitle
                cell.textLabel?.textAlignment = NSTextAlignment.Center
            } else {
                cell.textLabel?.text = "No title available"
            }
            if let movieOverview = movieAtIndex.overView {
                cell.detailTextLabel?.text = movieOverview
                cell.detailTextLabel?.textAlignment = NSTextAlignment.Justified
                cell.detailTextLabel?.numberOfLines = 3
                cell.detailTextLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
            } else {
                cell.detailTextLabel?.text = "No overview available"
            }
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 280
    }
    
}
