import SwiftUI
import AppKit

@main
struct CheckBoardApp: App {
    @StateObject private var languageManager = LanguageManager()
    @StateObject private var routineManager = RoutineManager()
    @State private var resetCheckTimer: Timer?
    
    var body: some Scene {
        WindowGroup {
            ClipboardView()
                .environmentObject(routineManager)
                .environmentObject(languageManager)
                .onAppear {
                    setupApp()
                }
                .frame(width: 400, height: 650)
                .frame(minWidth: 400, maxWidth: 400, minHeight: 650, maxHeight: 650)
        }
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
    }
    
    private func setupApp() {
        // Connect languageManager to routineManager
        routineManager.languageManager = languageManager
        
        // Load custom icon
        DockIconManager.shared.loadIcon()
        
        // Bring window to front on startup
        NSApplication.shared.activate(ignoringOtherApps: true)
        
        // Start timer to check for reset time every minute
        startResetCheckTimer()
        
        // Configure window with delay to ensure it's properly loaded
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let window = NSApplication.shared.windows.first {
                window.makeKeyAndOrderFront(nil)
                window.title = "CheckBoard"
                
                
                // Set fixed window size
                window.setContentSize(NSSize(width: 400, height: 650))
                window.minSize = NSSize(width: 400, height: 650)
                window.maxSize = NSSize(width: 400, height: 650)
                
            }
        }
    }
    
    private func startResetCheckTimer() {
        // Invalider le timer existant si présent
        resetCheckTimer?.invalidate()
        
        // Vérifier toutes les 30 secondes pour plus de précision
        resetCheckTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            self.checkForResetTime()
        }
    }
    
    private func checkForResetTime() {
        let now = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: now)
        let currentMinute = calendar.component(.minute, from: now)
        
        // Récupérer la dernière réinitialisation
        let lastResetKey = "lastResetDate"
        let userDefaults = UserDefaults(suiteName: "CheckBoard") ?? UserDefaults.standard
        let lastReset = userDefaults.object(forKey: lastResetKey) as? Date ?? Date.distantPast
        
        // Calculer l'heure de reset aujourd'hui
        let todayResetTime = calendar.dateInterval(of: .day, for: now)!.start
            .addingTimeInterval(Double(routineManager.resetHour) * 3600 + Double(routineManager.resetMinute) * 60)
        
        // Si on est dans la minute de reset et qu'on n'a pas déjà reset récemment
        if currentHour == routineManager.resetHour && 
           currentMinute == routineManager.resetMinute &&
           lastReset < todayResetTime {
            
            // Réinitialiser les tâches
            routineManager.resetAllTasks()
            userDefaults.set(now, forKey: lastResetKey)
            
            print("🌅 Auto-reset tasks at \(String(format: "%02d:%02d", routineManager.resetHour, routineManager.resetMinute))")
            
            // Mettre à jour l'icône du Dock
            DockIconManager.shared.updateDockIcon(allTasksCompleted: false)
        }
    }
}