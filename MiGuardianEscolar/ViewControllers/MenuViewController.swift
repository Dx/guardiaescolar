//
//  ViewController.swift
//  MiGuardianEscolar
//
//  Created by Dx on 09/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import UIKit
import CoreLocation

class MenuViewController: UIViewController {

    @IBOutlet weak var qrButton: UIButton!
    @IBOutlet weak var registrarButton: UIButton!
    @IBOutlet weak var cambiarPinButton: UIButton!
    
    let defaults = UserDefaults.standard
    var horarios: [Horario]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(validateLogin), name: .needsToValidateLogin, object: nil)
        
        defaults.set(false, forKey: defaultsKeys.loggedIn)
        
        validateLogin()
        
        setTimerForLocation()
    }
    
    func setTimerForLocation() {
        
        let timer = Timer(timeInterval: 300.0, target: self, selector: #selector(checkLocation), userInfo: nil, repeats: true)
        timer.tolerance = 0.2

        RunLoop.current.add(timer, forMode: .common)
    }
    
    func getHorarios() {
        // Obtiene los horarios
        let clientSQL = SQLiteClient()
        if let horarios = clientSQL.getHorarios() {
            self.horarios = horarios
        }
    }
    
    @objc func checkLocation() {
        // Revisa si está en horario
        let currentDate = Date()
        if horarios != nil {
            for horario in horarios! {
                if horario.isInSchedule(currentDate, tolerance: defaults.integer(forKey: defaultsKeys.minutosTolerancia)) {
                    // Activa localización
                    if isInGeofence() {
                        // Si cumple, registra en server
                    }
                }
            }
        }
    }
    
    func isInGeofence() -> Bool {
        return true
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
                
                self.defaults.set(empresa!.minutos, forKey: defaultsKeys.minutosTolerancia)
                self.defaults.set(empresa!.latitud, forKey: defaultsKeys.latitudEmpresa)
                self.defaults.set(empresa!.longitud, forKey: defaultsKeys.longitudEmpresa)
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

