//
//  NipValidationViewController.swift
//  MiGuardianEscolar
//
//  Created by Dx on 09/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import UIKit

class NipValidationViewController: UIViewController {

    //MARK:- Properties
    
    @IBOutlet weak var loginNip: UITextField!
    @IBOutlet weak var image: UIImageView!
    
    let defaults = UserDefaults.standard
    
    //MARK:- View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeView()

        let idEmpresa = defaults.integer(forKey: defaultsKeys.empresa)
        
        // Obtiene datos de la empresa
        let clientSQL = SQLiteClient()
        if let empresa = clientSQL.getEmpresa(idEmpresa: idEmpresa) {
            if empresa.count > 0 {
                let tools = Tools()
                
                if let imageFromB64 = tools.base64ToImage(empresa[0].imagen) {
                    image.image = imageFromB64
                } else {
                    print("Foto inválida")
                }
            }
        }
    }
    
    func initializeView() {
        self.loginNip.keyboardType = UIKeyboardType.numberPad
        self.loginNip.becomeFirstResponder()
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
                let alert = UIAlertController(title: "PIN inválido", message: "Verifique su información", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            print("default")
                      }))
                self.present(alert, animated: true, completion: {() in
                    self.loginNip.text = ""
                })
            }
        }
    }
}
