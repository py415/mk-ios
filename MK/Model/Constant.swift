//
//  Constant.swift
//  MK
//
//  Created by Philip Yu on 5/15/20.
//  Copyright © 2020 Philip Yu. All rights reserved.
//

import Foundation

struct Constant {
    
    static func fetchResource(named resource: String, ofType type: String) -> Data {
        
        let path = Bundle.main.path(forResource: resource, ofType: type)!
        let url = URL(fileURLWithPath: path)
        var data: Data?
        
        do {
            data = try Data(contentsOf: url)
        } catch {
            print("Failed to fetch data – \(error)")
        }
        
        return data!
        
    }
    
    // Fetches characters name using image view tag
    static func getKart(usingTag tag: Int) -> Kart.RawValue {
        
        var kart: Kart
        
        switch tag {
        case 1:
            kart = Kart.mario
        case 2:
            kart = Kart.luigi
        case 3:
            kart = Kart.princessToadstool
        case 4:
            kart = Kart.yoshi
        case 5:
            kart = Kart.bowser
        case 6:
            kart = Kart.donkeyKong
        case 7:
            kart = Kart.koopaTroopa
        case 8:
            kart = Kart.toad
        case 10:
            kart = Kart.lakitu
        default:
            kart = Kart.mario
        }
        
        return kart.rawValue
        
    }
    
}

extension String {
    
    func capitalizingFirstLetter() -> String {
    
        return prefix(1).uppercased() + self.lowercased().dropFirst()
        
    }

    mutating func capitalizeFirstLetter() {
        
      self = self.capitalizingFirstLetter()
        
    }
    
}
