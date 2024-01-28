//
//  Color.swift
//  Plan
//
//  Created by Joses Solmaximo on 28/01/24.
//

import SwiftUI

extension Color {
    static func fromString(_ stringColor: String) -> Color {
        if stringColor.split(separator: "#").count == 4 {
            return Color(red: (Double(stringColor.split(separator: "#")[0]) ?? 0) / 1,
                  green: (Double(stringColor.split(separator: "#")[1]) ?? 0) / 1,
                  blue: (Double(stringColor.split(separator: "#")[2]) ?? 0) / 1,
                  opacity: Double(stringColor.split(separator: "#")[3]) ?? 0)
        } else {
            return Color(.clear)
        }
    }
}
