//
//  TableViewHelper.swift
//  Formula1
//
//  Created by Daniil Kim on 08.06.2021.
//

import UIKit

struct TableViewHelper {
    
    static func updateCell(cell: UITableViewCell,
                           subtitle: String,
                           fontSizeMod: CGFloat = 0,
                           text: (value: String, isBold: Bool)...) {
        let combinedText = NSMutableAttributedString()
        for string in text {
            let attributedString: NSMutableAttributedString
            
            if string.isBold {
                attributedString = NSMutableAttributedString(string: string.value + " ",
                                                             attributes: [.font: UIFont.boldSystemFont(ofSize: 16 + fontSizeMod)])
            } else {
                attributedString = NSMutableAttributedString(string: string.value + " ")
            }
            
            combinedText.append(attributedString)
        }
        
        cell.textLabel?.attributedText = combinedText
        cell.detailTextLabel?.text = subtitle
    }
    
}
