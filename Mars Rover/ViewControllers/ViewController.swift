//
//  ViewController.swift
//  Mars Rover
//
//  Created by Wael Saad - r00tdvd on 6/19/19.
//  Copyright © 2019 NetTrinity. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let rover: Rover = Rover()
    private var instructions: String = String.empty
    
    @IBOutlet weak var startPositionTextfield: UITextField!
    @IBOutlet weak var finalPositionTextfield: UITextField!
    
    @IBOutlet weak var instructionsTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()

        // Ensure Provided Input and Output are working as expected. These are now also implemented in the Unit Tests
        print ("================================")

        rover.setPosition(x: 1, y: 2, orientation: Direction.North)
        rover.process(commands: "LMLMLMLMM")
        print (rover.x, rover.y, rover.position) // prints 1 3 N

        print ("================================")

        rover.setPosition(x: 3, y: 3, orientation: Direction.East)
        rover.process(commands: "MMRMMRMRRM")
        print (rover.x, rover.y, rover.position) /// prints 5 1 E

        print ("================================")
    }
    
    @IBAction func moveButtonTapped(_ sender: Any) {
        instructions += Instructions.M.rawValue
        instructionsTextfield.text = instructions
    }
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        instructions += Instructions.L.rawValue
        instructionsTextfield.text = instructions
    }
    
    @IBAction func rightButtonTapped(_ sender: Any) {
        instructions += Instructions.R.rawValue
        instructionsTextfield.text = instructions
    }
    
    @IBAction func executeButtonTapped(_ sender: Any) {
        
        executeInstructions()
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        instructions = String.empty
        startPositionTextfield.text = String.empty
        finalPositionTextfield.text = String.empty
        instructionsTextfield.text  = String.empty
    }
    
    func executeInstructions() {
        
        //        let string = "12N"
        //        let index = string.index (string.startIndex, offsetBy: 1)
        //        print (string [index])
        
        //
        //        if let positionText = startPositionTextfield.text {
        //            //let position = positionText.compactMap {Int(String($0))}
        //        }
        
        guard
            let positionText = startPositionTextfield.text, positionText.count == Constants.mximumNumberOfPositionCharacters,
            let x = Int(positionText[0]),
            let y = Int(positionText[1]),
            instructionsTextfield.text?.count != 0
            else {
                displayAlertMessage()
                return
        }
        
        rover.setPosition(x: x, y: y, orientation: rover.getOrientation(direction: positionText[2].uppercased()))
        rover.process(commands: instructions)
        finalPositionTextfield.text = rover.x.description + rover.y.description + rover.position
    }
    
    func displayAlertMessage() {
        let alert = UIAlertController(title: "Mars Rover Protection",
                                      message: "You must enter a value for the starting position in the form of (12N) and also some instructions for the rover",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler: nil))
        self.present(alert, animated: true)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        executeInstructions()
        textField.resignFirstResponder()
        return true
    }
    
    // You cannot type anymore than 3 characters
    // You must enter a digit for the first and the second characters
    // The third character must exists in this array ["N", "E", "S", "W"]
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.count == 0 {
            return true
        }
        
        if range.location == 0 || range.location == 1 {
            guard let _ = Int(string) else { return false }
        }
        
        if range.location == 2 {
            return Constants.orientations.contains(string.uppercased()) ? true : false
        }
        
        return range.location < Constants.mximumNumberOfPositionCharacters
    }
}
