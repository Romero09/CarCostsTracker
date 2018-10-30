//
//  Pulsing.swift
//  CarCostsTracker
//
//  Created by pavels.vetlugins on 30/10/2018.
//  Copyright © 2018 Ilyas-Karshigabekov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Pulsing: CALayer {
    
    private var animationGroup = CAAnimationGroup()
    
    private var initialPulseScale:Float = 0
    
    private var nextPulseAfter:TimeInterval = 0
    
    private var animationDuration: TimeInterval = 1.5
    
    private var radius: CGFloat = 200
    
    private var numberOfPulses: Float = Float.infinity
    
    var isCompleted: Observable<Bool> {
        return completedAnimation.asObservable()
    }
    
    private var completedAnimation = PublishSubject<Bool>()
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init (numberOfPulses:Float, componentRadius: CGFloat, radius:CGFloat, position:CGPoint, duration: TimeInterval){
        super.init()
        self.initialPulseScale = Float(componentRadius / radius)
        self.backgroundColor = UIColor.black.cgColor
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
        self.radius = radius
        self.numberOfPulses = numberOfPulses
        self.position = position
        self.animationDuration = duration
        
        self.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        self.cornerRadius = radius
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.setupAnimationGroup()
            
            DispatchQueue.main.async {
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    self.completedAnimation.onNext(true)
                }
                
                self.add(self.animationGroup, forKey: "pulse")
                CATransaction.commit()
            }
        }
    }
    
    private func screateScaleAnimation() -> CABasicAnimation{
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = NSNumber(value: initialPulseScale)
        scaleAnimation.toValue = NSNumber(value: 1)
        scaleAnimation.duration = animationDuration
        return scaleAnimation
    }
    
    private func createOpacityAnimation() -> CAKeyframeAnimation{
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.values = [0.4, 0.8, 0]
        opacityAnimation.keyTimes = [0, 0.2, 1]
        
        return opacityAnimation
    }
    
    private func setupAnimationGroup(){
        self.animationGroup = CAAnimationGroup()
        self.animationGroup.duration = animationDuration + nextPulseAfter
        self.animationGroup.repeatCount = numberOfPulses
        let defaultCurve = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        self.animationGroup.timingFunction = defaultCurve
        self.animationGroup.animations = [screateScaleAnimation(), createOpacityAnimation()]
        
    }
}


