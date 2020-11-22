//
//  CircularProgressView.swift
//  UberApp
//
//  Created by Justyna Kowalkowska on 22/11/2020.
//

import UIKit

class CircularProgressView: UIView {
    
// MARK: - Properties
    
    var progressLayer: CAShapeLayer!
    var trackLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!

// MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Helper Functions
    
    private func configureCircleLayers() {
        pulsatingLayer = circleShapeLayer(strokeColor: .clear, fillColor: .red)
        layer.addSublayer(pulsatingLayer)
        
        trackLayer = circleShapeLayer(strokeColor: .clear, fillColor: .clear)
        layer.addSublayer(trackLayer)
        trackLayer.strokeEnd = 1
        
        progressLayer = circleShapeLayer(strokeColor: .systemPink, fillColor: .clear)
        layer.addSublayer(progressLayer)
        progressLayer.strokeEnd = 1
    }
            
    private func circleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let center = CGPoint(x: 0, y: 32)
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: self.frame.width / 2.5,
                                        startAngle: -(.pi / 2), endAngle: 1.5 * .pi,
                                        clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 12
        layer.fillColor = fillColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = self.center
        
        return layer
    }
    
}
