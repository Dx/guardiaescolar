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
            
            if response != nil {
                
                print(response)
                let idEmpresa = 54
                let nombre = "nombre empresa"
                let imagen = "imagen empresa"
                let latitud: Double = 0
                let longitud: Double = 0
                let metros: Int = 0
                let minutos: Int = 0
                let empresa = Empresa(idEmpresa: idEmpresa, nombre: nombre, imagen: imagen, latitud: latitud, longitud: longitud, metros: metros, minutos: minutos)
                
                completion(empresa, nil)
            } else {
                completion(nil, "Empresa no encontrada")
            }
            
            if error != nil
            {
                completion(nil, "Error en conexión")
                print("Error: " + error.debugDescription)
            }

        })
        task.resume()
    }
    
}
