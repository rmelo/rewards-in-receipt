//
//  CameraCaptureButton.swift
//  rewards-in-receipt
//
//  Created by Rodrigo Melo on 13/08/19.
//  Copyright © 2019 Rodrigo Melo. All rights reserved.
//

import UIKit

@IBDesignable
class CameraCaptureButton: UIButton {
    
    var pathLayer: CAShapeLayer!
    @IBInspectable var lineSpace: CGFloat = 4
    @IBInspectable var lineWidth: CGFloat = 6
    @IBInspectable var circleWidth: CGFloat = 20
    @IBInspectable var circleBackgroundColor: UIColor = UIColor.white
    @IBInspectable var circleStrokeColor: UIColor = UIColor.white

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func awakeFromNib() {
        self.setTitle("", for: .normal)
        self.setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        self.setTitle("", for: .normal)
        self.setup()
    }
    
    func setup()
    {
        self.pathLayer = CAShapeLayer()
        
        let rect = CGRect(x: (bounds.width / 2) - (circleWidth/2),
            y: (bounds.height / 2) - (circleWidth/2),
            width: circleWidth,
            height: circleWidth)
        
        self.pathLayer.path = UIBezierPath(ovalIn: rect).cgPath
        
        self.pathLayer.strokeColor = nil
        
        self.pathLayer.fillColor = self.circleBackgroundColor.cgColor
        
        self.layer.addSublayer(self.pathLayer)
    }
    
    override func draw(_ rect: CGRect) {
    
        let rect = CGRect(x: lineSpace, y: lineSpace, width: bounds.width - (lineSpace * 2), height: bounds.height - (lineSpace * 2))
        
        let outerRing = UIBezierPath(ovalIn: rect)
        
        outerRing.lineWidth = self.lineWidth
        self.circleStrokeColor.setStroke()
        outerRing.stroke()
    }

}
