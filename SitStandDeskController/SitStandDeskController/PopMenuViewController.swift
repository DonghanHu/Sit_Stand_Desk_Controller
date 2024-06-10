//
//  PopMenuViewController.swift
//  SitStandDeskController
//
//  Created by Donghan Hu on 4/8/24.
//

import Foundation
import AppKit
import Cocoa
import IOBluetooth
import CoreBluetooth


class PopMenuViewController: NSViewController {
    
    @IBOutlet weak var SeparatorLine: NSBox!
    
    private var quitButton: NSButton!
    private var goUpButton : NSButton!
    private var goDownButton : NSButton!
    
    private var connectionLabel : NSTextField!
    
    private var connectedFlag : Bool!
    
    private var detectConnectionTimer = Timer()
    private var timeIntervalForDetect = 3.0
    
    var bluetoothManager: BluetoothManager?
    var bluetoothManagerObject: BluetoothManagerIOClass?
    
    // @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // keep scanning available devices
        //bluetoothManager = BluetoothManager()
        
        // listed connected devices
        bluetoothManagerObject = BluetoothManagerIOClass()
        bluetoothManagerObject?.listConnectedDevices()
        
        
        
        
        connectedFlag = false
  
        // text field for bluetooth connection
        connectionLabel = NSTextField(frame: NSRect(x: self.view.frame.origin.x + 20, y: self.view.frame.origin.y + 140, width: 160, height: 30))
        connectionLabel.isEditable = false
        connectionLabel.textColor = .black
        connectionLabel.stringValue = String(connectedFlag)
        connectionLabel.bezelStyle = .roundedBezel
        connectionLabel.isBordered = true
        connectionLabel.alignment = .center
        self.view.addSubview(connectionLabel)
        
        
        // detectConnectionTimer = Timer.scheduledTimer(timeInterval: timeIntervalForDetect, target: self, selector: #selector(detectConnection), userInfo: nil, repeats: true)
        
        // go up botton
        goUpButton = NSButton(frame: NSRect(x: self.view.frame.origin.x + 20, y: self.view.frame.origin.y + 50, width: 160, height: 30))
        goUpButton.target = self
        goUpButton.title = "Go Up （1）"
        goUpButton.bezelStyle = .rounded
        goUpButton.isBordered = true
        goUpButton.setButtonType(.momentaryPushIn)
        // keyboard: 1
        goUpButton.keyEquivalent = "1"
        goUpButton.action = #selector(self.goUpFunction)
        self.view.addSubview(goUpButton)
        
        // go down button
        goDownButton = NSButton(frame: NSRect(x: self.view.frame.origin.x + 20, y: self.view.frame.origin.y + 100, width: 160, height: 30))
        goDownButton.target = self
        goDownButton.title = "Go Down (2)"
        goDownButton.bezelStyle = .rounded
        goDownButton.isBordered = true
        goDownButton.setButtonType(.momentaryPushIn)
        // keyboard: 1
        goDownButton.keyEquivalent = "2"
        goDownButton.action = #selector(self.goDownFunction)
        self.view.addSubview(goDownButton)
        
        SeparatorLine.borderColor = .black
        
        // Quit Button
        quitButton = NSButton(frame: NSRect(x: self.view.frame.origin.x + 20, y: self.view.frame.origin.y + 10, width: 160, height: 30))
        quitButton.target = self
        quitButton.title = "Quit"
        quitButton.bezelStyle = .rounded
        quitButton.isBordered = true
        quitButton.setButtonType(.momentaryPushIn)
        quitButton.keyEquivalent = "q"
        quitButton.action = #selector(self.quitFunction)
        self.view.addSubview(quitButton)
        
    }
    
    @objc func goUpFunction(){
        
        //TODO
        // check if script on raspberry is still running
        
        print("clicked go up!")
        var bluetoothManagerData: BluetoothManagerData!
        let deviceAddress = "b8:27:eb:e3:89:bb"
        bluetoothManagerData = BluetoothManagerData(deviceAddress: deviceAddress)
        bluetoothManagerData.connectToDevice()
        // Example of sending data
        let message = "Go Up"
        if let data = message.data(using: .utf8) {
            bluetoothManagerData.sendData(data)
        }
        // send a package for going up
    }
    
    @objc func goDownFunction() {
        print("clicked go down!")
        var bluetoothManagerData: BluetoothManagerData!
        let deviceAddress = "b8:27:eb:e3:89:bb"
        bluetoothManagerData = BluetoothManagerData(deviceAddress: deviceAddress)
        bluetoothManagerData.connectToDevice()
        // Example of sending data
        let message = "Go Down"
        if let data = message.data(using: .utf8) {
            bluetoothManagerData.sendData(data)
        }
        // send a package for going down
    }
    
    @objc func quitFunction() {
        detectConnectionTimer.invalidate()
        exit(0);
    }
    
    @objc func detectConnection(){
        // detect bluetooth connection with BlueTooth
        // let bluetoothManager = BluetoothManager()
        
//        let bluetoothScanner = BluetoothScanner()
//        print(bluetoothScanner.discoveredPeripherals.count)

        
    
    }
    
    func getConnectedDevice(){

    }
}


// not using now

//class BluetoothSearchDelegate: NSObject, IOBluetoothDeviceInquiryDelegate {
//    func deviceInquiryDeviceFound(_ sender: IOBluetoothDeviceInquiry, device: IOBluetoothDevice) {
//            print("Found Device \(device.name ?? "nil")")
//        }
//
//        func deviceInquiryStarted(_ sender: IOBluetoothDeviceInquiry) {
//            print("started")
//        }
//
//        func deviceInquiryComplete(_ sender: IOBluetoothDeviceInquiry, error: IOReturn, aborted: Bool) {
//            print("completed")
//        }
//}


extension PopMenuViewController {
    static func initController() -> PopMenuViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name( "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("PopMenuViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? PopMenuViewController else {
            fatalError("Cannot find PopMenuViewController")
        }
        return viewcontroller
    }
}
