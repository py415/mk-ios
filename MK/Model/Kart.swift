//
//  Kart.swift
//  MK
//
//  Created by Philip Yu on 5/16/20.
//  Copyright © 2020 Philip Yu. All rights reserved.
//

import UIKit

class Kart: UIImageView {
    
    // MARK: - Properties
    var speedDictionary: [String: TimeInterval] = [:]
    
    // MARK: - Initialization
    override init(image: UIImage?) {
        
        super.init(image: image)
        
        // Set kart properties
        self.isUserInteractionEnabled = true
        self.frame = CGRect(x: 20, y: 500, width: 120, height: 120)
        self.contentMode = .scaleAspectFit
        self.tag = getTag(for: image!)
        
        // Set gestures
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanKartView(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinchKartView(_:)))
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotateKartView(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapKartView(_:)))
        let gestures: [UIGestureRecognizer]
        
        tapGesture.numberOfTapsRequired = 1
        gestures = [
            panGesture,
            pinchGesture,
            rotateGesture,
            tapGesture
        ]
        
        for gesture in gestures {
            self.addGestureRecognizer(gesture)
            gesture.delegate = self
        }
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // MARK: - Private Fuctions Section
    
    private func getTag(for image: UIImage) -> Int {
        
        var tag: Int
        
        switch image {
        case UIImage(named: "mario"):
            tag = 0
        case UIImage(named: "luigi"):
            tag = 1
        case UIImage(named: "princesstoadstool"):
            tag = 2
        case UIImage(named: "yoshi"):
            tag = 3
        case UIImage(named: "bowser"):
            tag = 4
        case UIImage(named: "donkeykong"):
            tag = 5
        case UIImage(named: "koopatroopa"):
            tag = 6
        case UIImage(named: "toad"):
            tag = 7
        default:
            tag = -1
        }
        
        return tag
        
    }
    
    private func resetKartPosition(for kartView: UIView, at initialPosition: CGFloat) {
        
        kartView.center.x = 0 - kartView.frame.width
        
        UIView.animate(withDuration: 0.4) {
            kartView.center.x = initialPosition
        }
        
    }
    
    func drive() {
        
        // Initial kart position
        let initialPosition = self.center.x
        
        // Create zoom animation
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: [.curveEaseIn], animations: {
            // Move backwards before driving forward
            self.center.x -= 30
        }) { (_) in
            // Render wheelie animation
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                // Start wheelie animation
                self.transform = CGAffineTransform(rotationAngle: CGFloat((-30) * Double.pi / 180))
            }) { (_) in
                // End wheelie animation
                UIView.animate(withDuration: 0.3, animations: {
                    self.transform = CGAffineTransform(rotationAngle: 0)
                })
            }
        }
        
        let randomDuration = TimeInterval.random(in: 0.5 ... 1.5)
        speedDictionary["\(Constant.getKart(usingTag: self.tag))"] = randomDuration
        
        // Create race animation – move all karts
        UIView.animate(withDuration: randomDuration, delay: 0, options: .curveEaseIn, animations: {
            // Move karts across screen
            self.center.x += 400
        }) { (_) in
            // Reset karts to original position
            self.resetKartPosition(for: self, at: initialPosition)
        }
        
    }
    
    // MARK: - Gestures Section
    
    // Allows user to move karts around
    @objc private func didPanKartView(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self)
        let kartView = sender.view!
        
        if sender.state == .began {
            // Initiate spring animation – makes kartView bigger
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                // Scale kartView up – make bigger
                kartView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: nil)
        } else if sender.state == .changed {
            // Update the karts position and assign translation
            kartView.center.x += translation.x
            kartView.center.y += translation.y
            
            // Reset gesture scale
            sender.setTranslation(CGPoint(x: 0, y: 0), in: self)
        } else if sender.state == .ended {
            // End spring animation – makes kartView smaller
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                // Scale kartView down – make kartView smaller
                kartView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
        
    }
    
    // Scale kart when user pinches
    @objc private func didPinchKartView(_ sender: UIPinchGestureRecognizer) {
        
        let scale = sender.scale
        let kartView = sender.view!
        
        // Update karts transform property with scale from gesture
        kartView.transform = kartView.transform.scaledBy(x: scale, y: scale)
        sender.scale = 1
        
        if sender.state == .ended {
            // Render bounce animation when pinch gesture has been released
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                // Return all karts to their original transformation state
                kartView.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        
    }
    
    // Rotates kart
    @objc private func didRotateKartView(_ sender: UIRotationGestureRecognizer) {
        
        let rotation = sender.rotation
        let kartView = sender.view!
        
        // Update karts transform property with rotation from gesture
        kartView.transform = kartView.transform.rotated(by: rotation)
        sender.rotation = 0
        
        if sender.state == .ended {
            // Render bounce animation when pinch gesture has been released
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                // Return all karts to their original transformation state
                kartView.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        
    }
    
    // Drive double tapped kart
    @objc private func didTapKartView(_ sender: UITapGestureRecognizer) {
        
        let kart = Constant.getKart(usingTag: self.tag)
        print("\(kart.capitalizingFirstLetter()) is driving...")
        drive()
        
    }
    
}

// MARK: - UIGestureRecognizerDelegate Section

extension Kart: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
}
