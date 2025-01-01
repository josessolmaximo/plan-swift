//
//  TaskSheetView.swift
//  Plan
//
//  Created by Joses Solmaximo on 28/01/24.
//

import SwiftUI

struct TaskSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var taskVM: TaskViewModel
    
    
    @StateObject private var vm: TaskSheetViewModel
    
    @FocusState var subtaskFocused: Bool
    @FocusState var tagFocused: Bool
    
    @State var isAddingSubtasks = false
    @State var isAddingTags = false
    @State var subtaskText = ""
    
    init(task: Task) {
            _vm = StateObject(wrappedValue: TaskSheetViewModel(task: task))
    }
    
    var dateRange: ClosedRange<Int> {
        switch vm.task.repetition.period {
        case .never:
            return 1...1
        case .hour:
            return 1...24
        case .day:
            return 1...31
        case .selectedDays:
            return 1...1
        case .week:
            return 1...31
        case .month:
            return 1...12
        }
    }
    
    func periodAmountText(_ num: Int) -> Text {
        switch vm.task.repetition.period {
        case .never:
            return Text("")
        case .hour:
            if num == 1 {
                return Text("Every hour")
            } else {
                return Text("^[Every \(num) hour](inflect: true)")
            }
        case .day:
            if num == 1 {
                return Text("Everyday")
            } else {
                return Text("^[Every \(num) day](inflect: true)")
            }
        case .selectedDays:
            return Text("Every \(num) day")
        case .week:
            if num == 1 {
                return Text("Every week")
            } else {
                return Text("^[Every \(num) week](inflect: true)")
            }
        case .month:
            if num == 1 {
                return Text("Every month")
            } else {
                return Text("^[Every \(num) month](inflect: true)")
            }
        }
    }
    
    var daysOfTheWeek: [Date] {
        var dates: [Date] = []
        var startDate = Date().startOfWeek.startOfDay
        
        while startDate <= Date().endOfWeek.startOfDay {
            dates.append(startDate)
            startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        }
        
        return dates
    }
    
    var typeRow: some View {
        Picker("", selection: $vm.task.typeEnum) {
            ForEach(TaskType.allCases, id: \.self) { type in
                Text(type.displayString)
                    .tag(type)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    var previewRow: some View {
        if vm.task.typeEnum == .habit {
            HabitRowView(habit: vm.task, text: Binding(get: {
                vm.task.title ?? ""
            }, set: { v in
                vm.task.title = v
            })) { habit in
                
            }
        }
    }
    
    @ViewBuilder
    var titleRow: some View {
        if vm.task.typeEnum == .task {
            sheetRow {
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "text.alignleft")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                        ZStack {
                            TextEditor(text: Binding(get: {
                                vm.task.title ?? ""
                            }, set: { v in
                                vm.task.title = v
                            }))
                                .frame(minHeight: 20.33)
                                .padding(.vertical, -(38 - 20.33)/2)
                                .padding(.leading, -5)
                                .scrollContentBackground(.hidden)
                            
                            HStack {
                                Text("Title")
                                    .foregroundColor(Color(uiColor: .tertiaryLabel))
                                
                                Spacer()
                            }
                            .opacity(vm.task.description.isEmpty ? 1 : 0)
                            .allowsHitTesting(false)
                        }
                        .primaryLabel()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var noteRow: some View {
        sheetRow {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "doc.plaintext")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    ZStack {
                        TextEditor(text: Binding(get: {
                            vm.task.note ?? ""
                        }, set: { v in
                            vm.task.note = v
                        }))
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
                    .primaryLabel()
                }
            }
        }
    }
    
    var dateRow: some View {
        sheetRow {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text("Date")
                        .primaryLabel()
                    
                    Spacer()
                    
                    Text(vm.task.date?.formatAs(.dMMMMyyyy) ?? "")
                        .overlay {
                            DatePicker(
                                "",
                                selection: Binding(get: {
                                    vm.task.date ?? Date()
                                }, set: { v in
                                    vm.task.date = v
                                }),
                                displayedComponents: .date
                            )
                            .blendMode(.destinationOver)
                        }
                        .secondaryLabel()
                }
                .frame(height: 30)
                
                if vm.task.typeEnum == .task {
                    HStack(spacing: 12) {
                        Image(systemName: "flag")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                        Text("Priority")
                            .primaryLabel()
                        
                        Spacer()
                        
                        Menu {
                            Picker("", selection: $vm.task.priority) {
                                ForEach(Priority.allCases, id: \.self) { priority in
                                    Text(priority.displayString)
                                        .tag(priority)
                                        .foregroundColor(.primary)
                                }
                            }
                        } label: {
                            Text(vm.task.priorityEnum.displayString)
                                .foregroundColor(vm.task.priorityEnum.color)
                                .secondaryLabel()
                        }
                    }
                }
                
                HStack(spacing: 12) {
                    Image(systemName: "paintpalette")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text("Color")
                        .primaryLabel()
                    
                    Spacer()
                    
                    let color: Binding<Color> = Binding(
                        get: { (vm.task.color ?? "").stringToColor },
                        set: { vm.task.color = ($0.cgColor?.components?.map(String.init).joined(separator: "#"))! }
                    )
                    
                    Menu {
                        Picker("", selection: $vm.task.color) {
                            ForEach(DefaultColors.allCases, id: \.self) { color in
                                HStack {
                                    Text(color.name)
                                    Image(uiImage: UIImage(systemName: "circle.fill")!.withTintColor(UIColor(cgColor: color.rawValue.stringToColor.cgColor!), renderingMode: .alwaysOriginal))
                                }
                                .tag(color.rawValue)
                            }
                        }
                    } label: {
                        Image(systemName: "circle.fill")
                            .foregroundColor((vm.task.color ?? "").stringToColor)
                    }
                    
                    Divider()
                        
                    ColorPicker("", selection: color)
                        .labelsHidden()
                }
            }
        }
    }
    
    var tagRow: some View {
        sheetRow {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "tag")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text("Tags")
                        .primaryLabel()
                    
                    Spacer()
                    
                    Button {
//                        vm.task.tags.append("")
                    } label: {
                        Text("Add")
                            .secondaryLabel()
                    }
                }
                
                if !(vm.task.tags ?? []).isEmpty {
                    VStack(spacing: 8) {
                        ForEach(Array((vm.task.tags ?? []).enumerated()), id: \.offset) { index, tag in
                            HStack(spacing: 8) {
                                NavigationLink {
                                    IconPickerView { icon in
                                        taskVM.tags[tag] = icon
                                    }
                                } label: {
                                    Image(systemName: taskVM.tags[tag] ?? "questionmark.square.dashed")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 16, height: 16)
                                        .foregroundColor(.primary)
                                }
                                
                                TextField("Tag", text: Binding(get: {
                                    vm.task.tags?[index] ?? ""
                                }, set: { v in
                                    vm.task.tags?[index] = v
                                }))
                                
                                Button {
                                    if let index = vm.task.tags?.firstIndex(where: { $0 == tag}) {
//                                        vm.task.tags.remove(at: index)
                                    }
                                } label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                    .padding(.leading, 32)
                }
            }
        }
    }
    
    var subtasksRow: some View {
        sheetRow {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "checklist")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text("Subtasks")
                        .primaryLabel()
                    
                    Spacer()
                    
                    Button {
//                        vm.task.subtasks.append(Task.Subtask())
                    } label: {
                        Text("Add")
                            .secondaryLabel()
                    }
                }
                
//                if !vm.task.subtasks.isEmpty {
//                    VStack(spacing: 8) {
//                        ForEach(vm.task.subtasks) { subtask in
//                            HStack(spacing: 8) {
//                                Button {
//                                    if let index = vm.task.subtasks.firstIndex(where: { $0.id == subtask.id }) {
//                                        vm.task.subtasks[index].completed.toggle()
//                                    }
//                                } label: {
//                                    Image(systemName: subtask.completed ? "checkmark.square.fill" : "square")
//                                        .resizable()
//                                        .frame(width: 16, height: 16)
//                                        .foregroundColor(subtask.completed ? .gray : .black)
//                                }
//                                
//                                TextField("Subtask", text: Binding(get: {
//                                    subtask.title
//                                }, set: { v in
//                                    if let index = vm.task.subtasks.firstIndex(where: { $0.id == subtask.id}) {
//                                        vm.task.subtasks[index].title = v
//                                    }
//                                }))
//                                .strikethrough(subtask.completed)
//                                
//                                Button {
//                                    if let index = vm.task.subtasks.firstIndex(where: { $0.id == subtask.id }) {
//                                        vm.task.subtasks.remove(at: index)
//                                    }
//                                } label: {
//                                    Image(systemName: "xmark")
//                                        .resizable()
//                                        .frame(width: 12, height: 12)
//                                        .foregroundColor(.black)
//                                }
//                            }
//                        }
//                    }
//                    .padding(.leading, 32)
//                }
            }
        }
    }
    
    var repeatRow: some View {
        sheetRow {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "repeat")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text("Repeats")
                        .primaryLabel()
                    
                    Spacer()
                    
                    Menu {
                        Picker("", selection: $vm.task.repetition.period) {
                            ForEach(Repetition.Period.allCases, id: \.self) { period in
                                Text(period.displayString)
                                    .tag(period)
                            }
                        }
                    } label: {
                        Text(vm.task.repetition.period.displayString)
                            .foregroundColor(vm.task.repetition.period == .never ? .secondary : .black)
                            .secondaryLabel()
                    }
                }
                
                if vm.task.repetition.period != .never {
                    HStack(spacing: 4) {
                        if vm.task.repetition.period == .selectedDays {
                            ForEach(daysOfTheWeek, id: \.self) { date in
                                let dayInt =  Calendar.current.dateComponents([.weekday], from: date).weekday!
                                
                                let isSelected = vm.task.repetition.weekdays.contains(Int64(dayInt))
                                
                                Button {
                                    if isSelected {
                                        vm.task.repetition.weekdays.removeAll(where: { $0 == dayInt })
                                    } else {
                                        vm.task.repetition.weekdays.append(Int64(dayInt))
                                    }
                                } label: {
                                    Text(date.formatAs(.EEEE).prefix(1))
                                        .padding(.horizontal, 2)
                                        .underline(isSelected)
                                        .secondaryLabel()
                                }
                            }
                        } else {
                            Menu {
                                Picker("", selection: $vm.task.repetition.periodAmount) {
                                    ForEach(dateRange, id: \.self) { num in
                                        periodAmountText(num)
                                            .tag(num)
                                    }
                                }
                            } label: {
                                periodAmountText(Int(vm.task.repetition.periodAmount))
                                    .secondaryLabel()
                                    .underline()
                            }
                        }
                        
                        Text("at")
                            .primaryLabel()
                        
                        Text(vm.task.repetition.repeatTime.formatAs(.h_mma))
                            .underline()
                            .overlay(
                                DatePicker("", selection: $vm.task.repetition.repeatTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .blendMode(.destinationOver)
                            )
                            .secondaryLabel()
                        
                        Spacer()
                    }
                    .padding(.leading, 32)
                    
                    HStack(spacing: 4) {
                        Text("Since")
                            .primaryLabel()
                        
                        Menu {
                            Picker("", selection: $vm.task.repetition.repeatFrom) {
                                ForEach(Repetition.RepeatFrom.allCases, id: \.self) { from in
                                    Text(from.displayString)
                                        .tag(from)
                                }
                            }
                        } label: {
                            Text(vm.task.repetition.repeatFrom.displayString)
                                .secondaryLabel()
                                .underline()
                        }
                        
                        Spacer()
                    }
                    .padding(.leading, 32)
                }
            }
        }
    }
    
    var goalRow: some View {
        sheetRow {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "target")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text("Goal")
                        .primaryLabel()
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        TextField("0", value: $vm.task.goal.amount, formatter: NumberFormatter())
                            .labelsHidden()
                            .multilineTextAlignment(.trailing)
                            .font(.system(size: 17, weight: .medium))
                        
                        Menu {
                            ForEach(Unit.allCases, id: \.self) { unit in
                                Menu {
                                    Picker("", selection: $vm.task.goal.subunit) {
                                        ForEach(unit.subunits, id: \.self) { subunit in
                                            Text(subunit.displayString)
                                        }
                                    }
                                } label: {
                                    Text(unit.displayString)
                                }
                            }
                        } label: {
                            Text("\(vm.task.goal.subunit.displayString.lowercased())")
                                .secondaryLabel()
                                .underline()
                        }
        
                        Text("a")
                        
                        Menu {
                            Picker("", selection: $vm.task.goal.period) {
                                ForEach(Goal.Period.allCases, id: \.self) { period in
                                    Text(period.displayString)
                                        .tag(period)
                                       
                                }
                            }
                        } label: {
                            Text(vm.task.goal.period.displayString.lowercased())
                                .secondaryLabel()
                                .underline()
                        }
                    }
                }
            }
        }
    }
    
    var reminderRow: some View {
        sheetRow {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "bell.badge")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text("Reminder")
                        .primaryLabel()
                    
                    Spacer()
                    
                    Button {
                        if vm.task.reminder == nil {
                            vm.task.reminder = Reminder(time: vm.task.date ?? Date())
                        } else {
//                            vm.task.reminder = nil
                        }
                    } label: {
                        Image(systemName: vm.task.reminder != nil ? "checkmark.square.fill" : "square")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(vm.task.reminder != nil ? .gray : .black)
                    }
                }
                .frame(height: 30)
                
                if true {
                    HStack(spacing: 12) {
                        if vm.task.typeEnum == .task {
                            Text("Date")
                                .primaryLabel()
                            
                            Spacer()
                            
                            Text(vm.task.reminder.time.formatAs(.dMMMMyyyy) ?? vm.task.date?.formatAs(.dMMMMyyyy) ?? "")
                                .overlay {
                                    DatePicker("", selection: Binding(get: {
                                        vm.task.reminder.time
                                    }, set: { v in
                                        vm.task.reminder.time = v
                                    }),
                                               displayedComponents: .date
                                    )
                                    .blendMode(.destinationOver)
                                }
                                .secondaryLabel()
                            
                            Divider()
                        } else {
                            Text("Time")
                                .primaryLabel()
                            
                            Spacer()
                        }
                        
                        Text(vm.task.reminder.time.formatAs(.h_mma))
                            .overlay(
                                DatePicker("", selection: Binding(get: {
                                    vm.task.reminder.time
                                }, set: { v in
                                    vm.task.reminder.time = v
                                }), displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .blendMode(.destinationOver)
                            )
                            .secondaryLabel()
                    }
                    .padding(.leading, 32)
                    
                    if vm.task.typeEnum == .habit {
                        HStack(spacing: 12) {
                            Text("Days")
                                .primaryLabel()
                            
                            Spacer()
                            
                            ForEach(daysOfTheWeek, id: \.self) { date in
                                let dayInt =  Calendar.current.dateComponents([.weekday], from: date).weekday!
                                
                                let isSelected = vm.task.reminder.weekdays.contains(Int64(dayInt))
                                
                                Button {
                                    if isSelected {
                                        vm.task.reminder.weekdays.removeAll(where: { $0 == dayInt })
                                    } else {
                                        vm.task.reminder.weekdays.append(Int64(dayInt))
                                    }
                                } label: {
                                    Text(date.formatAs(.EEEE).prefix(1))
                                        .padding(.horizontal, 2)
                                        .underline(isSelected)
                                        .secondaryLabel()
                                }
                            }
                        }
                        .padding(.leading, 32)
                    }
                }
            }
        }
    }
    
    var tapsToCompleteRow: some View {
        sheetRow {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "hand.tap")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text("Taps to Complete")
                        .primaryLabel()
                    
                    Spacer()
                    
                    TextField("", value: $vm.task.completionAmount, formatter: NumberFormatter())
                        .labelsHidden()
                        .multilineTextAlignment(.trailing)
                        .secondaryLabel()
                }
            }
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            NavigationView {
                ZStack(alignment: .bottom) {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            typeRow
                            
                            previewRow
                            
                            VStack(spacing: 16) {
                                titleRow
                                
                                noteRow
                                
                                dateRow
                                
                                if vm.task.typeEnum == .task {
                                    tagRow
                                }
                                
                                if vm.task.typeEnum == .task {
                                    subtasksRow
                                }
                                
                                if vm.task.typeEnum == .task {
                                    repeatRow
                                } else {
                                    goalRow
                                }
                                
                                reminderRow
                                
                                if vm.task.typeEnum == .task {
                                   tapsToCompleteRow
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
//                    if isAddingTags {
//                        ZStack {
//                            Color(.keyboard)
//                            
//                            ScrollView(.horizontal) {
//                                LazyHStack {
//                                    
//                                }
//                            }
//                        }
//                        .frame(height: 40)
//                    }
                }
                .navigationTitle("Create \(vm.task.typeEnum.displayString)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Cancel")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.black)
                        })
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
//                            taskVM.tasks.append(vm.task)
                            
                            dismiss()
                        }, label: {
                            Text("Create")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.black)
                        })
                    }
                }
                .onChange(of: subtaskFocused) { v in
                    isAddingSubtasks = v
                }
                .onChange(of: tagFocused) { v in
                    isAddingTags = v
                }
            }
        }
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true), content: {
            TaskSheetView(task: Task())
                .environmentObject(TaskViewModel())
        })
}

extension TaskSheetView {
    func sheetRow<Content: View>(_ content: () -> Content) -> some View {
        content()
    }
}

fileprivate struct PrimaryLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .regular))
            .foregroundColor(.primary)
    }
}

fileprivate struct SecondaryLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .medium))
            .foregroundColor(.primary)
    }
}

extension View {
    func primaryLabel() -> some View {
        self.modifier(PrimaryLabel())
    }
    
    func secondaryLabel() -> some View {
        self.modifier(SecondaryLabel())
    }
}
