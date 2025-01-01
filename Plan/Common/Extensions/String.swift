//
//  String.swift
//  Plan
//
//  Created by Joses Solmaximo on 30/01/24.
//

import SwiftUI

extension String {
    var stringToColor:  Color {
        if self.split(separator: "#").count == 4 {
            return Color(red: (Double(self.split(separator: "#")[0]) ?? 0) / 1,
                         green: (Double(self.split(separator: "#")[1]) ?? 0) / 1,
                         blue: (Double(self.split(separator: "#")[2]) ?? 0) / 1,
                         opacity: Double(self.split(separator: "#")[3]) ?? 0)
        } else {
            return Color(self)
        }
    }
}
