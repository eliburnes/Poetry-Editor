//
//  AppDelegate.swift
//  Poetry Editor
//
//  Created by Eli Burnes on 2/24/24.
//

import Cocoa
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        
        let rootVc = ViewController()
        
        let windowRect = NSRect(x: 0, y: 0, width: 1000, height: 800)
        
        window = NSWindow(
            contentRect: windowRect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.contentViewController = rootVc

        window.setFrame(windowRect, display: true)
        window?.center() // Center the window on the screen
       window.makeKeyAndOrderFront(nil)
       
       // Optionally, if you want to set a title for the window
       window.title = "Poetry Editor"
        
       addEditMenu()
    }
    private func addEditMenu(){
        let mainMenu = NSApplication.shared.mainMenu ?? NSMenu()
        
        // Create the Edit menu
        let editMenu = NSMenu(title: "Edit")
        let editMenuItem = NSMenuItem(title: "Edit", action: nil, keyEquivalent: "")
        editMenuItem.submenu = editMenu
        
        // Add Copy
        let copyMenuItem = NSMenuItem(title: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
        editMenu.addItem(copyMenuItem)
        
        // Add Paste
        let pasteMenuItem = NSMenuItem(title: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
        editMenu.addItem(pasteMenuItem)
        
        // Add other menu items as needed...
        
        // Insert the Edit menu into the main menu
        mainMenu.addItem(editMenuItem)
        
        NSApplication.shared.mainMenu = mainMenu

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

