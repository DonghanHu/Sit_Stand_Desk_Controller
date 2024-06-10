//
//  IOBluetooth.swift
//  SitStandDeskController
//
//  Created by Donghan Hu on 5/20/24.
//

import Foundation
import Cocoa
import IOBluetooth


class BluetoothManagerIOClass {
    
    private var device: IOBluetoothDevice?
    
    private var rfcommChannel: IOBluetoothRFCOMMChannel?
    
    private var dataLength = 200
    
    func connectToBluetoothDevice() {
        let devices = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice]
        if let device = devices?.first(where: { $0.name == "YourDeviceName" }) {
            self.device = device
            self.device?.openConnection()
        } else {
            print("Bluetooth device not found.")
        }
    }
    
    func sendStringOverBluetooth(string: String) {
        guard let device = self.device else {
            print("Bluetooth device not connected.")
            return
        }
        
        if device.isConnected() {
            let rfcommChannelID: BluetoothRFCOMMChannelID = 1 // Change the channel ID as needed
            let result = device.openRFCOMMChannelSync(&rfcommChannel, withChannelID: rfcommChannelID, delegate: nil)
            if let channel = self.rfcommChannel {
                if let data = string.data(using: .utf8) {
                    let dataPointer = UnsafeMutablePointer<UInt8>.allocate(capacity: data.count)
                    defer { dataPointer.deallocate() } // Deallocate the pointer after use
                    data.copyBytes(to: dataPointer, count: data.count)
                    channel.writeSync(dataPointer, length: UInt16(data.count))
                    print("String sent successfully.")
                } else {
                    print("Failed to convert string to data.")
                }
            } else {
                print("Failed to open RFCOMM channel.")
            }
        } else {
            print("Bluetooth device is not connected.")
        }
        
        
        
        
    }
    
    
    func listConnectedDevices() {
        // Get an array of all paired devices
        guard let devices = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice] else {
            print("No paired devices found.")
            return
        }
        
        print("Connected Bluetooth devices:")
        for device in devices {
            if device.isConnected() {
                print("Name: \(device.name ?? "Unknown"), Address: \(device.addressString ?? "Unknown")")
                
            }
        }
        
        
    }
}


