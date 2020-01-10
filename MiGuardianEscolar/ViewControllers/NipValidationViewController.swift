//
//  NipValidationViewController.swift
//  MiGuardianEscolar
//
//  Created by Dx on 09/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import UIKit

class NipValidationViewController: UIViewController {

    @IBOutlet weak var loginNip: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginNip.keyboardType = UIKeyboardType.numberPad
        self.loginNip.becomeFirstResponder()
    }
    
    @IBAction func loginClick(_ sender: Any) {
        
        // Valida que el nip sea el mismo que el guardado
        let defaults = UserDefaults.standard
        if let storedNip = defaults.string(forKey: defaultsKeys.nip) {
            if storedNip == loginNip.text {
                dismiss(animated: true, completion: nil)
            } else {
                // Muestra alerta
            }
        }
        
    }
}
