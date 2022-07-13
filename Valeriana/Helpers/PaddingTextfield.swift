//
//  PaddingTextfield.swift
//  Valeriana
//
//  Created by Francisco Jaime on 02/07/22.
//

import Foundation
import UIKit

class PaddingTextfield: UITextField{
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 6
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.valerianaColor.gray?.cgColor
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24))
        return bounds
    }
}
