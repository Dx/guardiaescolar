//
//  ViewController.swift
//  MiGuardianEscolar
//
//  Created by Dx on 09/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import UIKit
import CoreLocation

class MenuViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var qrButton: UIButton!
    @IBOutlet weak var registrarButton: UIButton!
    @IBOutlet weak var cambiarPinButton: UIButton!
    
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    
    var empresaRegion: CLCircularRegion?
    let defaults = UserDefaults.standard
    var horarios: [Horario]?
    var locationManager: CLLocationManager!
    var currentHorario = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(validateLogin), name: .needsToValidateLogin, object: nil)
        
        showButtons(false)
        configureLocationManager()
        defaults.set(false, forKey: defaultsKeys.loggedIn)
        
        validateLogin()
        
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }
    
    func setTimerForLocation() {
        
        let timeInterval = defaults.double(forKey: defaultsKeys.timeInterval)
        
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
           UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
        })
        
        let timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.checkLocation), userInfo: nil, repeats: true)
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
        print("Check location")
        
        // Crea la región por monitorear
        empresaRegion = createRegion(latitud: defaults.double(forKey: defaultsKeys.latitudEmpresa), longitud: defaults.double(forKey: defaultsKeys.longitudEmpresa))
        
        // Revisa si está en horario
        let currentDate = Date()
        if horarios != nil {
            for horario in horarios! {
                
                print(horario.dias)
                print(horario.hora)
                print(horario.state)
                if horario.state == 0 {
                    if horario.isInSchedule(currentDate, tolerance: defaults.integer(forKey: defaultsKeys.minutosTolerancia)) {
                        currentHorario = horario.idHorario
                        
                        // Si cumple con el horario, se activa localización
                        activateLocation()
                        
                        // El horario actual lo cambia a estado 1, que ya está localizando. Los demás los deja en 0, que se pueden revisar
                        let myIndex = horarios!.firstIndex(where: { $0.idHorario == currentHorario })!
                        for horarioChange in horarios! {
                            let index = horarios!.firstIndex(where: { $0.idHorario == horarioChange.idHorario })!
                            if index == myIndex {
                                horarios![index].state = 2
                            } else {
                                horarios![index].state = 0
                            }
                        }
                    }
                }
            }
        }
    }
    
    func activateLocation() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if empresaRegion != nil {
            let location = locations.last! as CLLocation

            let currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            if empresaRegion!.contains(currentLocation) {
                // Se reporta al WS
                let soapClient = SoapClient()
                soapClient.reportOnGeofence(completion:{(result: String?, error: String?) in
                    if error == nil {
                        // Detiene el monitoreo
                        self.locationManager.stopUpdatingLocation()
                        
                        // Cambia estado del horario a revisado
                        let myIndex = self.horarios!.firstIndex(where: { $0.idHorario == self.currentHorario })!
                        self.horarios![myIndex].state = 3
                    }
                })
            }
        }
    }
    
    func createRegion(latitud: Double, longitud: Double) -> CLCircularRegion {
        let center = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
        let maxDistance = CLLocationDistance(exactly: defaults.integer(forKey: defaultsKeys.metrosEmpresa))!
        let region = CLCircularRegion(center: center, radius: maxDistance, identifier: "Empresa")
        return region
    }
        
    @objc func validateLogin() {
        
        // Valida si ya tiene código de verificación
        let loggedIn = defaults.bool(forKey: defaultsKeys.loggedIn)
        if loggedIn {
            bringNewValuesFromWS()
            getHorarios()
            setTimerForLocation()
            showButtons(true)
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
    
    func showButtons(_ show: Bool) {
        self.qrButton.isHidden = !show
        self.registrarButton.isHidden = !show
        self.cambiarPinButton.isHidden = !show
    }
    
    func bringNewValuesFromWS() {
        let clientSOAP = SoapClient()
        let clientSQL = SQLiteClient()
        
        // Obtiene la empresa del WS
        clientSOAP.getEmpresa(idEmpresa: defaults.integer(forKey: defaultsKeys.empresa), completion: {(empresa: Empresa?, error: String?) in
            if empresa != nil {
                //Guarda el IdEmpresa en la BD
                clientSQL.addEmpresa(empresa: empresa!)
                
                self.defaults.set(empresa!.metros, forKey: defaultsKeys.metrosEmpresa)
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

