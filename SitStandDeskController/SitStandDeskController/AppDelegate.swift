//
//  AppDelegate.swift
//  SitStandDeskController
//
//  Created by Donghan Hu on 4/8/24.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var statusItem: NSStatusItem!
    
    let menu = NSMenu()
    let popover = NSPopover()
    private var monitor: Any?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "scribble.variable", accessibilityDescription: "app Icon")
            button.action = #selector(togglePopover(_:))
        }
        
        popover.contentViewController = PopMenuViewController.initController()
        popover.behavior = NSPopover.Behavior.transient;
        
        // setupMenus()
        
    }
    
    @objc func togglePopover(_ sender: Any?) {
          if popover.isShown {
            closePopover(sender: sender)
            if monitor != nil {
                NSEvent.removeMonitor(monitor!)
            }
            monitor = nil
          } else {
            monitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown,.rightMouseDown] ){ [weak self] event in
                if let strongSelf = self, strongSelf.popover.isShown {
                  strongSelf.closePopover(sender: event)
                }
            }
            showPopover(sender: sender)
          }
    }
    func showPopover(sender: Any?) {
        if let button = statusItem?.button {
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
      }
    }

    func closePopover(sender: Any?) {
      popover.performClose(sender)
    }
    
    func setupMenus() {
        
        let one = NSMenuItem(title: "One", action: #selector(didTapOne) , keyEquivalent: "1")
        menu.addItem(one)

        let GoUpBut = NSMenuItem(title: "Go Up", action: #selector(didTapTwo) , keyEquivalent: "2")
        menu.addItem(GoUpBut)

        let GoDwonBut = NSMenuItem(title: "Go Down", action: #selector(didTapThree) , keyEquivalent: "3")
        menu.addItem(GoDwonBut)

        menu.addItem(NSMenuItem.separator())

        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        
        statusItem.menu = menu
    }
    
    @objc func didTapOne() {
        print("1")
    }

    @objc func didTapTwo() {
        print("2")
    }

    @objc func didTapThree() {
        print("3")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

