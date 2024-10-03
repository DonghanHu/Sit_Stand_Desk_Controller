import Cocoa
import IOBluetooth

class BluetoothManagerData: NSObject, IOBluetoothRFCOMMChannelDelegate {
    
    var rfcommChannel: IOBluetoothRFCOMMChannel?
    var deviceAddress: String
    
    init(deviceAddress: String) {
        self.deviceAddress = deviceAddress
        super.init()
    }
    
    func connectToDevice(retryCount: Int = 3) {
        guard let device = IOBluetoothDevice(addressString: deviceAddress) else {
            print("Device not found")
            return
        }

        if !device.isPaired() {
            print("Device is not paired. Please pair the device first.")
            return
        }

        var retries = retryCount
        let rfcommChannelID: BluetoothRFCOMMChannelID = 1  // Set RFCOMM channel to 1

        // Attempt connection retryCount times
        while retries > 0 {
            print("Trying to connect to RFCOMM channel \(rfcommChannelID)")
            
            let status = device.openRFCOMMChannelSync(&rfcommChannel, withChannelID: rfcommChannelID, delegate: self)
            if status == kIOReturnSuccess, let rfcommChannel = rfcommChannel {
                print("Connected to \(deviceAddress) on RFCOMM channel \(rfcommChannelID)")
                return
            } else {
                print("Failed to connect to device: \(status). Retrying...")
            }

            retries -= 1
            if retries > 0 {
                print("Retrying connection... (\(retryCount - retries + 1) of \(retryCount))")
                sleep(2)  // Wait for 2 seconds before retrying
            } else {
                print("Failed to connect after \(retryCount) attempts.")
            }
        }
    }
    
    func sendData(_ data: Data) {
        guard let rfcommChannel = rfcommChannel else {
            print("RFCOMM channel not available")
            return
        }
        
        data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            guard let pointer = bytes.baseAddress else {
                print("Failed to get data pointer")
                return
            }
            
            let status = rfcommChannel.writeSync(UnsafeMutableRawPointer(mutating: pointer), length: UInt16(data.count))
            if status == kIOReturnSuccess {
                print("Data sent successfully")
            } else {
                print("Failed to send data: \(status)")
            }
        }
    }
    
    // IOBluetoothRFCOMMChannelDelegate methods
    func rfcommChannelData(_ rfcommChannel: IOBluetoothRFCOMMChannel, data dataPointer: UnsafeMutablePointer<Void>, length dataLength: Int) {
        let receivedData = Data(bytes: dataPointer, count: dataLength)
        print("Received data: \(receivedData)")
    }
    
    func rfcommChannelClosed(_ rfcommChannel: IOBluetoothRFCOMMChannel) {
        print("RFCOMM channel closed")
        self.rfcommChannel = nil
    }
}


//import Cocoa
//import IOBluetooth
//
//class BluetoothManagerData: NSObject, IOBluetoothRFCOMMChannelDelegate {
//    
//    var rfcommChannel: IOBluetoothRFCOMMChannel?
//    var deviceAddress: String
//    
//    init(deviceAddress: String) {
//        self.deviceAddress = deviceAddress
//        super.init()
//    }
//    
//    func connectToDevice(retryCount: Int = 3) {
//        guard let device = IOBluetoothDevice(addressString: deviceAddress) else {
//            print("Device not found")
//            return
//        }
//
//        if !device.isPaired() {
//            print("Device is not paired. Please pair the device first.")
//            return
//        }
//
//        var retries = retryCount
//        var rfcommChannelID: BluetoothRFCOMMChannelID = 1
//
//        // Attempt connection retryCount times
//        while retries > 0 {
//            if device.services != nil, let services = device.services as? [IOBluetoothSDPServiceRecord] {
//                for service in services {
//                    if service.getRFCOMMChannelID(&rfcommChannelID) == kIOReturnSuccess {
//                        print("Found RFCOMM Channel ID: \(rfcommChannelID)")
//
//                        let status = device.openRFCOMMChannelSync(&rfcommChannel, withChannelID: rfcommChannelID, delegate: self)
//
//                        if status == kIOReturnSuccess, let rfcommChannel = rfcommChannel {
//                            print("Connected to \(deviceAddress) on RFCOMM channel \(rfcommChannelID)")
//                            return
//                        } else {
//                            print("Failed to connect to device: \(status). Retrying...")
//                        }
//                    }
//                }
//            }
//
//            retries -= 1
//            if retries > 0 {
//                print("Retrying connection... (\(retryCount - retries + 1) of \(retryCount))")
//                sleep(2)  // Wait for 2 seconds before retrying
//            } else {
//                print("Failed to connect after \(retryCount) attempts.")
//            }
//        }
//    }
//
//
//    
//    func sendData(_ data: Data) {
//        guard let rfcommChannel = rfcommChannel else {
//            print("RFCOMM channel not available")
//            return
//        }
//        
//        data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
//            guard let pointer = bytes.baseAddress else {
//                print("Failed to get data pointer")
//                return
//            }
//            
//            let status = rfcommChannel.writeSync(UnsafeMutableRawPointer(mutating: pointer), length: UInt16(data.count))
//            if status == kIOReturnSuccess {
//                print("Data sent successfully")
//            } else {
//                print("Failed to send data: \(status)")
//            }
//        }
//    }
//    
//    // IOBluetoothRFCOMMChannelDelegate methods
//    func rfcommChannelData(_ rfcommChannel: IOBluetoothRFCOMMChannel, data dataPointer: UnsafeMutablePointer<Void>, length dataLength: Int) {
//        let receivedData = Data(bytes: dataPointer, count: dataLength)
//        print("Received data: \(receivedData)")
//    }
//    
//    func rfcommChannelClosed(_ rfcommChannel: IOBluetoothRFCOMMChannel) {
//        print("RFCOMM channel closed")
//        self.rfcommChannel = nil
//    }
//}



//import Cocoa
//import IOBluetooth
//
//class BluetoothManagerData: NSObject, IOBluetoothRFCOMMChannelDelegate {
//    
//    var rfcommChannel: IOBluetoothRFCOMMChannel?
//    var deviceAddress: String
//    
//    init(deviceAddress: String) {
//        self.deviceAddress = deviceAddress
//        super.init()
//    }
//    
//    func connectToDevice() {
//        guard let device = IOBluetoothDevice(addressString: deviceAddress) else {
//            print("Device not found")
//            return
//        }
//        print("connect successfully")
//        let rfcommChannelID: BluetoothRFCOMMChannelID = 1
//        let status = device.openRFCOMMChannelSync(&rfcommChannel, withChannelID: rfcommChannelID, delegate: self)
//        
//        if status == kIOReturnSuccess, let rfcommChannel = rfcommChannel {
//            print("Connected to \(deviceAddress) on RFCOMM channel \(rfcommChannelID)")
//        } else {
//            print("Failed to connect to device: \(status)")
//        }
//    }
//    
//    func sendData(_ data: Data) {
//        guard let rfcommChannel = rfcommChannel else {
//            print("RFCOMM channel not available")
//            return
//        }
//        
//        data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
//            guard let pointer = bytes.baseAddress else {
//                print("Failed to get data pointer")
//                return
//            }
//            
//            let status = rfcommChannel.writeSync(UnsafeMutableRawPointer(mutating: pointer), length: UInt16(data.count))
//            if status == kIOReturnSuccess {
//                print("Data sent successfully")
//            } else {
//                print("Failed to send data: \(status)")
//            }
//        }
//    }
//    
//    
//    // IOBluetoothRFCOMMChannelDelegate methods
//    func rfcommChannelData(_ rfcommChannel: IOBluetoothRFCOMMChannel, data dataPointer: UnsafeMutablePointer<Void>, length dataLength: Int) {
//        let receivedData = Data(bytes: dataPointer, count: dataLength)
//        print("Received data: \(receivedData)")
//    }
//    
//    func rfcommChannelClosed(_ rfcommChannel: IOBluetoothRFCOMMChannel) {
//        print("RFCOMM channel closed")
//        self.rfcommChannel = nil
//    }
//}


