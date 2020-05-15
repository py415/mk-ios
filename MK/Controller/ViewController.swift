//
//  ViewController.swift
//  MK
//
//  Created by Philip Yu on 5/14/20.
//  Copyright © 2020 Philip Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var kartImageView0: UIImageView!
    @IBOutlet weak var kartImageView1: UIImageView!
    @IBOutlet weak var kartImageView2: UIImageView!
    
    // MARK: - Properties
    private var startingPointKartView0 = CGPoint()
    private var startingPointKartView1 = CGPoint()
    private var startingPointKartView2 = CGPoint()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        startingPointKartView0 = kartImageView0.center
        startingPointKartView1 = kartImageView1.center
        startingPointKartView2 = kartImageView2.center
        
    }
    
    // MARK: - IBAction Section
    
    @IBAction func longPressBackground(_ sender: UILongPressGestureRecognizer) {
        
        // Reset kart starting position
        UIView.animate(withDuration: 0.6) {
            self.kartImageView0.center = self.startingPointKartView0
            self.kartImageView0.transform = CGAffineTransform.identity
            self.kartImageView1.center = self.startingPointKartView1
            self.kartImageView1.transform = CGAffineTransform.identity
            self.kartImageView2.center = self.startingPointKartView2
            self.kartImageView2.transform = CGAffineTransform.identity
        }
        
    }
    
    @IBAction func didPanKartView(_ sender: UIPanGestureRecognizer) {
        
        let location = sender.location(in: view)
        let kartView = sender.view!
        
        kartView.center = location
        
    }
    
    @IBAction func didPinchKartView(_ sender: UIPinchGestureRecognizer) {
        
        let scale = sender.scale
        let kartView = sender.view!
        
        kartView.transform = CGAffineTransform(scaleX: scale, y: scale)
        
    }
    
    @IBAction func didRotateKartView(_ sender: UIRotationGestureRecognizer) {
        
        let rotation = sender.rotation
        let kartView = sender.view!
        
        kartView.transform = CGAffineTransform(rotationAngle: rotation)
        
    }
    
    @IBAction func didTapKartView(_ sender: UITapGestureRecognizer) {
        
        let kartView = sender.view!
        let initialPosition = sender.view!.center.x
        
        UIView.animate(withDuration: 0.6, animations: {
            kartView.center.x += 400
        }) { (completion) in
            self.resetKartPosition(for: kartView, at: initialPosition)
        }
        
    }
    
    // MARK: - Private Function Section
    
    private func resetKartPosition(for kartView: UIView, at initialPosition: CGFloat) {
        
        kartView.center.x = 0 - kartView.frame.width
        
        UIView.animate(withDuration: 0.6) {
            kartView.center.x = initialPosition
        }
        
    }
    
}
