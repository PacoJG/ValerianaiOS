//
//  CustomTabBarController.swift
//  Valeriana
//
//  Created by Francisco Jaime on 06/07/22.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(UIColor.valerianaColor.baseLight!, size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero).withRoundedCorners(radius: 10)
        //UIColor.valerianaColor.baseLight!
        tabBar.tintColor = UIColor.valerianaColor.fontBase
        tabBar.barTintColor = .white
        tabBar.backgroundColor = .white
        tabBar.isOpaque = true
        tabBar.isTranslucent = false
        
        
    }

}

extension UIImage{
    class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(origin: CGPoint(x: 23 ,y: -8), size: CGSize(width: 35, height: 35))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
        
    }
    
}

extension UIImage{
    public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
