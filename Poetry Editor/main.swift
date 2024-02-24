//
//  main.swift
//  Poetry Editor
//
//  Created by Eli Burnes on 2/24/24.
//

import Foundation
import AppKit

// 1
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate



// 2
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
