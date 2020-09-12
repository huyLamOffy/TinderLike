//
//  SwipableContainer.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/12/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import UIKit

class SwipableContainer: UIView {
    
    //MARK: - Properties
    var xCenter: CGFloat = 0.0
    var yCenter: CGFloat = 0.0
    let theresoldMargin = (UIScreen.main.bounds.size.width/2) * 0.75
    let stength : CGFloat = 4
    let range : CGFloat = 0.90
    var originalPoint: CGPoint = .zero
    var didRemovedCardHandler: (() -> Void)?
    var didGoRightHandler: (() -> Void)?
    var didGoLeftHandler: (() -> Void)?
    
    //MARK: - View Cycle Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        originalPoint = center
        addSwipablePansGesture()
    }
    
    //MARK: - Actions
    
    //MARK: - Private Methods
    func addSwipablePansGesture() {
        let panRecognizer = UIPanGestureRecognizer(target:self, action: #selector(self.beingDragged(_:)))
        panRecognizer.delegate = self
        addGestureRecognizer(panRecognizer)
    }
    
    func cardGoesRight() {
        didGoRightHandler?()
        let finishPoint = CGPoint(x: frame.size.width*2, y: 2 * yCenter + originalPoint.y)
        UIView.animate(withDuration: 0.5, animations: {
            self.center = finishPoint
        }, completion: {(_) in
            self.didRemovedCardHandler?()
        })
    }
    
    func cardGoesLeft() {
        didGoLeftHandler?()
        let finishPoint = CGPoint(x: -frame.size.width*2, y: 2 * yCenter + originalPoint.y)
        UIView.animate(withDuration: 0.5, animations: {
            self.center = finishPoint
        }, completion: {(_) in
            self.didRemovedCardHandler?()
        })
    }
}

// MARK: UIGestureRecognizerDelegate Methods
extension SwipableContainer: UIGestureRecognizerDelegate {
    
    /*
     * Gesture methods
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /*
     * Gesture methods
     */
    @objc fileprivate func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        xCenter = gestureRecognizer.translation(in: self).x
        yCenter = gestureRecognizer.translation(in: self).y
        switch gestureRecognizer.state {
        // Keep swiping
        case .began:
            originalPoint = center
            break;
        //in the middle of a swipe
        case .changed:
            let rotationStrength = min(xCenter / UIScreen.main.bounds.size.width, 1)
            let rotationAngel = .pi/8 * rotationStrength
            let scale = max(1 - abs(rotationStrength) / stength, range)
            center = CGPoint(x: originalPoint.x + xCenter, y: originalPoint.y + yCenter)
            let transforms = CGAffineTransform(rotationAngle: rotationAngel)
            let scaleTransform: CGAffineTransform = transforms.scaledBy(x: scale, y: scale)
            self.transform = scaleTransform
            break;
            
        // swipe ended
        case .ended:
            afterSwipeAction()
            break;
            
        case .possible: break
        case .cancelled: break
        case .failed: break
        @unknown default:
            assertionFailure()
            break
        }
    }
    
    private func afterSwipeAction() {
        
        if xCenter > theresoldMargin {
            cardGoesRight()
        }
        else if xCenter < -theresoldMargin {
            cardGoesLeft()
        }
        else {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
            })
        }
    }
}
