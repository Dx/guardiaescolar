//
//  ViewController.swift
//  MiGuardianEscolar
//
//  Created by Dx on 09/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import UIKit
import CoreLocation
import BackgroundTasks

class MenuViewController: UIViewController, CLLocationManagerDelegate {

    //MARK:- Properties
    @IBOutlet weak var qrButton: UIButton!
    @IBOutlet weak var registrarButton: UIButton!
    @IBOutlet weak var cambiarPinButton: UIButton!
    
    var empresaRegion: CLCircularRegion?
    let defaults = UserDefaults.standard
    var horarios: [Horario]?
    var currentHorario = 0
    
    var passed30seconds = false
    
    var lastLocation: CLLocation?
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()
    
    //MARK:- View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Observer para cuando al crear nuevo nip se vuelve a validar el login
        NotificationCenter.default.addObserver(self, selector: #selector(validateLogin), name: .needsToValidateLogin, object: nil)
        
        // Crea la región por monitorear
        empresaRegion = createRegion(latitud: defaults.double(forKey: defaultsKeys.latitudEmpresa), longitud: defaults.double(forKey: defaultsKeys.longitudEmpresa))
        
        showButtons(false)
        defaults.set(false, forKey: defaultsKeys.loggedIn)
        
        validateLogin()
    }
    
    @objc func validateLogin() {
        
        // Valida si ya tiene código de verificación
        let loggedIn = defaults.bool(forKey: defaultsKeys.loggedIn)
        if loggedIn {
            tasksToInitialize()
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
    
    //MARK:- Methods for localization
    
    func tasksToInitialize() {
        bringNewValuesFromWS()
        getHorarios()
        registerLocalNotification()
        printValues() // Solo por pruebas
        locationManager.startUpdatingLocation()
        showButtons(true)
    }
    
    // Se ejecuta cada que iOS recibe un cambio de posición
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        lastLocation = locations.last!
        
        if passed30seconds {
            // Ya pasaron los 30 segundos y va a revisar si la nueva posición también está en la geocerca
            if empresaRegion!.contains(lastLocation!.coordinate) {
                scheduleLocalNotification()
                reportPosition()
                print("Ya reportó posición")
                passed30seconds = false
            }
        } else {
        
            if UIApplication.shared.applicationState == .active {
                print("App is active. New location received at \(Date().description(with: .current))")
            } else {
                print("App is backgrounded. New location received at \(Date().description(with: .current))")
            }
            
            // Si la hora es mayor a 1159 pm, reinicia horarios a cero
            if isHourPast(hourAsked: 11, minuteAsked: 59) && horarios != nil {
                for horario in horarios! {
                    horario.state = 0
                }
            }
            
            // Revisa si está dentro de la geocerca
            if let currentLocation = locations.last {
                if empresaRegion!.contains(currentLocation.coordinate) {
                    checkSchedule()
                }
            }
        }
    }
    
    func isHourPast(hourAsked: Int, minuteAsked: Int) -> Bool {
        // Revisa si el horario actual ya pasó un horario solicitado
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60
        
        let dateSecondsAsked = hourAsked * 3600 + minuteAsked * 60

        return dateSeconds >= dateSecondsAsked
    }
    
    func checkSchedule() {
        // Está dentro de la geocerca, entonces revisa si está en horario
        let currentDate = Date()
        
        if horarios != nil {
            
            for horario in horarios! {
                if horario.state == 0 {
                    if horario.isInSchedule(currentDate, tolerance: defaults.integer(forKey: defaultsKeys.minutosTolerancia)) {
                        
                        print("Estoy en horario y posición, pongo timer a 30 segs")
                        
                        currentHorario = horario.idHorario
                        
                        // Calendariza en 30 segundos la revisión
                        updateTimer = Timer.scheduledTimer(timeInterval: 30, target: self,
                                                           selector: #selector(passed30segs), userInfo: nil, repeats: false)
                        // Registra background task
                        registerBackgroundTask()
                        locationManager.stopUpdatingLocation()
                    }
                }
            }
        }
    }
    
    var updateTimer: Timer?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    func registerBackgroundTask() {
      backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
        self?.endBackgroundTask()
      }
      assert(backgroundTask != .invalid)
    }
    
    func endBackgroundTask() {
      print("Background task ended.")
      UIApplication.shared.endBackgroundTask(backgroundTask)
      backgroundTask = .invalid
    }
    
    @objc func passed30segs() {
        // Ya se cumplieron 30 segundos. Solicita encender localización para ver si se reporta
        print("Ya pasaron 30 segundos")
        passed30seconds = true
        self.locationManager.startUpdatingLocation()
    }
    
    func reportPosition() {
        // Se reporta al WS
        let soapClient = SoapClient()
        soapClient.reportOnGeofence(completion:{(result: String?, error: String?) in
            if error == nil {
                
                // Cambia estado del horario a revisado
                let myIndex = self.horarios!.firstIndex(where: { $0.idHorario == self.currentHorario })!
                self.horarios![myIndex].state = 3
            }
        })
        
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
    
    //MARK:- Helpers
    func createRegion(latitud: Double, longitud: Double) -> CLCircularRegion {
        // Crea la geocerca de la empresa
        let center = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
        let maxDistance = CLLocationDistance(exactly: defaults.integer(forKey: defaultsKeys.metrosEmpresa))!
        let region = CLCircularRegion(center: center, radius: maxDistance, identifier: "Empresa")
        
        return region
    }
    
    func makeDate(year: Int, month: Int, day: Int, hr: Int, min: Int, sec: Int) -> Date {
        // Crea una fecha
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(year: year, month: month, day: day, hour: hr, minute: min, second: sec)
        return calendar.date(from: components)!
    }
        
    func showButtons(_ show: Bool) {
        // Muestra u oculta los botones de la pantalla inicial
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
    
    func getHorarios() {
        // Obtiene los horarios
        let clientSQL = SQLiteClient()
        if let horarios = clientSQL.getHorarios() {
            self.horarios = horarios
        }
    }
    
    func printValues() {
        // Solo por pruebas
        print("La posicion de la empresa es: latitud: \(empresaRegion!.center.latitude) longitud: \(empresaRegion!.center.latitude) y radio: \(empresaRegion!.radius)")
        print("Los horarios que tengo son:")
        for horario in horarios!{            
            print("Los días \(horario.dias) a las \(horario.hora)")
        }
    }
}

//MARK:- Notification Helper

extension MenuViewController {
    
    func registerLocalNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("El usuario negó autorizar notificaciones")
            }
        }
    }
    
    func scheduleLocalNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                self.fireNotification()
            }
        }
    }
    
    func fireNotification() {
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = "Mi Guardia Escolar"
        notificationContent.body = "En la geocerca"
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("No fue posible encolar la notificación (\(error), \(error.localizedDescription))")
            }
        }
    }
}

