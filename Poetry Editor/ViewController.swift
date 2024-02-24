//
//  ViewController.swift
//  Poetry Editor
//
//  Created by Eli Burnes on 2/24/24.
//
import Cocoa
import AppKit


protocol LineNumberListener{
    func handleNewLineNumber(_ newLineNumber: Int)
}
protocol NoteListener{
    func handleNewNote(_ note: String)
}

class ViewController: NSViewController, LineNumberListener
{
    
    var lineNumberToDraftTextMap = [Int: String]()
    var currentLineNumber: Int = 0

    func handleNewLineNumber(_ newLineNumber: Int) {
        lineNumberToDraftTextMap[currentLineNumber] = draftTextView.textView.string
        currentLineNumber = newLineNumber
        draftTextView.textView.string = lineNumberToDraftTextMap[newLineNumber] ?? ""
        draftTextViewTitle.string = "Line \(newLineNumber) notes:"
        setDraftSummaryText()
    }
    
    func setDraftSummaryText(){
        var text = ""
        for key in lineNumberToDraftTextMap.keys.sorted(){
            if let note = lineNumberToDraftTextMap[key] {
                if !note.isEmpty{
                    text.append("Line \(key): \(note) \n")
                }
            }
        }
        combinedDraftTextView.textView.string = text
    }
    
    let primaryTextView: ScrollableTextView =
    {
        var view = ScrollableTextView()
        return view
    }()
    
    let draftTextView: ScrollableTextView =
    {
        var view = ScrollableTextView()
        return view
    }()
    
    let draftTextViewTitle: NSTextView = {
        let view = NSTextView()
        view.string = "Line 1 notes"
        view.isEditable = false
        return view
    }()
    
    let combinedDraftTextViewTitle: NSTextView = {
        let view = NSTextView()
        view.string = "Line by line notes:"
        view.isEditable = false
        return view
    }()
    
    let combinedDraftTextView: ScrollableTextView = {
        var view = ScrollableTextView()
        view.textView.isEditable = false
        view.textView.backgroundColor = NSColor.lightGray
        return view
    }()
    
    let generalNotesTextView: ScrollableTextView = {
        var view = ScrollableTextView()
        return view
    }()
    
    let generalNotesTitle: NSTextView = {
        let view = NSTextView()
        view.string = "General notes"
        return view
    }()
    
    let draftView: NSView = NSView()
    
    let toggleButton: NSButton = {
        let button = NSButton(title: "Toggle Notes View", target: self, action: #selector(toggleRightView))
            return button
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
    }
    
    private let textViewsTopMargin: CGFloat = 60
    private let buttonsTopMargin: CGFloat = 30
    
    func addSubviews() {
        view.addSubview(primaryTextView)
        view.addSubview(draftView)
        view.addSubview(toggleButton)
        
        draftView.addSubview(combinedDraftTextViewTitle)
        draftView.addSubview(draftTextViewTitle)
        draftView.addSubview(draftTextView)
        draftView.addSubview(combinedDraftTextView)
        draftView.addSubview(generalNotesTextView)
        draftView.addSubview(generalNotesTitle)
        primaryTextView.addLineNumbersToTextView(lineNumberListener: self)
    }
    
    var primaryTextViewWidthConstraint: NSLayoutConstraint!
    var primaryTextViewCenterConstraint: NSLayoutConstraint!
    var alternatePrimaryTextViewConstraints: [NSLayoutConstraint] = []
    
    var viewWidthConstraint: NSLayoutConstraint!
    var viewHeightConstraint: NSLayoutConstraint!

    var standardDraftViewConstraints: [NSLayoutConstraint] = []
    var standardPrimaryTextViewConstraints: [NSLayoutConstraint] = []
    
    var windowWidth: CGFloat = 800.0
    var windowHeight: CGFloat = 800.0

    
    func setupConstraints() {
        
        view.setContentHuggingPriority(NSLayoutConstraint.Priority.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(NSLayoutConstraint.Priority.defaultHigh, for: .vertical)
        
        view.setContentCompressionResistancePriority(NSLayoutConstraint.Priority.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(NSLayoutConstraint.Priority.defaultHigh, for: .vertical)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: windowWidth),
            view.heightAnchor.constraint(equalToConstant: windowHeight)
        ])

        primaryTextView.translatesAutoresizingMaskIntoConstraints = false
        draftView.translatesAutoresizingMaskIntoConstraints = false
        draftTextView.translatesAutoresizingMaskIntoConstraints = false
        draftTextViewTitle.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        combinedDraftTextView.translatesAutoresizingMaskIntoConstraints = false
        combinedDraftTextViewTitle.translatesAutoresizingMaskIntoConstraints = false
        generalNotesTextView.translatesAutoresizingMaskIntoConstraints = false
        generalNotesTitle.translatesAutoresizingMaskIntoConstraints = false
        
        standardDraftViewConstraints = [
            draftView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: -20),
            draftView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            draftView.topAnchor.constraint(equalTo: view.topAnchor, constant: textViewsTopMargin),
            draftView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let draftTextViewConstraints = [
            draftTextView.leadingAnchor.constraint(equalTo: draftView.leadingAnchor),
            draftTextView.trailingAnchor.constraint(equalTo: draftView.trailingAnchor),
            draftTextView.topAnchor.constraint(equalTo: draftView.topAnchor, constant: 20),
            draftTextView.heightAnchor.constraint(equalTo: draftView.heightAnchor, multiplier: 0.1, constant: -20)
        ]
        let combinedDraftTextViewConstraints = [
            combinedDraftTextView.leadingAnchor.constraint(equalTo: draftView.leadingAnchor),
            combinedDraftTextView.trailingAnchor.constraint(equalTo: draftView.trailingAnchor),
            combinedDraftTextView.topAnchor.constraint(equalTo: draftTextView.bottomAnchor, constant: 20),
            combinedDraftTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25)
        ]
        
        let generalNotesTextViewConstraints = [
            generalNotesTextView.topAnchor.constraint(equalTo: combinedDraftTextView.bottomAnchor, constant: 20),
            generalNotesTextView.bottomAnchor.constraint(equalTo: draftView.bottomAnchor, constant: -20),
            generalNotesTextView.leadingAnchor.constraint(equalTo: draftView.leadingAnchor),
            generalNotesTextView.trailingAnchor.constraint(equalTo: draftView.trailingAnchor)
        ]
        
        
        standardPrimaryTextViewConstraints = [
            primaryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            primaryTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: textViewsTopMargin),
            primaryTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            primaryTextView.trailingAnchor.constraint(equalTo: draftView.leadingAnchor, constant: -20)
        ]
                
        NSLayoutConstraint.activate([
            primaryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            primaryTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: textViewsTopMargin),
            primaryTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
            ] + standardDraftViewConstraints 
                                    + standardPrimaryTextViewConstraints
                                    + draftTextViewConstraints
                                    + combinedDraftTextViewConstraints
                                    + generalNotesTextViewConstraints)
        
        // Prepare for alternate layout but don't activate yet
        primaryTextViewWidthConstraint = primaryTextView.widthAnchor.constraint(equalToConstant: calculateDesiredWidth())
        primaryTextViewCenterConstraint = primaryTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        primaryTextViewWidthConstraint.priority = NSLayoutConstraint.Priority(500)
        
        alternatePrimaryTextViewConstraints = [
            primaryTextViewWidthConstraint!,
            primaryTextViewCenterConstraint!
        ]

        
        NSLayoutConstraint.activate([
            // Toggle Button Constraints
            toggleButton.topAnchor.constraint(equalTo: view.topAnchor, constant: buttonsTopMargin),
            toggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            draftTextViewTitle.leadingAnchor.constraint(equalTo: draftTextView.leadingAnchor),
            draftTextViewTitle.bottomAnchor.constraint(equalTo: draftTextView.topAnchor, constant: -16),
            
            combinedDraftTextViewTitle.leadingAnchor.constraint(equalTo: combinedDraftTextView.leadingAnchor),
            combinedDraftTextViewTitle.bottomAnchor.constraint(equalTo: combinedDraftTextView.topAnchor, constant: -16),
            
            generalNotesTitle.leadingAnchor.constraint(equalTo: generalNotesTextView.leadingAnchor),
            generalNotesTitle.bottomAnchor.constraint(equalTo: generalNotesTextView.topAnchor, constant: -16)
        ])
    }
    
    func windowDidResize(_ notification: Notification) {
    }
    
    @objc func toggleRightView() {
        draftView.isHidden.toggle()
        if draftView.isHidden {
            // Activate constraints for alternate layout
            primaryTextViewWidthConstraint?.constant = calculateDesiredWidth()

            NSLayoutConstraint.deactivate(standardPrimaryTextViewConstraints)
            NSLayoutConstraint.deactivate(standardDraftViewConstraints)
            NSLayoutConstraint.activate(alternatePrimaryTextViewConstraints)
        } else {
            // Return to standard layout
            NSLayoutConstraint.deactivate(alternatePrimaryTextViewConstraints)
            NSLayoutConstraint.activate(standardDraftViewConstraints)
            NSLayoutConstraint.activate(standardPrimaryTextViewConstraints)
        }
        
        // Animate the layout transition
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            view.layoutSubtreeIfNeeded()
        }
    }
    // Helper function to calculate a fixed or maximum width for the left view
    func calculateDesiredWidth() -> CGFloat {
        // Return a fixed width or calculate based on the current window size
        return min(600, view.frame.width * 0.8) // Example: use a fixed value or 80% of the current window width, whichever is smaller
    }


    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

