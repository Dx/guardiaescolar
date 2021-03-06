//
//  Horario.swift
//  MiGuardianEscolar
//
//  Created by Dx on 10/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import Foundation
import Squeal

class Horario {
    
    //MARK:- Properties
    
    let idHorario: Int
    let dias: String // 12345
    let hora: String // 17:25
    var state = 0 // 0 es Esperando horario, 1 es Ya pasó el horario, 2 Ya estoy esperando, 3 es Ya lo reporté
    
    //MARK:- Initializers
    
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
    
    //MARK:- Methods
    
    func isInSchedule(_ currentDate: Date, tolerance: Int) -> Bool {
        var result = false
        if inWeekDay(currentDate) {
            if inHour(currentDate, tolerance) {
                result = true
            }
        }
        
        return result
    }
    
    func inWeekDay(_ currentDate: Date) -> Bool {
        var result = false
        let weekday = String(Calendar.current.component(.weekday, from: currentDate) - 1)
        if dias.firstIndex(of: String.Element(weekday)) != nil {
            result = true
        }
        
        return result
    }
    
    func inHour(_ currentDate: Date, _ tolerance: Int) -> Bool {
        var result = false
        
        // Obtiene la misma fecha del día actual
        let day = Calendar.current.component(.day, from: currentDate)
        let month = Calendar.current.component(.month, from: currentDate)
        let year = Calendar.current.component(.year, from: currentDate)
        
        // Obtiene los componentes hora y minuto del horario solicitado
        let hourAsked = Int(hora.prefix(2))!
        let minutesAsked = Int(hora.suffix(2))!
        
        // Arma el date para poder comparar
        let givenDate = makeDate(year: year, month: month, day: day, hr: hourAsked, min: minutesAsked, sec: 0)
        
        // La diferencia es en segundos, así que se divide entre 60 para tener minutos
        let difference = currentDate.timeIntervalSince(givenDate) / 60
        
        // Revisa si la diferencia es menor a la tolerancia
        if abs(difference) < Double(tolerance) {
            result = true
        } else {
            if difference > 0 {
                // Este horario ya pasó
                state = 1
            }
        }
        
        return result
    }
    
    func makeDate(year: Int, month: Int, day: Int, hr: Int, min: Int, sec: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(year: year, month: month, day: day, hour: hr, minute: min, second: sec)
        return calendar.date(from: components)!
    }
}
