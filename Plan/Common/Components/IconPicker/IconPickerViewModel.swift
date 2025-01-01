//
//  IconPickerViewModel.swift
//  Plan
//
//  Created by Joses Solmaximo on 01/02/24.
//

import UIKit

class IconPickerViewModel: ObservableObject {
    static let shared = IconPickerViewModel()
    
    @Published var allSymbols = sfSymbols
    @Published var validSymbols = sfSymbols
    @Published var filteredSymbols = sfSymbols
    
    init() {
        filterInvalidSymbols()
    }
    
    func filterInvalidSymbols() {
        DispatchQueue.global().async {
            let valid = self.validSymbols.filter({
                UIImage(systemName: $0) != nil
            })
            
            DispatchQueue.main.async {
                self.validSymbols = valid
            }
        }
    }
}
