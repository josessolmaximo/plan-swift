//
//  TaskSheetView.swift
//  Plan
//
//  Created by Joses Solmaximo on 28/01/24.
//

import SwiftUI

struct TaskSheetView: View {
    @StateObject var vm = TaskSheetViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        Picker("", selection: $vm.task.type) {
                            ForEach(Task.TaskType.allCases, id: \.self) { type in
                                Text(type.displayString)
                                    .tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        TaskRowView(task: vm.task) {
                            
                        }
                        
                        VStack(spacing: 12) {
                            TextField("Title", text: $vm.task.title)
                                .font(.system(size: 17, weight: .medium))
                            
                            ZStack {
                                TextEditor(text: $vm.task.description)
                                    .frame(minHeight: 20.33)
                                    .padding(.vertical, -(38 - 20.33)/2)
                                    .padding(.leading, -5)
                                    .scrollContentBackground(.hidden)
                                
                                HStack {
                                    Text("Description")
                                        .foregroundColor(Color(uiColor: .tertiaryLabel))
                                        
                                    Spacer()
                                }
                                .opacity(vm.task.description.isEmpty ? 1 : 0)
                                .allowsHitTesting(false)
                            }
                        }
                        .padding(16)
                        .background(Color(uiColor: UIColor(red: 118/256, green: 118/256, blue: 128/256, alpha: 0.12)))
                        .cornerRadius(8)
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("Priority")
                                
                                Spacer()
                                
                                Menu {
                                    Picker("", selection: $vm.task.priority) {
                                        ForEach(Task.Priority.allCases, id: \.self) { priority in
                                            Text(priority.displayString)
                                                .tag(priority)
                                                .foregroundColor(.primary)
                                        }
                                    }
                                } label: {
                                    Text(vm.task.priority.displayString)
                                        .font(.system(size: 17, weight: .medium))
                                        .foregroundColor(.primary)
                                }
                            }
                            
                            let color: Binding<Color> = Binding(
                                get: { Color.fromString(vm.task.color ?? "0#0#0#1") },
                                set: { vm.task.color = ($0.cgColor?.components?.map(String.init).joined(separator: "#"))! }
                            )
                            
                            HStack {
                                Text("Color")
                                
                                Spacer()
                                
                                Menu {
                                    Picker("", selection: $vm.task.color) {
                                        ForEach(DefaultColors.allCases, id: \.self) { color in
                                            HStack {
                                                Text(color.name)
                                                Image(uiImage: UIImage(systemName: "circle.fill")!.withTintColor(UIColor(cgColor: Color.fromString(color.rawValue).cgColor!), renderingMode: .alwaysOriginal))
                                            }
                                            .tag(color.rawValue)
                                        }
                                    }
                                } label: {
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color.fromString(vm.task.color ?? "0#0#0#1"))
                                }
                                
                                Divider()
                                
                                ColorPicker("", selection: color)
                                    .labelsHidden()
                            }
                        }
                        .padding(16)
                        .background(Color(uiColor: UIColor(red: 118/256, green: 118/256, blue: 128/256, alpha: 0.12)))
                        .cornerRadius(8)
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("Tags")
                                
                                Spacer()
                                
                                Button {
                                    
                                } label: {
                                    Label("Add", systemImage: "plus")
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .padding(16)
                        .background(Color(uiColor: UIColor(red: 118/256, green: 118/256, blue: 128/256, alpha: 0.12)))
                        .cornerRadius(8)
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("Assignees")
                                
                                Spacer()
                                
                                Button {
                                    
                                } label: {
                                    Label("Add", systemImage: "plus")
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .padding(16)
                        .background(Color(uiColor: UIColor(red: 118/256, green: 118/256, blue: 128/256, alpha: 0.12)))
                        .cornerRadius(8)
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("Subtasks")
                                
                                Spacer()
                                
                                Button {
                                    
                                } label: {
                                    Label("Add", systemImage: "plus")
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .padding(16)
                        .background(Color(uiColor: UIColor(red: 118/256, green: 118/256, blue: 128/256, alpha: 0.12)))
                        .cornerRadius(8)
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("Repeats")
                                
                                Spacer()
                                
                                Toggle("", isOn: Binding(get: {
                                    vm.task.repetition != nil
                                }, set: { v in
                                    if v {
                                        vm.task.repetition = Task.Repetition(amount: 1, periodAmount: 1, period: .day)
                                    } else {
                                        vm.task.repetition = nil
                                    }
                                }))
                            }
                            
                            if let repetition = vm.task.repetition {
                                HStack {
                                    TextField("", value: Binding(get: {
                                        repetition.amount
                                    }, set: { v in
                                        vm.task.repetition?.amount = v
                                    }), formatter: NumberFormatter())
                                    
                                    Text("Time")
                                    
                                    Spacer()
                                    
                                    Text("Every")
                                    
                                    TextField("", value: Binding(get: {
                                        repetition.periodAmount
                                    }, set: { v in
                                        vm.task.repetition?.periodAmount = v
                                    }), formatter: NumberFormatter())
                                    
                                    Menu {
                                        Picker("", selection: Binding(get: {
                                            repetition.period
                                        }, set: { v in
                                            vm.task.repetition?.period = v
                                        })) {
                                            ForEach(Task.Repetition.Period.allCases, id: \.self) { period in
                                                Text(period.displayString)
                                                    .tag(period)
                                            }
                                        }
                                    } label: {
                                        Text(repetition.period.displayString)
                                            .font(.system(size: 17, weight: .medium))
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color(uiColor: UIColor(red: 118/256, green: 118/256, blue: 128/256, alpha: 0.12)))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Create \(vm.task.type.displayString)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        
                    }, label: {
                        Text("Cancel")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.black)
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                    }, label: {
                        Text("Create")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.black)
                    })
                }
            }
        }
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true), content: {
            TaskSheetView()
        })
}
