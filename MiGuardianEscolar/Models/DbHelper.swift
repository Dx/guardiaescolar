//
//  dbHelper.swift
//  MiGuardianEscolar
//
//  Created by Edgar Nuñez on 10/16/19.
//  Copyright © 2019 Heimtek SAPI de CV. All rights reserved.
//

import Foundation
import SQLite3
import os.log

class dbHelper {
    // Get the URL to db store file
        let dbURL: URL
        // The database pointer.
        var db: OpaquePointer?
        // Prepared statement https://www.sqlite.org/c3ref/stmt.html to insert an event into Table.
        // we use prepared statements for efficiency and safe guard against sql injection.
        var insertEntryStmt: OpaquePointer?
        var readEntryStmt: OpaquePointer?
        var updateEntryStmt: OpaquePointer?
        var deleteEntryStmt: OpaquePointer?
        
        let oslog = OSLog(subsystem: "MGE", category: "sqliteintegration")

        init() {
            do {
                do {
                    dbURL = try FileManager.default
                        .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                        .appendingPathComponent("mge.db")
                    os_log("URL: %s", dbURL.absoluteString)
                } catch {
                    //TODO: Just logging the error and returning empty path URL here. Handle the error gracefully after logging
                    os_log("Some error occurred. Returning empty path.")
                    dbURL = URL(fileURLWithPath: "")
                    return
                }
                
                try openDB()
                try createTables()
                } catch {
                    //TODO: Handle the error gracefully after logging
                    os_log("Some error occurred. Returning.")
                    return
                }
        }
        
        // Command: sqlite3_open(dbURL.path, &db)
        // Open the DB at the given path. If file does not exists, it will create one for you
        func openDB() throws {
            if sqlite3_open(dbURL.path, &db) != SQLITE_OK { // error mostly because of corrupt database
                os_log("error opening database at %s", log: oslog, type: .error, dbURL.absoluteString)
    //            deleteDB(dbURL: dbURL)
                throw SqliteError(message: "error opening database \(dbURL.absoluteString)")
            }
        }
        
        // Code to delete a db file. Useful to invoke in case of a corrupt DB and re-create another
        func deleteDB(dbURL: URL) {
            os_log("removing db", log: oslog)
            do {
                try FileManager.default.removeItem(at: dbURL)
            } catch {
                os_log("exception while removing db %s", log: oslog, error.localizedDescription)
            }
        }
        
        func createTables() throws {
            // create the tables if they dont exist.
            
            // create the table to store the entries.
            // ID | Name | Employee Id | Designation
            var ret =  sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS empresa (idempresa INTEGER PRIMARY KEY, nombre TEXT NOT NULL, imagen TEXT, latitud REAL, longitud REAL, minutos INTEGER, metros INTEGER)", nil, nil, nil)
            if (ret != SQLITE_OK) { // corrupt database.
                logDbErr("Error creating db table - empresa")
                throw SqliteError(message: "unable to create table empresa")
            }
            ret =  sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS horarios (idhorario INTEGER PRIMARY KEY, dias TEXT NOT NULL, hora TEXT NOT NULL)", nil, nil, nil)
            if (ret != SQLITE_OK) { // corrupt database.
                logDbErr("Error creating db table - horarios")
                throw SqliteError(message: "unable to create table horarios")
            }
        }
        
        func logDbErr(_ msg: String) {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            os_log("ERROR %s : %s", log: oslog, type: .error, msg, errmsg)
        }
    }

    // Indicates an exception during a SQLite Operation.
    class SqliteError : Error {
        var message = ";"
        var error = SQLITE_ERROR
        init(message: String = "") {
            self.message = message
        }
        init(error: Int32) {
            self.error = error
        }
    }
