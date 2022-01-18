//
//  ViewController.swift
//  Tip Calculator
//
//  Created by Robert Reyes-Enamorado on 1/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var billAmountLabel: UILabel!
    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var partySizeStepper: UIStepper!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var partySizeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var splitPerPersonLabel: UILabel!
    @IBOutlet weak var splitLabel: UILabel!
    @IBOutlet weak var roundControl: UISegmentedControl!
    
    let defaults = UserDefaults.standard
    
    var tipValue:Double?
    var totalValue:Double?
    var splitValue:Double?
    
    var currency = ""
    var tipPercentage = 0.0
    var defaultBillAmount:String?
    
    var calculationDate:NSDate?
    var expirationDate:NSDate?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        currencyBasedOnRegion()
        
        // Change text field placeholder text & summon keyboard on start
        billAmountTextField.placeholder = currency
        billAmountTextField.becomeFirstResponder()
       
        // Apply defaults for segmented controls
        tipControl.selectedSegmentIndex = defaults.integer(forKey: "%")
        roundControl.selectedSegmentIndex = defaults.integer(forKey: "Round")
        defaultTip()
        rememberBillAmount()

        
        // Edit stepper increment and decrement image colors
        partySizeStepper.setDecrementImage(partySizeStepper.decrementImage(for: .normal), for: .normal)
        partySizeStepper.setIncrementImage(partySizeStepper.incrementImage(for: .normal), for: .normal)
        
        calculateTip(Any.self)
    }
    
    func currencyBasedOnRegion() {
        
        // Get the current region
        let userLocation = Locale.current.regionCode
        
        // Change the currency based on the region
        switch userLocation {
            
            case "FR", "DE", "IE", "NL", "PT", "ES":
                currency = "€"
                break
                
            case "GB":
                currency = "£"
                break
        
            case "JP", "CN":
                currency = "¥"
                break
                
            default:
                currency = "$"
        }
    }
    
    func rememberBillAmount() {
        
        // Assign dates to constants
        let currentDate = NSDate()
        let expireDate:NSDate = defaults.object(forKey: "Expiration") as! NSDate
        
        // Calculate which date is later
        if currentDate.laterDate(expireDate as Date) == currentDate as Date {
            
            // Executes if time expired
            billAmountTextField.text = ""
            partySizeStepper.value = 1
            
        } else {
            
            // Exececutes if time has not expired
            billAmountTextField.text = defaults.string(forKey: "Bill")
            partySizeStepper.value = Double(defaults.integer(forKey: "Party"))
        }
    }
    
    func defaultTip() {
        
        let tipIndex = defaults.integer(forKey: "%")
        
        switch tipIndex {
            
            case 1:
                tipPercentage = 0.18
                break
            
            case 2:
                tipPercentage = 0.20
                break
        
            default:
                tipPercentage = 0.15
        }
    }
    
    @IBAction func calculateTip(_ sender: Any) {
                
        // Get bill amount from text field input
        let bill = Double(billAmountTextField.text!) ?? 0
        
        // Calculate required values
        tipValue = bill * tipPercentage
        totalValue = bill + tipValue!
        
        // Use stepper & calculate Split Per Person
        let size = Int(partySizeStepper.value)
        splitValue = (totalValue ?? 0)/Double(size)

        // Update the Party Size, Tip Amount, & Total labels
        partySizeLabel.text = String(size)
        tipAmountLabel.text = String(format: "\(currency)%.2f", tipValue!)
        totalLabel.text = String(format: "\(currency)%.2f", totalValue!)
        
        roundSplitValue(partySize: size)
        
        // Update Split Amount label
        splitLabel.text = String(format: "\(currency)%.2f", splitValue!)
        
        displayAnimations()
        
        // Set Calculation Date & an Expiration Date for 10 minutes later
        calculationDate = NSDate()
        expirationDate = calculationDate?.addingTimeInterval(600)
        
        // Save the Expriation Date, Bill Amount, and Party Size
        defaults.set(expirationDate, forKey: "Expiration")
        defaults.set(billAmountTextField.text, forKey: "Bill")
        defaults.set(partySizeStepper.value, forKey: "Party")

        defaults.synchronize()
    }
    
    @IBAction func didMoveTipContol(_ sender: Any) {
        
        let index = tipControl.selectedSegmentIndex
        
        // Store Tip Percentage based on index value
        switch index {
            
            case 1:
                tipPercentage = 0.18
                break
            
            case 2:
                tipPercentage = 0.20
                break
            
            default:
                tipPercentage = 0.15
        }
        
        calculateTip(Any.self)
    }
    
    func roundSplitValue (partySize: Int) {
        
        // Rounding
        if roundControl.selectedSegmentIndex == 1 {
            
            splitValue = (totalValue ?? 0)/Double(partySize)
            
        } else if roundControl.selectedSegmentIndex == 2 {
            
            splitValue = (totalValue ?? 0)/Double(partySize)
            splitValue = splitValue!.rounded(.up)
               
        } else {
            
            splitValue = (totalValue ?? 0)/Double(partySize)
            splitValue = splitValue!.rounded(.down)
        }
    }

    func DarkModeEditor() {
        
        let boolValue = defaults.bool(forKey: "Dark Mode")
        
        // Toggle Dark Mode or Default Mode
        if boolValue == true {
            
            self.navigationController?.navigationBar.barStyle = .black
            self.view.backgroundColor = .black
            
            titleLabel.textColor = .white

            billAmountTextField.textColor = .white
            billAmountTextField.keyboardAppearance = .dark
            billAmountTextField.attributedPlaceholder = NSAttributedString(string: currency, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightText])

            billAmountLabel.textColor = .white
            tipLabel.textColor = .white
            partyLabel.textColor = .white
            total.textColor = .white
            tipAmountLabel.textColor = .white
            partySizeLabel.textColor = .white
            totalLabel.textColor = .white
            splitPerPersonLabel.textColor = .white
            
            tipControl.backgroundColor = .secondaryLabel
            tipControl.selectedSegmentTintColor = .systemGreen
            tipControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
            
            roundControl.backgroundColor = .secondaryLabel
            roundControl.selectedSegmentTintColor = .systemGreen
            roundControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
            
            partySizeStepper.backgroundColor = .secondaryLabel
            partySizeStepper.tintColor = .white
            
        } else if boolValue == false{
            
            self.navigationController?.navigationBar.barStyle = .default
            self.view.backgroundColor = .systemBackground
            
            titleLabel.textColor = .black
            
            billAmountTextField.textColor = .black
            billAmountTextField.keyboardAppearance = .light
            billAmountTextField.attributedPlaceholder = NSAttributedString(string: currency, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            
            billAmountLabel.textColor = .black
            tipLabel.textColor = .black
            partyLabel.textColor = .black
            total.textColor = .black
            tipAmountLabel.textColor = .black
            partySizeLabel.textColor = .black
            totalLabel.textColor = .black
            splitPerPersonLabel.textColor = .black
            
            tipControl.selectedSegmentTintColor = .systemGreen
            tipControl.backgroundColor = .systemBackground
            tipControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.normal)
            
            roundControl.selectedSegmentTintColor = .systemGreen
            roundControl.backgroundColor = .systemBackground
            roundControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.normal)
            
            partySizeStepper.backgroundColor = .systemGray6
            partySizeStepper.tintColor = .black
        }
    }
    
    func displayAnimations() {
        
        UIView.animate(withDuration: 0.05, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0 ,animations: {
            
            self.splitLabel.center = CGPoint(x: 274, y:446+2)

            }, completion: nil)
        
        UIView.animate(withDuration: 0.05, delay: 0.05, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, animations: {
            
            self.splitLabel.center = CGPoint(x: 274, y:446-2)
            
            }, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        DarkModeEditor()
        tipControl.selectedSegmentIndex = defaults.integer(forKey: "%")
        roundControl.selectedSegmentIndex = defaults.integer(forKey: "Round")
        defaultTip()
        calculateTip(Any.self)
    }
}
