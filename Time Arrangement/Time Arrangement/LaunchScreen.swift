//
//  LaunchScreen.swift
//  Time Arrangement
//
//  Created by sunan xiang on 2020/3/19.
//  Copyright © 2020 sunan xiang. All rights reserved.
//

import Foundation
import UIKit

class LaunchScreen: UIViewController {
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var build: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    /* property*/
    var autoDismiss = false
    
    //
    // MARK: - Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        self.version.text = "version: \(appVersion)"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        self.build.text = "build: \(build)"
        self.continueButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        setupUIDesign()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.autoDismiss {
            self.continueButton.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    func setupUIDesign() {
        // button
        self.continueButton.layer.cornerRadius = 5
        self.continueButton.layer.shadowColor = UIColor.gray.cgColor
        self.continueButton.layer.shadowOpacity = 0.5
        self.continueButton.layer.shadowOffset = .zero
        self.continueButton.layer.shadowRadius = 5
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
