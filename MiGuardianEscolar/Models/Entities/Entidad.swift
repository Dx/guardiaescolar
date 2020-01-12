//
//  Entidad.swift
//  MiGuardianEscolar
//
//  Created by Dx on 11/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import Foundation
import Squeal

struct Entidad {
    let idEntidad: Int
    let nombre: String
    let telefono: String
    let email: String
    let imagen: String
    
    init(row: Statement) throws {
        idEntidad = row.intValue("idEntidad") ?? 0
        nombre = row.stringValue("nombre") ?? ""
        telefono = row.stringValue("telefono") ?? ""
        email = row.stringValue("email") ?? ""
        imagen = row.stringValue("imagen") ?? ""
    }
    
    init(idEntidad: Int, nombre: String, telefono: String, email: String, imagen: String) {
        self.idEntidad = idEntidad
        self.nombre = nombre
        self.telefono = telefono
        self.email = email
        self.imagen = imagen
    }
}
