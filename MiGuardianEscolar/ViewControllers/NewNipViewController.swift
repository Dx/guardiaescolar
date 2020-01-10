//
//  NewNipViewController.swift
//  MiGuardianEscolar
//
//  Created by Dx on 09/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import UIKit

class NewNipViewController: UIViewController {

    @IBOutlet weak var firstNip: UITextField!
    @IBOutlet weak var secondNip: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.firstNip.keyboardType = UIKeyboardType.numberPad
        self.secondNip.keyboardType = UIKeyboardType.numberPad
        
        self.firstNip.becomeFirstResponder()
    }
    
    @IBAction func registerNipClick(_ sender: Any) {
        // Valida que sean iguales
        if firstNip.text == secondNip.text {
        
            // Valida que sean de 4 dígitos
            if firstNip.text?.count == 4 {
                // Registra el NIP
                let defaults = UserDefaults.standard
                defaults.set(firstNip.text!, forKey: defaultsKeys.nip)
                
                // Regresa al menú para validar login
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: .needsToValidateLogin, object: nil)
            }
        }
    }
}
