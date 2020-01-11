//
//  Horario.swift
//  MiGuardianEscolar
//
//  Created by Dx on 10/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import Foundation
import Squeal

struct Horario {
    let idHorario: Int
    let dias: String // 12345
    let hora: String // 17:25
    
    init(row: Statement) throws {
        idHorario = row.intValue("idHorario") ?? 0
        dias = row.stringValue("dias") ?? ""
        hora = row.stringValue("hora") ?? ""
    }
    
    init(idHorario: Int, dias: String, hora: String) {
        self.idHorario = idHorario
        self.dias = dias
        self.hora = hora
    }
}
