//
//  Card_Content.swift
//  Namit
//
//  Created by Adrian on 1/20/18.
//  Copyright © 2018 Zhipeng. All rights reserved.
//

import UIKit

class Card_Content: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
    }

    @IBAction func dismiss_view(_ sender: Any) {
        self.removeFromSuperview()
    }
}
