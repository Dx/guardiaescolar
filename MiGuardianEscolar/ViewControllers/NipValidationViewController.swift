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
    
    @IBOutlet weak var image: UIImageView!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginNip.keyboardType = UIKeyboardType.numberPad
        self.loginNip.becomeFirstResponder()
        
        let idEmpresa = defaults.integer(forKey: defaultsKeys.empresa)
        
        let clientSQL = SQLiteClient()
        if let empresa = clientSQL.getEmpresa(idEmpresa: idEmpresa) {
            let tools = Tools()
            image.image = tools.base64ToImage(empresa[0].imagen)
        }
        
        self.image.layer.cornerRadius = 5
        self.image.layer.borderWidth = 3.0
        self.image.layer.borderColor = UIColor(red: 0.3, green: 0.8039, blue: 0.9843, alpha: 1).cgColor
    }
    
    @IBAction func loginClick(_ sender: Any) {
        
        // Valida que el nip sea el mismo que el guardado
        
        if let storedNip = defaults.string(forKey: defaultsKeys.nip) {
            if storedNip == loginNip.text {
                dismiss(animated: true, completion: nil)
                defaults.set(true, forKey: defaultsKeys.loggedIn)
                NotificationCenter.default.post(name: .needsToValidateLogin, object: nil)
            } else {
                // Muestra alerta
            }
        }
        
    }
}
