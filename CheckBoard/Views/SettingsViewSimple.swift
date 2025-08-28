import SwiftUI

struct SettingsViewSimple: View {
    @EnvironmentObject var routineManager: RoutineManager  
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var showSettings: Bool
    @State private var newTaskTitle = ""
    @State private var newTaskEmoji = "✨"
    @State private var showEmojiPicker = false
    @State private var showEditPopup = false
    @State private var taskToEdit: RoutineTask?
    @State private var editTitle = ""
    @State private var editEmoji = ""
    @AppStorage("soundEnabled") private var soundEnabled = true
    
    var body: some View {
        ZStack {
            // Vue principale des paramètres
            ClipboardBackground {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // Titre PARAMÈTRES en haut
                        HStack {
                            Text(languageManager.text(.settings).uppercased())
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
                            
                            Spacer()
                            
                            // Bouton fermer plus grand et carré
                            Button(action: { showSettings = false }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.red.opacity(0.8))
                                        .frame(width: 40, height: 40)
                                    
                                    Text("✕")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 15)
                        .padding(.top, 15)
                        .padding(.bottom, 5)
                        
                        // Section Ajouter une tâche
                        AddTaskSection(
                            newTaskTitle: $newTaskTitle,
                            newTaskEmoji: $newTaskEmoji,
                            showEmojiPicker: $showEmojiPicker
                        )
                        
                        // Section Mes tâches EN DEUXIEME
                        TaskListSection(
                            onEdit: { task in
                                taskToEdit = task
                                editTitle = task.title
                                editEmoji = task.emoji
                                showEditPopup = true
                            }
                        )
                        
                        // En-tête avec sons et langues EN DERNIER
                        HeaderView(showSettings: $showSettings, soundEnabled: $soundEnabled)
                        
                        // Section Heure de réinitialisation
                        ResetTimeSection()
                        
                        // Spacer pour pousser le bouton vers le bas
                        Spacer()
                        
                        // Bouton en bas centré avec meilleur style
                        HStack {
                            Spacer()
                            Button(action: {
                                routineManager.setupDefaultTasks()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "arrow.counterclockwise")
                                        .font(.system(size: 14, weight: .medium))
                                    Text(languageManager.text(.restoreDefault))
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                }
                                .foregroundColor(Color(red: 0.95, green: 0.5, blue: 0.2))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.orange.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.orange.opacity(0.4), lineWidth: 1.5)
                                        )
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            Spacer()
                        }
                        .padding(.vertical, 25)
                    }
                    .padding(.top, 10)
                }
            }
            .frame(width: 400, height: 650)
            
            // Popup d'édition custom
            if showEditPopup {
                EditTaskPopup(
                    isPresented: $showEditPopup,
                    taskTitle: $editTitle,
                    taskEmoji: $editEmoji,
                    onSave: { newTitle, newEmoji in
                        if let task = taskToEdit {
                            routineManager.updateTaskTitle(task, newTitle: newTitle)
                            routineManager.updateTaskEmoji(task, emoji: newEmoji)
                        }
                    }
                )
            }
            
        }
    }
}

// Composant pour le fond clipboard
struct ClipboardBackground<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Fond clipboard
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.75, green: 0.65, blue: 0.55),
                            Color(red: 0.70, green: 0.60, blue: 0.50)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 0) {
                Color.clear.frame(height: 40)
                
                ZStack(alignment: .top) {
                    // Papier
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    
                    content
                        .padding(.horizontal, 15)
                        .padding(.bottom, 20)
                        .padding(.top, 5)
                        .clipped()
                }
            }
            
            // Pince métallique
            VStack {
                MetallicClip()
                    .offset(y: 12)
                Spacer()
            }
        }
    }
}

struct MetallicClip: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.85, green: 0.85, blue: 0.88),
                            Color(red: 0.75, green: 0.75, blue: 0.78),
                            Color(red: 0.85, green: 0.85, blue: 0.88)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 70, height: 25)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
            
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.white.opacity(0.3))
                .frame(width: 60, height: 8)
                .offset(y: -4)
            
            // 3 petites barres métalliques
            HStack(spacing: 3) {
                ForEach(0..<3) { _ in
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 2, height: 12)
                }
            }
        }
    }
}

struct HeaderView: View {
    @Binding var showSettings: Bool
    @Binding var soundEnabled: Bool
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        VStack(spacing: 20) {
            // Sélecteur de langue
            LanguageSelector()
                .padding(.horizontal, 15)
            
            // Toggle pour les sons avec meilleur style
            VStack(spacing: 10) {
                Text(languageManager.currentLanguage == .french ? "Paramètres audio" : "Audio Settings")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                
                HStack {
                    HStack(spacing: 8) {
                        Text(soundEnabled ? "🔊" : "🔇")
                            .font(.system(size: 18))
                        Text(languageManager.currentLanguage == .french ? 
                             (soundEnabled ? "Sons activés" : "Sons désactivés") : 
                             (soundEnabled ? "Sound enabled" : "Sound disabled"))
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(soundEnabled ? Color(red: 0.2, green: 0.2, blue: 0.3) : .gray)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $soundEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.4, green: 0.7, blue: 0.4)))
                        .scaleEffect(0.85)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0.95, green: 0.95, blue: 0.97))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 15)
            }
        }
    }
}

struct AddTaskSection: View {
    @Binding var newTaskTitle: String
    @Binding var newTaskEmoji: String
    @Binding var showEmojiPicker: Bool
    @EnvironmentObject var routineManager: RoutineManager
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(languageManager.text(.addTask))
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
            
            HStack {
                Button(action: { showEmojiPicker = true }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.gray.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        
                        Text(newTaskEmoji)
                            .font(.system(size: 20))
                    }
                    .frame(width: 45, height: 38)
                }
                .buttonStyle(PlainButtonStyle())
                .popover(isPresented: $showEmojiPicker, arrowEdge: .top) {
                    EmojiSelectorView(selectedEmoji: $newTaskEmoji, isPresented: $showEmojiPicker)
                }
                
                TextField(languageManager.text(.newTaskPlaceholder), text: $newTaskTitle)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.3))
                    .font(.system(size: 14, design: .rounded))
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.gray.opacity(0.08))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                
                Button(action: {
                    if !newTaskTitle.isEmpty {
                        // Capitaliser la première lettre
                        let capitalizedTitle = newTaskTitle.prefix(1).uppercased() + newTaskTitle.dropFirst()
                        routineManager.addTask(capitalizedTitle, emoji: newTaskEmoji)
                        newTaskTitle = ""
                        newTaskEmoji = "✨"
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(newTaskTitle.isEmpty ? Color.gray : Color.green)
                            .frame(width: 30, height: 30)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .disabled(newTaskTitle.isEmpty)
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 15)
        .padding(.top, 10)
    }
}

struct TaskListSection: View {
    @EnvironmentObject var routineManager: RoutineManager
    @EnvironmentObject var languageManager: LanguageManager
    let onEdit: (RoutineTask) -> Void
    @State private var draggedIndex: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Titre Mes tâches
            Text(languageManager.text(.myTasks))
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
                .padding(.horizontal, 15)
            
            // Zone des tâches sans scroll interne
            VStack(spacing: 10) {
                ForEach(Array(routineManager.tasks.enumerated()), id: \.element.id) { index, task in
                    TaskRowDraggable(
                        task: task,
                        index: index,
                        allTasks: routineManager.tasks,
                        onEdit: { onEdit(task) },
                        onDelete: { routineManager.deleteTask(task) },
                        draggedIndex: $draggedIndex,
                        onReorder: { from, to in
                            moveTask(from: from, to: to)
                        }
                    )
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.02))
            )
            .padding(.horizontal, 10)
        }
    }
    
    func moveTask(from sourceIndex: Int, to targetIndex: Int) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            routineManager.reorderTask(from: sourceIndex, to: targetIndex)
        }
    }
}

struct TaskRowDraggable: View {
    let task: RoutineTask
    let index: Int
    let allTasks: [RoutineTask]
    let onEdit: () -> Void
    let onDelete: () -> Void
    @Binding var draggedIndex: Int?
    let onReorder: (Int, Int) -> Void
    @State private var isTargeted = false
    
    var body: some View {
        ZStack {
            // Indicateur d'insertion en haut
            if isTargeted {
                VStack {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 2)
                    Spacer()
                }
            }
            
            HStack(spacing: 10) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 11))
                    .foregroundColor(.gray.opacity(0.5))
                
                if !task.emoji.isEmpty {
                    Text(task.emoji)
                        .font(.system(size: 16))
                }
                
                Text(task.title)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.3))
                
                Spacer()
                
                Button(action: onEdit) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.15))
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "pencil")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: onDelete) {
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.1))
                            .frame(width: 24, height: 24)
                        
                        Text("×")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.red.opacity(0.7))
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray.opacity(0.05))
            )
            .opacity(draggedIndex == index ? 0.5 : 1.0)
        }
        .onDrag {
            self.draggedIndex = index
            return NSItemProvider(object: task.title as NSString)
        }
        .onDrop(of: [.text], delegate: SimpleDropDelegate(
            currentIndex: index,
            draggedIndex: $draggedIndex,
            isTargeted: $isTargeted,
            onReorder: onReorder
        ))
    }
}

struct SimpleDropDelegate: DropDelegate {
    let currentIndex: Int
    @Binding var draggedIndex: Int?
    @Binding var isTargeted: Bool
    let onReorder: (Int, Int) -> Void
    
    func dropEntered(info: DropInfo) {
        guard let draggedIndex = draggedIndex,
              draggedIndex != currentIndex else { return }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            isTargeted = true
        }
    }
    
    func dropExited(info: DropInfo) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            isTargeted = false
        }
    }
    
    func performDrop(info: DropInfo) -> Bool {
        guard let sourceIndex = draggedIndex,
              sourceIndex != currentIndex else { 
            isTargeted = false
            draggedIndex = nil
            return false 
        }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            isTargeted = false
        }
        
        onReorder(sourceIndex, currentIndex)
        
        DispatchQueue.main.async {
            self.draggedIndex = nil
        }
        
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}

struct TaskRowSimple: View {
    let task: RoutineTask
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 11))
                .foregroundColor(.gray.opacity(0.5))
            
            if !task.emoji.isEmpty {
                Text(task.emoji)
                    .font(.system(size: 16))
            }
            
            Text(task.title)
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.3))
            
            Spacer()
            
            Button(action: onEdit) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.15))
                        .frame(width: 24, height: 24)
                    
                    Image(systemName: "pencil")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.blue)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: onDelete) {
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.1))
                        .frame(width: 24, height: 24)
                    
                    Text("×")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.red.opacity(0.7))
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 4)
    }
}

struct ResetTimeSection: View {
    @EnvironmentObject var routineManager: RoutineManager
    @EnvironmentObject var languageManager: LanguageManager
    @State private var hourText = "06"
    @State private var minuteText = "00"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(languageManager.currentLanguage == .french ? "⏰ Heure de réinitialisation" : "⏰ Reset Time")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
                .padding(.horizontal, 15)
            
            VStack(spacing: 8) {
                HStack {
                    Text(languageManager.currentLanguage == .french ? 
                         "Les tâches se réinitialisent à :" : 
                         "Tasks reset at:")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        // Champ pour les heures
                        TextField("00", text: $hourText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.3))
                            .multilineTextAlignment(.center)
                            .frame(width: 28)
                            .onChange(of: hourText) { newValue in
                                // Filtrer pour n'accepter que les chiffres
                                let filtered = newValue.filter { $0.isNumber }
                                
                                // Limiter à 2 caractères
                                let limited = String(filtered.prefix(2))
                                
                                // Valider la plage
                                if let hour = Int(limited) {
                                    if hour > 23 {
                                        hourText = "23"
                                    } else {
                                        hourText = limited
                                    }
                                    
                                    // Sauvegarder si valide
                                    if let minute = Int(minuteText.isEmpty ? "0" : minuteText), minute >= 0 && minute <= 59 {
                                        routineManager.updateResetTime(hour: hour, minute: minute)
                                    }
                                } else {
                                    hourText = limited
                                }
                            }
                        
                        Text(":")
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.3))
                        
                        // Champ pour les minutes
                        TextField("00", text: $minuteText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.3))
                            .multilineTextAlignment(.center)
                            .frame(width: 28)
                            .onChange(of: minuteText) { newValue in
                                // Filtrer pour n'accepter que les chiffres
                                let filtered = newValue.filter { $0.isNumber }
                                
                                // Limiter à 2 caractères
                                let limited = String(filtered.prefix(2))
                                
                                // Valider la plage
                                if let minute = Int(limited) {
                                    if minute > 59 {
                                        minuteText = "59"
                                    } else {
                                        minuteText = limited
                                    }
                                    
                                    // Sauvegarder si valide
                                    if let hour = Int(hourText.isEmpty ? "0" : hourText), hour >= 0 && hour <= 23 {
                                        routineManager.updateResetTime(hour: hour, minute: minute)
                                    }
                                } else {
                                    minuteText = limited
                                }
                            }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0.95, green: 0.95, blue: 0.97))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                )
                
                Text(languageManager.currentLanguage == .french ?
                     "Vos tâches seront automatiquement décochées chaque jour à cette heure." :
                     "Your tasks will be automatically unchecked every day at this time.")
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 15)
            .onAppear {
                hourText = String(format: "%02d", routineManager.resetHour)
                minuteText = String(format: "%02d", routineManager.resetMinute)
            }
        }
    }
}

struct LanguageSelector: View {
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        VStack(spacing: 10) {
            Text(languageManager.text(.language) + ":")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 15) {
                ForEach(LanguageManager.Language.allCases, id: \.self) { language in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            languageManager.setLanguage(language)
                        }
                    }) {
                        HStack(spacing: 6) {
                            Text(language.flag)
                                .font(.system(size: 16))
                            Text(language.displayName)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(languageManager.currentLanguage == language ? 
                                      Color.blue.opacity(0.15) : Color.gray.opacity(0.08))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(languageManager.currentLanguage == language ? 
                                              Color.blue.opacity(0.4) : Color.gray.opacity(0.2), 
                                              lineWidth: 1.5)
                                )
                        )
                        .foregroundColor(languageManager.currentLanguage == language ? 
                                       .blue : Color(red: 0.3, green: 0.3, blue: 0.4))
                        .scaleEffect(languageManager.currentLanguage == language ? 1.05 : 1.0)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}



struct StatsSection: View {
    @EnvironmentObject var routineManager: RoutineManager
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📊 " + (languageManager.currentLanguage == .french ? "Statistiques" : "Statistics"))
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
            
            VStack(spacing: 8) {
                StatRow(
                    icon: "✅", 
                    title: languageManager.currentLanguage == .french ? "Tâches terminées" : "Completed tasks",
                    value: "\(routineManager.tasks.filter { $0.isCompleted }.count)"
                )
                
                StatRow(
                    icon: "⏳", 
                    title: languageManager.currentLanguage == .french ? "Tâches restantes" : "Remaining tasks",
                    value: "\(routineManager.tasks.filter { !$0.isCompleted }.count)"
                )
                
                StatRow(
                    icon: "📈", 
                    title: languageManager.currentLanguage == .french ? "Progression" : "Progress",
                    value: "\(Int(routineManager.completionPercentage))%"
                )
                
                StatRow(
                    icon: "📝", 
                    title: languageManager.currentLanguage == .french ? "Total des tâches" : "Total tasks",
                    value: "\(routineManager.tasks.count)"
                )
            }
        }
        .padding(.horizontal, 35)
        .padding(.top, 20)
    }
}

struct StatRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(icon)
                .font(.system(size: 16))
            
            Text(title)
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.5))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(.blue)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.05))
        )
    }
}

struct PreferencesSection: View {
    @EnvironmentObject var languageManager: LanguageManager
    @State private var enableNotifications = true
    @State private var dailyReset = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("⚙️ " + (languageManager.currentLanguage == .french ? "Préférences" : "Preferences"))
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
            
            VStack(spacing: 8) {
                PreferenceRow(
                    icon: "🔔",
                    title: languageManager.currentLanguage == .french ? "Notifications" : "Notifications",
                    isOn: $enableNotifications
                )
                
                PreferenceRow(
                    icon: "🌅",
                    title: languageManager.currentLanguage == .french ? "Réinitialisation quotidienne" : "Daily reset",
                    isOn: $dailyReset
                )
                
                // Info sur le reset à 6h
                HStack {
                    Text("ℹ️")
                        .font(.system(size: 14))
                    
                    Text(languageManager.currentLanguage == .french ? 
                         "Réinitialisation automatique à 6h00" : 
                         "Automatic reset at 6:00 AM")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
            }
        }
        .padding(.horizontal, 35)
        .padding(.top, 15)
    }
}

struct PreferenceRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(icon)
                .font(.system(size: 16))
            
            Text(title)
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.5))
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .scaleEffect(0.8)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.05))
        )
    }
}

struct InfoSection: View {
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ℹ️ " + (languageManager.currentLanguage == .french ? "Informations" : "Information"))
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
            
            VStack(spacing: 8) {
                InfoRow(
                    icon: "⏰",
                    title: languageManager.currentLanguage == .french ? "Heure de réinitialisation" : "Reset time",
                    value: "6:00 AM"
                )
                
                InfoRow(
                    icon: "🔄",
                    title: languageManager.currentLanguage == .french ? "Fréquence des rappels" : "Reminder frequency",
                    value: languageManager.currentLanguage == .french ? "20 min" : "20 min"
                )
                
                InfoRow(
                    icon: "📱",
                    title: languageManager.currentLanguage == .french ? "Version de l'app" : "App version",
                    value: "1.0.0"
                )
                
                InfoRow(
                    icon: "💾",
                    title: languageManager.currentLanguage == .french ? "Données sauvegardées" : "Data saved",
                    value: languageManager.currentLanguage == .french ? "Localement" : "Locally"
                )
            }
        }
        .padding(.horizontal, 35)
        .padding(.top, 15)
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(icon)
                .font(.system(size: 16))
            
            Text(title)
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.5))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(.gray)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.1))
                )
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.05))
        )
    }
}

struct AboutSection: View {
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🏷️ " + (languageManager.currentLanguage == .french ? "À propos" : "About"))
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
            
            VStack(spacing: 8) {
                AboutRow(
                    icon: "🎯",
                    title: "CheckBoard",
                    description: languageManager.currentLanguage == .french ? 
                        "Application de routine matinale" : "Morning routine tracker"
                )
                
                AboutRow(
                    icon: "✨",
                    title: languageManager.currentLanguage == .french ? "Fonctionnalités" : "Features",
                    description: languageManager.currentLanguage == .french ? 
                        "Gestion des tâches • Notifications • Statistiques" : 
                        "Task management • Notifications • Statistics"
                )
                
                AboutRow(
                    icon: "🏆",
                    title: languageManager.currentLanguage == .french ? "Objectif" : "Goal",
                    description: languageManager.currentLanguage == .french ? 
                        "Améliorer votre routine matinale quotidienne" : 
                        "Improve your daily morning routine"
                )
                
                // Section contact/aide
                VStack(spacing: 6) {
                    HStack {
                        Text("💬")
                            .font(.system(size: 14))
                        
                        Text(languageManager.currentLanguage == .french ? "Besoin d'aide ?" : "Need help?")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.5))
                        
                        Spacer()
                    }
                    
                    HStack(spacing: 12) {
                        ActionButton(
                            icon: "❓",
                            title: languageManager.currentLanguage == .french ? "FAQ" : "FAQ",
                            color: .blue
                        )
                        
                        ActionButton(
                            icon: "📧",
                            title: languageManager.currentLanguage == .french ? "Contact" : "Contact",
                            color: .green
                        )
                        
                        ActionButton(
                            icon: "⭐",
                            title: languageManager.currentLanguage == .french ? "Noter" : "Rate",
                            color: .orange
                        )
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.03))
                )
            }
        }
        .padding(.horizontal, 35)
        .padding(.top, 15)
    }
}

struct AboutRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(icon)
                    .font(.system(size: 16))
                
                Text(title)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
                
                Spacer()
            }
            
            Text(description)
                .font(.system(size: 11, design: .rounded))
                .foregroundColor(.gray)
                .padding(.leading, 24)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.05))
        )
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {
            // Actions à implémenter plus tard
        }) {
            HStack(spacing: 4) {
                Text(icon)
                    .font(.system(size: 12))
                Text(title)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
            }
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(color.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
