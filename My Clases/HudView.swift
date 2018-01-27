//
//  HudView.swift
//  MyLocations
//
//  Created by getTrickS2 on 1/21/18.
//  Copyright © 2018 Nik's. All rights reserved.
//

import UIKit

class HudView: UIView {
    // MARK: - Variables ========
    var text = ""
    // ==========================
    
    // MARK: - Type functions ==============================================
    class func hud(inView view: UIView, animated: Bool) -> HudView {
        // 1. Initialization
        let hudView = HudView(frame: view.bounds)
        // 2. Configuration the hudView
        hudView.isOpaque = false
        // 3. Configuration the view
        view.addSubview(hudView)
        view.isUserInteractionEnabled = false
        // 4. Execute animation
        hudView.show(animated: animated)
        
        return hudView
    }
    // =====================================================================
    
    // MARK: - Override functions ============================================
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        // Draw the Rect --------------------------
        // 1. Create a point
        let boxWidth: CGFloat = 96
        let boxHeight: CGFloat = 96
        let boxRect = CGRect(x: center.x - round( boxWidth / 2 ),
                             y: center.y - round( boxHeight / 2 ),
                             width: boxWidth,
                             height: boxHeight)
        // 2. Init Rectangle
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        // 3. Set color
        UIColor(white: 0.3, alpha: 0.8).setFill()
        // 4. Draw
        roundedRect.fill()
        
        // Draw the image ------------------------
        if let image = UIImage(named: "Checkmark") {
            let imagePoint = CGPoint(x: center.x - round(image.size.width / 2),
                                     y: center.y - round(image.size.height / 2) - boxHeight / 8)
            image.draw(at: imagePoint)
        }
        
        // Draw the label ------------------------
        // 1. Configurate the text property
        let attribs = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),
                        NSAttributedStringKey.foregroundColor: UIColor.white ]
        let textSize = text.size(withAttributes: attribs)
        // 2. Create a point
        let textPoint = CGPoint(
            x: center.x - round(textSize.width / 2),
            y: center.y - round(textSize.height / 2) + boxHeight / 4)
        // 3. Draw
        text.draw(at: textPoint, withAttributes: attribs)
    }
    // =======================================================================

    // MARK: - Functions =====================================================
    func show(animated: Bool) {
        if animated {
            // 1. Set up the initial state of the view before the animation starts
            alpha = 0 // Fully transparent
            transform = CGAffineTransform(scaleX: 3, y: 3) // Teh view is initially stretched out
            // 2. Start animation (from the initial to the final)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                // Final state
                self.alpha = 1
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    // =======================================================================


}






























