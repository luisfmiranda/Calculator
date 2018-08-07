import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet private weak var display: UILabel!
    
    private var userIsTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        if let digit = sender.currentTitle {
            if userIsTyping {
                let textCurrentlyInDisplay = display.text!
                display.text = textCurrentlyInDisplay + digit
            } else {
                display.text = digit
                userIsTyping = true
            }
        }
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var calculator = Calculator()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsTyping {
            calculator.setOperand(displayValue)
            userIsTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
           calculator.performOperation(mathematicalSymbol)
        }
        
        if let result = calculator.result {
            displayValue = result
        }
    }
}
