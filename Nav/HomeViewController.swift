//
//  HomeViewController.swift
//  Nav
//
//  Created by Gamaliel Tellez on 5/1/16.
//  Copyright © 2016 Gamaliel Tellez. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    lazy var storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    
    override func viewDidLoad() {
        self.buttonSetUp(self.searchButton)
        self.textFieldSetup(self.searchTextField)
    }
    
    func buttonSetUp(searchButton:UIButton) {
        searchButton.enabled = false
        searchButton.layer.cornerRadius = 10
        searchButton.layer.borderWidth = 1
        searchButton.setTitle("Search", forState: .Normal)
        searchButton.setTitle("Searching...", forState: .Selected)

    }
    
    func textFieldSetup(searchTextField:UITextField) {
        searchTextField.addTarget(self, action: #selector(HomeViewController.textFieldTextChanged(_:)), forControlEvents: .EditingChanged)
    }
    
    func textFieldTextChanged(textField:UITextField) {
        if let textFieldText = textField.text {
            if textFieldText.isEmpty {
                self.searchButton.enabled = false
                self.searchButton.setTitle("Search", forState: .Normal)
            } else {
                self.searchButton.enabled = true
            }
        }
    }
    
    @IBAction func searchButtonTapped(sender: UIButton) {
        self.searchButton.setTitle("Searching..", forState: .Normal)
        if let textToSearch = self.searchTextField.text {
            MovieDBController.apiController.newMovieSearch(with: textToSearch, completion: { (result) in
                    if result.isKindOfClass(NSError) {
                        if let resultError = result as? NSError {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.alertViewController("Oops, something went wrong!", message: resultError.localizedDescription, actionTitle: "Continue")
                            })
                        }
                    } else if result.isKindOfClass(NSHTTPURLResponse) {
                        if let resultResponse = result as? NSHTTPURLResponse {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.alertViewController("Oops, something went wrong", message: String(format: "Error: %d", resultResponse.statusCode), actionTitle: "Continue")
                            })
                        }
                    } else {
                       if let resultsDictionary = result.objectForKey("results") as? [NSDictionary] {
                            let moviesFound = self.createMovieObjects(from: resultsDictionary)
                            if moviesFound.count == 0 {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.alertViewController("No movies found", message: "Please try again for a different title", actionTitle: "Continue")
                                })
                            } else {
                                if let searchResultsVC = self.storyBoard.instantiateViewControllerWithIdentifier("resultsVC") as? SearchResultsTVController {
                                    searchResultsVC.movieResults = moviesFound
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.navigationController?.pushViewController(searchResultsVC, animated: true)
                                    })
                                }
                        }
                    }
                }
            })
        }
    }
    
    func createMovieObjects(from resultsDictionary:[NSDictionary]) -> [Movie] {
        var movies:[Movie] = []
        for dictionary in resultsDictionary {
            let newMovie = Movie(from: dictionary)
            movies.append(newMovie)
        }
        return movies
    }
    
    func alertViewController(title:String, message:String, actionTitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .Default, handler: nil))
        self.navigationController?.presentViewController(alert, animated: true, completion: nil)
    }
}
