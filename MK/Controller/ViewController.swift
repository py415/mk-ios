//
//  ViewController.swift
//  MK
//
//  Created by Philip Yu on 5/14/20.
//  Copyright © 2020 Philip Yu. All rights reserved.
//

import UIKit
import FLAnimatedImage

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var cloudAnimatedView: FLAnimatedImageView!
    
    // MARK: - Properties
    private var backingView: UIView!
    private var cloudAnimatedImage: FLAnimatedImage?
    private var cloudDownCenter = CGPoint.zero
    private var cloudUpCenter = CGPoint.zero
    private var karts = [Kart]()
    private var originalKartPositions = [CGPoint]()
    private var speedDictionary: [String: TimeInterval] = [:]
    private var winner: String?
    private var kartExistsInView = [String]()
    private var xPosition: CGFloat!
    private var yPosition: CGFloat!
    
    private let screenSize = UIScreen.main.bounds
    private let maxmimumKarts = 8
    private let kartWidth: CGFloat = 120
    private let kartHeight: CGFloat = 120
    private let characters = [
        "mario", "luigi", "princesstoadstool", "yoshi", "bowser", "donkeykong", "koopatroopa", "toad"
    ]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        xPosition = 20
        yPosition = screenSize.height - kartHeight - 20
        
        // Set position where cloud will drop
        cloudDownCenter = cloudAnimatedView.center
        
        // Set initial cloud position
        cloudUpCenter.x = cloudDownCenter.x
        cloudUpCenter.y = 0 - cloudAnimatedView.frame.size.height / 2
        cloudAnimatedView.center = cloudUpCenter
        
        // Set animated cloud gif
        let gifData = Constant.fetchResource(named: "lakitu", ofType: "gif")
        let animatedImage = FLAnimatedImage(animatedGIFData: gifData)
        
        cloudAnimatedImage = animatedImage
        
    }
    
    // MARK: - IBAction Section
    
    // Remove all karts button pressed
    @IBAction func removeAllKartsPressed(_ sender: UIBarButtonItem) {
        
        for kart in self.view.subviews where kart.tag >= 0 {
            kart.removeFromSuperview()
        }
        
        karts.removeAll()
        kartExistsInView.removeAll()
        xPosition = 20
        yPosition = screenSize.height - kartHeight - 20
        
    }
    
    // Add new kart in view
    @IBAction func addKartPressed(_ sender: UIBarButtonItem) {
        
        print("Add kart pressed...")
        
        if karts.count < maxmimumKarts {
            checkIfKartExistsInView()
            
            for character in characters {
                // Check if kart exists
                if !kartExistsInView.contains(character) {
                    let position = CGPoint(x: xPosition, y: yPosition)
                    
                    // Add kart to view if doesn't already exist
                    createKart(named: character, atPosition: position)
                    yPosition -= kartHeight
                    
                    if karts.count == (maxmimumKarts - karts.count) {
                        xPosition += kartWidth
                        yPosition = screenSize.height - kartHeight - 80
                    }
                    
                    break
                }
            }
            
            print("Can add \(maxmimumKarts - karts.count) more karts... \n")
        } else {
            print("Failed to add more karts... Reached kart capacity... \n")
            createErrorMessage(title: "Failed To Add Karts", message: "Reached maximum kart capacity.")
        }
        
    }
    
    // Start race
    @IBAction func startRacePressed(_ sender: UIBarButtonItem) {
        
        if karts.count > 1 {
            print("Start race...")
            
            // Reset cloud animated image view
            cloudAnimatedView.animatedImage = nil
            // Loud animated image to image view
            cloudAnimatedView.animatedImage = cloudAnimatedImage
            // Temporarily freeze animation (to get first frame) until cloud is down in view
            cloudAnimatedView.stopAnimating()
            
            // Start cloud drop animation
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                self.cloudAnimatedView.center = self.cloudDownCenter
            }) { (_) in
                UIView.animate(withDuration: 0.8, delay: 0, options: [.autoreverse, .repeat], animations: {
                    self.cloudAnimatedView.center.y -= 40
                }, completion: nil)
            }
            
            // Start cloud gif animation
            self.cloudAnimatedView.startAnimating()
            
            self.cloudAnimatedView.loopCompletionBlock = {_ in
                self.cloudAnimatedView.stopAnimating()
                
                // Generate random kart finishers sequence (winner is position 0)
                let finishingSequence = self.karts.shuffled()
                
                for (index, kart) in finishingSequence.enumerated() {
                    kart.drive()
                    
                    let kartRider = "\(Constant.getKart(usingTag: kart.tag))"
                    self.speedDictionary[kartRider] = kart.speedDictionary[kartRider]
                    
                    if finishingSequence.count > 1 && index == finishingSequence.count - 1 {
                        let winner = self.findWinner(from: self.speedDictionary)!
                        
                        print("\(winner.capitalizingFirstLetter()) is the winner!")
                        self.animateWinnerCard(with: winner)
                        print("End race... \n")
                    }
                }
            }
        } else {
            print("Failed to start race... Need at least 2 karts in view... \n")
            createErrorMessage(title: "Cannot Start Race", message: "Need at least 2 karts to star race.")
        }
        
    }
    
    // Reset kart to initial position and transformation state
    @IBAction func resetButtonPressed(_ sender: UIBarButtonItem) {
        
        if !karts.isEmpty {
            print("Resetting kart to initial position and transformation state...")
            
            UIView.animate(withDuration: 0.4) {
                for (index, kart) in self.karts.enumerated() {
                    // Return all karts to their initial transformation state
                    kart.transform = CGAffineTransform.identity
                    // Return all karts to their initial positions
                    kart.center = self.originalKartPositions[index]
                }
            }
        } else {
            print("Nothing to reset... No karts in view...")
            createErrorMessage(title: "Failed To Reset Kart Position", message: "No kart positions to be reset.")
        }
        
    }
    
    // MARK: - Private Function Section
    
    // Create new kart
    private func createKart(named name: String, atPosition position: CGPoint) {
        
        let image = UIImage(named: name)
        let kart = Kart(image: image)
        
        kart.frame = CGRect(x: position.x, y: position.y, width: kartWidth, height: kartHeight)
        karts.append(kart)
        originalKartPositions.append(kart.center)
        
        self.view.addSubview(kart)
        
    }
    
    // Check if kart exists in view
    private func checkIfKartExistsInView() {
        
        // Loop through subviews in view to see if any subviews are karts
        for kart in self.view.subviews where kart.tag >= 0 {
            // Get kart name from tag
            let kartExist = Constant.getKart(usingTag: kart.tag)
            
            // Add kart to kart exists array
            kartExistsInView.append(kartExist)
        }
        
    }
    
    // Returns winner of race
    private func findWinner(from dictionary: [String: TimeInterval]) -> String? {
        
        let smallestInDict = self.speedDictionary.min(by: { a, b in a.value < b.value })
        let smallestTimeInterval = smallestInDict?.key
        
        return smallestTimeInterval
        
    }
    
    // Creates winner card
    private func animateWinnerCard(with winner: String) {
        
        // Create winner card
        let backingView = UIView(frame: screenSize)
        let winnerCardView = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapWinnerCard(_:)))
        let gifData = Constant.fetchResource(named: winner, ofType: "gif")
        let animatedImage = FLAnimatedImage(animatedGIFData: gifData)
        let animatedWinnerView = FLAnimatedImageView()
        let label = UILabel()
        
        // Set backing view properties
        backingView.backgroundColor = .black
        backingView.alpha = 0.8
        
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
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            winnerCardView.alpha = 0.8
            winnerCardView.center = backingView.center
            self.cloudAnimatedView.center = self.cloudUpCenter
        }, completion: nil)
        
    }
    
    // Dismiss winner card when tapped
    @objc private func didTapWinnerCard(_ sender: UITapGestureRecognizer) {
        
        let winnerCardView = sender.view!
        
        // Render animation to dismiss winner card
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            winnerCardView.frame.origin.y = self.screenSize.height
            self.backingView.alpha = 0
        }) { (_) in
            // Remove winner card from view
            winnerCardView.removeFromSuperview()
            self.backingView.removeFromSuperview()
        }
        
    }
    
    private func createErrorMessage(title: String, message: String, alertTitle: String = "OK", alertStyle: UIAlertAction.Style = .default) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: alertTitle, style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
