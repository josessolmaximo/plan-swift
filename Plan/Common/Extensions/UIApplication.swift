//
//  UIApplication.swift
//  Plan
//
//  Created by Joses Solmaximo on 30/01/24.
//

import UIKit

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
