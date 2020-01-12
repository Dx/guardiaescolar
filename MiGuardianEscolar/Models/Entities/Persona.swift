//
//  Persona.swift
//  MiGuardianEscolar
//
//  Created by Dx on 11/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import Foundation
import Squeal

struct Persona {
    let idPersona: Int
    let nombre: String
    let telefono: String
    let email: String
    let imagen: String
    
    init(row: Statement) throws {
        idPersona = row.intValue("idPersona") ?? 0
        nombre = row.stringValue("nombre") ?? ""
        telefono = row.stringValue("telefono") ?? ""
        email = row.stringValue("email") ?? ""
        imagen = row.stringValue("imagen") ?? ""
    }
    
    init(idPersona: Int, nombre: String, telefono: String, email: String, imagen: String) {
        self.idPersona = idPersona
        self.nombre = nombre
        self.telefono = telefono
        self.email = email
        self.imagen = imagen
    }
}
