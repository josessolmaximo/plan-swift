//
//  HabitView.swift
//  Plan
//
//  Created by Joses Solmaximo on 25/01/24.
//

import SwiftUI

struct HabitView: View {
    @State var isFull: Double = 0
    
    var body: some View {
        ZStack {
            Gauge(
                value: isFull,
                label: {
                    Text("Label")
                },
                currentValueLabel: {
                    Image(systemName: "house")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                },
                markedValueLabels: {
                    Text("0%").tag(0.0)
                    Text("50%").tag(0.5)
                    Text("100%").tag(1.0)
                }
            )
            .gaugeStyle(.accessoryCircularCapacity)
        }
        .onTapGesture {
            withAnimation {
                isFull += 0.1
            }
        }
    }
}

#Preview {
    HabitView()
}
