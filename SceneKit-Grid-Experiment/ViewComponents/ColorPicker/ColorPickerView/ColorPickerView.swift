//
//  ColorPickerView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 11/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol ColorPickerViewDelegate: class {
    func didTap(color: UIColor)
}

public protocol ColorPickerViewDataSource: class {
    func viewModel(InColorPickerView colorPickerView: ColorPickerView) -> ColorPickerViewModel
}

public class ColorPickerView: UIView {
    
    // MARK: - Internal properties
    
    private static let saturationExponentTop: Float = 2.0
    private static let saturationExponentBottom: Float = 1.3
    
    var elementSize: CGFloat = 20 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private weak var delegate: ColorPickerViewDelegate?
    private weak var dataSource: ColorPickerViewDataSource?
    
    // MARK: - Setup
    
    public init(delegate: ColorPickerViewDelegate, dataSource: ColorPickerViewDataSource) {
        super.init(frame: .zero)
        
        self.delegate = delegate
        self.dataSource = dataSource
        
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.clipsToBounds = true
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(didSelectColor(_:)))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        self.addGestureRecognizer(touchGesture)
    }
    
    override public func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            fatalError("Cannot retrieve the current graphics context")
        }
        
        for y in stride(from: (0 as CGFloat), to: rect.height, by: elementSize) {
            
            var saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height : 2.0 * CGFloat(rect.height - y) / rect.height
            saturation = CGFloat(powf(Float(saturation), y < rect.height / 2.0 ? ColorPickerView.saturationExponentTop : ColorPickerView.saturationExponentBottom))
            let brightness = y < rect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.height - y) / rect.height
            
            for x in stride(from: (0 as CGFloat), to: rect.height, by: elementSize) {
                let hue = x / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                context.setFillColor(color.cgColor)
                context.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
            }
        }
    }
    
    // MARK: - Color
    
    private func getColorAt(point: CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
                                   y:elementSize * CGFloat(Int(point.y / elementSize)))
        var saturation = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(2 * roundedPoint.y) / self.bounds.height
            : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < self.bounds.height / 2.0 ? ColorPickerView.saturationExponentTop : ColorPickerView.saturationExponentBottom))
        let brightness = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        let hue = roundedPoint.x / self.bounds.width
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    private func getPointForColor(color:UIColor) -> CGPoint {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);
        
        var yPos:CGFloat = 0
        let halfHeight = (self.bounds.height / 2)
        
        if (brightness >= 0.99) {
            let percentageY = powf(Float(saturation), 1.0 / ColorPickerView.saturationExponentTop)
            yPos = CGFloat(percentageY) * halfHeight
        } else {
            // Use brightness to get Y
            yPos = halfHeight + halfHeight * (1.0 - brightness)
        }
        
        let xPos = hue * self.bounds.width
        
        return CGPoint(x: xPos, y: yPos)
    }
    
    // MARK: - Gesture Recognizer
    
    @objc
    func didSelectColor(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: self)
            let color = getColorAt(point: point)
            
            delegate?.didTap(color: color)
        }
    }
}
