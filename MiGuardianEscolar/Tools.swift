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
    
//    func otherToImage(_ hexString: String) -> UIImage? {
//        let len = hexString.count / 2
//        var data = Data(capacity: len)
//        for i in 0..<len {
//            let j = hexString.index(hexString.startIndex, offsetBy: i*2)
//            let k = hexString.index(j, offsetBy: 2)
//            let bytes = hexString[j..<k]
//            if var num = UInt8(bytes, radix: 16){
//                data.append(&num, count:1)
//            } else {
//                return nil
//            }
//        }
//
//        return UIImage(data: data)
//    }
//
//    func ImageToOther(){
//        ByteArrayOutputStream bos = new ByteArrayOutputStream();
//        imgbmp.compress(Bitmap.CompressFormat.JPEG, 100, bos);
//        byte[] imageBytes = bos.toByteArray();
//        //ByteBuffer byteBuffer = ByteBuffer.allocate(size);
//        //imgbmp.copyPixelsToBuffer(byteBuffer);
//        //byte[] imageBytes = byteBuffer.array();
//        String imageString = globales.bytesToHex(imageBytes);
//    }
//
//    func byteToHex() {
//        public static String byteToHex(byte num) {
//            char[] hexDigits = new char[2];
//            hexDigits[0] = Character.forDigit((num >> 4) & 0xF, 16);
//            hexDigits[1] = Character.forDigit((num & 0xF), 16);
//            return new String(hexDigits);
//        }
//    }
}
