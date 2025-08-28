# CheckBoard 📋

A beautiful and intuitive morning routine tracker for macOS, designed to help you build and maintain healthy habits.

![macOS](https://img.shields.io/badge/macOS-11.0%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.0-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0-purple)
![License](https://img.shields.io/badge/license-MIT-green)

## ✨ Features

### 🎯 Task Management
- **Default Morning Routine**: Start with 7 pre-configured healthy habits
- **Customizable Tasks**: Add, edit, delete, and reorder tasks to match your routine
- **Emoji Support**: Personalize each task with fun emojis
- **Progress Tracking**: Visual progress bar shows completion percentage
- **Drag & Drop**: Easily reorganize tasks to match your workflow

### 🎨 Beautiful Design
- **Skeuomorphic Clipboard**: Realistic clipboard design with paper and metal clip
- **Smooth Animations**: Spring animations for all interactions
- **Celebration Effects**: Green confetti animation when all tasks are completed
- **Sound Effects**: Material Design sounds for check/uncheck actions

### 🌐 Internationalization
- **Multi-language Support**: Available in English and French
- **Dynamic Language Switching**: Change language on the fly without restart
- **System Date Format**: Uses your Mac's date format settings

### 🔄 Auto-Reset
- **Daily Reset**: Tasks automatically reset at configurable time (default 6:00 AM)
- **Smart Detection**: Checks every 30 seconds to ensure timely reset
- **Persistent State**: Remembers last reset to avoid duplicates

### 📱 Dock Integration
- **Dynamic Icon Badge**: Shows completion status directly in the Dock
  - ✅ Green checkmark when all tasks complete
  - 🟠 Orange dots when tasks remain
- **Visual Feedback**: Icon updates in real-time as you complete tasks

## 📦 Installation

### Download Pre-built DMG
1. Download the latest `CheckBoard.dmg` from [Releases](https://github.com/yourusername/CheckBoard/releases)
2. Double-click the DMG file
3. Drag CheckBoard to your Applications folder
4. Launch CheckBoard from Applications or Launchpad

### Build from Source
```bash
# Clone the repository
git clone https://github.com/yourusername/CheckBoard.git
cd CheckBoard

# Build with Xcode
xcodebuild -project CheckBoard.xcodeproj -scheme CheckBoard -configuration Release

# Or use the compile script
chmod +x compile.sh
./compile.sh

# Create DMG for distribution
chmod +x create_dmg.sh
./create_dmg.sh
```

## 🚀 Usage

1. **Launch the App**: Open CheckBoard from your Applications folder
2. **Complete Tasks**: Click checkboxes as you complete your morning routine
3. **Customize Tasks**: Click the settings gear to:
   - Add new tasks
   - Edit existing tasks
   - Change task emojis
   - Reorder tasks
   - Set reset time
4. **Track Progress**: Watch the progress bar fill as you complete tasks
5. **Celebrate**: Enjoy the confetti animation when you complete everything!

## Technologies Used 🛠️

- **SwiftUI** - Modern UI framework
- **AppKit** - macOS integration
- **UserDefaults** - Local data persistence

## Contributing 🤝

Feel free to contribute to CheckBoard! Here's how:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments 🙏

- Built with ❤️ using SwiftUI
- Inspired by the importance of morning routines
- Part of the Hack Club community

---

Made with 🤖 [Claude Code](https://claude.ai/code)