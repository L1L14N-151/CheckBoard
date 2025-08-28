import Foundation

class LanguageManager: ObservableObject {
    @Published var currentLanguage: Language = .english
    private let userDefaults = UserDefaults(suiteName: "CheckBoard") ?? UserDefaults.standard
    private let languageKey = "selectedLanguage"
    
    enum Language: String, CaseIterable {
        case english = "en"
        case french = "fr"
        
        var displayName: String {
            switch self {
            case .english: return "English"
            case .french: return "Français"
            }
        }
        
        var flag: String {
            switch self {
            case .english: return "🇺🇸"
            case .french: return "🇫🇷"
            }
        }
    }
    
    init() {
        loadLanguage()
    }
    
    func setLanguage(_ language: Language) {
        currentLanguage = language
        saveLanguage()
    }
    
    private func saveLanguage() {
        userDefaults.set(currentLanguage.rawValue, forKey: languageKey)
    }
    
    private func loadLanguage() {
        if let savedLanguage = userDefaults.string(forKey: languageKey),
           let language = Language(rawValue: savedLanguage) {
            currentLanguage = language
        }
    }
    
    // Textes traduits
    func text(_ key: TextKey) -> String {
        switch currentLanguage {
        case .english:
            return englishTexts[key] ?? key.rawValue
        case .french:
            return frenchTexts[key] ?? key.rawValue
        }
    }
}

enum TextKey: String, CaseIterable {
    // Main interface
    case morningRoutine = "MORNING ROUTINE"
    case progress = "PROGRESS"
    case settings = "SETTINGS"
    case addTask = "Add a task"
    case myTasks = "My tasks"
    case restoreDefault = "Restore default"
    case newTaskPlaceholder = "New task..."
    
    // Default tasks
    case drinkWater = "Drink a glass of water"
    case meditate = "Meditate for 5 minutes"
    case stretch = "Stretch"
    case coldShower = "Cold shower"
    case healthyBreakfast = "Healthy breakfast"
    case reviewGoals = "Review daily goals"
    case readTenMinutes = "Read for 10 minutes"
    
    // Notifications
    case notificationTitle = "⏰ CheckBoard"
    case oneTaskLeft = "You have 1 task left to complete!"
    case tasksLeft = "tasks left to complete!"
    case reminderTitle = "⏰ REMINDER - CheckBoard"
    case stillHaveTasks = "You still have"
    case taskToComplete = "task(s) to complete!"
    
    // Language selector
    case language = "Language"
}

private let englishTexts: [TextKey: String] = [
    .morningRoutine: "MORNING ROUTINE",
    .progress: "PROGRESS",
    .settings: "⚙️ SETTINGS",
    .addTask: "Add a task",
    .myTasks: "My tasks",
    .restoreDefault: "Restore default",
    .newTaskPlaceholder: "New task...",
    .drinkWater: "Drink a glass of water",
    .meditate: "Meditate for 5 minutes",
    .stretch: "Stretch",
    .coldShower: "Cold shower",
    .healthyBreakfast: "Healthy breakfast",
    .reviewGoals: "Review daily goals",
    .readTenMinutes: "Read for 10 minutes",
    .notificationTitle: "⏰ CheckBoard",
    .oneTaskLeft: "You have 1 task left to complete!",
    .tasksLeft: "tasks left to complete!",
    .reminderTitle: "⏰ REMINDER - CheckBoard",
    .stillHaveTasks: "You still have",
    .taskToComplete: "task(s) to complete!",
    .language: "Language"
]

private let frenchTexts: [TextKey: String] = [
    .morningRoutine: "ROUTINE MATINALE",
    .progress: "PROGRESSION",
    .settings: "⚙️ PARAMÈTRES",
    .addTask: "Ajouter une tâche",
    .myTasks: "Mes tâches",
    .restoreDefault: "Rétablir par défaut",
    .newTaskPlaceholder: "Nouvelle tâche...",
    .drinkWater: "Boire un verre d'eau",
    .meditate: "Méditer 5 minutes",
    .stretch: "S'étirer",
    .coldShower: "Douche froide",
    .healthyBreakfast: "Petit-déjeuner sain",
    .reviewGoals: "Revoir les objectifs du jour",
    .readTenMinutes: "Lire pendant 10 minutes",
    .notificationTitle: "⏰ CheckBoard",
    .oneTaskLeft: "Il vous reste 1 tâche à terminer !",
    .tasksLeft: "tâches à terminer !",
    .reminderTitle: "⏰ RAPPEL - CheckBoard",
    .stillHaveTasks: "Il vous reste encore",
    .taskToComplete: "tâche(s) à terminer !",
    .language: "Langue"
]