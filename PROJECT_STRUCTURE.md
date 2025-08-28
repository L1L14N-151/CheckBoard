# 📁 CheckBoard Project Structure

```
CheckBoard/
│
├── 📱 CheckBoard/                      # Source code
│   ├── CheckBoardApp.swift            # Main app entry point
│   ├── DockIconManager.swift          # Dock icon badge management
│   ├── LanguageManager.swift          # i18n support (EN/FR)
│   ├── CheckBoard.entitlements        # App permissions
│   │
│   ├── 📂 Models/
│   │   └── RoutineTask.swift          # Task model & RoutineManager
│   │
│   ├── 🎨 Views/
│   │   ├── ClipboardView.swift        # Main clipboard UI
│   │   ├── SettingsViewSimple.swift   # Settings modal
│   │   ├── EditTaskPopup.swift        # Task editing UI
│   │   └── EmojiPickerView.swift      # Emoji selector
│   │
│   ├── 🔊 Sounds/
│   │   ├── check.caf                  # Check sound effect
│   │   ├── uncheck.caf                # Uncheck sound effect
│   │   └── celebration.caf            # 100% completion sound
│   │
│   ├── 🎨 Assets.xcassets/
│   │   └── AppIcon.appiconset/        # App icon assets
│   │
│   └── 📦 Preview Content/
│       └── Preview Assets.xcassets/   # SwiftUI preview assets
│
├── 🛠️ CheckBoard.xcodeproj/           # Xcode project file
│   └── project.pbxproj                # Project configuration
│
├── 📚 Docs/                            # Documentation
│   └── RELEASE_NOTES.md               # Release notes for v1.0.0
│
├── 🎁 Resources/                       # Additional resources
│   └── CheckBoard.icns                # macOS app icon
│
├── 📜 Scripts/
│   └── compile.sh                     # Build script
│
├── 📝 Documentation/
│   ├── README.md                      # Main project documentation
│   ├── LICENSE                        # MIT License
│   └── PROJECT_STRUCTURE.md           # This file
│
└── ⚙️ Configuration/
    └── .gitignore                     # Git ignore rules

```

## 🔑 Key Components

### Core Application (`CheckBoard/`)
- **SwiftUI-based** macOS app
- **MVVM architecture** with ObservableObject
- **UserDefaults** for persistence
- **Localization** support (EN/FR)

### Build (`Scripts/`)
- `compile.sh`: Quick build without Xcode

### Resources (`Resources/`)
- Original icon file (`.icns`)

### Documentation (`Docs/`)
- Release notes and changelog

## 🚀 Quick Commands

```bash
# Build the app
./Scripts/compile.sh

# Run the app
open CheckBoard.app

# Clean build artifacts
rm -rf build/ *.app
```

## 📦 Distribution

The app is distributed as:
1. **DMG file** - For end users
2. **Source code** - On GitHub
3. **Release binaries** - GitHub Releases

## 🎯 Target Platform

- **macOS 11.0+** (Big Sur and later)
- **Architecture**: Universal (Intel + Apple Silicon)
- **Size**: ~10 MB installed