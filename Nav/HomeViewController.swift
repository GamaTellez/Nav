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
    var storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    var searchingView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        self.buttonSetUp(self.searchButton)
        self.textFieldSetup(self.searchTextField)
    }
    
    func buttonSetUp(searchButton:UIButton) {
        searchButton.enabled = false
        searchButton.layer.cornerRadius = 10
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.grayColor().CGColor
        searchButton.setTitle("Search", forState: .Normal)
    }
    
    func textFieldSetup(searchTextField:UITextField) {
        searchTextField.addTarget(self, action: #selector(HomeViewController.textFieldTextChanged(_:)), forControlEvents: .EditingChanged)
        searchTextField.returnKeyType = .Go
        let toolBar = UIToolbar()
        toolBar.translucent = true
        let cancelButton = UIBarButtonItem(title: "Cancel", style:.Done , target: self, action: #selector(HomeViewController.dismissKeyboard))
        toolBar.setItems([cancelButton], animated: false)
        toolBar.sizeToFit()
        searchTextField.inputAccessoryView = toolBar
    }
    
    func dismissKeyboard() {
        if self.searchTextField.editing {
            self.searchTextField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.performSearch()
        return true
    }
    
    func textFieldTextChanged(textField:UITextField) {
        if let textFieldText = textField.text {
            if textFieldText.isEmpty {
                self.searchButton.enabled = false
                self.searchButton.layer.borderColor = UIColor.grayColor().CGColor
                self.searchButton.setTitle("Search", forState: .Normal)
            } else {
                self.searchButton.enabled = true
                self.searchButton.layer.borderColor = UIColor.blueColor().CGColor
            }
        }
    }
    
    @IBAction func searchButtonTapped(sender: UIButton) {
        self.performSearch()
           }
    
    func performSearch() {
        if self.searchTextField.editing {
            self.searchTextField.resignFirstResponder()
        }
        self.presentSearchingView()
        self.searchButton.setTitle("Searching...", forState: .Normal)
        self.searchButton.enabled = false
        if let textToSearch = self.searchTextField.text {
            MovieDBController.apiController.newMovieSearch(with: textToSearch, completion: { (result) in
                if result.isKindOfClass(NSError) {
                    if let resultError = result as? NSError {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.alertViewController("Oops, something went wrong!", message: resultError.localizedDescription, actionTitle: "Continue")
                            self.searchButton.setTitle("Search", forState: .Normal)
                        })
                    }
                } else if result.isKindOfClass(NSHTTPURLResponse) {
                    if let resultResponse = result as? NSHTTPURLResponse {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.alertViewController("Oops, something went wrong", message: String(format: "Error: %d", resultResponse.statusCode), actionTitle: "Continue")
                            self.searchButton.setTitle("Search", forState: .Normal)
                        })
                    }
                } else {
                    if let resultsDictionary = result.objectForKey("results") as? [NSDictionary] {
                        let moviesFound = self.createMovieObjects(from: resultsDictionary)
                        if moviesFound.count == 0 {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.alertViewController("No movies found", message: "Please try again for a different title", actionTitle: "Continue")
                                self.searchButton.setTitle("Search", forState: .Normal)
                            })
                        } else {
                            if let searchResultsVC = self.storyBoard.instantiateViewControllerWithIdentifier("resultsVC") as? SearchResultsTVController {
                                searchResultsVC.movieResults = moviesFound
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.navigationController?.pushViewController(searchResultsVC, animated: true)
                                    self.searchTextField.text = ""
                                    self.searchButton.setTitle("Search", forState: .Normal)
                                    self.searchButton.layer.borderColor = UIColor.grayColor().CGColor
                                    self.removeSearchingView()
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
        alert.addAction(UIAlertAction(title: actionTitle, style: .Default, handler: { (action:UIAlertAction) in
            self.removeSearchingView()
        }))
        self.navigationController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    func presentSearchingView() {
        self.searchingView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.searchingView.backgroundColor = UIColor.grayColor()
        self.searchingView.alpha = 0.7
        self.activityIndicator.center = self.searchingView.center
        self.activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        self.activityIndicator.startAnimating()
        self.searchingView.addSubview(self.activityIndicator)
        self.view.addSubview(self.searchingView)
    }
    
    func removeSearchingView() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
        self.searchingView.removeFromSuperview()
    }
    
}
