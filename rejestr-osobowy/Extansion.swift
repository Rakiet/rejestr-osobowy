//
//  Extansion.swift
//  rejestr-osobowy
//
//  Created by Piotr Żakieta on 29/09/2022.
//

import UIKit
private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}

extension String {
    var isOnlyLetters: Bool {
        return range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
    
    var isOnlyNumbers: Bool {
        return range(of: "[^0-9]", options: .regularExpression) == nil
    }
}
