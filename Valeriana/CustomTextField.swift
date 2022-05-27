//
//  CustomTextField.swift
//  Valeriana
//
//  Created by Francisco Jaime on 26/05/22.
//

import Foundation
import UIKit
import SwiftUI

class CustomTextField : UITextField{
    
    let padding : CGFloat = 36
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        
        setupUnderlinedTextField()
    }
    
    func setupUnderlinedTextField(){
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width - 8, height: 1)
        bottomLayer.backgroundColor = UIColor.valerianaColor.fontBase?.cgColor
        self.layer.addSublayer(bottomLayer)
    }
    
    func setupLeftImageView(image : UIImage){
        self.leftViewMode = .always
        let leftView = UIImageView(frame: CGRect(x: 0, y: self.frame.height / 2 - 10, width: 20, height: 20))
        leftView.tintColor = .valerianaColor.fontBase
        leftView.image = image
        self.addSubview(leftView)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let bounds = CGRect(x: self.padding, y: 0, width: bounds.width, height: bounds.height)
        return bounds
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let bounds = CGRect(x: self.padding, y: 0, width: bounds.width, height: bounds.height)
        return bounds
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let bounds = CGRect(x: self.padding, y: 0, width: bounds.width, height: bounds.height)
        return bounds
    }
    
}
