//
//  UserCodeViewController.swift
//  MiGuardianEscolar
//
//  Created by Dx on 09/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import UIKit

class UserCodeViewController: UIViewController {

    @IBOutlet weak var verificationCode: UITextField!
    @IBOutlet weak var labelError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        verificationCode.becomeFirstResponder()
    }
    
    @IBAction func validateClick(_ sender: Any) {
        
        labelError.isHidden = true
        
        if validations() {
            
            //Revisa si es un código válido contra el web service
            let client = SoapClient()
            client.sendCode(code: verificationCode.text!, completion: {(result: String?, error: String?) in
                if result != nil {
                    // Registra el código
                    let defaults = UserDefaults.standard
                    defaults.set(self.verificationCode.text, forKey: defaultsKeys.verificationCode)
                    
                    //Guarda el IdEmpresa en la BD
                    //TODO
                    
                    //Cierra la ventana actual y avisa al Menu que valide login
                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: .needsToValidateLogin, object: nil)
                } else {
                    if error != nil {
                        DispatchQueue.main.async {
                            self.labelError.isHidden = false
                            self.labelError.text = error
                        }
                    }
                }
            })
        }
    }
    
    func validations() -> Bool {
        if var code = verificationCode.text {
            code = code.trimmingCharacters(in:
                .whitespacesAndNewlines
            )
            if code != "" {
                verificationCode.text = code
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
