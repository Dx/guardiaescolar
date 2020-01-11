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
        let clientSOAP = SoapClient()
        let clientSQL = SQLiteClient()
        
        labelError.isHidden = true
        
        if validations() {
            //Revisa si es un código válido contra el web service
            
            let code = verificationCode.text!
            
            clientSOAP.sendCode(code: code, completion: {(result: String?, error: String?) in
                if result != nil {
                    // Registra el código
                    let defaults = UserDefaults.standard
                    defaults.set(code, forKey: defaultsKeys.verificationCode)
                    
                    // Guarda codigo en BD
                    clientSQL.addCodigo(codigo: code)
                    
                    // Obtiene la empresa del WS
                    clientSOAP.getEmpresa(idEmpresa: 1, completion: {(empresa: Empresa?, error: String?) in
                        if empresa != nil {
                            //Guarda el IdEmpresa en la BD
                            clientSQL.addEmpresa(empresa: empresa!)
                        }
                    })
                    
                    //Cierra la ventana actual y avisa al Menu que valide login
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
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
