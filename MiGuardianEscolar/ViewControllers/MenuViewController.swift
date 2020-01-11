//
//  ViewController.swift
//  MiGuardianEscolar
//
//  Created by Dx on 09/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(validateLogin), name: .needsToValidateLogin, object: nil)
        
        defaults.set(false, forKey: defaultsKeys.loggedIn)
        
        validateLogin()
    }
    
    @objc func validateLogin() {
        
        // Valida si ya tiene código de verificación
        let loggedIn = defaults.bool(forKey: defaultsKeys.loggedIn)
        if loggedIn {
            bringNewValuesFromWS()
        } else {
            if let verificationCode = defaults.string(forKey: defaultsKeys.verificationCode) {
                print("Este es el código que ya se tiene: \(verificationCode)")
                if defaults.string(forKey: defaultsKeys.nip) != nil {
                    
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "validateNIP", sender: self)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "askNewNIP", sender: self)
                    }
                }
            } else {
                // Si no lo tiene todavía se solicita
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showVerificationCode", sender: self)
                }
            }
        }
    }
    
    func bringNewValuesFromWS() {
        let clientSOAP = SoapClient()
        let clientSQL = SQLiteClient()
        
        
        // Obtiene la empresa del WS
        clientSOAP.getEmpresa(idEmpresa: defaults.integer(forKey: defaultsKeys.empresa), completion: {(empresa: Empresa?, error: String?) in
            if empresa != nil {
                //Guarda el IdEmpresa en la BD
                clientSQL.addEmpresa(empresa: empresa!)
            }
        })
        
        // Obtiene los horarios del WS
        clientSOAP.getHorarios(code: "1", completion: {(result: [Horario]?, error: String?) in
            
            if result != nil {
                // Los agrega a la BD
                for horario in result! {
                    clientSQL.addHorario(horario: horario)
                }
            }
        })
    }
}

