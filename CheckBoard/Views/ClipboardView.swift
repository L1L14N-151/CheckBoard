import SwiftUI
import AppKit

extension DateFormatter {
    static func dayMonth(for language: LanguageManager.Language) -> DateFormatter {
        let formatter = DateFormatter()
        if language == .french {
            formatter.dateFormat = "d MMMM"  // "27 août" au lieu de "27 Aug"
            formatter.locale = Locale(identifier: "fr_FR")
        } else {
            formatter.dateFormat = "MMM d"   // "Aug 27" pour l'anglais
            formatter.locale = Locale(identifier: "en_US")
        }
        return formatter
    }
}

struct ClipboardView: View {
    @EnvironmentObject var routineManager: RoutineManager
    @EnvironmentObject var languageManager: LanguageManager
    @State private var showSettings = false
    @State private var showCompletionAnimation = false
    @State private var confettiOpacity = 0.0
    @State private var particleOffsets: [CGFloat] = Array(repeating: -350, count: 20)
    @AppStorage("soundEnabled") private var soundEnabled = true
    
    var body: some View {
        if showSettings {
            SettingsViewSimple(showSettings: $showSettings)
                .environmentObject(routineManager)
                .environmentObject(languageManager)
        } else {
            ZStack {
            // Fond clipboard en bois/carton
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
            
            // Papier blanc avec ligne
            VStack(spacing: 0) {
                // Espace pour la pince
                Color.clear
                    .frame(height: 50)
                
                // Feuille de papier
                ZStack(alignment: .top) {
                    // Papier principal
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    
                    // Contenu du papier
                    VStack(alignment: .leading, spacing: 0) {
                        // Titre avec style manuscrit
                        HStack {
                            Text(languageManager.text(.morningRoutine))
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.3))
                            
                            Spacer()
                            
                            Text(DateFormatter.dayMonth(for: languageManager.currentLanguage).string(from: Date()))
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 20)
                        
                        // Ligne de séparation style dessinée
                        Path { path in
                            path.move(to: CGPoint(x: 40, y: 0))
                            path.addLine(to: CGPoint(x: 340, y: 0))
                        }
                        .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [5, 3]))
                        .frame(height: 1)
                        .padding(.vertical, 10)
                        
                        // Liste des tâches avec lignes de cahier
                        ScrollView {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(routineManager.tasks) { task in
                                    TaskLineRow(task: task)
                                        .environmentObject(routineManager)
                                }
                            }
                            .padding(.horizontal, 40)
                        }
                        .frame(maxHeight: 380)
                        
                        // Footer avec progression
                        VStack(spacing: 8) {
                            HStack {
                                Text(languageManager.text(.progress))
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Text("\(Int(routineManager.completionPercentage == 0 ? 0 : routineManager.tasks.filter { $0.isCompleted }.count))/\(routineManager.tasks.count)")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal, 40)
                            
                            // Barre de progression style dessinée
                            ZStack(alignment: .leading) {
                                // Fond
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                                    .frame(height: 12)
                                
                                // Remplissage
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.4, green: 0.7, blue: 0.4),
                                                Color(red: 0.5, green: 0.8, blue: 0.5)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: (320 * (routineManager.completionPercentage / 100)), height: 10)
                                    .padding(.leading, 1)
                                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: routineManager.completionPercentage)
                            }
                            .frame(width: 320, height: 12)
                            .padding(.horizontal, 40)
                            
                        }
                        .padding(.vertical, 20)
                    }
                    .padding(.top, 10)
                }
            }
            
            // Pince métallique en haut
            VStack {
                ZStack {
                    // Base de la pince
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
                        .frame(width: 80, height: 30)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                    
                    // Reflet métallique
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 70, height: 10)
                        .offset(y: -5)
                    
                    // Ressort/mécanisme
                    HStack(spacing: 3) {
                        ForEach(0..<3) { _ in
                            RoundedRectangle(cornerRadius: 1)
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 2, height: 15)
                        }
                    }
                }
                .offset(y: 15)
                
                Spacer()
            }
            
            // Bouton paramètres avec roue crantée en haut à droite
            VStack {
                HStack {
                    Spacer()
                    
                    // Roue crantée style post-it avec animation
                    ParametersButton(showSettings: $showSettings)
                        .padding(.trailing, 30)
                        .padding(.top, 20)
                }
                
                Spacer()
            }
            
            // PLUIE DE PARTICULES VERTES - Tombent du vrai haut
            if showCompletionAnimation {
                ForEach(0..<20, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(greenShade(for: i))
                        .frame(width: 12, height: 12)
                        .offset(
                            x: CGFloat.random(in: -180...180), // Position X aléatoire
                            y: particleOffsets[i] // Y varie de -350 à +350
                        )
                        .rotationEffect(.degrees(Double.random(in: 0...360)))
                        .animation(
                            .easeIn(duration: 2.5).delay(Double.random(in: 0...1.0)),
                            value: particleOffsets[i]
                        )
                }
            }
            }
            .frame(width: 400, height: 650)
            .onChange(of: routineManager.completionPercentage) { newValue in
                if newValue >= 100 && !showCompletionAnimation {
                    showCompletionAnimation = true
                    confettiOpacity = 1.0
                    
                    // DÉMARRER L'ANIMATION DES PARTICULES
                    for i in 0..<20 {
                        particleOffsets[i] = -350
                        withAnimation(.easeIn(duration: 2.5).delay(Double.random(in: 0...1.0))) {
                            particleOffsets[i] = 350
                        }
                    }
                    
                    // Son de célébration Material Design (si activé)
                    if soundEnabled {
                        if let soundURL = Bundle.main.url(forResource: "Sounds/celebration", withExtension: "caf"),
                           let sound = NSSound(contentsOf: soundURL, byReference: false) {
                            sound.play()
                        }
                    }
                    
                    // Faire disparaître après 5 secondes (musique plus longue)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        withAnimation(.easeOut(duration: 0.5)) {
                            confettiOpacity = 0.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showCompletionAnimation = false
                            particleOffsets = Array(repeating: -350, count: 20) // Reset
                        }
                    }
                } else if newValue < 100 {
                    showCompletionAnimation = false
                    particleOffsets = Array(repeating: -350, count: 20)
                }
            }
        }
    }
    
    // Fonction pour les nuances de vert
    private func greenShade(for index: Int) -> Color {
        let greenShades = [
            Color(red: 0.2, green: 0.8, blue: 0.2),
            Color(red: 0.3, green: 0.9, blue: 0.3),
            Color(red: 0.1, green: 0.7, blue: 0.1),
            Color(red: 0.25, green: 0.85, blue: 0.25),
            Color(red: 0.15, green: 0.75, blue: 0.15)
        ]
        return greenShades[index % greenShades.count]
    }
}

struct ParametersButton: View {
    @Binding var showSettings: Bool
    @State private var isHovering = false
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            // Fond post-it jaune
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.yellow.opacity(0.9))
                .frame(width: 45, height: 45)
                .shadow(color: .black.opacity(0.2), radius: 3, x: 1, y: 2)
                .rotationEffect(.degrees(isHovering ? 8 : 5))
            
            // Roue crantée
            Image(systemName: "gearshape.fill")
                .font(.system(size: 24))
                .foregroundColor(.black.opacity(0.6))
                .rotationEffect(.degrees(rotation))
        }
        .scaleEffect(isHovering ? 1.15 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHovering)
        .onHover { hovering in
            isHovering = hovering
            if hovering {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            } else {
                withAnimation(.linear(duration: 0.3)) {
                    rotation = 0
                }
            }
        }
        .onTapGesture {
            showSettings = true
        }
    }
}


struct FallingParticle: View {
    let index: Int
    let isActive: Bool
    let opacity: Double
    
    // Position X fixe pour chaque particule
    private let xPosition: CGFloat
    private let particleSize: CGFloat
    private let delay: Double
    private let color: Color
    
    init(index: Int, isActive: Bool, opacity: Double) {
        self.index = index
        self.isActive = isActive
        self.opacity = opacity
        
        // Propriétés fixes calculées à l'initialisation
        self.xPosition = CGFloat.random(in: 50...350)
        self.particleSize = CGFloat.random(in: 6...12)
        self.delay = Double(index) * 0.08
        
        let greenShades = [
            Color(red: 0.2, green: 0.8, blue: 0.2),
            Color(red: 0.3, green: 0.9, blue: 0.3),
            Color(red: 0.1, green: 0.7, blue: 0.1),
            Color(red: 0.25, green: 0.85, blue: 0.25),
            Color(red: 0.15, green: 0.75, blue: 0.15)
        ]
        self.color = greenShades[index % greenShades.count]
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(color)
            .frame(width: particleSize, height: particleSize)
            .offset(
                x: xPosition - 200, // Centrer par rapport à la vue
                y: isActive ? 600 : -50  // Tombe de -50 à +600
            )
            .rotationEffect(.degrees(isActive ? 720 : 0))
            .opacity(isActive ? opacity : 0)
            .animation(
                Animation.easeIn(duration: 2.5).delay(delay),
                value: isActive
            )
    }
}

struct TaskLineRow: View {
    let task: RoutineTask
    @EnvironmentObject var routineManager: RoutineManager
    @State private var isHovering = false
    @AppStorage("soundEnabled") private var soundEnabled = true
    
    var body: some View {
        HStack(spacing: 15) {
            // Case à cocher style dessinée à la main
            ZStack {
                // Carré dessiné
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color(red: 0.3, green: 0.3, blue: 0.4), lineWidth: 2)
                    .frame(width: 20, height: 20)
                
                if task.isCompleted {
                    // Coche style manuscrite
                    Path { path in
                        path.move(to: CGPoint(x: 5, y: 10))
                        path.addLine(to: CGPoint(x: 8, y: 14))
                        path.addLine(to: CGPoint(x: 15, y: 6))
                    }
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    .frame(width: 20, height: 20)
                }
            }
            .scaleEffect(isHovering ? 1.1 : 1.0)
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    routineManager.toggleTask(task)
                    // Son Material Design pour check/uncheck (si activé)
                    if soundEnabled {
                        let soundFile = task.isCompleted ? "uncheck" : "check"
                        if let soundURL = Bundle.main.url(forResource: "Sounds/\(soundFile)", withExtension: "caf"),
                           let sound = NSSound(contentsOf: soundURL, byReference: false) {
                            sound.play()
                        }
                    }
                }
            }
            
            // Emoji et texte de la tâche
            HStack(spacing: 8) {
                if !task.emoji.isEmpty {
                    Text(task.emoji)
                        .font(.system(size: 18))
                }
                
                Text(task.title)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(task.isCompleted ? .gray : Color(red: 0.2, green: 0.2, blue: 0.3))
                    .strikethrough(task.isCompleted, color: .gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
        .background(
            // Ligne de cahier
            VStack {
                Spacer()
                Rectangle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(height: 1)
            }
        )
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                routineManager.toggleTask(task)
                // Son Material Design pour check/uncheck (si activé)
                if soundEnabled {
                    let soundFile = task.isCompleted ? "uncheck" : "check"
                    if let soundURL = Bundle.main.url(forResource: "Sounds/\(soundFile)", withExtension: "caf"),
                       let sound = NSSound(contentsOf: soundURL, byReference: false) {
                        sound.play()
                    }
                }
            }
        }
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovering = hovering
            }
        }
    }
}