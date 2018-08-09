import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet private weak var display: UILabel!
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.attributedText = configureText(newValue.cleanValue, for: "display")
        }
    }
    
    @IBOutlet weak var operationDescriptionLabel: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    
    private var calculator = Calculator()
    private var userIsTyping = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        display.attributedText = configureText("0", for: "display")
        operationDescriptionLabel.attributedText = configureText("0", for: "operationDescription")
        
        for button in buttons {
            let oldTitle = button.title(for: UIControl.State.normal)!
            let newTitle = configureText(oldTitle, for: "button")
            button.setAttributedTitle(newTitle, for: UIControl.State.normal)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        display.attributedText = configureText((display.attributedText?.string)!, for: "display")
        operationDescriptionLabel.attributedText = configureText("0", for: "operationDescription")
        
        for button in buttons {
            let oldTitle = button.title(for: UIControl.State.normal)!
            let newTitle = configureText(oldTitle, for: "button")
            button.setAttributedTitle(newTitle, for: UIControl.State.normal)
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        if let digit = sender.currentTitle {
            if userIsTyping {
                if digit == "." && display.text!.contains(".") { return }
                
                let textCurrentlyInDisplay = display.text!
                display.attributedText = configureText(textCurrentlyInDisplay + digit, for: "display")
            } else {
                if digit == "0" { return }
                
                if digit == "." {
                    display.attributedText = configureText("0.", for: "display")
                } else {
                    display.attributedText = configureText(digit, for: "display")
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
            display.attributedText = configureText(display.text!, for: "display")
        } else {
            display.attributedText = configureText("0", for: "display")
        }
        
        if display.text! == "0" {
            userIsTyping = false
        }
    }
    
    @IBAction func touchClearButton(_ sender: UIButton) {
        calculator = Calculator()
        display.attributedText = configureText("0", for: "display")
        userIsTyping = false
    }
    
    private func configureText(_ string: String, for labelType: String) -> NSAttributedString {
        let fontSize = SizeRatios.fontSizeOffset + view.bounds.height * SizeRatios.fonts[labelType]!
        
        let fontWeight: UIFont.Weight
        if labelType != "button" {
            fontWeight = .thin
        } else if string != "." {
            fontWeight = .light
        } else {
            fontWeight = .regular
        }
        
        let font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        let paragraphStyle = NSMutableParagraphStyle()
        let foregroundColor: UIColor
        
        if labelType == "display" || labelType == "operationDescription" {
            paragraphStyle.alignment = .right
            foregroundColor = UIColor.white
        } else {
            paragraphStyle.alignment = .center
            
            if Array(0...9).map( { String($0) }).contains(string) || string == "." {
                foregroundColor = UIColor.white
            } else if ["C", "⤺", "⌫"].contains(string) {
                foregroundColor = #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.5529411765, alpha: 1)
            } else {
                foregroundColor = #colorLiteral(red: 0.3803921569, green: 0.6156862745, blue: 0.9254901961, alpha: 1)
            }
        }
        
        return NSAttributedString(string: string, attributes: [.font: font, .paragraphStyle: paragraphStyle,
                                                               .foregroundColor: foregroundColor])
    }
}

private struct SizeRatios {
    static let fontSizeOffset: CGFloat = 6
    static let fonts: [String: CGFloat] = [
        "display": 0.08,
        "operationDescription": 0.05,
        "button": 0.03
    ]
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

