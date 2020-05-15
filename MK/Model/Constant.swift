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
    
}
