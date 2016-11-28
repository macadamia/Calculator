//
//  ViewController.swift
//  Calculator
//
//  Created by Neil White on 29/10/16.
//  Copyright © 2016 Neil White. All rights reserved.
//

import UIKit  // this is a default module for Views, that contains the Classes for Buttons, Text etc etc

var periodEntered = false

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel! //when declaring, use ! as it's implied because the label will be set and add private
    
    
    
    private var userIsInTheMiddleOfTyping = false // doesn't need a type bcause it's inferred from false
    private var tickerTapeDisplay = ""
    
    private var displayValue: Double {
        //commputed property
        get {
            return Double(display.text!)! // will crash the app if display.text can't be converted, which is OK
        }
        set {
            display.text = String(newValue)
            tickerTapeDisplay = tickerTapeDisplay + String(newValue)
            displayTape.text = tickerTapeDisplay
        }
    }
    
    @IBOutlet weak var displayTape: UILabel!
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        //there can only be 1 period entered
        if digit == "." {
            if !periodEntered {
                periodEntered = true
            } else {
                return // ignore keypress
            }
        }
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
            tickerTapeDisplay = tickerTapeDisplay + digit
            displayTape.text = tickerTapeDisplay
        } else {
            if display.text! == "0" && periodEntered {
                display.text = "0."
                tickerTapeDisplay = tickerTapeDisplay + "0."
                displayTape.text = tickerTapeDisplay
            } else {
                display.text = digit
                tickerTapeDisplay = tickerTapeDisplay + digit
                displayTape.text = tickerTapeDisplay
            }
        }
        userIsInTheMiddleOfTyping = true
    }

    var savedProgram: CalculatorModel.PropertyList?
    
    @IBAction func save() {
        savedProgram = calculator.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            calculator.program = savedProgram!
            displayValue = calculator.result
        }
    }
    
    
    private var calculator = CalculatorModel() // this allows us to talk to the model, easily


    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            calculator.setOperand(operand: displayValue)
            tickerTapeDisplay = tickerTapeDisplay + String(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            tickerTapeDisplay = tickerTapeDisplay + " " + mathematicalSymbol
            displayTape.text = tickerTapeDisplay
            calculator.performOperation(symbol: mathematicalSymbol)
            
        }
        displayValue = calculator.result
    }
    
}
