//
//  TaskRowView.swift
//  Plan
//
//  Created by Joses Solmaximo on 25/01/24.
//

import SwiftUI

struct TaskRowView: View {
    let task: Task
    let onCompleteTapped: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Spacer()
                .frame(width: 2.5)
            
            Spacer()
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .strikethrough(task.completed, color: .gray)
                    .foregroundStyle(task.completed ? .gray : .black)
                    .font(.system(size: 17, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if task.startTime != nil ||
                    task.endTime != nil ||
                    !task.tags.isEmpty ||
                    !task.assignees.isEmpty {
                    
                    HStack {
                        HStack(spacing: 6) {
                            if let startTime = task.startTime {
                                Image(systemName: "clock")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 13, height: 13)
                                
                                HStack(spacing: 2) {
                                    
                                    Text("\(startTime.formatAs(.Hmm))")
                                    
                                    if let endTime = task.endTime {
                                        Text("-")
                                        
                                        Text(endTime.formatAs(.Hmm))
                                    }
                                }
                            }
                        }
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(task.completed ? .gray : .black)
                        
                        if task.startTime != nil && !task.tags.isEmpty {
                            Rectangle()
                                .frame(width: 1, height: 20)
                                .foregroundColor(.gray)
                        }
                        
                        ForEach(task.tags, id: \.self) { tag in
                            Image(systemName: allTags.first(where: { $0.0 == tag })?.1 ?? "")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(task.priority.color)
                                .frame(width: 13, height: 13)
                        }
                        
                        if !task.tags.isEmpty && !task.assignees.isEmpty {
                            Rectangle()
                                .frame(width: 1, height: 20)
                                .foregroundColor(.gray)
                        }
                        
                        HStack(spacing: -4) {
                            ForEach(task.assignees, id: \.self) { assignee in
                                Circle()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.gray)
                                    .overlay {
                                        Text(assignee.prefix(1))
                                            .font(.system(size: 9, weight: .medium))
                                            .foregroundColor(.white)
                                    }
                                    .overlay {
                                        Circle()
                                            .stroke(.white, lineWidth: 2)
                                    }
                            }
                        }
                    }
                }
                
                if !task.subtasks.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(task.subtasks) { subtask in
                            HStack {
                                Button {
                                    
                                } label: {
                                    Image(systemName: subtask.completed ? "checkmark.square.fill" : "square")
                                        .resizable()
                                        .frame(width: 13, height: 13)
                                        .foregroundColor(task.completed ? .gray : task.priority.color)
                                }
                                
                                Text(subtask.title)
                                    .font(.system(size: 14))
                                    .foregroundColor(subtask.completed ? .gray : .black.opacity(0.8))
                                    .strikethrough(subtask.completed, color: .gray)
                            }
                        }
                    }
                }
            }
            .lineLimit(1)
        }
        .frame(minHeight: 40)
        .overlay(
            ZStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 12) {
                    Rectangle()
                        .foregroundColor(task.priority.color)
                        .frame(width: 2.5)
                        .frame(minHeight: 40)
                    
                    Button {
                        onCompleteTapped()
                    } label: {
                        Image(systemName: task.completed ? "checkmark.square.fill" : "square")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(task.completed ? .gray : task.priority.color)
                    }
                    .padding(.vertical, 10)
                    
                    Spacer()
                }
            }
        )
        .frame(minHeight: 40)
    }
}

#Preview {
    VStack(spacing: 16) {
        TaskRowView(task: Task(title: "Take out the garbage"), onCompleteTapped: {
            
        })
        .padding(.horizontal, 16)
        
        TaskRowView(task: Task.randomTasks(1).first!, onCompleteTapped: {
            
        })
        .padding(.horizontal, 16)
        
        TaskRowView(task: Task.randomTasks(1).first!, onCompleteTapped: {
            
        })
        .padding(.horizontal, 16)
        
        TaskRowView(task: Task.randomTasks(1).first!, onCompleteTapped: {
            
        })
        .padding(.horizontal, 16)
        
        TaskRowView(task: Task.randomTasks(1).first!, onCompleteTapped: {
            
        })
        .padding(.horizontal, 16)
        
        TaskRowView(task: Task.randomTasks(1).first!, onCompleteTapped: {
            
        })
        .padding(.horizontal, 16)
    }
}
