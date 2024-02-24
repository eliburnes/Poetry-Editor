//
//  ScrollableTextView.swift
//  Poetry Editor
//
//  Created by Eli Burnes on 2/24/24.
//

import Foundation
import Cocoa

class ScrollableTextView: NSScrollView {
    // Create the NSTextView property
    private(set) var textView: CustomNSTextView!

    // Initializer
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupTextView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextView()
    }

    // Setup the NSTextView
    private func setupTextView() {
        // Configure the scroll view
        self.hasVerticalScroller = true
        self.borderType = .noBorder
        
        // Create and configure the NSTextView
        let contentSize = self.contentSize
        textView = CustomNSTextView(frame: NSRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height))
        textView.minSize = NSMakeSize(0.0, contentSize.height)
        textView.maxSize = NSMakeSize(CGFloat.greatestFiniteMagnitude, CGFloat.greatestFiniteMagnitude)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.autoresizingMask = [.width, .height]
        textView.textContainer?.containerSize = NSMakeSize(contentSize.width, CGFloat.greatestFiniteMagnitude)
        textView.textContainer?.widthTracksTextView = true
        textView.textColor = NSColor.black

        
        if textView.textContainer == nil{
            print("text container is nil")
        }
        
        textView.isEditable = true
        textView.isHidden = false
        textView.textContainerInset = NSSize(width: 12, height: 16)
        
        // Set the textView as the documentView of the scrollView
        self.documentView = textView
    }
    public func addLineNumbersToTextView(){
        textView.setUpLineNumbers()
    }
}

