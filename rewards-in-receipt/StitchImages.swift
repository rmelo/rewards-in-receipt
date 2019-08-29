//
//  UIImageCombine.swift
//  rewards-in-receipt
//
//  Created by Rodrigo Melo on 28/08/19.
//  Copyright © 2019 Rodrigo Melo. All rights reserved.
//

import UIKit
import CoreGraphics
import AVFoundation

func stitchImages(images: [UIImage], isVertical: Bool) -> UIImage {
    var stitchedImages : UIImage!
    
    let totalSize = images.reduce(CGSize(width: 0, height: 0)) { result, image in
        CGSize(width: image.size.width, height: image.size.height + result.height) }
    
    var offset = CGFloat(0)
    UIGraphicsBeginImageContext(totalSize)
    for image in images {
        
        let rect =  AVMakeRect(aspectRatio: image.size,
                               insideRect: CGRect(x: 0, y: offset, width: image.size.width, height: image.size.height))
        
        offset += image.size.height
        
        image.draw(in: rect)
    }
    stitchedImages = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return stitchedImages
}
