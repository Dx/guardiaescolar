//
//  QRCreatorViewController.swift
//  MiGuardianEscolar
//
//  Created by Dx on 09/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import UIKit

class QRCreatorViewController: UIViewController {
    
    //MARK:- Properties
    
    @IBOutlet weak var qrImage: UIImageView!
    
    //MARK:- View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let stringForQR = formatter.string(from: Date())

        qrImage.image = generateQRCode(from: stringForQR)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 7, y: 7)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}
