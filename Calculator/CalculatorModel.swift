//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Neil White on 30/10/16.
//  Copyright © 2016 Neil White. All rights reserved.
//

// Never import UIKit into a Model

import Foundation

class CalculatorModel {
    //funcs are the methods of the class
    
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    // could implement a switch case, but a generic function would be better
    
    //a dictional to hold constants and operation, much like Python
    //Operation is defined in an enum below
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI), // here M_PI is associated with the enum Constant in Operation
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "−" : Operation.BinaryOperation({ $0 - $1 }),
        "=" : Operation.Equals
    ]

    private enum Operation {
        case Constant(Double)
        case UnaryOperation ( (Double) -> Double) //associated value is a function that takes a Double and returns a Double
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation { // don't need a default for this switch because all the possiblecases in the enum are accounted for
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
                
            }
        }
    }
    
    private func executePendingBinaryOperation()
    {
        if pending != nil { // is there is a pending operation
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
        periodEntered = false
    }
    
    
    private var pending: PendingBinaryOperationInfo? // created as an optional as BinaryOperation may not have been called
    
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double  // automagically initialised in structs
        var firstOperand: Double
    }
    
    var result: Double { // computed property, cannot be set, only get in this case
        get {
            return accumulator
        }
    }
}
