//
//  UIStackViewExt.swift
//  Formula1
//
//  Created by Daniil Kim on 05.06.2021.
//

import UIKit

extension UIStackView {
    
    func configure(axis: NSLayoutConstraint.Axis,
                   alignment: UIStackView.Alignment,
                   spacing: CGFloat) {
        self.axis = .horizontal
        self.alignment = .center
        self.spacing = spacing
    }
    
}
