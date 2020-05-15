//
//  ViewController.swift
//  MK
//
//  Created by Philip Yu on 5/14/20.
//  Copyright © 2020 Philip Yu. All rights reserved.
//

import UIKit
import FLAnimatedImage

enum GestureDuration: TimeInterval {
    
    case slow = 0.6
    case mediumSlow = 0.5
    case medium = 0.4
    case mediumFast = 0.3
    case fast = 0.2
    
}

enum Character: String {
    
    case bowser = "Bowser"
    case mario = "Mario"
    case toad = "Toad"
    
}

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var kartView0: UIImageView!
    @IBOutlet weak var kartView1: UIImageView!
    @IBOutlet weak var kartView2: UIImageView!
    @IBOutlet weak var cloudAnimatedView: FLAnimatedImageView!
    
    // MARK: - Properties
    private let usingSpringWithDamping: CGFloat = 0.4
    private let initialSpringVelocity: CGFloat = 1
    private let animationDelay: TimeInterval = 0
    
    private var karts = [UIImageView]()
    private var originalKartPositions = [CGPoint]()
    private var randomDuration: TimeInterval = 0
    private var backingView: UIView!
    private var cloudAnimatedImage: FLAnimatedImage?
    private var cloudDownCenter = CGPoint.zero
    private var cloudUpCenter = CGPoint.zero
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Store karts in array
        karts = [
            kartView0,
            kartView1,
            kartView2
        ]
        
        // Store original kart positions
        originalKartPositions = [
            kartView0.center,
            kartView1.center,
            kartView2.center
        ]
        
        // Set position where cloud will drop
        cloudDownCenter = cloudAnimatedView.center
        
        // Set initial cloud position
        cloudUpCenter.x = cloudDownCenter.x
        cloudUpCenter.y = 0 - cloudAnimatedView.frame.size.height / 2
        cloudAnimatedView.center = cloudUpCenter
        
        // Set animated cloud gif
        let gifData = Constant.fetchResource(named: "cloudAnimated", ofType: "gif")
        let animatedImage = FLAnimatedImage(animatedGIFData: gifData)
        
        cloudAnimatedImage = animatedImage
        
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
            
            // Reset gesture scale
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
    
    // Drive double tapped kart
    @IBAction func didDoubleTapKart(_ sender: UITapGestureRecognizer) {
        
        let kartView = sender.view!
        
        print("[\(type(of: sender))] Start moving \(getCharacter(usingTag: kartView.tag)) kart...")
        
        startRace(with: [kartView])
        
    }
    
    // Start race with all karts
    @IBAction func didTripleTapBackground(_ sender: UITapGestureRecognizer) {
        
        print("[\(type(of: sender))] Starting race...")
        
        // Reset cloud animated image view
        cloudAnimatedView.animatedImage = nil
        // Loud animated image to image view
        cloudAnimatedView.animatedImage = cloudAnimatedImage
        // Temporarily freeze animation (to get first frame) until cloud is down in view
        cloudAnimatedView.stopAnimating()
        
        // Start cloud drop animation
        UIView.animate(withDuration: GestureDuration.mediumFast.rawValue, delay: animationDelay, options: .curveEaseOut, animations: {
            self.cloudAnimatedView.center = self.cloudDownCenter
        }) { (_) in
            UIView.animate(withDuration: 0.8, delay: self.animationDelay, options: [.autoreverse, .repeat], animations: {
                self.cloudAnimatedView.center.y -= 40
            }, completion: nil)
        }
        
        // Start cloud gif animation
        self.cloudAnimatedView.startAnimating()
        
        self.cloudAnimatedView.loopCompletionBlock = {_ in
            self.cloudAnimatedView.stopAnimating()
            
            var kartViews = [UIView]()
            
            for kartView in self.view.subviews {
                // Move all views that are not < 0 (karts)
                if kartView.tag < 0 { continue }
                
                kartViews.append(kartView)
            }
            
            // Generate random kart finishers sequence (winner is position 0)
            let finishingSequence = kartViews.shuffled()
            
            // Kick off race animations
            self.startRace(with: finishingSequence)
        }
        
    }
    
    // Reset kart to initial position
    @IBAction func didLongPressBackground(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            print("[\(type(of: sender))] Resetting kart to initial position and transformation state...")
            
            UIView.animate(withDuration: GestureDuration.medium.rawValue) {
                
                for (index, kart) in self.karts.enumerated() {
                    // Return all karts to their initial transformation state
                    kart.transform = CGAffineTransform.identity
                    // Return all karts to their initial positions
                    kart.center = self.originalKartPositions[index]
                }
                
            }
        }
        
    }
    
    // MARK: - Private Function Section
    
    private func startRace(with kartViews: [UIView]) {
        
        for (index, kartView) in kartViews.enumerated() {
            // Initial kart position
            let initialPosition = kartView.center.x
            
            // Create zoom animation
            UIView.animate(withDuration: GestureDuration.mediumFast.rawValue, delay: animationDelay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: (initialSpringVelocity * 10), options: [.curveEaseIn], animations: {
                // Move backwards before driving forward
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
            
            // Create race animation – move all karts
            UIView.animate(withDuration: randomDuration, delay: animationDelay, options: .curveEaseIn, animations: {
                // Move karts across screen
                kartView.center.x += self.view.frame.width + 400
            }) { (_) in
                if kartViews.count > 1 && index == kartViews.count - 1 {
                    self.animateWinnerCard(with: kartViews)
                } else if index == kartViews.count - 1 {
                    self.resetKartPosition(for: kartView, at: initialPosition)
                }
            }
        }
        
    }
    
    // Creates winner card
    private func animateWinnerCard(with kartViews: [UIView]) {
        
        // Create winner card
        let backingView = UIView(frame: self.view.frame)
        let winnerCardView = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapWinnerCard(_:)))
        let gifData = Constant.fetchResource(named: "winner_\(kartViews[0].tag)", ofType: "gif")
        let animatedImage = FLAnimatedImage(animatedGIFData: gifData)
        let animatedWinnerView = FLAnimatedImageView()
        let label = UILabel()
        
        // Set backing view properties
        backingView.backgroundColor = .black
        backingView.alpha = 0
        
        // Set tap gesture properties
        tapGesture.numberOfTapsRequired = 1
        
        // Set winner card properties
        winnerCardView.isUserInteractionEnabled = true
        winnerCardView.frame.size.width = backingView.frame.size.width * 0.7
        winnerCardView.frame.size.height = backingView.frame.size.height * 0.5
        winnerCardView.center.x = backingView.center.x
        winnerCardView.center.y = 0 - winnerCardView.frame.size.height / 2
        winnerCardView.layer.cornerRadius = 30
        winnerCardView.backgroundColor = .white
        winnerCardView.addGestureRecognizer(tapGesture)
        
        // Set animated winner view properties
        animatedWinnerView.frame.size.width = winnerCardView.frame.size.width * 0.8
        animatedWinnerView.frame.size.height = animatedWinnerView.frame.size.width
        animatedWinnerView.center.x = winnerCardView.frame.size.width / 2
        animatedWinnerView.center.y = winnerCardView.frame.size.height / 3 * 2
        animatedWinnerView.contentMode = .scaleAspectFit
        animatedWinnerView.clipsToBounds = true
        animatedWinnerView.animatedImage = animatedImage
        
        // Set label properties
        label.frame.size.width = 200
        label.frame.size.height = 200
        label.center.x = winnerCardView.frame.size.width / 2
        label.center.y = winnerCardView.frame.size.height / 4.5
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 100, weight: .thin)
        label.text = "🏆"
        label.textAlignment = .center
        
        // Add animated winner view to winner card
        winnerCardView.addSubview(animatedWinnerView)
        // Add label to winner card
        winnerCardView.addSubview(label)
        
        // Add winner card to view
        self.backingView = backingView
        self.view.addSubview(self.backingView)
        self.view.addSubview(winnerCardView)
        
        // Render winner card animation
        UIView.animate(withDuration: 1, delay: self.animationDelay, usingSpringWithDamping: 0.6, initialSpringVelocity: self.initialSpringVelocity, options: .curveEaseOut, animations: {
            winnerCardView.center = backingView.center
            self.backingView.alpha = 0.8
            self.cloudAnimatedView.center = self.cloudUpCenter
        }, completion: nil)
        
    }
    
    // Dismiss winner card when tapped
    @objc private func didTapWinnerCard(_ sender: UITapGestureRecognizer) {
        
        let winnerCardView = sender.view!
        
        // Render animation to dismiss winner card
        UIView.animate(withDuration: GestureDuration.medium.rawValue, delay: animationDelay, options: .curveEaseIn, animations: {
            winnerCardView.frame.origin.y = self.view.frame.size.height
            self.backingView.alpha = 0
        }) { (_) in
            // Remove winner card from view
            winnerCardView.removeFromSuperview()
            self.backingView.removeFromSuperview()
        }
        
    }
    
    // Reset positions of karts
    private func resetKartPosition(for kartView: UIView, at initialPosition: CGFloat) {
        
        kartView.center.x = 0 - kartView.frame.width
        
        UIView.animate(withDuration: 0.6) {
            kartView.center.x = initialPosition
        }
        
    }
    
    // Fetches characters name using image view tag
    private func getCharacter(usingTag tag: Int) -> Character.RawValue {
        
        var character: Character
        
        switch tag {
        case 0:
            character = Character.bowser
        case 1:
            character = Character.mario
        case 2:
            character = Character.toad
        default:
            character = Character.bowser
        }
        
        return character.rawValue
        
    }
    
}

// MARK: - UIGestureRecognizerDelegate Section

extension ViewController: UIGestureRecognizerDelegate {
    
    // Allow for multiple gestures simultaneously
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
}
