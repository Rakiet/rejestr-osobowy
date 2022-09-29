//
//  MessageAlert.swift
//  rejestr-osobowy
//
//  Created by Piotr Żakieta on 29/09/2022.
//

import UIKit

class MessageAlert{
    class func showValidAlert(title: String, messageTable: [String], vc: UIViewController){
        var message = ""
        
        for text in messageTable {
            message += "\(text)\n"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    
}
