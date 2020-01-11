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
    
    
    func createTables() {
        
        createEmpresas()
        createEntidades()
        createAcercamientos()
        createHorarios()
        createCodigos()
    }
    
    func createEmpresas() {
        do {
            try globalVariables.db!.createTable("Empresa", definitions: [
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
            try globalVariables.db!.createTable("Entidades", definitions: [
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
            try globalVariables.db!.createTable("Acercamientos", definitions: [
                "nAcerca INTEGER PRIMARY KEY",
                "fecha TEXT"
            ], ifNotExists: true)
        } catch {
            print("Error \(error)")
        }
    }
    
    func createHorarios() {
        do {
            try globalVariables.db!.createTable("Horarios", definitions: [
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
            try globalVariables.db!.createTable("Codigos", definitions: [
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
                    try globalVariables.db!.update("Empresa", set: [
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
                    try globalVariables.db!.insertInto(
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
            let empresas:[Empresa] = try globalVariables.db!.selectFrom(
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
    
    func getAllEmpresas(empresa: Empresa) -> [Empresa]? {
        do {
            let empresas:[Empresa] = try globalVariables.db!.selectFrom(
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
    
    func addCodigo(codigo: String) {
        
        if let codigos = self.getCodigo(codigo: codigo) {
            if codigos.count > 0 {
                do {
                    try globalVariables.db!.update("Codigos", set: [
                        "codigo": codigo,
                        "pin": ""
                    ],
                    whereExpr:"codigo = '\(codigo)'")
                } catch {
                    print("Error \(error)")
                }
            } else {
                do {
                    try globalVariables.db!.insertInto("Codigos", values: [
                        "codigo": codigo,
                        "pin": ""
                    ])
                } catch {
                    print("Error \(error)")
                }
            }
        }
    }
    
    func getCodigo(codigo: String) -> [Codigo]? {
        do {
            let codigos:[Codigo] = try globalVariables.db!.selectFrom(
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
    
    func test() {
        
        let value1: Double = 12.12
        let value2: Int = 3
        
        do {
            try globalVariables.db!.insertInto(
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
            let idEmpresa = try globalVariables.db!.insertInto(
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
            let empresas:[Empresa] = try globalVariables.db!.selectFrom(
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

