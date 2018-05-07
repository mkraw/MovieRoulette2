//
//  ButtonBounce.swift
//  MovieRoulette2
//
//  Created by Marta Krawiec on 4/22/17.
//  Copyright © 2017 Marta Krawiec. All rights reserved.
//

import UIKit

class ButtonBounce: UIButton {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform.identity

        
        }, completion: nil)
        
        
        super.touchesBegan(touches, with: event)
    }



}
