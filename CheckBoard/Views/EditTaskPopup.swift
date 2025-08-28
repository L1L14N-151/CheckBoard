import SwiftUI

struct EditTaskPopup: View {
    @Binding var isPresented: Bool
    @Binding var taskTitle: String
    @Binding var taskEmoji: String
    let onSave: (String, String) -> Void
    @State private var tempTitle: String = ""
    @State private var tempEmoji: String = ""
    @State private var showEmojiPicker = false
    
    var body: some View {
        ZStack {
            // Fond sombre transparent
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            // Popup style clipboard
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
                
                // Papier blanc
                VStack(spacing: 0) {
                    // Espace pour la pince
                    Color.clear
                        .frame(height: 30)
                    
                    // Feuille de papier
                    ZStack(alignment: .top) {
                        // Papier principal
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                            .padding(.horizontal, 15)
                            .padding(.bottom, 15)
                        
                        // Contenu du papier
                        VStack(alignment: .leading, spacing: 20) {
                            // Titre
                            Text("✏️ MODIFIER LA TÂCHE")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.3))
                                .frame(maxWidth: .infinity)
                                .padding(.top, 10)
                            
                            // Ligne de séparation
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: 0))
                                path.addLine(to: CGPoint(x: 280, y: 0))
                            }
                            .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [5, 3]))
                            .frame(height: 1)
                            
                            // Sélecteur d'emoji
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Emoji")
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
                                
                                Button(action: {
                                    showEmojiPicker = true
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color.gray.opacity(0.08))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 6)
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                            )
                                            .frame(width: 50, height: 38)
                                        
                                        if tempEmoji.isEmpty {
                                            Text("—")
                                                .font(.system(size: 20))
                                                .foregroundColor(.gray)
                                        } else {
                                            Text(tempEmoji)
                                                .font(.system(size: 20))
                                        }
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            // Champ de texte
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Nom de la tâche")
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
                                
                                TextField("Entrez le nom...", text: $tempTitle)
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
                            }
                            
                            // Boutons
                            HStack(spacing: 12) {
                                // Bouton Annuler
                                Button(action: {
                                    isPresented = false
                                }) {
                                    Text("Annuler")
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                // Bouton Valider
                                Button(action: {
                                    if !tempTitle.isEmpty {
                                        onSave(tempTitle, tempEmoji)
                                        isPresented = false
                                    }
                                }) {
                                    Text("Valider")
                                        .font(.system(size: 14, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(Color.green)
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(tempTitle.isEmpty)
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.vertical, 15)
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
                            .frame(width: 60, height: 20)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                        
                        // Reflet métallique
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 50, height: 6)
                            .offset(y: -3)
                    }
                    .offset(y: 10)
                    
                    Spacer()
                }
            }
            .frame(width: 320, height: 350)
        }
        .onAppear {
            tempTitle = taskTitle
            tempEmoji = taskEmoji
        }
        .sheet(isPresented: $showEmojiPicker) {
            EmojiSelectorView(selectedEmoji: $tempEmoji, isPresented: $showEmojiPicker)
        }
    }
}