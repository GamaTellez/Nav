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
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieResults.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //if let cell = tableView.dequeueReusableCellWithIdentifier(self.cellID) as? MovieCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(self.cellID, forIndexPath: indexPath) as? MovieCell {
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
            cell.movieImage.image = UIImage(named: "film")
            if let imageURL = movieAtIndex.urlForImage {
                //cell.movieImage.image = image
                //set the image holder temporaly until the actual picture is obtained
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { 
                        if let imageData = NSData(contentsOfURL: imageURL) {
                            if let movieImage = UIImage(data: imageData) {
                                dispatch_async(dispatch_get_main_queue(), {
                                  cell.movieImage.image = movieImage
                                })
                            }
                        }
                    })
                    } else {
                }
            return cell
        } else {
            return UITableViewCell()
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueID = segue.identifier {
            if segueID == "movieDetail" {
                if let movieDetailVC = segue.destinationViewController as? MovieDetailVC {
                    if let rowTapped = self.tableView.indexPathForSelectedRow?.row {
                        let movieTapped = self.movieResults[rowTapped]
                        movieDetailVC.moviewSelected = movieTapped
                    } else {
                        let alert = UIAlertController(title: "Oops!", message: "There was an error with the selected moview, please forgive us!", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: nil))
                        self.navigationController?.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
}

