//
//  Tools.swift
//  MiGuardianEscolar
//
//  Created by Dx on 10/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import Foundation
import UIKit

class Tools {
    
    func base64ToImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: imageData)
    }

    func imageToBase64(_ image: UIImage) -> String? {
        return image.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
}
