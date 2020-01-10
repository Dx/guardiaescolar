//
//  ViewController.swift
//  MiGuardianEscolar
//
//  Created by Dx on 09/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(validateLogin), name: .needsToValidateLogin, object: nil)
        
        validateLogin()
    }
    
    @objc func validateLogin() {
        // Valida si ya tiene código de verificación
        let defaults = UserDefaults.standard
        if let verificationCode = defaults.string(forKey: defaultsKeys.verificationCode) {
            print("Este es el código que ya se tiene: \(verificationCode)")
            if let nip = defaults.string(forKey: defaultsKeys.nip) {
                print("Este es el nip: \(nip)")
                performSegue(withIdentifier: "validateNIP", sender: self)
            } else {
                performSegue(withIdentifier: "askNewNIP", sender: self)
            }
        } else {
            // Si no lo tiene todavía se solicita
            performSegue(withIdentifier: "showVerificationCode", sender: self)
        }
    }
}

