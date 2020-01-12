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
        createPersonas()
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
    
    func createPersonas() {
        do {
            try db!.createTable("Personas", definitions: [
                "idPersona INTEGER PRIMARY KEY AUTOINCREMENT",
                "nombre TEXT",
                "telefono TEXT",
                "email TEXT",
                "imagen TEXT"
            ], ifNotExists: true)
        } catch {
            print("Error \(error)")
        }
    }
    
    
    func createEntidades() {
        do {
            try db?.createTable("Entidades", definitions: [
                "idEntidad INTEGER PRIMARY KEY",
                "nombre TEXT",
                "foto TEXT"
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
    
    func getPersona(idPersona: Int) -> [Persona]? {
        do {
            let personas:[Persona] = try db!.selectFrom(
                "Personas",
                whereExpr:"idPersona = '\(idPersona)'",
                block: Persona.init
            )
            
            return personas
            
        } catch {
            print("Error \(error)")
            return nil
        }
    }
    
    func getPersonas() -> [Persona]? {
        do {
            let personas:[Persona] = try db!.selectFrom(
                "Personas",
                whereExpr:"nombre IS NOT NULL",
                block: Persona.init
            )
            
            return personas
            
        } catch {
            print("Error \(error)")
            return nil
        }
    }
    
    func addPersona(persona: Persona) {
        if let personas = self.getPersona(idPersona: persona.idPersona) {
            if personas.count > 0 {
                do {
                    try db?.update("Personas", set: [
                        "idPersona": persona.idPersona,
                        "nombre": persona.nombre,
                        "telefono": persona.telefono,
                        "email": persona.email,
                        "imagen": persona.imagen
                    ],
                    whereExpr:"idPersona = '\(persona.idPersona)'")
                } catch {
                    print("Error \(error)")
                }
            } else {
                do {
                    try db?.insertInto(
                        "Personas",
                        values: [
                            "nombre": persona.nombre,
                            "telefono": persona.telefono,
                            "email": persona.email,
                            "imagen": persona.imagen
                        ]
                    )
                } catch {
                    print("Error \(error)")
                }
            }
        }
    }
    
    func test() {
        
        let value1: Double = 12.12
        let value2: Int = 3
        
        do {
            try db!.insertInto(
                "Empresa",
                values: [
                    "idEmpresa": 3,
                    "nombre": "Empresa 1",
                    "imagen": "jkflasdf",
                    "latitud": value1,
                    "longitud": value1,
                    "metros": value2,
                    "minutos": value2
                ]
            )
        } catch {
            print("Error \(error)")
        }
        
        do {
            try db!.insertInto(
                "Empresa",
                values: [
                    "idEmpresa": 4,
                    "nombre": "Empresa 2",
                    "imagen": "jkflasdffs",
                    "latitud": -12.12,
                    "longitud": 13.93,
                    "metros": 4,
                    "minutos": 5
                ]
            )
        } catch {
            print("Error")
        }
        
        do {
            let empresas:[Empresa] = try db!.selectFrom(
                "Empresa",
                whereExpr:"nombre IS NOT NULL",
                block: Empresa.init
            )
            
            print(empresas[0].nombre)
            
        } catch {
            print("Error")
        }
    }
}

