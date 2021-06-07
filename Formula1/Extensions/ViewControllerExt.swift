//
//  ViewControllerExt.swift
//  Formula1
//
//  Created by Daniil Kim on 07.06.2021.
//

import UIKit

extension UIViewController {
    
    func showAlert(text: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
