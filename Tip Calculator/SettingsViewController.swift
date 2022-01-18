//
//  SettingsViewController.swift
//  Tip Calculator
//
//  Created by Robert Reyes-Enamorado on 1/10/22.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var middleView2: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var defaultPercentageControl: UISegmentedControl!
    @IBOutlet weak var defaultRoundingControl: UISegmentedControl!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let boolValue = defaults.bool(forKey: "Dark Mode")
        // Apply defaults
        defaultPercentageControl.selectedSegmentIndex = defaults.integer(forKey: "%")
        defaultRoundingControl.selectedSegmentIndex = defaults.integer(forKey: "Round")
            
        // Determine whether switch is on or off on load
        if boolValue == true {
            darkModeSwitch.isOn = true
        }
        else {
            darkModeSwitch.isOn = false
        }
        toggledSwitch(Any.self)
    }
            
    @IBAction func toggledSwitch(_ sender: Any) {
        
        if darkModeSwitch.isOn == true {
            
            self.navigationController?.navigationBar.barStyle = .black
            
            // Change color of screen & views
            topView.backgroundColor = .black
            middleView.backgroundColor = .black
            middleView2.backgroundColor = .black
            bottomView.backgroundColor = .black
            let darkBackground = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 1.0)
            view.backgroundColor = darkBackground
            
            // Change the text color
            titleLabel.textColor = .white
            darkModeLabel.textColor = .white
            
            // Change Segmented Control style
            defaultPercentageControl.backgroundColor = .secondaryLabel
            defaultPercentageControl.selectedSegmentTintColor = .systemGreen
            defaultPercentageControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
            defaultRoundingControl.backgroundColor = .secondaryLabel
            defaultRoundingControl.selectedSegmentTintColor = .systemGreen
            defaultRoundingControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
    
            // Store the dark mode settings settings
            defaults.set(true, forKey: "Dark Mode")
        }
        else {

            self.navigationController?.navigationBar.barStyle = .default

            // Change background of screen and views
            topView.backgroundColor = .systemGray6
            middleView.backgroundColor = .systemGray6
            middleView2.backgroundColor = .systemGray6
            bottomView.backgroundColor = .systemGray6
            view.backgroundColor = .systemBackground
            
            // Change the text color
            titleLabel.textColor = .black
            darkModeLabel.textColor = .black
           
            // Change Segmented Control style
            defaultPercentageControl.selectedSegmentTintColor = .systemGreen
            defaultPercentageControl.backgroundColor = .systemGray6
            defaultPercentageControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.normal)
            defaultRoundingControl.selectedSegmentTintColor = .systemGreen
            defaultRoundingControl.backgroundColor = .systemGray6
            defaultRoundingControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.normal)
                
            // Store the Default Mode settings
            defaults.set(false, forKey: "Dark Mode")
        }
        
        defaults.synchronize()
    }
    
    @IBAction func defaultPercentageChanged(_ sender: Any) {
           
        // Save the default percent settings
        defaults.set(defaultPercentageControl.selectedSegmentIndex, forKey: "%")
        defaults.synchronize()
    }

    @IBAction func defaultRoundingChanged(_ sender: Any) {
        
        // Save the default rounding settings
        defaults.set(defaultRoundingControl.selectedSegmentIndex, forKey: "Round")
        defaults.synchronize()
    }
}
