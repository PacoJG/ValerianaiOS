//
//  Utilities.swift
//  Valeriana
//
//  Created by Francisco Jaime on 23/06/22.
//

import Foundation

class Utilities{
    
    static func isPasswordValid(_ password : String) -> Bool {
            
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
            return passwordTest.evaluate(with: password)
        }
    
    
}
