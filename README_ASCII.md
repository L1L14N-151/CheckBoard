# CheckBoard

> ## IMPORTANT: First Launch Instructions
> **If the app crashes at startup, it's because it isn't signed.** Since I don't have an Apple developer account, it requires a very simple workaround:
>
> 1. Go to **System Settings** -> scroll down to **Privacy & Security**
> 2. Find the **Security** section at the bottom
> 3. Click **"Open Anyway"** for the app
> 4. Confirm again by clicking **"Open"** in the popup
>
> After this, the app should launch normally every time.

A beautiful and intuitive morning routine tracker for macOS, designed to help you build and maintain healthy habits.

![macOS](https://img.shields.io/badge/macOS-11.0%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.0-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0-purple)
![License](https://img.shields.io/badge/license-MIT-green)

**[✓] Tested on macOS Sequoia with Mac M3**

## Screenshots

> ### [View full version with animations and screenshots on GitHub](https://github.com/L1L14N-151/CheckBoard)

- Beautiful skeuomorphic clipboard design with your daily tasks
- Smooth animations and real-time progress tracking
- Confetti celebration when all tasks are completed!

## Features

### Task Management
- **Default Morning Routine**: Start with 7 pre-configured healthy habits
- **Customizable Tasks**: Add, edit, delete, and reorder tasks to match your routine
- **Emoji Support**: Personalize each task with fun emojis
- **Progress Tracking**: Visual progress bar shows completion percentage
- **Drag & Drop**: Easily reorganize tasks to match your workflow

- Easy task customization with emoji picker and drag & drop reordering

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

- Dynamic dock icon shows your progress at a glance

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

- Settings panel for customizing your routine and preferences

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