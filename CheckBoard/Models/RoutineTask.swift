import Foundation

struct RoutineTask: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var emoji: String = "✨"
    var isCompleted: Bool = false
    var order: Int
    
    init(title: String, emoji: String = "✨", order: Int) {
        self.id = UUID()
        self.title = title
        self.emoji = emoji
        self.order = order
    }
    
    // Pour gérer la migration des anciennes données
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        emoji = try container.decodeIfPresent(String.self, forKey: .emoji) ?? "✨"
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        order = try container.decode(Int.self, forKey: .order)
    }
}

class RoutineManager: ObservableObject {
    @Published var tasks: [RoutineTask] = []
    @Published var selectedEmoji: String = "☀️"
    @Published var resetHour: Int = 6 // Heure de réinitialisation (par défaut 6h)
    @Published var resetMinute: Int = 0 // Minutes de réinitialisation (par défaut 0)
    weak var languageManager: LanguageManager?
    private let userDefaults = UserDefaults(suiteName: "CheckBoard") ?? UserDefaults.standard
    private let tasksKey = "morningRoutineTasks"
    private let emojiKey = "selectedEmoji"
    private let resetHourKey = "resetHour"
    private let resetMinuteKey = "resetMinute"
    
    init(languageManager: LanguageManager? = nil) {
        self.languageManager = languageManager
        loadTasks()
        loadEmoji()
        loadResetTime()
        if tasks.isEmpty {
            setupDefaultTasks()
        }
        resetTasksIfNewDay()
        // Initialiser l'icône du Dock au démarrage
        updateDockIcon()
    }
    
    func setupDefaultTasks() {
        // Si pas de languageManager, utiliser l'anglais par défaut
        let langManager = languageManager ?? LanguageManager()
        
        tasks = [
            RoutineTask(title: langManager.text(.drinkWater), emoji: "💧", order: 0),
            RoutineTask(title: langManager.text(.meditate), emoji: "🧘", order: 1),
            RoutineTask(title: langManager.text(.stretch), emoji: "🤸", order: 2),
            RoutineTask(title: langManager.text(.coldShower), emoji: "🚿", order: 3),
            RoutineTask(title: langManager.text(.healthyBreakfast), emoji: "🥗", order: 4),
            RoutineTask(title: langManager.text(.reviewGoals), emoji: "📝", order: 5),
            RoutineTask(title: langManager.text(.readTenMinutes), emoji: "📚", order: 6)
        ]
        saveTasks()
    }
    
    func toggleTask(_ task: RoutineTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            saveTasks()
            updateDockIcon()
        }
    }
    
    private func updateDockIcon() {
        let allCompleted = tasks.allSatisfy { $0.isCompleted }
        DockIconManager.shared.updateDockIcon(allTasksCompleted: allCompleted)
    }
    
    func addTask(_ title: String, emoji: String = "✨") {
        let newTask = RoutineTask(title: title, emoji: emoji, order: tasks.count)
        tasks.append(newTask)
        saveTasks()
    }
    
    func deleteTask(_ task: RoutineTask) {
        tasks.removeAll { $0.id == task.id }
        updateOrder()
        saveTasks()
    }
    
    func updateTaskTitle(_ task: RoutineTask, newTitle: String) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].title = newTitle
            saveTasks()
        }
    }
    
    func updateTaskEmoji(_ task: RoutineTask, emoji: String) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].emoji = emoji
            saveTasks()
        }
    }
    
    func moveTask(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
        updateOrder()
        saveTasks()
    }
    
    func reorderTask(from sourceIndex: Int, to targetIndex: Int) {
        guard sourceIndex != targetIndex,
              sourceIndex >= 0 && sourceIndex < tasks.count,
              targetIndex >= 0 && targetIndex <= tasks.count else { return }
        
        let task = tasks.remove(at: sourceIndex)
        let insertIndex = targetIndex > sourceIndex ? targetIndex - 1 : targetIndex
        tasks.insert(task, at: insertIndex)
        updateOrder()
        saveTasks()
    }
    
    private func updateOrder() {
        for (index, _) in tasks.enumerated() {
            tasks[index].order = index
        }
    }
    
    func resetAllTasks() {
        for index in tasks.indices {
            tasks[index].isCompleted = false
        }
        saveTasks()
        updateDockIcon()
    }
    
    private func resetTasksIfNewDay() {
        let lastResetKey = "lastResetDate"
        let lastReset = userDefaults.object(forKey: lastResetKey) as? Date ?? Date.distantPast
        
        // Obtenir l'heure actuelle et l'heure de réinitialisation aujourd'hui
        let now = Date()
        let calendar = Calendar.current
        let todayResetTime = calendar.dateInterval(of: .day, for: now)!.start
            .addingTimeInterval(Double(resetHour) * 3600 + Double(resetMinute) * 60)
        
        // Si la dernière réinitialisation était avant l'heure de reset aujourd'hui ET qu'il est maintenant après
        if lastReset < todayResetTime && now >= todayResetTime {
            resetAllTasks()
            userDefaults.set(now, forKey: lastResetKey)
            print("🌅 Tasks reset at \(String(format: "%02d:%02d", resetHour, resetMinute))")
        }
    }
    
    func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            userDefaults.set(encoded, forKey: tasksKey)
        }
    }
    
    private func loadTasks() {
        if let data = userDefaults.data(forKey: tasksKey),
           let decoded = try? JSONDecoder().decode([RoutineTask].self, from: data) {
            tasks = decoded
        }
    }
    
    var completionPercentage: Double {
        guard !tasks.isEmpty else { return 0 }
        let completed = tasks.filter { $0.isCompleted }.count
        return Double(completed) / Double(tasks.count) * 100
    }
    
    func updateEmoji(_ emoji: String) {
        selectedEmoji = emoji
        saveEmoji()
    }
    
    private func saveEmoji() {
        userDefaults.set(selectedEmoji, forKey: emojiKey)
    }
    
    private func loadEmoji() {
        if let emoji = userDefaults.string(forKey: emojiKey) {
            selectedEmoji = emoji
        }
    }
    
    func updateResetTime(hour: Int, minute: Int) {
        resetHour = hour
        resetMinute = minute
        saveResetTime()
    }
    
    private func saveResetTime() {
        userDefaults.set(resetHour, forKey: resetHourKey)
        userDefaults.set(resetMinute, forKey: resetMinuteKey)
    }
    
    private func loadResetTime() {
        let savedHour = userDefaults.object(forKey: resetHourKey) as? Int
        resetHour = savedHour ?? 6 // Par défaut 6h si jamais configuré
        resetMinute = userDefaults.integer(forKey: resetMinuteKey) // Par défaut 0 si jamais configuré
    }
}