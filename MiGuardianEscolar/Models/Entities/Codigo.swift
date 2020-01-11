//
//  Codigo.swift
//  MiGuardianEscolar
//
//  Created by Dx on 10/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import Foundation
import Squeal

struct Codigo {
    let codigo: String
    let pin: String
    
    init(row: Statement) throws {
        codigo = row.stringValue("codigo") ?? ""
        pin = row.stringValue("pin") ?? ""
    }
    
    init(codigo: String, pin: String) {
        self.codigo = codigo
        self.pin = pin
    }
}
