//
//  UIImage+CVPixelBuffer.swift
//  MachineLearning
//
//  Created by Britto Thomas on 03/07/19.
//  Copyright © 2019 Britto Thomas. All rights reserved.
//

import UIKit

extension UIImage {
   
    public func pixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        var pixelBuffer :CVPixelBuffer?
        let attributes = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                          kCVPixelBufferCGBitmapContextCompatibilityKey:kCFBooleanTrue]
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(width), Int(height), kCVPixelFormatType_32ABGR, attributes as CFDictionary, &pixelBuffer)
        
        guard status == kCVReturnSuccess,
            let imageBuffer = pixelBuffer else {
                return nil
        }
        
        CVPixelBufferLockBaseAddress(<#T##pixelBuffer: CVPixelBuffer##CVPixelBuffer#>, <#T##lockFlags: CVPixelBufferLockFlags##CVPixelBufferLockFlags#>)
        
        
    }
    
}
