//
//  PeopleRegistrationViewController.swift
//  MiGuardianEscolar
//
//  Created by Dx on 09/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

class PeopleRegistrationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var peopleTable: UITableView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var personPhoto: UIImageView!
    
    var people: [Entidad]?
    var selectedIdEntidad = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peopleTable.dataSource = self
        peopleTable.delegate = self
        peopleTable.separatorStyle = .singleLine
        peopleTable.tableFooterView = UIView()
        
//        let plusImage = UIImage(named: "plus").withRenderingMode(.alwaysTemplate)
        let button = MDCFloatingButton(frame: CGRect(x: self.view.frame.size.width / 2 - 25, y: 300, width: 50, height: 50))
        button.titleLabel?.text = "+"
        button.addTarget(self, action: #selector(saveClick), for: .touchUpInside)
        self.view.addSubview(button)

        updateTableData()
    }
    
    func updateTableData() {
        let clientSQL = SQLiteClient()
        self.people = clientSQL.getEntidades()
        peopleTable.reloadData()
    }
    
    @objc func saveClick() {
        if validations() {
            let nameText = name.text!
            let phoneText = phone.text!
            let emailText = email.text!
            var imageText = ""
            if personPhoto.image != nil {
                let tools = Tools()
                imageText = tools.imageToBase64(personPhoto.image!)!
            }
            
            let clientSQL = SQLiteClient()
            clientSQL.addEntidad(entidad: Entidad(idEntidad: selectedIdEntidad, nombre: nameText, telefono: phoneText, email: emailText, imagen: imageText))
            
            updateTableData()
            cleanFields()
        }
    }
    
    func cleanFields() {
        name.text = ""
        phone.text = ""
        email.text = ""
        selectedIdEntidad = 0
        personPhoto.image = nil
    }
    
    func validations() -> Bool {
        var result = false
        if var nameText = name.text {
            nameText = nameText.trimmingCharacters(in:
                .whitespacesAndNewlines)
            if nameText != "" {
                name.text = nameText
                result = true
            } else {
                result = false
            }
        }
        
        return result
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        fillData(entidad: people![indexPath.row])
    }
    
    func fillData(entidad: Entidad) {
        selectedIdEntidad = entidad.idEntidad
        name.text = entidad.nombre
        phone.text = entidad.telefono
        email.text = entidad.email
        let tools = Tools()
        personPhoto.image = tools.base64ToImage(entidad.imagen)
    }
    
    func photoLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        }
    }
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.showsCameraControls = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func takePhotoClick(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cámara", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Galería de fotos", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            self.personPhoto.image = image
        }
        
        dismiss(animated: true)
    }
}
