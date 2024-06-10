import Cocoa
import IOBluetooth

class BluetoothManagerData: NSObject, IOBluetoothRFCOMMChannelDelegate {
    
    var rfcommChannel: IOBluetoothRFCOMMChannel?
    var deviceAddress: String
    
    init(deviceAddress: String) {
        self.deviceAddress = deviceAddress
        super.init()
    }
    
    func connectToDevice() {
        guard let device = IOBluetoothDevice(addressString: deviceAddress) else {
            print("Device not found")
            return
        }
        print("connect successfully")
        let rfcommChannelID: BluetoothRFCOMMChannelID = 1
        let status = device.openRFCOMMChannelSync(&rfcommChannel, withChannelID: rfcommChannelID, delegate: self)
        
        if status == kIOReturnSuccess, let rfcommChannel = rfcommChannel {
            print("Connected to \(deviceAddress) on RFCOMM channel \(rfcommChannelID)")
        } else {
            print("Failed to connect to device: \(status)")
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

//// Usage in your main app
//class AppDelegate: NSObject, NSApplicationDelegate {
//    var window: NSWindow!
//    var bluetoothManagerData: BluetoothManagerData!
//
//    func applicationDidFinishLaunching(_ notification: Notification) {
//        // Replace with your device's Bluetooth address
//        let deviceAddress = "XX:XX:XX:XX:XX:XX"
//        bluetoothManager = BluetoothManager(deviceAddress: deviceAddress)
//
//        window = NSWindow(contentRect: NSMakeRect(0, 0, 480, 300),
//                          styleMask: [.titled, .closable, .resizable, .miniaturizable],
//                          backing: .buffered, defer: false)
//        window.center()
//        window.title = "Bluetooth App"
//        window.makeKeyAndOrderFront(nil)
//
//        bluetoothManager.connectToDevice()
//
//        // Example of sending data
//        let message = "Hello, Device!"
//        if let data = message.data(using: .utf8) {
//            bluetoothManager.sendData(data)
//        }
//    }
//}
//
