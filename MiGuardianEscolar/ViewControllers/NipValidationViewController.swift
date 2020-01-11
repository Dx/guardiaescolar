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
//            image.image = tools.base64ToImage(empresa[0].imagen)
        }
    }
    
    @IBAction func loginClick(_ sender: Any) {
        
        // Valida que el nip sea el mismo que el guardado
        
        if let storedNip = defaults.string(forKey: defaultsKeys.nip) {
            if storedNip == loginNip.text {
                dismiss(animated: true, completion: nil)
                defaults.set(true, forKey: defaultsKeys.loggedIn)
            } else {
                // Muestra alerta
            }
        }
        
    }
}
