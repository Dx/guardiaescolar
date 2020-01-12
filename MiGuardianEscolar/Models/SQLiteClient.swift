//
//  SQLiteClient.swift
//  MiGuardianEscolar
//
//  Created by Dx on 09/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import Foundation
import Squeal

class SQLiteClient {
    
    let db: Database?
    
    init(){
        do {
            let dbPath: String = "MiGuardianEscolar.sqlite"
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
            
            db = try Database.init(path: fileURL.path)
        } catch {
            print("Error \(error)")
            db = nil
        }
    }
    
    
    
    func createTables() {
        
        createEmpresas()
        createEntidades()
        createAcercamientos()
        createHorarios()
        createCodigos()
    }
    
    func createEmpresas() {
        do {
            try db!.createTable("Empresa", definitions: [
                "idEmpresa INTEGER PRIMARY KEY",
                "nombre TEXT",
                "imagen TEXT",
                "latitud REAL",
                "longitud REAL",
                "metros INTEGER",
                "minutos INTEGER"
            ], ifNotExists: true)
        } catch {
            print("Error \(error)")
        }
    }
    
    func createEntidades() {
        do {
            try db!.createTable("Entidades", definitions: [
                "idEntidad INTEGER PRIMARY KEY AUTOINCREMENT",
                "nombre TEXT",
                "telefono TEXT",
                "email TEXT",
                "imagen TEXT"
            ], ifNotExists: true)
        } catch {
            print("Error \(error)")
        }
    }
    
    func createAcercamientos() {
        do {
            try db?.createTable("Acercamientos", definitions: [
                "nAcerca INTEGER PRIMARY KEY",
                "fecha TEXT"
            ], ifNotExists: true)
        } catch {
            print("Error \(error)")
        }
    }
    
    func createHorarios() {
        do {
            try db?.createTable("Horarios", definitions: [
                "idHorario INTEGER PRIMARY KEY",
                "dias TEXT",
                "hora TEXT"
            ], ifNotExists: true)
        } catch {
            print("Error \(error)")
        }
    }
    
    func createCodigos() {
        do {
            try db?.createTable("Codigos", definitions: [
                "codigo TEXT PRIMARY KEY",
                "pin TEXT"
            ], ifNotExists: true)
        } catch {
            print("Error \(error)")
        }
    }
    
    func addEmpresa(empresa: Empresa) {
        
        if let empresas = self.getEmpresa(idEmpresa: empresa.idEmpresa) {
            if empresas.count > 0 {
                do {
                    try db?.update("Empresa", set: [
                        "idEmpresa": empresa.idEmpresa,
                        "nombre": empresa.nombre,
                        "imagen": empresa.imagen,
                        "latitud": empresa.latitud,
                        "longitud": empresa.longitud,
                        "metros": empresa.metros,
                        "minutos": empresa.minutos
                    ],
                    whereExpr:"idEmpresa = '\(empresa.idEmpresa)'")
                } catch {
                    print("Error \(error)")
                }
            } else {
                do {
                    try db?.insertInto(
                        "Empresa",
                        values: [
                            "idEmpresa": empresa.idEmpresa,
                            "nombre": empresa.nombre,
                            "imagen": empresa.imagen,
                            "latitud": empresa.latitud,
                            "longitud": empresa.longitud,
                            "metros": empresa.metros,
                            "minutos": empresa.minutos
                        ]
                    )
                } catch {
                    print("Error \(error)")
                }
            }
        }
    }
    
    func getEmpresa(idEmpresa: Int) -> [Empresa]? {
        do {
            let empresas:[Empresa] = try db!.selectFrom(
                "Empresa",
                whereExpr:"idEmpresa = '\(idEmpresa)'",
                block: Empresa.init
            )
            
            return empresas
            
        } catch {
            print("Error \(error)")
            return nil
        }
    }
    
    func getAllEmpresas() -> [Empresa]? {
        do {
            let empresas:[Empresa] = try db!.selectFrom(
                "Empresa",
                whereExpr:"nombre IS NOT NULL",
                block: Empresa.init
            )
            
            return empresas
            
        } catch {
            print("Error \(error)")
            return nil
        }
    }
    
    func addCodigo(codigo: String, nip: String) {
        
        if let codigos = self.getCodigo(codigo: codigo) {
            if codigos.count > 0 {
                do {
                    try db!.update("Codigos", set: [
                        "codigo": codigo,
                        "pin": nip
                    ],
                    whereExpr:"codigo = '\(codigo)'")
                } catch {
                    print("Error \(error)")
                }
            } else {
                do {
                    try db!.insertInto("Codigos", values: [
                        "codigo": codigo,
                        "pin": nip
                    ])
                } catch {
                    print("Error \(error)")
                }
            }
        }
    }
    
    func getCodigo(codigo: String) -> [Codigo]? {
        do {
            let codigos:[Codigo] = try db!.selectFrom(
                "Codigos",
                whereExpr:"codigo = '\(codigo)'",
                block: Codigo.init
            )
            
            return codigos
        } catch {
            print("Error \(error)")
            return nil
        }
    }
    
    func addHorario(horario: Horario) {
        
        if let horarios = self.getHorario(idHorario: horario.idHorario) {
            if horarios.count > 0 {
                do {
                    try db?.update("Horarios", set: [
                        "idHorario": horario.idHorario,
                        "dias": horario.dias,
                        "hora": horario.hora
                    ],
                    whereExpr:"idHorario = '\(horario.idHorario)'")
                } catch {
                    print("Error \(error)")
                }
            } else {
                do {
                    try db?.insertInto(
                        "Horarios",
                        values: [
                            "idHorario": horario.idHorario,
                            "dias": horario.dias,
                            "hora": horario.hora
                        ]
                    )
                } catch {
                    print("Error \(error)")
                }
            }
        }
    }
    
    func getHorario(idHorario: Int) -> [Horario]? {
        do {
            let horarios:[Horario] = try db!.selectFrom(
                "Horarios",
                whereExpr:"idHorario = '\(idHorario)'",
                block: Horario.init
            )
            
            return horarios
            
        } catch {
            print("Error \(error)")
            return nil
        }
    }
    
    func getEntidad(idEntidad: Int) -> [Entidad]? {
        do {
            let entidades:[Entidad] = try db!.selectFrom(
                "Entidades",
                whereExpr:"idEntidad = '\(idEntidad)'",
                block: Entidad.init
            )
            
            return entidades
            
        } catch {
            print("Error \(error)")
            return nil
        }
    }
    
    func getEntidades() -> [Entidad]? {
        do {
            let entidades:[Entidad] = try db!.selectFrom(
                "Entidades",
                whereExpr:"nombre IS NOT NULL",
                block: Entidad.init
            )
            
            return entidades
            
        } catch {
            print("Error \(error)")
            return nil
        }
    }
    
    func addEntidad(entidad: Entidad) {
        if let entidades = self.getEntidad(idEntidad: entidad.idEntidad) {
            if entidades.count > 0 {
                do {
                    try db?.update("Entidades", set: [
                        "idEntidad": entidad.idEntidad,
                        "nombre": entidad.nombre,
                        "telefono": entidad.telefono,
                        "email": entidad.email,
                        "imagen": entidad.imagen
                    ],
                    whereExpr:"idEntidad = '\(entidad.idEntidad)'")
                } catch {
                    print("Error \(error)")
                }
            } else {
                do {
                    try db?.insertInto(
                        "Entidades",
                        values: [
                            "nombre": entidad.nombre,
                            "telefono": entidad.telefono,
                            "email": entidad.email,
                            "imagen": entidad.imagen
                        ]
                    )
                } catch {
                    print("Error \(error)")
                }
            }
        }
    }
}

