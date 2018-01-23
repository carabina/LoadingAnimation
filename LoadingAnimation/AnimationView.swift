//
//  AnimationView.swift
//  LoadingAnimation
//
//  Created by xuech on 2018/1/23.
//  Copyright © 2018年 xuech. All rights reserved.
//

import UIKit

protocol AnimationViewDelegate: class {
    func completeAnimation()
}

class AnimationView: UIView {

    let circleLayer = CircleLayer()
    let triangleLayer = TriangleLayer()
    let redRectangleLayer = RectangleLayer()
    let blueRectangleLayer = RectangleLayer()
    let waveLayer = WaveLayer()
    var parentFrame: CGRect = CGRect.zero
    weak var delegate: AnimationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addCircleLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func addCircleLayer(){
        self.layer.addSublayer(circleLayer)
        circleLayer.expand()
        Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(wobbleCircleLayer), userInfo: nil, repeats: false)
    }
    
    @objc func wobbleCircleLayer() {
        circleLayer.wobbleAnimate()
        layer.addSublayer(triangleLayer)
        Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(showTriangleAnimation), userInfo: nil, repeats: false)
    }
    
    @objc func showTriangleAnimation() {
        triangleLayer.triangleAnimate()
        Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(transformAnima), userInfo: nil, repeats: false)
    }
    
    @objc func transformAnima() {
        transformRotationZ()
        circleLayer.contract()
        Timer.scheduledTimer(timeInterval: 0.45, target: self, selector: #selector(drawRedRectangleAnimation), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: 0.65, target: self, selector: #selector(drawBlueRectangleAnimation), userInfo: nil, repeats: false)
    }
    
    private func transformRotationZ(){
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.65)
        let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = 0.45
        rotationAnimation.isRemovedOnCompletion = true
        layer.add(rotationAnimation, forKey: nil)
    }
    
    @objc private func drawRedRectangleAnimation () {
        layer.addSublayer(redRectangleLayer)
        redRectangleLayer.strokeChangeWithColor(color: UIColor.colorWithHexString(hex: "#da70d6"))
    }
    
    @objc private func drawBlueRectangleAnimation() {
        layer.addSublayer(blueRectangleLayer)
        blueRectangleLayer.strokeChangeWithColor(color: UIColor.colorWithHexString(hex: "#40e0b0"))
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(drawWaveAnimation), userInfo: nil, repeats: false)
    }
    
    @objc private func drawWaveAnimation(){
        layer.addSublayer(waveLayer)
        waveLayer.animate()
        Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(expandView), userInfo: nil, repeats: false)
    }
    ///控制水波形状
    @objc private func expandView() {
        backgroundColor = UIColor.colorWithHexString(hex: "#40e0b0")
        frame = CGRect(x: frame.origin.x - blueRectangleLayer.lineWidth,
                       y: frame.origin.y - blueRectangleLayer.lineWidth,
                       width: frame.size.width + blueRectangleLayer.lineWidth * 2,
                       height: frame.size.height + blueRectangleLayer.lineWidth * 2)
        layer.sublayers = nil
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.frame = self.parentFrame
        }, completion: { finished in
            self.delegate?.completeAnimation()
        })
    }
    
    
 

}
