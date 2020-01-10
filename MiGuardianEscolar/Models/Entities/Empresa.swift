//
//  Empresa.swift
//  MiGuardianEscolar
//
//  Created by Dx on 10/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import Foundation
import Squeal

struct Empresa {
    let idEmpresa:Int
    let nombre:String
    let imagen:String
    let latitud:Double
    let longitud:Double
    let metros:Int
    let minutos:Int
    
    init(row: Statement) throws {
        idEmpresa = row.intValue("idEmpresa") ?? 0
        nombre = row.stringValue("nombre") ?? ""
        imagen = row.stringValue("imagen") ?? ""
        latitud = row.doubleValue("latitud") ?? 0
        longitud = row.doubleValue("longitud") ?? 0
        metros = row.intValue("metros") ?? 0
        minutos = row.intValue("minutos") ?? 0
    }
}
