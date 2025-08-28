import AppKit
import SwiftUI

class DockIconManager {
    static let shared = DockIconManager()
    
    private var baseIcon: NSImage?
    
    private init() {}
    
    func loadIcon() {
        // Try to load CheckBoard.icns from bundle resources first
        if let icnsURL = Bundle.main.url(forResource: "CheckBoard", withExtension: "icns"),
           let icnsImage = NSImage(contentsOf: icnsURL) {
            baseIcon = icnsImage
            print("✅ CheckBoard.icns chargée depuis le bundle")
        } else if let bundleIcon = NSImage(named: "CheckBoard") {
            baseIcon = bundleIcon
            print("✅ Icône CheckBoard du bundle chargée")
        } else if let bundleIcon = NSImage(named: "AppIcon") {
            baseIcon = bundleIcon
            print("✅ AppIcon du bundle chargée")
        } else if let appIcon = NSApp.applicationIconImage {
            // Use the app's icon
            baseIcon = appIcon
            print("✅ Icône de l'app chargée")
        } else {
            print("⚠️ Icône non trouvée, création par défaut")
            // Créer une icône par défaut simple
            baseIcon = createDefaultIcon()
        }
    }
    
    private func createDefaultIcon() -> NSImage {
        let size = NSSize(width: 512, height: 512)
        let icon = NSImage(size: size)
        
        icon.lockFocus()
        
        // Fond transparent
        NSColor.clear.setFill()
        NSRect(origin: .zero, size: size).fill()
        
        // Dimensions du clipboard
        let clipboardWidth: CGFloat = 360
        let clipboardHeight: CGFloat = 440
        let clipboardX = (size.width - clipboardWidth) / 2
        let clipboardY = (size.height - clipboardHeight) / 2 - 20
        
        // Dessiner l'ombre du clipboard
        let shadow = NSShadow()
        shadow.shadowOffset = NSSize(width: 0, height: -8)
        shadow.shadowBlurRadius = 12
        shadow.shadowColor = NSColor.black.withAlphaComponent(0.3)
        
        // Corps principal du clipboard (marron)
        let clipboardRect = NSRect(x: clipboardX, y: clipboardY, width: clipboardWidth, height: clipboardHeight)
        let clipboardPath = NSBezierPath(roundedRect: clipboardRect, xRadius: 20, yRadius: 20)
        
        NSGraphicsContext.current?.saveGraphicsState()
        shadow.set()
        NSColor(red: 0.55, green: 0.4, blue: 0.3, alpha: 1.0).setFill()
        clipboardPath.fill()
        NSGraphicsContext.current?.restoreGraphicsState()
        
        // Bordure du clipboard
        NSColor(red: 0.45, green: 0.32, blue: 0.25, alpha: 1.0).setStroke()
        clipboardPath.lineWidth = 3
        clipboardPath.stroke()
        
        // Clip métallique en haut
        let clipWidth: CGFloat = 120
        let clipHeight: CGFloat = 100
        let clipX = (size.width - clipWidth) / 2
        let clipY = clipboardY + clipboardHeight - 60
        
        // Partie métallique du clip
        let clipRect = NSRect(x: clipX, y: clipY, width: clipWidth, height: clipHeight)
        let clipPath = NSBezierPath(roundedRect: clipRect, xRadius: 15, yRadius: 15)
        
        // Gradient métallique pour le clip
        let gradient = NSGradient(colors: [
            NSColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0),
            NSColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1.0),
            NSColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        ])
        gradient?.draw(in: clipPath, angle: -90)
        
        // Bordure du clip
        NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).setStroke()
        clipPath.lineWidth = 2
        clipPath.stroke()
        
        // Trou du clip
        let holeRadius: CGFloat = 12
        let holeRect = NSRect(x: clipX + clipWidth/2 - holeRadius, 
                              y: clipY + clipHeight - 35, 
                              width: holeRadius * 2, 
                              height: holeRadius * 2)
        let holePath = NSBezierPath(ovalIn: holeRect)
        NSColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.5).setFill()
        holePath.fill()
        
        // Papier sur le clipboard
        let paperWidth: CGFloat = 300
        let paperHeight: CGFloat = 340
        let paperX = (size.width - paperWidth) / 2
        let paperY = clipboardY + 30
        
        // Ombre du papier
        let paperShadow = NSShadow()
        paperShadow.shadowOffset = NSSize(width: 0, height: -2)
        paperShadow.shadowBlurRadius = 4
        paperShadow.shadowColor = NSColor.black.withAlphaComponent(0.15)
        
        let paperRect = NSRect(x: paperX, y: paperY, width: paperWidth, height: paperHeight)
        let paperPath = NSBezierPath(roundedRect: paperRect, xRadius: 5, yRadius: 5)
        
        NSGraphicsContext.current?.saveGraphicsState()
        paperShadow.set()
        NSColor.white.setFill()
        paperPath.fill()
        NSGraphicsContext.current?.restoreGraphicsState()
        
        // Lignes sur le papier
        NSColor(red: 0.9, green: 0.9, blue: 0.92, alpha: 1.0).setStroke()
        let lineSpacing: CGFloat = 30
        let lineStartX = paperX + 20
        let lineEndX = paperX + paperWidth - 20
        
        for i in 1...8 {
            let lineY = paperY + paperHeight - CGFloat(i) * lineSpacing - 10
            let linePath = NSBezierPath()
            linePath.lineWidth = 1
            linePath.move(to: NSPoint(x: lineStartX, y: lineY))
            linePath.line(to: NSPoint(x: lineEndX, y: lineY))
            linePath.stroke()
        }
        
        // Checkboxes sur le papier (pour représenter les tâches)
        NSColor(red: 0.3, green: 0.3, blue: 0.35, alpha: 1.0).setStroke()
        for i in 1...3 {
            let checkY = paperY + paperHeight - CGFloat(i) * lineSpacing - 18
            let checkRect = NSRect(x: lineStartX, y: checkY, width: 16, height: 16)
            let checkPath = NSBezierPath(roundedRect: checkRect, xRadius: 2, yRadius: 2)
            checkPath.lineWidth = 1.5
            checkPath.stroke()
            
            // Ajouter un check dans la première case
            if i == 1 {
                NSColor(red: 0.2, green: 0.7, blue: 0.3, alpha: 1.0).setStroke()
                let checkMark = NSBezierPath()
                checkMark.lineWidth = 2
                checkMark.lineCapStyle = .round
                checkMark.move(to: NSPoint(x: checkRect.minX + 3, y: checkRect.midY))
                checkMark.line(to: NSPoint(x: checkRect.minX + 6, y: checkRect.minY + 3))
                checkMark.line(to: NSPoint(x: checkRect.maxX - 2, y: checkRect.maxY - 3))
                checkMark.stroke()
            }
        }
        
        icon.unlockFocus()
        
        return icon
    }
    
    func updateDockIcon(allTasksCompleted: Bool) {
        // Version simplifiée qui fonctionne après que l'app soit chargée
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.performIconUpdate(allTasksCompleted: allTasksCompleted)
        }
    }
    
    private func performIconUpdate(allTasksCompleted: Bool) {
        // Si l'icône n'est pas encore chargée, la charger
        if baseIcon == nil {
            loadIcon()
        }
        
        guard let baseIcon = baseIcon else {
            print("❌ Impossible de charger l'icône")
            return
        }
        
        // Créer une copie de l'icône pour la modifier
        let iconSize = NSSize(width: 512, height: 512)
        let modifiedIcon = NSImage(size: iconSize)
        
        modifiedIcon.lockFocus()
        
        // Dessiner l'icône de base
        baseIcon.draw(in: NSRect(origin: .zero, size: iconSize))
        
        // Ajouter un badge plus proche du centre
        let badgeSize: CGFloat = 160
        let badgeOrigin = NSPoint(x: iconSize.width - badgeSize - 80, y: 80)
        
        if allTasksCompleted {
            // Dessiner un tick vert
            drawCheckmark(at: badgeOrigin, size: badgeSize)
        } else {
            // Dessiner une croix rouge
            drawCross(at: badgeOrigin, size: badgeSize)
        }
        
        modifiedIcon.unlockFocus()
        
        // Appliquer l'icône modifiée au Dock (seulement si l'app est initialisée)
        if let app = NSApplication.shared.delegate {
            NSApplication.shared.applicationIconImage = modifiedIcon
            print("🎨 Icône du Dock mise à jour: \(allTasksCompleted ? "✅" : "❌")")
        }
    }
    
    private func drawCheckmark(at origin: NSPoint, size: CGFloat) {
        // Cercle vert OPAQUE de fond
        let circlePath = NSBezierPath(ovalIn: NSRect(x: origin.x, y: origin.y, width: size, height: size))
        NSColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1.0).setFill() // Opaque
        circlePath.fill()
        
        // Bordure blanche opaque
        NSColor.white.setStroke()
        circlePath.lineWidth = 6
        circlePath.stroke()
        
        // Dessiner le checkmark
        let checkPath = NSBezierPath()
        checkPath.lineWidth = 12
        checkPath.lineCapStyle = .round
        checkPath.lineJoinStyle = .round
        
        let padding: CGFloat = size * 0.25
        let checkOrigin = NSPoint(x: origin.x + padding, y: origin.y + padding)
        let checkSize = size - (padding * 2)
        
        checkPath.move(to: NSPoint(x: checkOrigin.x, y: checkOrigin.y + checkSize * 0.45))
        checkPath.line(to: NSPoint(x: checkOrigin.x + checkSize * 0.35, y: checkOrigin.y + checkSize * 0.15))
        checkPath.line(to: NSPoint(x: checkOrigin.x + checkSize * 0.8, y: checkOrigin.y + checkSize * 0.7))
        
        NSColor.white.setStroke()
        checkPath.stroke()
    }
    
    private func drawCross(at origin: NSPoint, size: CGFloat) {
        // Cercle orange/jaune OPAQUE de fond
        let circlePath = NSBezierPath(ovalIn: NSRect(x: origin.x, y: origin.y, width: size, height: size))
        NSColor(red: 1.0, green: 0.65, blue: 0.1, alpha: 1.0).setFill() // Opaque avec alpha 1.0
        circlePath.fill()
        
        // Bordure blanche opaque
        NSColor.white.setStroke()
        circlePath.lineWidth = 6
        circlePath.stroke()
        
        // Dessiner trois points mieux centrés
        let dotSize: CGFloat = size * 0.12
        let centerY = origin.y + size / 2 - dotSize / 2
        let totalWidth = dotSize * 3 + size * 0.15 * 2  // 3 points + 2 espaces
        let startX = origin.x + size / 2 - totalWidth / 2
        let spacing = size * 0.15
        
        NSColor.white.setFill()
        
        // Point gauche
        NSBezierPath(ovalIn: NSRect(x: startX, y: centerY, width: dotSize, height: dotSize)).fill()
        
        // Point centre
        NSBezierPath(ovalIn: NSRect(x: startX + dotSize + spacing, y: centerY, width: dotSize, height: dotSize)).fill()
        
        // Point droit
        NSBezierPath(ovalIn: NSRect(x: startX + (dotSize + spacing) * 2, y: centerY, width: dotSize, height: dotSize)).fill()
    }
}