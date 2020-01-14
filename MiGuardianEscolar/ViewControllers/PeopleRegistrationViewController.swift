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
        
        prepareView()
        
        peopleTable.dataSource = self
        peopleTable.delegate = self
        
        updateTableData()
    }
    
    func prepareView() {
        peopleTable.separatorStyle = .singleLine
        peopleTable.tableFooterView = UIView()
        
        name.keyboardType = UIKeyboardType.namePhonePad
        phone.keyboardType = UIKeyboardType.phonePad
        email.keyboardType = UIKeyboardType.emailAddress
        
        personPhoto.layer.cornerRadius = 5
        personPhoto.layer.borderWidth = 3.0
        personPhoto.layer.borderColor = UIColor(red: 0.3, green: 0.8039, blue: 0.9843, alpha: 1).cgColor
        
        let plusImage = UIImage(named: "save")!.withRenderingMode(.alwaysTemplate)
        let button = MDCFloatingButton(frame: CGRect(x: self.view.frame.size.width / 2 - 25, y: 300, width: 50, height: 50))
        button.titleLabel?.text = "+"
        button.setImage(plusImage, for: .normal)
        button.addTarget(self, action: #selector(saveClick), for: .touchUpInside)
        self.view.addSubview(button)

    }
    
    func updateTableData() {
        let clientSQL = SQLiteClient()
        self.people = clientSQL.getEntidades()
        peopleTable.reloadData()
    }
    
    @objc func saveClick() {
        if validations() {
            var entidad = createEntidad()
            
            entidad.idEntidad = addToSQLite(entidad: entidad)
            
            addToSOAPService(entidad: entidad)
        }
        
        self.updateTableData()
        self.cleanFields()
    }
    
    func addToSOAPService(entidad: Entidad) {
        
        if selectedIdEntidad == 0 {
            // Es nuevo
            newEntidadOnService(entidad: entidad)
        } else {
            // Es actualización
            updateEntidadOnService(entidad: entidad)
        }
    }
    
    func updateEntidadOnService(entidad: Entidad) {
        let soapClient = SoapClient()
        
        soapClient.sendUpdateEntity(entidad: entidad, completion: {(result: String?, error: String?) in
            if error != nil {
                let alert = UIAlertController(title: "Error al guardar", message: error!, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            print("default")
                      }))
                self.present(alert, animated: true, completion: {() in
                    // Si se necesita hacer algo cuando se cierra
                })
            } else {
                self.updatePhotoOnService(entidad: entidad)
            }
        })
    }
    
    func updatePhotoOnService(entidad: Entidad) {
        let soapClient = SoapClient()
        
        soapClient.sendUpdatePhoto(entidad: entidad, completion: {(result: String?, error: String?) in
            if error != nil {
                print("Error al guardar la foto")
            }
        })
    }
    
    func newEntidadOnService(entidad: Entidad) {
        let soapClient = SoapClient()
        
        soapClient.sendNewEntity(entidad: entidad, completion: {(result: String?, error: String?) in
            if error != nil {
                let alert = UIAlertController(title: "Error al guardar", message: error!, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            print("default")
                      }))
                self.present(alert, animated: true, completion: {() in
                    // Si se necesita hacer algo cuando se cierra
                })
            } else {
                self.updatePhotoOnService(entidad: entidad)
            }
        })
    }
    
    func addToSQLite(entidad: Entidad) -> Int {
        let clientSQL = SQLiteClient()
        
        // Regresa el nuevo IdEntidad
        return clientSQL.addEntidad(entidad: entidad)
    }
    
    func createEntidad() -> Entidad {
        let nameText = name.text!
        let phoneText = phone.text!
        let emailText = email.text!
        var imageText = ""
        if personPhoto.image != nil {
            let tools = Tools()
            imageText = tools.imageToBase64(personPhoto.image!)!
        }
        
        return Entidad(idEntidad: selectedIdEntidad, nombre: nameText, telefono: phoneText, email: emailText, imagen: imageText)
    }
    
    func cleanFields() {
        name.text = ""
        phone.text = ""
        email.text = ""
        selectedIdEntidad = 0
        personPhoto.image = nil
        name.becomeFirstResponder()
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
        
        if var image = info[.originalImage] as? UIImage {
            image = image.resizeImage(600, opaque: true)
            self.personPhoto.image = image
        }
        
        dismiss(animated: true)
    }
}

extension UIImage {
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage

        let size = self.size
        let aspectRatio =  size.width/size.height

        switch contentMode {
            case .scaleAspectFit:
                if aspectRatio > 1 {                            // Landscape image
                    width = dimension
                    height = dimension / aspectRatio
                } else {                                        // Portrait image
                    height = dimension
                    width = dimension * aspectRatio
                }

        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }

        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
                newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }

        return newImage
    }
}
