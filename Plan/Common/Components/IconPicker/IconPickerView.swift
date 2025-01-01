//
//  IconPickerView.swift
//  Plan
//
//  Created by Joses Solmaximo on 30/01/24.
//

import SwiftUI

struct IconPickerView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var vm = IconPickerViewModel.shared
    
    @State var searchText = ""
    @State var text = ""
    
    let onSelect: (_ icon: String) -> Void
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ScrollView {
                    let cellCount = Int(floor(proxy.size.width / (25 + 16)))
                    
                    LazyVStack(spacing: 16) {
                        let filteredSymbols = vm.validSymbols.filter({
                            $0.contains(searchText.lowercased()) || searchText.isEmpty})
                        
                        ForEach(Array(stride(from: 0, to: filteredSymbols.count, by: cellCount)), id: \.self) { index in
                            HStack(spacing: 16) {
                                ForEach(0..<cellCount, id: \.self) { cell in
                                    if filteredSymbols.count > index + cell {
                                        Button {
                                            dismiss()
                                            
                                            onSelect(filteredSymbols[index + cell])
                                        } label: {
                                            IconView(filteredSymbols[index + cell], size: 25)
                                        }
                                        .foregroundColor(.primary)
                                    } else {
                                        Color.clear
                                            .frame(width: 25, height: 25)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .id("\(searchText) \(vm.validSymbols.count)")
                }
            }
        }
        .navigationTitle("Icon")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .searchable(text: $text, placement: .navigationBarDrawer(displayMode: .always))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.primary)
                        .font(.system(size: 17, weight: .medium))
                })
            }
        }
        .onChange(of: text) { text in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if self.text == text {
                    self.searchText = text
                }
            }
        }
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true), content: {
            NavigationView {
                IconPickerView { icon in
                    
                }
            }
        })
}
