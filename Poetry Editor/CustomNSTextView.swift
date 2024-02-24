//
//  CustomNSTextView.swift
//  Poetry Editor
//
//  Created by Eli Burnes on 2/24/24.
//

import Foundation
import AppKit

class CustomNSTextView: NSTextView
{
    /// Holds the attached line number gutter.
    private var lineNumberGutter: LineNumberGutter?
    
    override func paste(_ sender: Any?) {
        // Call super to perform the default paste operation
        super.paste(sender)
        
        // Optionally, add any custom behavior after the paste operation
        // For example, logging, additional text processing, etc.
        print("Pasted text into CustomTextView")
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        // Make this text view the first responder when clicked
        self.window?.makeFirstResponder(self)
    }
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return window?.makeFirstResponder(self) ?? false
    }
    
    public func setUpLineNumbers(){
        guard let scrollView = self.enclosingScrollView else {
            fatalError("Unwrapping the text views scroll view failed!")
        }
        
        let gutterForegroundColor: NSColor = NSColor.black
        let gutterBackgroundColor: NSColor = NSColor.lightGray
        
        self.lineNumberGutter = LineNumberGutter(withTextView: self, foregroundColor: gutterForegroundColor, backgroundColor: gutterBackgroundColor)
        
        scrollView.verticalRulerView  = self.lineNumberGutter
        scrollView.hasHorizontalRuler = false
        scrollView.hasVerticalRuler   = true
        scrollView.rulersVisible      = true
                
        self.addObservers()
    }
    
    /// Add observers to redraw the line number gutter, when necessary.
    internal func addObservers() {
        self.postsFrameChangedNotifications = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.drawGutter), name: NSView.frameDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.drawGutter), name: NSText.didChangeNotification, object: self)
    }
    /// Set needsDisplay of lineNumberGutter to true.
       @objc internal func drawGutter() {
           if let lineNumberGutter = self.lineNumberGutter {
               lineNumberGutter.needsDisplay = true
           }
       }
    
}
