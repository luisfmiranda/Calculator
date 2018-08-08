import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet private weak var display: UILabel!
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = newValue.cleanValue
        }
    }
    
    private var calculator = Calculator()
    private var userIsTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        if let digit = sender.currentTitle {
            if userIsTyping {
                if digit == "." && display.text!.contains(".") { return }
                
                let textCurrentlyInDisplay = display.text!
                display.text = textCurrentlyInDisplay + digit
            } else {
                if digit == "0" { return }
                
                if digit == "." {
                    display.text = "0."
                } else {
                    display.text = digit
                }
            }
            
            userIsTyping = true
        }
    }
    
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
    
    @IBAction func touchEraseButton(_ sender: UIButton) {
        if display.text!.count > 1 {
            display.text!.removeLast()
        } else {
            display.text = "0"
        }
        
        if display.text! == "0" {
            userIsTyping = false
        }
    }
    
    @IBAction func touchClearButton(_ sender: UIButton) {
        calculator = Calculator()
        display.text = "0"
        userIsTyping = false
    }
}

extension Double {
    var cleanValue: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.maximumFractionDigits = 6
        let formattedValue = numberFormatter.string(from: self as NSNumber)!
        
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : formattedValue
    }
}

