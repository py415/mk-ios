//
//  Constant.swift
//  MK
//
//  Created by Philip Yu on 5/15/20.
//  Copyright © 2020 Philip Yu. All rights reserved.
//

import UIKit

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
    static func getKart(usingTag tag: Int) -> String {
        
        var kart: String
        
        switch tag {
        case 0:
            kart = "mario"
        case 1:
            kart = "luigi"
        case 2:
            kart = "princesstoadstool"
        case 3:
            kart = "yoshi"
        case 4:
            kart = "bowser"
        case 5:
            kart = "donkeykong"
        case 6:
            kart = "koopatroopa"
        case 7:
            kart = "toad"
        default:
            kart = "mario"
        }
        
        return kart
        
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
