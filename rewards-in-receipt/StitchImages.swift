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

//func stitchImages(images: [UIImage], isVertical: Bool) -> UIImage {
//    var stitchedImages : UIImage!
//    if images.count > 0 {
//        var maxWidth = CGFloat(0), maxHeight = CGFloat(0)
//        for image in images {
//            if image.size.width > maxWidth {
//                maxWidth = image.size.width
//            }
//            if image.size.height > maxHeight {
//                maxHeight = image.size.height
//            }
//        }
//        var totalSize : CGSize
//        let maxSize = CGSize(width: maxWidth, height: maxHeight)
//        if isVertical {
//            totalSize = CGSize(width: maxSize.width, height: maxSize.height * (CGFloat)(images.count))
//        } else {
//            totalSize = CGSize(width: maxSize.width  * (CGFloat)(images.count), height:  maxSize.height)
//        }
//        UIGraphicsBeginImageContext(totalSize)
//        for image in images {
//            let offset = (CGFloat)(images.index(of: image)!)
//            let rect =  AVMakeRect(aspectRatio: image.size, insideRect: isVertical ?
//                CGRect(x: 0, y: maxSize.height * offset, width: maxSize.width, height: maxSize.height) :
//                CGRect(x: maxSize.width * offset, y: 0, width: maxSize.width, height: maxSize.height))
//            image.draw(in: rect)
//        }
//        stitchedImages = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//    }
//    return stitchedImages
//}

//func stitchImages(images: [UIImage], isVertical: Bool) -> UIImage {
//
//    var stitchedImages : UIImage!
//
//    let totalSize = images.reduce(CGSize(width: 0, height: 0)) { result, image in
//        CGSize(width: image.size.width, height: image.size.height + result.height) }
//
//    UIGraphicsBeginImageContext(totalSize)
//
//    for image in images{
//
//    }
//
//    return images.first!
//}

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
