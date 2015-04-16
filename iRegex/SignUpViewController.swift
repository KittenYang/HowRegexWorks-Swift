//
//  SignUpViewController.swift
//  iRegex
//
//  Created by James Frost on 13/10/2014.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class SignUpViewController: UITableViewController {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var middleInitialField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    
    var textFields: [UITextField]!
    var regexes: [NSRegularExpression?]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func validateTextField(textField: UITextField) {
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        for textField in textFields {
            validateTextField(textField)
            textField.resignFirstResponder()
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.textColor = UIColor.blackColor()
        doneButton.enabled = true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        validateTextField(textField)
        doneButton.enabled = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        validateTextField(textField)
        
        makeNextTextFieldFirstResponder(textField)
        
        return true
    }
    
    func makeNextTextFieldFirstResponder(textField: UITextField) {
        textField.resignFirstResponder()

        if var index = find(textFields, textField) {
            index++
            if index < textFields.count {
                textFields[index].becomeFirstResponder()
            }
        }
    }
}

extension UIColor {
    class func trueColor() -> UIColor {
        return UIColor(red: 0.1882, green:0.6784, blue:0.3882, alpha:1.0)
    }
    
    class func falseColor() -> UIColor {
        return UIColor(red:0.7451, green:0.2275, blue:0.1922, alpha:1.0)
    }
}

