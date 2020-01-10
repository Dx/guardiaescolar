//
//  dbHelperExt.swift
//  MiGuardianEscolar
//
//  Created by Edgar Nuñez on 10/16/19.
//  Copyright © 2019 Heimtek SAPI de CV. All rights reserved.
//

import Foundation
import SQLite3

extension dbHelper{
    //"INSERT INTO Records (Name, EmployeeID, Designation) VALUES (?,?,?)"
    func insertEmpresa(ne: Int32, nameE: String, vlatitud: Double, vlongitud: Double, vmin: Int32, vmetros: Int32) {
        // ensure statements are created on first usage if nil
        guard self.prepareInsertEmpresaStmt() == SQLITE_OK else { return }
        
        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.insertEntryStmt)
        }
        
        //  At some places (esp sqlite3_bind_xxx functions), we typecast String to NSString and then convert to char*,
        // ex: (eventLog as NSString).utf8String. This is a weird bug in swift&#x27;s sqlite3 bridging. this conversion resolves it.
        
        if sqlite3_bind_int(self.insertEntryStmt, 1, ne) != SQLITE_OK {
            logDbErr("sqlite3_bind_int(insertEntryStmt)")
            return
        }
        if sqlite3_bind_text(self.insertEntryStmt, 3, (nameE as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            return
        }
        if sqlite3_bind_double(self.insertEntryStmt, 5, vlatitud) != SQLITE_OK {
            logDbErr("sqlite3_bind_double(insertEntryStmt)")
            return
        }
        if sqlite3_bind_double(self.insertEntryStmt, 6, vlongitud) != SQLITE_OK {
            logDbErr("sqlite3_bind_double(insertEntryStmt)")
            return
        }
        if sqlite3_bind_int(self.insertEntryStmt, 7, vmin) != SQLITE_OK {
            logDbErr("sqlite3_bind_int(insertEntryStmt)")
            return
        }
        if sqlite3_bind_int(self.insertEntryStmt, 8, vmetros) != SQLITE_OK {
            logDbErr("sqlite3_bind_int(insertEntryStmt)")
            return
        }
        
        //executing the query to insert values
        let r = sqlite3_step(self.insertEntryStmt)
        if r != SQLITE_DONE {
            logDbErr("sqlite3_step(insertEntryStmt) \(r)")
            return
        }
    }
    
    func prepareInsertEmpresaStmt() -> Int32 {
        guard insertEntryStmt == nil else { return SQLITE_OK }
        let sql = "INSERT INTO empresa (idempresa, nombre, latitud, longitud, minutos, metros) VALUES (?,?,?,?,?,?)"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &insertEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare insertEntryStmt")
        }
        return r
    }
    
    func actEmpresaInfo(ne: Int32, nameE: String, vlatitud: Double, vlongitud: Double, vmin: Int32, vmetros: Int32) {
        // ensure statements are created on first usage if nil
        guard self.prepareactEmpresaInfo() == SQLITE_OK else { return }
        
        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.updateEntryStmt)
        }
        
        //  At some places (esp sqlite3_bind_xxx functions), we typecast String to NSString and then convert to char*,
        // ex: (eventLog as NSString).utf8String. This is a weird bug in swift&#x27;s sqlite3 bridging. this conversion resolves it.
        
        if sqlite3_bind_int(self.updateEntryStmt, 8, ne) != SQLITE_OK {
            logDbErr("sqlite3_bind_int(updateEntryStmt)")
            return
        }
        if sqlite3_bind_text(self.updateEntryStmt, 1, (nameE as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(updateEntryStmt)")
            return
        }
        if sqlite3_bind_double(self.updateEntryStmt, 3, vlatitud) != SQLITE_OK {
            logDbErr("sqlite3_bind_double(updateEntryStmt)")
            return
        }
        if sqlite3_bind_double(self.updateEntryStmt, 4, vlongitud) != SQLITE_OK {
            logDbErr("sqlite3_bind_double(updateEntryStmt)")
            return
        }
        if sqlite3_bind_int(self.updateEntryStmt, 5, vmin) != SQLITE_OK {
            logDbErr("sqlite3_bind_int(updateEntryStmt)")
            return
        }
        if sqlite3_bind_int(self.updateEntryStmt, 6, vmetros) != SQLITE_OK {
            logDbErr("sqlite3_bind_int(updateEntryStmt)")
            return
        }
        //executing the query to update values
        let r = sqlite3_step(self.updateEntryStmt)
        if r != SQLITE_DONE {
            logDbErr("sqlite3_step(updateEntryStmt) \(r)")
            return
        }
    }
    
    // UPDATE operation prepared statement
    func prepareactEmpresaInfo() -> Int32 {
        guard updateEntryStmt == nil else { return SQLITE_OK }
        let sql = "UPDATE empresa SET nombre = ?, latitud = ?, longitud = ?, minutos = ?, metros = ? WHERE idempresa = ?";
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &updateEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare updateEntryStmt")
        }
        return r
    }
    
    func deleteEmpresa(ne: Int32) {
        // ensure statements are created on first usage if nil
        guard self.prepareDeleteEmpresaStmt() == SQLITE_OK else { return }
        
        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.deleteEntryStmt)
        }
        
        //  At some places (esp sqlite3_bind_xxx functions), we typecast String to NSString and then convert to char*,
        // ex: (eventLog as NSString).utf8String. This is a weird bug in swift&#x27;s sqlite3 bridging. this conversion resolves it.
        
        //Inserting name in deleteEntryStmt prepared statement
        if sqlite3_bind_int(self.deleteEntryStmt, 1, ne) != SQLITE_OK {
            logDbErr("sqlite3_bind_int(deleteEntryStmt)")
            return
        }
        
        //executing the query to delete row
        let r = sqlite3_step(self.deleteEntryStmt)
        if r != SQLITE_DONE {
            logDbErr("sqlite3_step(deleteEntryStmt) \(r)")
            return
        }
    }
    
    func prepareDeleteEmpresaStmt() -> Int32 {
        guard deleteEntryStmt == nil else { return SQLITE_OK }
        let sql = "DELETE FROM empresa WHERE idempresa = ?";
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &deleteEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare deleteEntryStmt")
        }
        return r
    }
    
    func actFotoEmpresa(ne: Int32, logo: String) {
        // ensure statements are created on first usage if nil
        guard self.prepareactFotoEmpresa() == SQLITE_OK else { return }
        
        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.updateEntryStmt)
        }
        
        //  At some places (esp sqlite3_bind_xxx functions), we typecast String to NSString and then convert to char*,
        // ex: (eventLog as NSString).utf8String. This is a weird bug in swift&#x27;s sqlite3 bridging. this conversion resolves it.
        
        if sqlite3_bind_int(self.updateEntryStmt, 2, ne) != SQLITE_OK {
            logDbErr("sqlite3_bind_int(updateEntryStmt)")
            return
        }
        if sqlite3_bind_text(self.updateEntryStmt, 1, (logo as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(updateEntryStmt)")
            return
        }
        //executing the query to update values
        let r = sqlite3_step(self.updateEntryStmt)
        if r != SQLITE_DONE {
            logDbErr("sqlite3_step(updateEntryStmt) \(r)")
            return
        }
    }
    
    // UPDATE operation prepared statement
    func prepareactFotoEmpresa() -> Int32 {
        guard updateEntryStmt == nil else { return SQLITE_OK }
        let sql = "UPDATE empresa SET imagen = ? WHERE idempresa = ?"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &updateEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare updateEntryStmt")
        }
        return r
    }
    
    //"SELECT * FROM Records WHERE EmployeeID = ? LIMIT 1"
//    func givemeEmpresaInfo(ne: Int32) -> Empresa {
//        // ensure statements are created on first usage if nil
//        var response = ""
//        guard self.prepareGivemeEmpresaStmt() == SQLITE_OK else { logDbErr("sqlite3_step COUNT* readEntryStmt:")
//            return Empresa(ide: ne, nameE: ", latitud: 0, longitud: 0, metros: 0, minutos: 0, imagen: ")
//        }
//
//        defer {
//            // reset the prepared statement on exit.
//            sqlite3_reset(self.readEntryStmt)
//        }
//
//        //  At some places (esp sqlite3_bind_xxx functions), we typecast String to NSString and then convert to char*,
//        // ex: (eventLog as NSString).utf8String. This is a weird bug in swift&#x27;s sqlite3 bridging. this conversion resolves it.
//
//        //Inserting employeeID in readEntryStmt prepared statement
//        if sqlite3_bind_int(self.readEntryStmt, 1, ne) != SQLITE_OK {
//            logDbErr("sqlite3_bind_int(readEntryStmt)")
//            return Empresa(ide: ne, nameE: ", latitud: 0, longitud: 0, metros: 0, minutos: 0, imagen: &quot;")
//        }
//        //executing the query to read value
//        if sqlite3_step(readEntryStmt) != SQLITE_ROW {
//            logDbErr("sqlite3_step COUNT* readEntryStmt:")
//            return Empresa(ide: ne, nameE: ", latitud: 0, longitud: 0, metros: 0, minutos: 0, imagen: &quot;")
//        }
//
//        return Academy(ide: ne, nameE: String(cString: sqlite3_column_text(readEntryStmt, 1)),
//        latitud: sqlite3_column_double(readEntryStmt, 2), longitud: sqlite3_column_double(readEntryStmt, 3), metros: sqlite3_column_int(readEntryStmt, 4), minutos: sqlite3_column_int(readEntryStmt, 5), imagen: String(cString: sqlite3_column_text(readEntryStmt, 6)))
//    }
    
    // READ operation prepared statement
    func prepareGivemeEmpresaStmt() -> Int32 {
        guard readEntryStmt == nil else { return SQLITE_OK }
        let sql = "SELECT * FROM empresa WHERE idempresa = ?"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &readEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare readEntryStmt")
        }
        return r
    }
    
    
}
