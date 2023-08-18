//
//  awsbuddyApp.swift
//  awsbuddy
//
//  Created by loops on 8/10/23.
//
import Cocoa
import SwiftUI

@main
struct awsbuddyApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var timeLeft: Int!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.close()
        }
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = #imageLiteral(resourceName: "aws_icon")
            button.image?.size = NSSize(width: 18.0, height: 18.0)
            button.title = " "
        }
        
        setupMenus()
        DispatchQueue.global(qos: .userInitiated).async {
            while (true) {
                let timeLeft = self.getTimeLeft()
                
                DispatchQueue.main.async {
                    self.changeStatusBarTitle(newtitle: timeLeft)
                }
                sleep(60)
            }
        }
    }
    
    func setupMenus() {
        let menu = NSMenu()
        
        let mnu_refresh = NSMenuItem(title: "Refresh Tokens...", action: #selector(didTapRefresh), keyEquivalent: "r")
        menu.addItem(mnu_refresh)
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    private func refreshTokens() {
        let path = "/usr/local/bin/aws"
        let arguments = ["sso", "login"]
        let task = Process.launchedProcess(launchPath: path, arguments: arguments)
        task.waitUntilExit()
        sleep(1)
        let timeLeft = getTimeLeft()
        self.changeStatusBarTitle(newtitle: timeLeft)
    }
    
    private func getTimeLeft() -> String {
        let path = "/usr/bin/python3"
        let arguments = ["/usr/local/bin/check_aws.py"]
        
        let task = Process.launchedProcess(launchPath: path, arguments: arguments)
        task.waitUntilExit()
        sleep(1)
        
        let outputfile = "/tmp/aws_cli_time_left"
        do {
            let timeleft = try String(contentsOfFile: outputfile)
            return timeleft
        } catch {
            return ""
        }
    }
    
    private func changeStatusBarTitle(newtitle: String) {
        if let button = statusItem.button {
            button.title = newtitle
        }
    }
    
    @objc func didTapRefresh() {
        // get new time and update
        refreshTokens()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
