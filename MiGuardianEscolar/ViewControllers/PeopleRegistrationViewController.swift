//
//  PeopleRegistrationViewController.swift
//  MiGuardianEscolar
//
//  Created by Dx on 09/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

class PeopleRegistrationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var peopleTable: UITableView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    
    var people: [Persona]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peopleTable.dataSource = self
        peopleTable.delegate = self
        peopleTable.separatorStyle = .singleLine
        peopleTable.tableFooterView = UIView()
        
//        let plusImage = UIImage(named: "plus").withRenderingMode(.alwaysTemplate)
        let button = MDCFloatingButton(frame: CGRect(x: 20, y: self.view.frame.size.height - 100, width: 100, height: 50))
        button.addTarget(self, action: #selector(saveClick), for: .touchUpInside)
        self.view.addSubview(button)

        updateTableData()
    }
    
    func updateTableData() {
        let clientSQL = SQLiteClient()
        self.people = clientSQL.getPersonas()
        peopleTable.reloadData()
    }
    
    @objc func saveClick() {
        if validations() {
            let nameText = name.text!
            let phoneText = phone.text!
            let emailText = email.text!
            
            let clientSQL = SQLiteClient()
            clientSQL.addPersona(persona: Persona(idPersona: 0, nombre: nameText, telefono: phoneText, email: emailText, imagen: ""))
            
            updateTableData()
        }
    }
    
    func validations() -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = 0
        if people != nil {
            result = people!.count
        }
        return result
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none        
        cell.textLabel?.text = people![(indexPath as NSIndexPath).row].nombre
        
        return cell
    }
}
