//
//  ViewController.swift
//  Poetry Editor
//
//  Created by Eli Burnes on 2/24/24.
//
import Cocoa
import AppKit


class ViewController: NSViewController {

    let primaryTextView: ScrollableTextView =
    {
        var view = ScrollableTextView()
        view.textView.backgroundColor = NSColor.green
        return view
    }()
    
    let draftTextView: ScrollableTextView =
    {
        var view = ScrollableTextView()
        view.textView.backgroundColor = NSColor.red
        return view
    }()
    
    let toggleButton: NSButton = {
        let button = NSButton(title: "Toggle Draft View", target: self, action: #selector(toggleRightView))
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
        view.addSubview(draftTextView)
        view.addSubview(toggleButton)
    }
    
    var primaryTextViewWidthConstraint: NSLayoutConstraint!
    var primaryTextViewCenterConstraint: NSLayoutConstraint!
    var alternatePrimaryTextViewConstraints: [NSLayoutConstraint] = []
    
    var viewWidthConstraint: NSLayoutConstraint!
    var viewHeightConstraint: NSLayoutConstraint!

    var standardDraftTextViewConstraints: [NSLayoutConstraint] = []
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
        draftTextView.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
                        
        standardDraftTextViewConstraints = [
            draftTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: -20),
            draftTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            draftTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: textViewsTopMargin),
            draftTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
            ]
        
        standardPrimaryTextViewConstraints = [
            primaryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            primaryTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: textViewsTopMargin),
            primaryTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            primaryTextView.trailingAnchor.constraint(equalTo: draftTextView.leadingAnchor, constant: -20)
        ]
                
        NSLayoutConstraint.activate([
            primaryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            primaryTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: textViewsTopMargin),
            primaryTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
            ] + standardDraftTextViewConstraints + standardPrimaryTextViewConstraints)
        
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
        ])
    }
    
    func windowDidResize(_ notification: Notification) {
        // Adjust yourSubview's top constraint or frame here based on the new window size or toolbar visibility
    }
    
    @objc func toggleRightView() {
        draftTextView.isHidden = !draftTextView.isHidden
        
        if draftTextView.isHidden {
            // Activate constraints for alternate layout
            primaryTextViewWidthConstraint?.constant = calculateDesiredWidth()

            NSLayoutConstraint.deactivate(standardPrimaryTextViewConstraints)
            NSLayoutConstraint.deactivate(standardDraftTextViewConstraints)
            NSLayoutConstraint.activate(alternatePrimaryTextViewConstraints)
        } else {
            // Return to standard layout
            NSLayoutConstraint.deactivate(alternatePrimaryTextViewConstraints)
            NSLayoutConstraint.activate(standardDraftTextViewConstraints)
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

