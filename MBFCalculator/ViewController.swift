//
//  ViewController.swift
//  MBFCalculator
//
//  Created by Lucas Baggio Figueira on 22/10/16.
//  Copyright © 2016 Sci4Tech. All rights reserved.
//

import UIKit

enum OperatorFunctions {
    case Binary(String,(Double,Double)->Double)
    case Unary(String,(Double)->Double)
    
    var description: String {
        get {
            switch self {
            case .Binary(let symbol, _):
                return symbol
            case .Unary(let symbol, _):
                return symbol
            }
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var displayText: UILabel!
    
    var isUserTyping = false
    
    var operands = [Double]()
    
    var operators = [String:OperatorFunctions]()
    
    var displayValue: Double {
        get {
            return Double(displayText.text!)!
        }
        set {
            displayText.text = "\(newValue)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        func initOperator(_ opFunc: OperatorFunctions) {
            operators[opFunc.description] = opFunc
        }
        
        initOperator(.Binary("+", +))
        initOperator(.Binary("−") { $1 - $0 })
        initOperator(.Binary("×", *))
        initOperator(.Binary("÷") { $1 / $0 })
        initOperator(.Unary("√", sqrt))
        initOperator(.Unary("±") { -$0 })
        initOperator(.Binary("%") { $1 * ($0 / 100) })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func appendDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if digit == "∙" && displayText.text!.contains(".") && isUserTyping {
            return
        }
        
        if isUserTyping {
            if digit == "∙" {
                displayText.text! += "."
            } else {
                displayText.text! += digit
            }
        } else {
            if digit == "∙" {
                displayText.text! = "0."
            } else {
                displayText.text! = digit
            }
            isUserTyping = true
        }
    }

    @IBAction func enter() {
        operands.append(displayValue)
        isUserTyping = false
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        let op = sender.currentTitle!
        
        if isUserTyping {
            enter()
        }

        if let oper = operators[op] {
            switch oper {
            case .Binary(_, let opFunc):
                if operands.count >= 2 {
                    displayValue = opFunc(operands.removeLast(),operands.removeLast())
                }
            case .Unary(_, let opFunc):
                if operands.count >= 1 {
                    displayValue = opFunc(operands.removeLast())
                }
            }
            
            enter()
        }
        
    }
    
    @IBAction func reset() {
        operands.removeAll()
        displayValue = 0.0
        isUserTyping = false
    }
}

