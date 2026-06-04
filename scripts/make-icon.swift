#!/usr/bin/env swift
import AppKit

// Tmux Cheatsheet app icon — deliberately distinct from mac-tmux-kit's icon
// (which is parallel green "thread" bars). Same dark squircle family, but a
// keycap with a bold amber "?" — tmux's `prefix ?` lists all key bindings, i.e.
// the cheatsheet itself. Amber accent (vs the main app's green) for at-a-glance
// differentiation.

func color(_ r: Int, _ g: Int, _ b: Int, _ a: CGFloat = 1) -> NSColor {
    NSColor(srgbRed: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: a)
}

let bgTop = color(0x21, 0x29, 0x38)
let bgBottom = color(0x0C, 0x10, 0x16)
let keyFaceTop = color(0xF2, 0xF5, 0xFA)
let keyFaceBottom = color(0xC9, 0xD1, 0xDD)
let keyShadow = color(0x1A, 0x1E, 0x26)
let accent = color(0xFF, 0xB3, 0x40)   // amber "?"

func render(_ px: Int) -> Data {
    let s = CGFloat(px)
    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil, pixelsWide: px, pixelsHigh: px,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true,
        isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0
    )!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    defer { NSGraphicsContext.restoreGraphicsState() }

    // Background squircle.
    let inset = s * 0.0977
    let rect = CGRect(x: inset, y: inset, width: s - 2 * inset, height: s - 2 * inset)
    let radius = rect.width * 0.2245
    let bg = NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
    NSGradient(colors: [bgBottom, bgTop])?.draw(in: bg, angle: 90)
    bg.lineWidth = max(1, s * 0.004)
    color(255, 255, 255, 0.06).setStroke()
    bg.stroke()

    // Keycap (with a little depth: a darker base behind, face raised on top).
    let keySize = rect.width * 0.50
    let keyX = rect.midX - keySize / 2
    let keyY = rect.midY - keySize / 2
    let depth = keySize * 0.10
    let keyRadius = keySize * 0.20

    let base = NSBezierPath(
        roundedRect: CGRect(x: keyX, y: keyY - depth, width: keySize, height: keySize),
        xRadius: keyRadius, yRadius: keyRadius
    )
    keyShadow.setFill()
    base.fill()

    let faceRect = CGRect(x: keyX, y: keyY, width: keySize, height: keySize)
    let face = NSBezierPath(roundedRect: faceRect, xRadius: keyRadius, yRadius: keyRadius)
    NSGradient(colors: [keyFaceBottom, keyFaceTop])?.draw(in: face, angle: 90)

    // Bold amber "?" centered on the face.
    let glyph = "?" as NSString
    let fontSize = keySize * 0.62
    let attrs: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: fontSize, weight: .heavy),
        .foregroundColor: accent,
    ]
    let gsz = glyph.size(withAttributes: attrs)
    glyph.draw(
        at: NSPoint(x: faceRect.midX - gsz.width / 2, y: faceRect.midY - gsz.height / 2),
        withAttributes: attrs
    )

    return rep.representation(using: .png, properties: [:])!
}

let fm = FileManager.default
let root = URL(fileURLWithPath: fm.currentDirectoryPath)
let setDir = root.appendingPathComponent("Resources/Assets.xcassets/AppIcon.appiconset")
try? fm.createDirectory(at: setDir, withIntermediateDirectories: true)

for px in [16, 32, 64, 128, 256, 512, 1024] {
    try! render(px).write(to: setDir.appendingPathComponent("icon_\(px).png"))
}

let contents = """
{
  "images" : [
    {"idiom":"mac","scale":"1x","size":"16x16","filename":"icon_16.png"},
    {"idiom":"mac","scale":"2x","size":"16x16","filename":"icon_32.png"},
    {"idiom":"mac","scale":"1x","size":"32x32","filename":"icon_32.png"},
    {"idiom":"mac","scale":"2x","size":"32x32","filename":"icon_64.png"},
    {"idiom":"mac","scale":"1x","size":"128x128","filename":"icon_128.png"},
    {"idiom":"mac","scale":"2x","size":"128x128","filename":"icon_256.png"},
    {"idiom":"mac","scale":"1x","size":"256x256","filename":"icon_256.png"},
    {"idiom":"mac","scale":"2x","size":"256x256","filename":"icon_512.png"},
    {"idiom":"mac","scale":"1x","size":"512x512","filename":"icon_512.png"},
    {"idiom":"mac","scale":"2x","size":"512x512","filename":"icon_1024.png"}
  ],
  "info" : {"author":"xcode","version":1}
}
"""
try! contents.write(to: setDir.appendingPathComponent("Contents.json"), atomically: true, encoding: .utf8)
print("Cheatsheet icon written to \(setDir.path)")
