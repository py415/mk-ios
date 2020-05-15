//
//  ViewController.swift
//  MK
//
//  Created by Philip Yu on 5/14/20.
//  Copyright © 2020 Philip Yu. All rights reserved.
//

import UIKit

enum GestureDuration: TimeInterval {
    
    case slow = 0.6
    case mediumSlow = 0.5
    case medium = 0.4
    case mediumFast = 0.3
    case fast = 0.2
    
}

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var kartView0: UIImageView!
    @IBOutlet weak var kartView1: UIImageView!
    @IBOutlet weak var kartView2: UIImageView!
    
    // MARK: - Properties
    private var originalKartPositions = [CGPoint]()
    private let usingSpringWithDamping: CGFloat = 0.4
    private let initialSpringVelocity: CGFloat = 1
    private let animationDelay: TimeInterval = 0
    private var randomDuration: TimeInterval = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Store original kart positions
        originalKartPositions = [
            kartView0.center,
            kartView1.center,
            kartView2.center
        ]
        
    }
    
    // MARK: - IBAction Section
    
    // Allows user to move karts around
    @IBAction func didPanKartView(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let kartView = sender.view!
        
        if sender.state == .began {
            // Initiate spring animation – makes kartView bigger
            UIView.animate(withDuration: GestureDuration.slow.rawValue, delay: animationDelay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: .curveEaseIn, animations: {
                // Scale kartView up – make bigger
                kartView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: nil)
        } else if sender.state == .changed {
            // Update the karts position and assign translation
            kartView.center.x += translation.x
            kartView.center.y += translation.y
            
            sender.setTranslation(CGPoint(x: 0, y: 0), in: view)
        } else if sender.state == .ended {
            // End spring animation – makes kartView smaller
            UIView.animate(withDuration: GestureDuration.medium.rawValue, delay: animationDelay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: .curveEaseIn, animations: {
                // Scale kartView down – make kartView smaller
                kartView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
        
    }
    
    // Scale kart when user pinches
    @IBAction func didPinchKartView(_ sender: UIPinchGestureRecognizer) {
        
        let scale = sender.scale
        let kartView = sender.view!
        
        // Update karts transform property with scale from gesture
        kartView.transform = kartView.transform.scaledBy(x: scale, y: scale)
        sender.scale = 1
        
        if sender.state == .ended {
            // Render bounce animation when pinch gesture has been released
            UIView.animate(withDuration: GestureDuration.medium.rawValue, delay: animationDelay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: .curveEaseIn, animations: {
                // Return all karts to their original transformation state
                kartView.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        
    }
    
    // Rotates kart
    @IBAction func didRotateKartView(_ sender: UIRotationGestureRecognizer) {
        
        let rotation = sender.rotation
        let kartView = sender.view!
        
        // Update karts transform property with rotation from gesture
        kartView.transform = kartView.transform.rotated(by: rotation)
        sender.rotation = 0
        
        if sender.state == .ended {
            // Render bounce animation when pinch gesture has been released
            UIView.animate(withDuration: GestureDuration.medium.rawValue, delay: animationDelay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: .curveEaseIn, animations: {
                // Return all karts to their original transformation state
                kartView.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        
    }
    
    @IBAction func didDoubleTapKart(_ sender: UITapGestureRecognizer) {
        
        let kartView = sender.view!
        
        race(with: kartView)
        
    }
    
    @IBAction func didLongPressBackground(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            UIView.animate(withDuration: GestureDuration.medium.rawValue) {
                // Return all karts to their original transformation state
                self.kartView0.transform = CGAffineTransform.identity
                self.kartView1.transform = CGAffineTransform.identity
                self.kartView2.transform = CGAffineTransform.identity
                
                // Return all karts to their original positions
                self.kartView0.center = self.originalKartPositions[0]
                self.kartView1.center = self.originalKartPositions[1]
                self.kartView2.center = self.originalKartPositions[2]
            }
        }
        
    }
    
    @IBAction func didTripleTapBackground(_ sender: UITapGestureRecognizer) {
    
        print("Triple tapped")
        
        // Loop through all karts
        for kartView in view.subviews {
            // Ignore background view (background tag == 10)
            if kartView.tag == 10 { continue }
            
            // Start race with kart
            race(with: kartView)
        }
        
    }
    
    // MARK: - Private Function Section
    
    private func race(with kartView: UIView) {

        let initialPosition = kartView.center.x
        
        UIView.animate(withDuration: GestureDuration.mediumFast.rawValue, delay: animationDelay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: (initialSpringVelocity * 10), options: [.curveEaseIn], animations: {
            // Backup backwards before driving forward
            kartView.center.x -= 30
        }) { (_) in
            // Render wheelie animation
            UIView.animate(withDuration: GestureDuration.mediumFast.rawValue, delay: self.animationDelay, options: [], animations: {
                // Start wheelie animation
                kartView.transform = CGAffineTransform(rotationAngle: CGFloat((-30) * Double.pi / 180))
            }) { (_) in
                // End wheelie animation
                UIView.animate(withDuration: GestureDuration.mediumFast.rawValue, animations: {
                    kartView.transform = CGAffineTransform(rotationAngle: 0)
                })
            }
        }
        
        randomDuration = TimeInterval.random(in: 0.5 ... 1.5)
        
        UIView.animate(withDuration: randomDuration, delay: animationDelay, options: .curveEaseIn, animations: {
            kartView.center.x += 400
        }) { (_) in
            self.resetPosition(for: kartView, at: initialPosition)
        }
        
    }
    
    private func resetPosition(for kartView: UIView, at initialPosition: CGFloat) {
        
        kartView.center.x = 0 - kartView.frame.width
        
        UIView.animate(withDuration: 0.6) {
            kartView.center.x = initialPosition
        }
        
    }
}

// MARK: - UIGestureRecognizerDelegate Section

extension ViewController: UIGestureRecognizerDelegate {
    
    // Allow for multiple gestures simultaneously
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
}
