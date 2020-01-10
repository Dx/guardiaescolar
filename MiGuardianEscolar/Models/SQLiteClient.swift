//
//  SQLiteClient.swift
//  MiGuardianEscolar
//
//  Created by Dx on 09/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import Foundation
import SQLite

class SQLiteClient {
    let db: Connection?
    
    init() throws {
        db = try Connection("db/guardiaescolar.sqlite3")
    }

    let empresa = Table("Empresa")
    let idEmpresa = Expression<Int>("idEmpresa")
    let nombre = Expression<String>("nombre")
    let imagen = Expression<String?>("imagen")
    let latitud = Expression<Float>("latitud")
    let longitud = Expression<Float>("longitud")
    let metros = Expression<Int>("metros")
    let minutos = Expression<Int>("minutos")
    
    let entidades = Table("Entidades")
    let idEntidad = Expression<Int>("idEntidad")
    let nombreEntidad = Expression<String>("nombre")
    let foto = Expression<String?>("foto")

    let acercamientos = Table("Acercamientos")
    let nAcerca = Expression<Int>("nAcerca")
    let fecha = Expression<String>("fecha")
    
    let horarios = Table("Horarios")
    let idHorario = Expression<Int>("idHorario")
    let dias = Expression<String>("dias")
    let hora = Expression<String>("hora")
    
    let codigos = Table("Codigos")
    let codigo = Expression<String>("codigo")
    let pin = Expression<String>("pin")
    
    try db.run(empresa.create { t in
        t.column(idEmpresa, primaryKey: true)
        t.column(nombre)
        t.column(imagen)
        t.column(latitud)
        t.column(longitud)
        t.column(metros)
        t.column(minutos)
    })

    let insert = users.insert(name <- "Alice", email <- "alice@mac.com")
    let rowid = try db.run(insert)
}

