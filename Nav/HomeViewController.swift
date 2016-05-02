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
    
    
    override func viewDidLoad() {
        self.buttonSetUp(self.searchButton)
        self.textFieldSetup(self.searchTextField)
    }
    
    func buttonSetUp(searchButton:UIButton) {
        searchButton.enabled = false
        searchButton.layer.cornerRadius = 10
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
            } else {
                self.searchButton.enabled = true
            }
        }
    }
    
    @IBAction func searchButtonTapped(sender: UIButton) {
        sender.selected = true
        
    }

}
