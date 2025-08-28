import SwiftUI
import AppKit

struct NativeEmojiButton: View {
    @Binding var emoji: String
    @State private var showingPopover = false
    
    var body: some View {
        Button(action: {
            showingPopover = true
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                
                Text(emoji.isEmpty ? "😀" : emoji)
                    .font(.system(size: 20))
            }
            .frame(width: 45, height: 38)
        }
        .buttonStyle(PlainButtonStyle())
        .popover(isPresented: $showingPopover, arrowEdge: .top) {
            EmojiSelectorView(selectedEmoji: $emoji, isPresented: $showingPopover)
        }
    }
}

struct EmojiSelectorView: View {
    @Binding var selectedEmoji: String
    @Binding var isPresented: Bool
    
    // Emojis organisés par catégories (sans symboles/lettres)
    let categories = [
        "Smileys": ["😀", "😃", "😄", "😁", "😆", "😅", "🤣", "😂", "🙂", "🙃", "😉", "😊", "😇", "🥰", "😍", "🤩", "😘", "😗", "😚", "😙", "😋", "😛", "😜", "🤪", "😝", "🤑", "🤗", "🤭", "🤫", "🤔", "🤐", "🤨", "😐", "😑", "😶", "😏", "😒", "🙄", "😬", "🤥", "😌", "😔", "😪", "🤤", "😴", "😷", "🤒", "🤕", "🤢", "🤮", "🤧", "🥵", "🥶", "🥴", "😵", "🤯", "🤠", "🥳", "😎", "🤓", "🧐", "😕", "😟", "🙁", "😮", "😯", "😲", "😳", "🥺", "😦", "😧", "😨", "😰", "😥", "😢", "😭", "😱", "😖", "😣", "😞", "😓", "😩", "😫", "🥱", "😤", "😡", "😠", "🤬", "😈", "👿", "💀", "☠️", "💩", "🤡", "👹", "👺", "👻", "👽", "👾", "🤖"],
        "Animaux": ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮", "🐷", "🐽", "🐸", "🐵", "🙈", "🙉", "🙊", "🐒", "🐔", "🐧", "🐦", "🐤", "🐣", "🐥", "🦆", "🦅", "🦉", "🦇", "🐺", "🐗", "🐴", "🦄", "🐝", "🐛", "🦋", "🐌", "🐞", "🐜", "🦟", "🦗", "🕷️", "🕸️", "🦂", "🐢", "🐍", "🦎", "🦖", "🦕", "🐙", "🦑", "🦐", "🦞", "🦀", "🐡", "🐠", "🐟", "🐬", "🐳", "🐋", "🦈", "🐊", "🐅", "🐆", "🦓", "🦍", "🦧", "🐘", "🦛", "🦏", "🐪", "🐫", "🦒", "🦘", "🐃", "🐂", "🐄", "🐎", "🐖", "🐏", "🐑", "🦙", "🐐", "🦌", "🐕", "🐩", "🦮", "🐈", "🐓", "🦃", "🦚", "🦜", "🦢", "🦩", "🕊️", "🐇", "🦝", "🦨", "🦡", "🦦", "🦥", "🐁", "🐀", "🐿️", "🦔"],
        "Nature": ["🌵", "🎄", "🌲", "🌳", "🌴", "🌱", "🌿", "☘️", "🍀", "🎍", "🎋", "🍃", "🍂", "🍁", "🍄", "🐚", "🌾", "💐", "🌷", "🌹", "🥀", "🌺", "🌸", "🌼", "🌻", "🌞", "🌝", "🌛", "🌜", "🌚", "🌕", "🌖", "🌗", "🌘", "🌑", "🌒", "🌓", "🌔", "🌙", "🌎", "🌍", "🌏", "💫", "⭐", "🌟", "✨", "⚡", "☄️", "💥", "🔥", "🌪️", "🌈", "☀️", "🌤️", "⛅", "🌥️", "☁️", "🌦️", "🌧️", "⛈️", "🌩️", "🌨️", "❄️", "☃️", "⛄", "🌬️", "💨", "💧", "💦", "☔", "☂️", "🌊", "🌫️"],
        "Nourriture": ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍈", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝", "🍅", "🍆", "🥑", "🥦", "🥬", "🥒", "🌶️", "🌽", "🥕", "🧄", "🧅", "🥔", "🍠", "🥐", "🥯", "🍞", "🥖", "🥨", "🧀", "🥚", "🍳", "🧈", "🥞", "🧇", "🥓", "🥩", "🍗", "🍖", "🌭", "🍔", "🍟", "🍕", "🥪", "🥙", "🧆", "🌮", "🌯", "🥗", "🥘", "🥫", "🍝", "🍜", "🍲", "🍛", "🍣", "🍱", "🥟", "🦪", "🍤", "🍙", "🍚", "🍘", "🍥", "🥠", "🥮", "🍢", "🍡", "🍧", "🍨", "🍦", "🥧", "🧁", "🍰", "🎂", "🍮", "🍭", "🍬", "🍫", "🍿", "🍩", "🍪", "🌰", "🥜", "🍯", "🥛", "🍼", "☕", "🍵", "🧃", "🥤", "🍶", "🍺", "🍻", "🥂", "🍷", "🥃", "🍸", "🍹", "🧉", "🍾", "🧊"],
        "Activités": ["⚽", "🏀", "🏈", "⚾", "🥎", "🎾", "🏐", "🏉", "🥏", "🎱", "🪀", "🏓", "🏸", "🏒", "🏑", "🥍", "🏏", "🥅", "⛳", "🪁", "🏹", "🎣", "🤿", "🥊", "🥋", "🎽", "🛹", "🛷", "⛸️", "🥌", "🎿", "⛷️", "🏂", "🪂", "🏋️", "🤼", "🤸", "🤺", "🤾", "🏌️", "🏇", "🧘", "🏄", "🏊", "🤽", "🚣", "🧗", "🚴", "🚵", "🎪", "🎭", "🎨", "🎬", "🎤", "🎧", "🎼", "🎹", "🥁", "🎷", "🎺", "🎸", "🪕", "🎻", "🎲", "♟️", "🎯", "🎳", "🎮", "🎰", "🧩"],
        "Voyages": ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎️", "🚓", "🚑", "🚒", "🚐", "🚚", "🚛", "🚜", "🦯", "🦽", "🦼", "🛴", "🚲", "🛵", "🏍️", "🛺", "🚨", "🚔", "🚍", "🚘", "🚖", "🚡", "🚠", "🚟", "🚃", "🚋", "🚞", "🚝", "🚄", "🚅", "🚈", "🚂", "🚆", "🚇", "🚊", "🚉", "✈️", "🛫", "🛬", "🛩️", "💺", "🛰️", "🚀", "🛸", "🚁", "🛶", "⛵", "🚤", "🛥️", "🛳️", "⛴️", "🚢", "⚓", "⛽", "🚧", "🚦", "🚥", "🚏", "🗺️", "🗿", "🗽", "🗼", "🏰", "🏯", "🏟️", "🎡", "🎢", "🎠", "⛲", "⛱️", "🏖️", "🏝️", "🏜️", "🌋", "⛰️", "🏔️", "🗻", "🏕️", "🛤️", "🛣️"],
        "Objets": ["⌚", "📱", "📲", "💻", "⌨️", "🖥️", "🖨️", "🖱️", "🖲️", "🕹️", "🗜️", "💽", "💾", "💿", "📀", "📼", "📷", "📸", "📹", "🎥", "📽️", "🎞️", "📞", "☎️", "📟", "📠", "📺", "📻", "🎙️", "🎚️", "🎛️", "🧭", "⏱️", "⏲️", "⏰", "🕰️", "⌛", "⏳", "📡", "🔋", "🔌", "💡", "🔦", "🕯️", "🪔", "🧯", "🛢️", "💸", "💵", "💴", "💶", "💷", "💰", "💳", "💎", "⚖️", "🧰", "🔧", "🔨", "⚒️", "🛠️", "⛏️", "🔩", "⚙️", "🧱", "⛓️", "🧲", "🔫", "💣", "🧨", "🪓", "🔪", "🗡️", "⚔️", "🛡️", "🚬", "⚰️", "⚱️", "🏺", "🔮", "📿", "🧿", "💈", "⚗️", "🔭", "🔬", "🕳️", "🩹", "🩺", "💊", "💉", "🩸", "🧬", "🦠", "🧫", "🧪"],
        "Symboles": ["❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "🤍", "🤎", "💔", "❣️", "💕", "💞", "💓", "💗", "💖", "💘", "💝", "💟", "☮️", "✝️", "☪️", "🕉️", "☸️", "✡️", "🔯", "🕎", "☯️", "☦️", "🛐", "⛎", "♈", "♉", "♊", "♋", "♌", "♍", "♎", "♏", "♐", "♑", "♒", "♓", "🆔", "⚛️", "🉑", "☢️", "☣️", "📴", "📳", "🈶", "🈚", "🈸", "🈺", "🈷️", "✴️", "🆚", "💮", "🉐", "㊙️", "㊗️", "🈴", "🈵", "🈹", "🈲", "🅰️", "🅱️", "🆎", "🆑", "🅾️", "🆘", "❌", "⭕", "🛑", "⛔", "📛", "🚫", "💯", "💢", "♨️", "🚷", "🚯", "🚳", "🚱", "🔞", "📵", "🚭", "❗", "❕", "❓", "❔", "‼️", "⁉️", "🔅", "🔆", "〽️", "⚠️", "🚸", "🔱", "⚜️", "🔰", "♻️", "✅", "🈯", "💹", "❇️", "✳️", "❎", "🌐", "💠", "Ⓜ️", "🌀", "💤", "🏧", "🚾", "♿", "🅿️", "🈳", "🈂️", "🛂", "🛃", "🛄", "🛅", "🚹", "🚺", "🚼", "🚻", "🚮", "🎦", "📶", "🈁", "🔣", "ℹ️", "🔤", "🔡", "🔠", "🆖", "🆗", "🆙", "🆒", "🆕", "🆓", "0️⃣", "1️⃣", "2️⃣", "3️⃣", "4️⃣", "5️⃣", "6️⃣", "7️⃣", "8️⃣", "9️⃣", "🔟"]
    ]
    
    @State private var selectedCategory = "Smileys"
    @State private var searchText = ""
    @State private var filteredEmojis: [String] = []
    @State private var scrollOffset: CGFloat = 0
    @State private var showLeftArrow = false
    @State private var showRightArrow = true
    
    var body: some View {
        VStack(spacing: 0) {
            // Barre de recherche
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                
                TextField("Rechercher un emoji...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: 13))
                    .onChange(of: searchText) { _ in
                        filterEmojis()
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        filterEmojis()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
            )
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            
            // Header avec catégories (seulement si pas de recherche)
            if searchText.isEmpty {
                HStack(spacing: 0) {
                    // Flèche gauche
                    if showLeftArrow {
                        Button(action: {
                            withAnimation {
                                navigateCategories(direction: .left)
                            }
                        }) {
                            ZStack {
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(NSColor.windowBackgroundColor),
                                        Color.gray.opacity(0.05)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .frame(width: 25)
                                
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(.gray)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(height: 30)
                    }
                    
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(Array(categories.keys.sorted()), id: \.self) { category in
                                    Button(action: {
                                        selectedCategory = category
                                        updateArrowVisibility()
                                    }) {
                                        Text(category)
                                            .font(.system(size: 11, weight: selectedCategory == category ? .semibold : .regular))
                                            .foregroundColor(selectedCategory == category ? .blue : .gray)
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 8)
                                            .background(
                                                RoundedRectangle(cornerRadius: 6)
                                                    .fill(selectedCategory == category ? Color.blue.opacity(0.1) : Color.clear)
                                            )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .id(category)
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                        .onChange(of: selectedCategory) { newCategory in
                            withAnimation {
                                proxy.scrollTo(newCategory, anchor: .center)
                            }
                        }
                    }
                    
                    // Flèche droite
                    if showRightArrow {
                        Button(action: {
                            withAnimation {
                                navigateCategories(direction: .right)
                            }
                        }) {
                            ZStack {
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.gray.opacity(0.05),
                                        Color(NSColor.windowBackgroundColor)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .frame(width: 25)
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(.gray)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(height: 30)
                    }
                }
                .frame(height: 30)
                .padding(.vertical, 4)
                .background(Color.gray.opacity(0.05))
            }
            
            Divider()
            
            // Grille d'emojis
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 9), spacing: 4) {
                    ForEach(searchText.isEmpty ? (categories[selectedCategory] ?? []) : filteredEmojis, id: \.self) { emoji in
                        Button(action: {
                            selectedEmoji = emoji
                            isPresented = false
                        }) {
                            Text(emoji)
                                .font(.system(size: 24))
                                .frame(width: 34, height: 34)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(selectedEmoji == emoji ? Color.blue.opacity(0.2) : Color.clear)
                                )
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onHover { isHovered in
                            if isHovered {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        }
                    }
                }
                .padding(8)
            }
            .frame(height: 280)
            
            Divider()
            
            // Footer
            HStack {
                Button("Sans emoji") {
                    selectedEmoji = ""
                    isPresented = false
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.gray)
                
                Spacer()
                
                Text(selectedEmoji.isEmpty ? "Aucun emoji" : "Sélectionné: \(selectedEmoji)")
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button("Fermer") {
                    isPresented = false
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.blue)
                )
            }
            .padding(10)
            .background(Color.gray.opacity(0.05))
        }
        .frame(width: 400, height: 420)
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(10)
        .shadow(radius: 10)
        .onAppear {
            filterEmojis()
            updateArrowVisibility()
        }
    }
    
    enum NavigationDirection {
        case left, right
    }
    
    private func navigateCategories(direction: NavigationDirection) {
        let sortedCategories = Array(categories.keys.sorted())
        guard let currentIndex = sortedCategories.firstIndex(of: selectedCategory) else { return }
        
        var newIndex: Int
        if direction == .left {
            newIndex = max(0, currentIndex - 1)
        } else {
            newIndex = min(sortedCategories.count - 1, currentIndex + 1)
        }
        
        selectedCategory = sortedCategories[newIndex]
        updateArrowVisibility()
    }
    
    private func updateArrowVisibility() {
        let sortedCategories = Array(categories.keys.sorted())
        guard let currentIndex = sortedCategories.firstIndex(of: selectedCategory) else { return }
        
        showLeftArrow = currentIndex > 0
        showRightArrow = currentIndex < sortedCategories.count - 1
    }
    
    private func filterEmojis() {
        if searchText.isEmpty {
            filteredEmojis = []
        } else {
            // Chercher dans toutes les catégories
            var allEmojis: [String] = []
            for (_, emojis) in categories {
                allEmojis.append(contentsOf: emojis)
            }
            
            // Filtrer par nom (utilise les descriptions Unicode si possible)
            filteredEmojis = allEmojis.filter { emoji in
                // Pour une recherche basique, on cherche si l'emoji contient le texte
                // Dans un cas réel, on pourrait mapper les emojis à leurs noms
                return searchMatchesEmoji(emoji, searchText)
            }
        }
    }
    
    private func searchMatchesEmoji(_ emoji: String, _ search: String) -> Bool {
        let searchLower = search.lowercased()
        
        // Recherche simple par le caractère lui-même
        if emoji.lowercased().contains(searchLower) {
            return true
        }
        
        // Dictionnaire complet emoji -> mots-clés pour la recherche
        let emojiKeywords = getEmojiKeywords()
        
        // Vérifier si l'emoji a des mots-clés associés
        if let keywords = emojiKeywords[emoji] {
            return keywords.contains { keyword in
                keyword.lowercased().contains(searchLower)
            }
        }
        
        return false
    }
    
    private func getEmojiKeywords() -> [String: [String]] {
        return [
            // Smileys & Emotions
            "😀": ["sourire", "smile", "heureux", "happy", "joie", "content", "grin"],
            "😃": ["sourire", "smile", "heureux", "happy", "joie", "grand"],
            "😄": ["sourire", "smile", "heureux", "happy", "rire", "laugh"],
            "😁": ["sourire", "smile", "dents", "teeth", "beam"],
            "😆": ["rire", "laugh", "lol", "mdr", "drôle", "funny"],
            "😅": ["nerveux", "nervous", "sueur", "sweat", "gêné"],
            "🤣": ["mdr", "lol", "ptdr", "rofl", "rire", "laugh", "floor"],
            "😂": ["rire", "laugh", "lol", "pleure", "cry", "drôle", "tears", "joie"],
            "🙂": ["sourire", "smile", "léger", "slight"],
            "🙃": ["inversé", "upside", "down", "renversé"],
            "😉": ["clin", "wink", "oeil", "eye"],
            "😊": ["sourire", "smile", "blush", "rougir", "content"],
            "😇": ["ange", "angel", "auréole", "halo", "innocent"],
            "🥰": ["amour", "love", "coeur", "hearts", "adorable"],
            "😍": ["amour", "love", "coeur", "heart", "yeux"],
            "🤩": ["étoiles", "stars", "wow", "impressionné"],
            "😘": ["bisou", "kiss", "coeur", "heart"],
            "😗": ["bisou", "kiss", "siffler", "whistle"],
            "😚": ["bisou", "kiss", "fermé", "closed"],
            "😙": ["bisou", "kiss", "sourire", "smile"],
            "😋": ["miam", "yum", "délicieux", "tasty", "langue"],
            "😛": ["langue", "tongue", "taquin"],
            "😜": ["langue", "tongue", "clin", "wink"],
            "🤪": ["fou", "crazy", "bizarre", "weird", "zany"],
            "😝": ["langue", "tongue", "fermé", "closed"],
            "🤑": ["argent", "money", "dollar", "riche"],
            "🤗": ["câlin", "hug", "abrazo", "embrassade"],
            "🤭": ["oops", "main", "hand", "bouche", "mouth"],
            "🤫": ["chut", "shh", "silence", "quiet"],
            "🤔": ["penser", "think", "réfléchir", "hmm"],
            "🤐": ["zip", "bouche", "fermé", "muet"],
            "🤨": ["sceptique", "skeptical", "sourcil", "eyebrow"],
            "😐": ["neutre", "neutral", "bof", "meh"],
            "😑": ["blasé", "expressionless", "ennui"],
            "😶": ["sans", "no", "bouche", "mouth"],
            "😏": ["sourire", "smirk", "coin", "malin"],
            "😒": ["pas", "not", "amusé", "amused"],
            "🙄": ["yeux", "eyes", "roll", "lever"],
            "😬": ["grimace", "dents", "teeth", "awkward"],
            "🤥": ["mentir", "lie", "pinocchio", "nez"],
            "😌": ["soulagé", "relieved", "zen", "calme"],
            "😔": ["triste", "sad", "pensif", "pensive"],
            "😪": ["dormir", "sleep", "fatigue", "tired"],
            "🤤": ["baver", "drool", "salive"],
            "😴": ["dormir", "sleep", "zzz", "sommeil"],
            "😷": ["masque", "mask", "malade", "sick"],
            "🤒": ["fièvre", "fever", "thermomètre", "malade"],
            "🤕": ["blessé", "hurt", "bandage", "accident"],
            "🤢": ["nausée", "nausea", "vert", "green", "malade"],
            "🤮": ["vomir", "vomit", "malade", "sick"],
            "🤧": ["éternuer", "sneeze", "mouchoir", "tissue"],
            "🥵": ["chaud", "hot", "chaleur", "heat"],
            "🥶": ["froid", "cold", "gel", "freeze"],
            "🥴": ["ivre", "drunk", "woozy", "étourdi"],
            "😵": ["étourdi", "dizzy", "ko"],
            "🤯": ["explosion", "explode", "mind", "blown", "tête"],
            "🤠": ["cowboy", "chapeau", "hat", "western"],
            "🥳": ["fête", "party", "celebration", "chapeau"],
            "😎": ["cool", "lunettes", "sunglasses", "stylé"],
            "🤓": ["nerd", "geek", "lunettes", "glasses"],
            "🧐": ["monocle", "enquête", "inspect"],
            "😕": ["confus", "confused", "perplexe"],
            "😟": ["inquiet", "worried", "concerné"],
            "🙁": ["triste", "sad", "frown", "malheureux"],
            "😮": ["surpris", "surprised", "oh", "bouche"],
            "😯": ["surpris", "surprised", "hushed"],
            "😲": ["choqué", "shocked", "astonished"],
            "😳": ["rougir", "blush", "flush", "embarrassé"],
            "🥺": ["plaidoyer", "pleading", "pitié", "mignon"],
            "😦": ["bouche", "frown", "open"],
            "😧": ["angoissé", "anguished"],
            "😨": ["peur", "fear", "fearful"],
            "😰": ["anxieux", "anxious", "sueur", "sweat"],
            "😥": ["soulagé", "relieved", "déçu"],
            "😢": ["pleur", "cry", "larme", "tear", "triste"],
            "😭": ["pleurer", "sob", "larmes", "tears", "fort"],
            "😱": ["crier", "scream", "peur", "fear"],
            "😖": ["confounded", "frustré"],
            "😣": ["persévérant", "persevere"],
            "😞": ["déçu", "disappointed"],
            "😓": ["sueur", "sweat", "travail"],
            "😩": ["fatigué", "weary", "tired"],
            "😫": ["épuisé", "tired", "fatigue"],
            "🥱": ["bailler", "yawn", "fatigue"],
            "😤": ["triomphe", "triumph", "vapeur", "steam"],
            "😡": ["colère", "angry", "rouge", "mad"],
            "😠": ["colère", "angry", "fâché"],
            "🤬": ["juron", "curse", "symboles", "colère"],
            "😈": ["diable", "devil", "cornes", "sourire"],
            "👿": ["diable", "devil", "colère", "imp"],
            "💀": ["crâne", "skull", "mort", "death"],
            "☠️": ["poison", "crossbones", "danger", "mort"],
            "💩": ["caca", "poop", "merde", "shit"],
            "🤡": ["clown", "cirque", "circus"],
            "👹": ["ogre", "monstre", "monster", "japon"],
            "👺": ["goblin", "tengu", "masque", "japon"],
            "👻": ["fantôme", "ghost", "boo", "halloween"],
            "👽": ["alien", "extraterrestre", "ovni", "ufo"],
            "👾": ["alien", "monstre", "jeu", "game"],
            "🤖": ["robot", "bot", "ia", "ai"],
            
            // Animaux
            "🐶": ["chien", "dog", "chiot", "puppy", "animal"],
            "🐱": ["chat", "cat", "chaton", "kitten", "animal"],
            "🐭": ["souris", "mouse", "rongeur", "animal"],
            "🐹": ["hamster", "rongeur", "animal"],
            "🐰": ["lapin", "rabbit", "bunny", "animal"],
            "🦊": ["renard", "fox", "animal"],
            "🐻": ["ours", "bear", "animal"],
            "🐼": ["panda", "chine", "china", "animal"],
            "🐨": ["koala", "australie", "animal"],
            "🐯": ["tigre", "tiger", "félin", "animal"],
            "🦁": ["lion", "roi", "king", "animal"],
            "🐮": ["vache", "cow", "ferme", "farm"],
            "🐷": ["cochon", "pig", "porc", "ferme"],
            "🐸": ["grenouille", "frog", "animal"],
            "🐵": ["singe", "monkey", "primate"],
            "🐔": ["poulet", "chicken", "poule", "ferme"],
            "🐧": ["pingouin", "penguin", "animal"],
            "🐦": ["oiseau", "bird", "animal"],
            "🐤": ["poussin", "chick", "bébé"],
            "🦆": ["canard", "duck", "animal"],
            "🦅": ["aigle", "eagle", "oiseau"],
            "🦉": ["hibou", "owl", "nuit"],
            "🦇": ["chauve-souris", "bat", "vampire"],
            "🐺": ["loup", "wolf", "animal"],
            "🐗": ["sanglier", "boar", "animal"],
            "🐴": ["cheval", "horse", "animal"],
            "🦄": ["licorne", "unicorn", "magie"],
            "🐝": ["abeille", "bee", "miel", "insecte"],
            "🐛": ["chenille", "caterpillar", "insecte"],
            "🦋": ["papillon", "butterfly", "insecte"],
            "🐌": ["escargot", "snail", "lent"],
            "🐞": ["coccinelle", "ladybug", "insecte"],
            "🐜": ["fourmi", "ant", "insecte"],
            "🦟": ["moustique", "mosquito", "insecte"],
            "🕷️": ["araignée", "spider", "insecte"],
            "🦂": ["scorpion", "insecte", "danger"],
            "🐢": ["tortue", "turtle", "lent"],
            "🐍": ["serpent", "snake", "reptile"],
            "🦎": ["lézard", "lizard", "reptile"],
            "🦖": ["t-rex", "dinosaure", "dinosaur"],
            "🦕": ["dinosaure", "dinosaur", "sauropode"],
            "🐙": ["poulpe", "octopus", "mer"],
            "🦑": ["calmar", "squid", "mer"],
            "🦐": ["crevette", "shrimp", "mer"],
            "🦞": ["homard", "lobster", "mer"],
            "🦀": ["crabe", "crab", "mer"],
            "🐡": ["poisson", "fish", "fugu"],
            "🐠": ["poisson", "fish", "tropical"],
            "🐟": ["poisson", "fish", "mer"],
            "🐬": ["dauphin", "dolphin", "mer"],
            "🐳": ["baleine", "whale", "mer"],
            "🐋": ["baleine", "whale", "eau"],
            "🦈": ["requin", "shark", "danger"],
            "🐊": ["crocodile", "alligator", "danger"],
            "🐅": ["tigre", "tiger", "félin"],
            "🐆": ["léopard", "leopard", "félin"],
            "🦓": ["zèbre", "zebra", "rayures"],
            "🦍": ["gorille", "gorilla", "singe"],
            "🐘": ["éléphant", "elephant", "trompe"],
            "🦛": ["hippopotame", "hippo", "eau"],
            "🦏": ["rhinocéros", "rhino", "corne"],
            "🐪": ["chameau", "camel", "désert"],
            "🐫": ["dromadaire", "dromedary", "désert"],
            "🦒": ["girafe", "giraffe", "cou"],
            "🦘": ["kangourou", "kangaroo", "australie"],
            
            // Nature
            "🌵": ["cactus", "désert", "plante"],
            "🎄": ["sapin", "christmas", "noël", "arbre"],
            "🌲": ["sapin", "evergreen", "arbre"],
            "🌳": ["arbre", "tree", "nature"],
            "🌴": ["palmier", "palm", "tropical"],
            "🌱": ["pousse", "seedling", "plante"],
            "🌿": ["herbe", "herb", "plante"],
            "☘️": ["trèfle", "shamrock", "irlande"],
            "🍀": ["chance", "luck", "trèfle", "quatre"],
            "🍃": ["feuille", "leaf", "vent"],
            "🍂": ["automne", "autumn", "fall", "feuille"],
            "🍁": ["érable", "maple", "canada"],
            "🍄": ["champignon", "mushroom", "mario"],
            "🌾": ["blé", "wheat", "grain"],
            "💐": ["bouquet", "fleurs", "flowers"],
            "🌷": ["tulipe", "tulip", "fleur"],
            "🌹": ["rose", "fleur", "amour"],
            "🥀": ["fanée", "wilted", "rose", "triste"],
            "🌺": ["hibiscus", "fleur", "tropical"],
            "🌸": ["cerisier", "cherry", "blossom", "japon"],
            "🌼": ["marguerite", "daisy", "fleur"],
            "🌻": ["tournesol", "sunflower", "fleur"],
            "🌞": ["soleil", "sun", "visage", "face"],
            "🌝": ["lune", "moon", "pleine", "full"],
            "🌛": ["lune", "moon", "premier", "first"],
            "🌜": ["lune", "moon", "dernier", "last"],
            "🌚": ["lune", "moon", "nouvelle", "new"],
            "🌕": ["pleine", "full", "lune", "moon"],
            "🌙": ["croissant", "crescent", "lune", "nuit"],
            "🌎": ["terre", "earth", "amérique", "monde"],
            "🌍": ["terre", "earth", "europe", "afrique"],
            "🌏": ["terre", "earth", "asie", "monde"],
            "💫": ["étoile", "dizzy", "star"],
            "⭐": ["étoile", "star", "favori"],
            "🌟": ["étoile", "star", "brillant", "glow"],
            "✨": ["étincelles", "sparkles", "magie", "brillant"],
            "⚡": ["éclair", "lightning", "électricité", "rapide"],
            "☄️": ["comète", "comet", "espace"],
            "💥": ["explosion", "boom", "collision"],
            "🔥": ["feu", "fire", "flamme", "chaud", "hot"],
            "🌪️": ["tornade", "tornado", "cyclone"],
            "🌈": ["arc-en-ciel", "rainbow", "couleurs"],
            "☀️": ["soleil", "sun", "sunny", "beau"],
            "🌤️": ["nuageux", "partly", "sunny"],
            "⛅": ["nuageux", "partly", "cloudy"],
            "🌥️": ["nuageux", "cloudy", "couvert"],
            "☁️": ["nuage", "cloud", "nuageux"],
            "🌦️": ["pluie", "rain", "soleil"],
            "🌧️": ["pluie", "rain", "cloud"],
            "⛈️": ["orage", "thunder", "storm"],
            "🌩️": ["éclair", "lightning", "orage"],
            "🌨️": ["neige", "snow", "cloud"],
            "❄️": ["flocon", "snowflake", "neige", "froid"],
            "☃️": ["bonhomme", "snowman", "neige"],
            "⛄": ["bonhomme", "snowman", "neige"],
            "🌬️": ["vent", "wind", "souffle"],
            "💨": ["vent", "dash", "rapide", "souffle"],
            "💧": ["goutte", "drop", "eau", "water"],
            "💦": ["éclaboussure", "splash", "eau", "sueur"],
            "☔": ["parapluie", "umbrella", "pluie"],
            "☂️": ["parapluie", "umbrella"],
            "🌊": ["vague", "wave", "ocean", "mer"],
            "🌫️": ["brouillard", "fog", "brume"],
            
            // Nourriture
            "🍏": ["pomme", "apple", "verte", "green"],
            "🍎": ["pomme", "apple", "rouge", "red"],
            "🍐": ["poire", "pear", "fruit"],
            "🍊": ["orange", "mandarine", "fruit"],
            "🍋": ["citron", "lemon", "jaune"],
            "🍌": ["banane", "banana", "fruit"],
            "🍉": ["pastèque", "watermelon", "fruit"],
            "🍇": ["raisin", "grapes", "fruit"],
            "🍓": ["fraise", "strawberry", "fruit"],
            "🍈": ["melon", "fruit"],
            "🍒": ["cerise", "cherry", "fruit"],
            "🍑": ["pêche", "peach", "fruit"],
            "🥭": ["mangue", "mango", "fruit"],
            "🍍": ["ananas", "pineapple", "fruit"],
            "🥥": ["coco", "coconut", "fruit"],
            "🥝": ["kiwi", "fruit"],
            "🍅": ["tomate", "tomato", "légume"],
            "🍆": ["aubergine", "eggplant", "légume"],
            "🥑": ["avocat", "avocado", "légume"],
            "🥦": ["brocoli", "broccoli", "légume"],
            "🥬": ["salade", "leafy", "green", "légume"],
            "🥒": ["concombre", "cucumber", "légume"],
            "🌶️": ["piment", "pepper", "hot", "épicé"],
            "🌽": ["maïs", "corn", "légume"],
            "🥕": ["carotte", "carrot", "légume"],
            "🧄": ["ail", "garlic", "légume"],
            "🧅": ["oignon", "onion", "légume"],
            "🥔": ["pomme", "potato", "terre", "légume"],
            "🍠": ["patate", "sweet", "potato"],
            "🥐": ["croissant", "france", "pain"],
            "🥯": ["bagel", "pain", "bread"],
            "🍞": ["pain", "bread", "boulangerie"],
            "🥖": ["baguette", "france", "pain"],
            "🥨": ["bretzel", "pretzel", "allemagne"],
            "🧀": ["fromage", "cheese", "france"],
            "🥚": ["oeuf", "egg", "breakfast"],
            "🍳": ["oeuf", "cooking", "poêle"],
            "🧈": ["beurre", "butter"],
            "🥞": ["pancake", "crêpe", "breakfast"],
            "🧇": ["gaufre", "waffle", "breakfast"],
            "🥓": ["bacon", "viande", "breakfast"],
            "🥩": ["steak", "viande", "meat"],
            "🍗": ["poulet", "chicken", "viande"],
            "🍖": ["viande", "meat", "os"],
            "🌭": ["hotdog", "saucisse", "sandwich"],
            "🍔": ["burger", "hamburger", "sandwich"],
            "🍟": ["frites", "fries", "pommes"],
            "🍕": ["pizza", "italie", "italy"],
            "🥪": ["sandwich", "pain", "lunch"],
            "🥙": ["kebab", "pita", "sandwich"],
            "🌮": ["taco", "mexique", "mexico"],
            "🌯": ["burrito", "mexique", "wrap"],
            "🥗": ["salade", "salad", "légumes"],
            "🥘": ["paella", "plat", "cuisine"],
            "🍝": ["pâtes", "spaghetti", "pasta"],
            "🍜": ["ramen", "nouilles", "soupe"],
            "🍲": ["pot", "soupe", "ragoût"],
            "🍛": ["curry", "riz", "rice"],
            "🍣": ["sushi", "japon", "poisson"],
            "🍱": ["bento", "japon", "lunch"],
            "🍤": ["crevette", "tempura", "frit"],
            "🍙": ["onigiri", "riz", "japon"],
            "🍚": ["riz", "rice", "bol"],
            "🍘": ["senbei", "crackers", "japon"],
            "🍥": ["naruto", "poisson", "japon"],
            "🍡": ["dango", "brochette", "japon"],
            "🍧": ["glace", "shaved", "ice"],
            "🍨": ["glace", "ice", "cream"],
            "🍦": ["glace", "soft", "ice"],
            "🥧": ["tarte", "pie", "dessert"],
            "🧁": ["cupcake", "gâteau", "dessert"],
            "🍰": ["gâteau", "cake", "part"],
            "🎂": ["anniversaire", "birthday", "gâteau"],
            "🍮": ["flan", "pudding", "dessert"],
            "🍭": ["sucette", "lollipop", "bonbon"],
            "🍬": ["bonbon", "candy", "sweet"],
            "🍫": ["chocolat", "chocolate", "barre"],
            "🍿": ["popcorn", "maïs", "cinéma"],
            "🍩": ["donut", "beignet", "dessert"],
            "🍪": ["cookie", "biscuit", "dessert"],
            "🥜": ["cacahuète", "peanut", "noix"],
            "🍯": ["miel", "honey", "pot"],
            "🥛": ["lait", "milk", "verre"],
            "🍼": ["biberon", "baby", "bottle"],
            "☕": ["café", "coffee", "chaud", "hot"],
            "🍵": ["thé", "tea", "chaud", "hot"],
            "🧃": ["jus", "juice", "box"],
            "🥤": ["soda", "boisson", "drink"],
            "🍶": ["saké", "japon", "alcool"],
            "🍺": ["bière", "beer", "alcool"],
            "🍻": ["bières", "beers", "santé", "cheers"],
            "🥂": ["champagne", "toast", "célébration"],
            "🍷": ["vin", "wine", "rouge", "alcool"],
            "🥃": ["whisky", "tumbler", "alcool"],
            "🍸": ["cocktail", "martini", "alcool"],
            "🍹": ["cocktail", "tropical", "drink"],
            "🧉": ["maté", "drink", "amérique"],
            "🍾": ["champagne", "bouteille", "celebration"],
            "🧊": ["glaçon", "ice", "cube", "froid"],
            
            // Activités
            "⚽": ["football", "soccer", "ballon", "sport"],
            "🏀": ["basketball", "basket", "ballon", "sport"],
            "🏈": ["football", "américain", "rugby", "sport"],
            "⚾": ["baseball", "balle", "sport"],
            "🥎": ["softball", "balle", "sport"],
            "🎾": ["tennis", "balle", "raquette", "sport"],
            "🏐": ["volleyball", "volley", "ballon", "sport"],
            "🏉": ["rugby", "ballon", "sport"],
            "🥏": ["frisbee", "disque", "sport"],
            "🎱": ["billard", "8", "pool", "sport"],
            "🏓": ["pingpong", "tennis", "table", "sport"],
            "🏸": ["badminton", "raquette", "sport"],
            "🏒": ["hockey", "crosse", "sport"],
            "🏑": ["hockey", "field", "sport"],
            "🥍": ["lacrosse", "sport"],
            "🏏": ["cricket", "sport"],
            "🥅": ["but", "goal", "football"],
            "⛳": ["golf", "drapeau", "flag", "sport"],
            "🏹": ["arc", "archery", "flèche", "sport"],
            "🎣": ["pêche", "fishing", "canne", "sport"],
            "🤿": ["plongée", "diving", "masque"],
            "🥊": ["boxe", "boxing", "gant", "sport"],
            "🥋": ["karaté", "judo", "arts", "martiaux"],
            "🎽": ["course", "running", "shirt", "sport"],
            "🛹": ["skateboard", "skate", "planche"],
            "🛷": ["luge", "sled", "neige"],
            "⛸️": ["patin", "ice", "skate", "glace"],
            "🥌": ["curling", "pierre", "sport"],
            "🎿": ["ski", "skis", "neige", "sport"],
            "⛷️": ["skieur", "skier", "neige"],
            "🏂": ["snowboard", "neige", "sport"],
            "🏋️": ["haltérophilie", "weightlifting", "poids"],
            "🤼": ["lutte", "wrestling", "combat"],
            "🤸": ["gymnastique", "cartwheel", "sport"],
            "🤺": ["escrime", "fencing", "épée"],
            "🤾": ["handball", "sport"],
            "🏌️": ["golf", "golfer", "sport"],
            "🏇": ["course", "horse", "racing", "cheval"],
            "🧘": ["yoga", "méditation", "lotus"],
            "🏄": ["surf", "surfing", "vague", "sport"],
            "🏊": ["nage", "swimming", "natation"],
            "🤽": ["waterpolo", "eau", "sport"],
            "🚣": ["aviron", "rowing", "bateau"],
            "🧗": ["escalade", "climbing", "grimper"],
            "🚴": ["vélo", "biking", "cyclisme"],
            "🚵": ["vtt", "mountain", "bike"],
            "🎪": ["cirque", "circus", "chapiteau"],
            "🎭": ["théâtre", "theater", "masques"],
            "🎨": ["art", "palette", "peinture"],
            "🎬": ["cinéma", "clap", "film", "action"],
            "🎤": ["micro", "microphone", "chanter"],
            "🎧": ["casque", "headphone", "musique"],
            "🎼": ["partition", "music", "score"],
            "🎹": ["piano", "clavier", "musique"],
            "🥁": ["batterie", "drum", "musique"],
            "🎷": ["saxophone", "jazz", "musique"],
            "🎺": ["trompette", "trumpet", "musique"],
            "🎸": ["guitare", "guitar", "rock"],
            "🪕": ["banjo", "musique"],
            "🎻": ["violon", "violin", "musique"],
            "🎲": ["dé", "dice", "jeu", "hasard"],
            "♟️": ["échecs", "chess", "pion"],
            "🎯": ["cible", "target", "dart", "objectif"],
            "🎳": ["bowling", "quilles", "sport"],
            "🎮": ["jeux", "gaming", "manette", "vidéo"],
            "🎰": ["casino", "slot", "machine"],
            "🧩": ["puzzle", "pièce", "jeu"],
            
            // Objets & Symboles
            "❤️": ["coeur", "heart", "amour", "love", "rouge"],
            "🧡": ["coeur", "heart", "orange", "amour"],
            "💛": ["coeur", "heart", "jaune", "amour"],
            "💚": ["coeur", "heart", "vert", "amour"],
            "💙": ["coeur", "heart", "bleu", "amour"],
            "💜": ["coeur", "heart", "violet", "amour"],
            "🖤": ["coeur", "heart", "noir", "amour"],
            "🤍": ["coeur", "heart", "blanc", "amour"],
            "🤎": ["coeur", "heart", "marron", "amour"],
            "💔": ["coeur", "broken", "brisé", "triste"],
            "❣️": ["coeur", "exclamation", "amour"],
            "💕": ["coeurs", "hearts", "amour"],
            "💞": ["coeurs", "revolving", "amour"],
            "💓": ["coeur", "beating", "battant"],
            "💗": ["coeur", "growing", "grandir"],
            "💖": ["coeur", "sparkling", "étincelle"],
            "💘": ["coeur", "arrow", "flèche", "cupidon"],
            "💝": ["cadeau", "gift", "coeur", "ruban"],
            "💟": ["coeur", "decoration", "décoration"],
            "☮️": ["paix", "peace", "symbole"],
            "✝️": ["croix", "cross", "chrétien"],
            "☪️": ["islam", "étoile", "croissant"],
            "🕉️": ["om", "hindou", "symbole"],
            "☸️": ["dharma", "roue", "bouddhiste"],
            "✡️": ["étoile", "david", "juif"],
            "🔯": ["étoile", "six", "points"],
            "🕎": ["menorah", "chandelier", "juif"],
            "☯️": ["yin", "yang", "équilibre"],
            "☦️": ["orthodoxe", "croix"],
            "🛐": ["prière", "worship", "lieu"],
            "⚛️": ["atome", "atom", "science"],
            "🆔": ["id", "identification", "badge"],
            "☢️": ["radioactif", "radioactive", "danger"],
            "☣️": ["biohazard", "danger", "biologique"],
            "📴": ["mobile", "off", "éteint"],
            "📳": ["vibreur", "vibration", "mode"],
            "🈶": ["payant", "charged", "japonais"],
            "🈚": ["gratuit", "free", "japonais"],
            "🈸": ["demande", "application", "japonais"],
            "🈺": ["ouvert", "open", "japonais"],
            "🈷️": ["mois", "month", "japonais"],
            "✴️": ["étoile", "huit", "branches"],
            "🆚": ["versus", "vs", "contre"],
            "💮": ["fleur", "blanc", "stamp"],
            "🉐": ["aubaine", "bargain", "japonais"],
            "㊙️": ["secret", "japonais"],
            "㊗️": ["félicitations", "japonais"],
            "🈴": ["réussite", "passing", "japonais"],
            "🈵": ["plein", "full", "japonais"],
            "🈹": ["remise", "discount", "japonais"],
            "🈲": ["interdit", "prohibited", "japonais"],
            "🅰️": ["a", "groupe", "sanguin"],
            "🅱️": ["b", "groupe", "sanguin"],
            "🆎": ["ab", "groupe", "sanguin"],
            "🆑": ["cl", "clear"],
            "🅾️": ["o", "groupe", "sanguin"],
            "🆘": ["sos", "aide", "help", "urgence"],
            "❌": ["croix", "x", "non", "faux"],
            "⭕": ["cercle", "o", "correct"],
            "🛑": ["stop", "arrêt", "panneau"],
            "⛔": ["interdit", "no", "entry"],
            "📛": ["badge", "nom", "name"],
            "🚫": ["interdit", "prohibited", "non"],
            "💯": ["100", "cent", "parfait", "score"],
            "💢": ["colère", "anger", "comic"],
            "♨️": ["source", "hot", "springs", "vapeur"],
            "🚷": ["piétons", "no", "pedestrians"],
            "🚯": ["déchets", "no", "littering"],
            "🚳": ["vélos", "no", "bicycles"],
            "🚱": ["eau", "non", "potable"],
            "🔞": ["18", "interdit", "mineurs"],
            "📵": ["téléphone", "no", "mobile"],
            "🚭": ["fumer", "no", "smoking"],
            "❗": ["exclamation", "important", "rouge"],
            "❕": ["exclamation", "gris"],
            "❓": ["question", "interrogation", "rouge"],
            "❔": ["question", "interrogation", "gris"],
            "‼️": ["double", "exclamation"],
            "⁉️": ["exclamation", "question"],
            "🔅": ["luminosité", "dim", "faible"],
            "🔆": ["luminosité", "bright", "fort"],
            "〽️": ["graphique", "chart", "part"],
            "⚠️": ["attention", "warning", "danger"],
            "🚸": ["enfants", "children", "crossing"],
            "🔱": ["trident", "neptune"],
            "⚜️": ["fleur", "lys", "scout"],
            "🔰": ["débutant", "beginner", "japon"],
            "♻️": ["recyclage", "recycle", "écologie"],
            "✅": ["check", "coché", "validé", "ok"],
            "🈯": ["réservé", "reserved", "japonais"],
            "💹": ["graphique", "chart", "hausse"],
            "❇️": ["étincelle", "sparkle"],
            "✳️": ["astérisque", "huit", "branches"],
            "❎": ["croix", "x", "button"],
            "🌐": ["globe", "méridiens", "world"],
            "💠": ["diamant", "diamond", "points"],
            "Ⓜ️": ["m", "metro", "métro"],
            "🌀": ["cyclone", "spirale", "tourbillon"],
            "💤": ["sommeil", "zzz", "dormir"],
            "🏧": ["atm", "distributeur", "argent"],
            "🚾": ["wc", "toilettes", "restroom"],
            "♿": ["handicapé", "wheelchair", "accessible"],
            "🅿️": ["parking", "p", "stationnement"],
            "🈳": ["vide", "vacancy", "japonais"],
            "🈂️": ["service", "sa", "japonais"],
            "🛂": ["passeport", "control", "douane"],
            "🛃": ["douane", "customs"],
            "🛄": ["bagages", "baggage", "claim"],
            "🛅": ["consigne", "left", "luggage"],
            "🚹": ["homme", "men", "toilettes"],
            "🚺": ["femme", "women", "toilettes"],
            "🚼": ["bébé", "baby", "symbole"],
            "🚻": ["toilettes", "restroom"],
            "🚮": ["poubelle", "litter", "déchets"],
            "🎦": ["cinéma", "cinema"],
            "📶": ["signal", "réseau", "barres"],
            "🈁": ["ici", "here", "japonais"],
            "🔣": ["symboles", "symbols", "input"],
            "ℹ️": ["information", "info", "i"],
            "🔤": ["abc", "lettres", "alphabet"],
            "🔡": ["abcd", "minuscules", "lowercase"],
            "🔠": ["ABCD", "majuscules", "uppercase"],
            "🆖": ["ng", "no", "good"],
            "🆗": ["ok", "okay", "bien"],
            "🆙": ["up", "haut", "niveau"],
            "🆒": ["cool", "bien"],
            "🆕": ["new", "nouveau"],
            "🆓": ["free", "gratuit"],
            "0️⃣": ["0", "zéro", "chiffre"],
            "1️⃣": ["1", "un", "chiffre"],
            "2️⃣": ["2", "deux", "chiffre"],
            "3️⃣": ["3", "trois", "chiffre"],
            "4️⃣": ["4", "quatre", "chiffre"],
            "5️⃣": ["5", "cinq", "chiffre"],
            "6️⃣": ["6", "six", "chiffre"],
            "7️⃣": ["7", "sept", "chiffre"],
            "8️⃣": ["8", "huit", "chiffre"],
            "9️⃣": ["9", "neuf", "chiffre"],
            "🔟": ["10", "dix", "chiffre"],
            "🔢": ["nombres", "numbers", "123"],
            "#️⃣": ["dièse", "hash", "hashtag"],
            "*️⃣": ["astérisque", "asterisk", "étoile"],
            "⏏️": ["eject", "éjecter"],
            "▶️": ["play", "lecture", "jouer"],
            "⏸️": ["pause"],
            "⏯️": ["play", "pause"],
            "⏹️": ["stop", "arrêt"],
            "⏺️": ["record", "enregistrer"],
            "⏭️": ["next", "suivant"],
            "⏮️": ["previous", "précédent"],
            "⏩": ["avance", "fast", "forward"],
            "⏪": ["retour", "rewind"],
            "⏫": ["haut", "up", "rapide"],
            "⏬": ["bas", "down", "rapide"],
            "◀️": ["gauche", "left", "triangle"],
            "🔼": ["haut", "up", "triangle"],
            "🔽": ["bas", "down", "triangle"],
            "➡️": ["droite", "right", "flèche"],
            "⬅️": ["gauche", "left", "flèche"],
            "⬆️": ["haut", "up", "flèche"],
            "⬇️": ["bas", "down", "flèche"],
            "↗️": ["nord-est", "northeast"],
            "↘️": ["sud-est", "southeast"],
            "↙️": ["sud-ouest", "southwest"],
            "↖️": ["nord-ouest", "northwest"],
            "↕️": ["haut", "bas", "vertical"],
            "↔️": ["gauche", "droite", "horizontal"],
            "↪️": ["retour", "return", "flèche"],
            "↩️": ["retour", "return", "gauche"],
            "⤴️": ["courbe", "haut", "flèche"],
            "⤵️": ["courbe", "bas", "flèche"],
            "🔀": ["aléatoire", "shuffle", "random"],
            "🔁": ["répéter", "repeat", "boucle"],
            "🔂": ["répéter", "repeat", "one"],
            "🔄": ["rafraîchir", "refresh", "sync"],
            "🔃": ["recharger", "reload", "vertical"]
        ]
    }
}