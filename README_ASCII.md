# CheckBoard

A beautiful and intuitive morning routine tracker for macOS, designed to help you build and maintain healthy habits.

![macOS](https://img.shields.io/badge/macOS-11.0%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.0-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0-purple)
![License](https://img.shields.io/badge/license-MIT-green)

## Screenshots

<div align="center">
  <img src="https://github.com/L1L14N-151/CheckBoard/blob/main/screenshots/Capture%20d'ecran%20globale.png" alt="CheckBoard Main Interface" width="180">
  <p><em>Beautiful skeuomorphic clipboard design with your daily tasks</em></p>
</div>

<div align="center">
  <img src="https://github.com/L1L14N-151/CheckBoard/blob/main/screenshots/cocher%20les%20cases.gif" alt="Progress Animation" width="180">
  <p><em>Smooth animations and real-time progress tracking</em></p>
</div>

<div align="center">
  <img src="https://github.com/L1L14N-151/CheckBoard/blob/main/screenshots/Celebration.gif" alt="Celebration Effect" width="180">
  <p><em>Confetti celebration when all tasks are completed!</em></p>
</div>

## Features

### Task Management
- **Default Morning Routine**: Start with 7 pre-configured healthy habits
- **Customizable Tasks**: Add, edit, delete, and reorder tasks to match your routine
- **Emoji Support**: Personalize each task with fun emojis
- **Progress Tracking**: Visual progress bar shows completion percentage
- **Drag & Drop**: Easily reorganize tasks to match your workflow

<div align="center">
  <img src="https://github.com/L1L14N-151/CheckBoard/blob/main/screenshots/Presentations%20des%20taches%20.gif" alt="Task Management Features" width="200">
  <p><em>Easy task customization with emoji picker and drag & drop reordering</em></p>
</div>

### Beautiful Design
- **Skeuomorphic Clipboard**: Realistic clipboard design with paper and metal clip
- **Smooth Animations**: Spring animations for all interactions
- **Celebration Effects**: Green confetti animation when all tasks are completed
- **Sound Effects**: Material Design sounds for check/uncheck actions

### Internationalization
- **Multi-language Support**: Available in English and French
- **Dynamic Language Switching**: Change language on the fly without restart
- **System Date Format**: Uses your Mac's date format settings

### Auto-Reset
- **Daily Reset**: Tasks automatically reset at configurable time (default 6:00 AM)
- **Smart Detection**: Checks every 30 seconds to ensure timely reset
- **Persistent State**: Remembers last reset to avoid duplicates

### Dock Integration
- **Dynamic Icon Badge**: Shows completion status directly in the Dock
  - [✓] Green checkmark when all tasks complete
  - [●] Orange dots when tasks remain
- **Visual Feedback**: Icon updates in real-time as you complete tasks

<div align="center">
  <img src="https://github.com/L1L14N-151/CheckBoard/blob/main/screenshots/changement%20dans%20le%20dock.gif" alt="Dock Integration" width="150">
  <p><em>Dynamic dock icon shows your progress at a glance</em></p>
</div>

## Installation

### Build from Source
```bash
# Clone the repository
git clone https://github.com/L1L14N-151/CheckBoard.git
cd CheckBoard

# Build with Xcode
xcodebuild -project CheckBoard.xcodeproj -scheme CheckBoard -configuration Release

# Or use the compile script
chmod +x Scripts/compile.sh
./Scripts/compile.sh
```

## Usage

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

### Quick Start Guide

<div align="center">
  <img src="https://github.com/L1L14N-151/CheckBoard/blob/main/screenshots/Presentation%20parametres.gif" alt="Settings Panel" width="180">
  <p><em>Settings panel for customizing your routine and preferences</em></p>
</div>

## Technologies Used

- **SwiftUI** - Modern UI framework
- **AppKit** - macOS integration
- **UserDefaults** - Local data persistence

## Contributing

Feel free to contribute to CheckBoard! Here's how:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with love using SwiftUI
- Inspired by the importance of morning routines
- Part of the Hack Club community

---

Made with [Claude Code](https://claude.ai/code)