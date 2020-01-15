//
//  soapClient.swift
//  MiGuardianEscolar
//
//  Created by Dx on 09/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import Foundation
import SWXMLHash

class SoapClient {
    
    func sendCode(code: String, completion:@escaping (_ result: String?, _ error: String?) -> Void) {
        let is_SoapMessage: String = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:hs='http://heimtek.mx/miguardianescolar/mgeIOS_Service_bp.php'><soapenv:Body><hs:validaIOS><hs:codigo>\(code)</hs:codigo></hs:validaIOS></soapenv:Body></soapenv:Envelope>"
        let is_URL: String = "http://heimtek.mx/miguardianescolar/mgeIOS_Service_bp.php"

        let lobj_Request = NSMutableURLRequest.init(url: URL(string: is_URL)!)
        let session = URLSession.shared

        lobj_Request.httpMethod = "POST"
        lobj_Request.httpBody = is_SoapMessage.data(using: String.Encoding.utf8)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: lobj_Request as URLRequest, completionHandler: {data, response, error -> Void in
            
            let xml = SWXMLHash.config {
                config in
                config.shouldProcessLazily = true
            }.parse(data!)
            
            if let response = xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:validaIOSResponse"]["return"].element?.text {
                if response == "A1A2" {
                    print("Envió nuevo código!")
                    completion(response, nil)
                } else {
                    completion(nil, "Código inválido, reintente")
                }
            }
            
            if error != nil
            {
                completion(nil, "Error en conexión")
                print("Error: " + error.debugDescription)
            }

        })
        task.resume()
    }
    
    func getEmpresa(idEmpresa: Int, completion:@escaping (_ result: Empresa?, _ error: String?) -> Void) {
        // Método dameTablaEmpresaIOS
        let is_SoapMessage: String = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:hs='http://heimtek.mx/miguardianescolar/mgeIOS_Service_bp.php'><soapenv:Body><hs:dameTablaEmpresaIOS><hs:idEmpresa>\(idEmpresa)</hs:idEmpresa></hs:dameTablaEmpresaIOS></soapenv:Body></soapenv:Envelope>"
        let is_URL: String = "http://heimtek.mx/miguardianescolar/mgeIOS_Service_bp.php"

        let lobj_Request = NSMutableURLRequest.init(url: URL(string: is_URL)!)
        let session = URLSession.shared

        lobj_Request.httpMethod = "POST"
        lobj_Request.httpBody = is_SoapMessage.data(using: String.Encoding.utf8)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: lobj_Request as URLRequest, completionHandler: {data, response, error -> Void in
            
            let xml = SWXMLHash.config {
                config in
                config.shouldProcessLazily = true
            }.parse(data!)
            
            for item in xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:dameTablaEmpresaIOSResponse"]["return"]["item"].all {                
                
                let idEmpresa = Int(item["nEmp"].element!.text)!
                let nombre = item["nombre"].element!.text
                var imagen = item["imagen"].element!.text
                
                // quitando los saltos de línea
                imagen = String(imagen.filter { !" \n".contains($0) })
                let latitud = Double(item["latitud"].element!.text)!
                let longitud = Double(item["longitud"].element!.text)!
                let metros = Int(item["metros"].element!.text)!
                let minutos = Int(item["minutos"].element!.text)!
                let empresa = Empresa(idEmpresa: idEmpresa, nombre: nombre, imagen: imagen, latitud: latitud, longitud: longitud, metros: metros, minutos: minutos)
                
                completion(empresa, nil)
            }
        })
        task.resume()
    }
    
    func getHorarios(code: String, completion:@escaping (_ result: [Horario]?, _ error: String?) -> Void) {
        // Método dameTablaHorariosIOS
        let is_SoapMessage: String = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:hs='http://heimtek.mx/miguardianescolar/mgeIOS_Service_bp.php'><soapenv:Body><hs:dameTablaHorariosIOS><hs:codigo>\(code)</hs:codigo></hs:dameTablaHorariosIOS></soapenv:Body></soapenv:Envelope>"
        let is_URL: String = "http://heimtek.mx/miguardianescolar/mgeIOS_Service_bp.php"

        let lobj_Request = NSMutableURLRequest.init(url: URL(string: is_URL)!)
        let session = URLSession.shared

        lobj_Request.httpMethod = "POST"
        lobj_Request.httpBody = is_SoapMessage.data(using: String.Encoding.utf8)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: lobj_Request as URLRequest, completionHandler: {data, response, error -> Void in
            
            let xml = SWXMLHash.config {
                config in
                config.shouldProcessLazily = true
            }.parse(data!)

            var horarios = [Horario]()

            for item in xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:dameTablaHorariosIOSResponse"]["return"]["item"].all {

                let dias = item["dias"].element!.text
                let hora = item["hora"].element!.text
                if let idHorario = Int(item["nHorario"].element!.text) {
                    let horario = Horario(idHorario: idHorario, dias: dias, hora: hora)
                    horarios.append(horario)
                }
            }
            
            // Para pruebas
//            let horario = Horario(idHorario: 22, dias: "12345", hora: "18:00")
//            horarios.append(horario)
            
            let horario2 = Horario(idHorario: 23, dias: "12345", hora: "23:00")
            horarios.append(horario2)
            
            completion(horarios, nil)
        })
        task.resume()
    }
    
    func sendNewEntity(entidad: Entidad, completion:@escaping (_ result: String?, _ error: String?) -> Void) {
                
        let is_SoapMessage: String = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:hs='http://heimtek.mx/miguardianescolar/mgeIOS_Service_bp.php'><soapenv:Body><hs:insEntIOS><ne>\(entidad.idEntidad)</ne><name>\(entidad.nombre)</name><date>\(getCurrentDate())</date></hs:insEntIOS></soapenv:Body></soapenv:Envelope>"
        let is_URL: String = "http://heimtek.mx/miguardianescolar/mgeIOS_Service_bp.php"

        let lobj_Request = NSMutableURLRequest.init(url: URL(string: is_URL)!)
        let session = URLSession.shared

        lobj_Request.httpMethod = "POST"
        lobj_Request.httpBody = is_SoapMessage.data(using: String.Encoding.utf8)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: lobj_Request as URLRequest, completionHandler: {data, response, error -> Void in
            
            let xml = SWXMLHash.config {
                config in
                config.shouldProcessLazily = true
            }.parse(data!)
            
            if let response = xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:insEntIOSResponse"]["return"].element?.text {
                if response == "1" {
                    print("Envió nueva entidad!")
                    completion(response, nil)
                } else {
                    completion(nil, "No fue posible guardar")
                }
            }
        })
        task.resume()
    }
    
    func sendUpdateEntity(entidad: Entidad, completion:@escaping (_ result: String?, _ error: String?) -> Void) {
        
        let is_SoapMessage: String = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:hs='http://heimtek.mx/miguardianescolar/mgeIOS_Service_bp.php'><soapenv:Body><hs:actEntIOS><ne>\(entidad.idEntidad)</ne><name>\(entidad.nombre)</name><date>\(getCurrentDate())</date></hs:actEntIOS></soapenv:Body></soapenv:Envelope>"
        let is_URL: String = "http://heimtek.mx/miguardianescolar/mgeIOS_Service_bp.php"

        let lobj_Request = NSMutableURLRequest.init(url: URL(string: is_URL)!)
        let session = URLSession.shared

        lobj_Request.httpMethod = "POST"
        lobj_Request.httpBody = is_SoapMessage.data(using: String.Encoding.utf8)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: lobj_Request as URLRequest, completionHandler: {data, response, error -> Void in
            
            let xml = SWXMLHash.config {
                config in
                config.shouldProcessLazily = true
            }.parse(data!)
            
            if let response = xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:actEntIOSResponse"]["return"].element?.text {
                if response == "1" {
                    print("Actualizó entidad!")
                    completion(response, nil)
                } else {
                    completion(nil, "No fue posible guardar")
                }
            }
        })
        task.resume()
    }
    
    func sendUpdatePhoto(entidad: Entidad, completion:@escaping (_ result: String?, _ error: String?) -> Void) {
        
        let is_SoapMessage: String = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:hs='http://heimtek.mx/miguardianescolar/mgeIOS_Service_bp.php'><soapenv:Body><hs:actFotoEntIOS><ne>\(entidad.idEntidad)</ne><foto>\(entidad.imagen)</foto></hs:actFotoEntIOS></soapenv:Body></soapenv:Envelope>"
        let is_URL: String = "http://heimtek.mx/miguardianescolar/mgeIOS_Service_bp.php"

        let lobj_Request = NSMutableURLRequest.init(url: URL(string: is_URL)!)
        let session = URLSession.shared

        lobj_Request.httpMethod = "POST"
        lobj_Request.httpBody = is_SoapMessage.data(using: String.Encoding.utf8)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: lobj_Request as URLRequest, completionHandler: {data, response, error -> Void in
            
            let xml = SWXMLHash.config {
                config in
                config.shouldProcessLazily = true
            }.parse(data!)
            
            if let response = xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:actFotoEntIOSResponse"]["return"].element?.text {
                if response == "1" {
                    print("Subió foto!")
                    completion(response, nil)
                } else {
                    completion(nil, "No fue posible guardar")
                }
            }
        })
        task.resume()
    }
    
    func reportOnGeofence(completion:@escaping (_ result: String?, _ error: String?) -> Void){
        
        let is_SoapMessage: String = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:hs='http://heimtek.mx/miguardianescolar/mgeIOS_Service_bp.php'><soapenv:Body><hs:acercaIOS><date>\(getCurrentDate())</date></hs:acercaIOS></soapenv:Body></soapenv:Envelope>"
        let is_URL: String = "http://heimtek.mx/miguardianescolar/mgeIOS_Service_bp.php"

        let lobj_Request = NSMutableURLRequest.init(url: URL(string: is_URL)!)
        let session = URLSession.shared

        lobj_Request.httpMethod = "POST"
        lobj_Request.httpBody = is_SoapMessage.data(using: String.Encoding.utf8)
        lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: lobj_Request as URLRequest, completionHandler: {data, response, error -> Void in
            if data != nil {
                let xml = SWXMLHash.config {
                    config in
                    config.shouldProcessLazily = true
                }.parse(data!)
                
                if let response = xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:acercaIOSResponse"]["return"].element?.text {
                    if response != "0" {
                        print("Reportando que está en posición!")
                        completion("1", nil)
                    } else {
                        completion(nil, "No fue posible guardar")
                    }
                }
            }
        })
        task.resume()
    }
    
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: Date())
    }
    
}
