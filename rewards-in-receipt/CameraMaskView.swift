//
//  CaptureReceiptView.swift
//  rewards-in-receipt
//
//  Created by Rodrigo Melo on 10/08/19.
//  Copyright © 2019 Rodrigo Melo. All rights reserved.
//

import UIKit

@IBDesignable
class CameraMaskView: UIView {
    
    @IBInspectable var topOffset: CGFloat = 20.0
    @IBInspectable var leftOffset: CGFloat = 20.0
    @IBInspectable var bottomOffset: CGFloat = 20.0
    @IBInspectable var rightOffset: CGFloat = 20.0
    
    override func prepareForInterfaceBuilder() {
        renderMask()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        renderMask()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        renderMask()
    }
    
    
    func renderMask(){
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        
        let path = UIBezierPath(rect: bounds)
        
        let rect = CGRect(x: leftOffset,
                          y: topOffset,
                          width: bounds.width - (leftOffset + rightOffset),
                          height: bounds.height - (topOffset + bottomOffset))
        
        let rectPath = UIBezierPath(rect: rect)
        
        path.append(rectPath)
        
        maskLayer.fillRule = .evenOdd
        maskLayer.path = path.cgPath
        
        layer.mask = maskLayer
    }
    
    

}
