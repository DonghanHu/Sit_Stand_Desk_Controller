import Cocoa
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate {
    private var centralManager: CBCentralManager!
    private var discoveredPeripherals: [CBPeripheral] = []

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            // Start scanning for devices
            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
            
            
        case .poweredOff, .resetting, .unauthorized, .unsupported, .unknown:
            print("Bluetooth is not available or not authorized.")
        @unknown default:
            print("A new state is available that is not handled.")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
            print("Discovered device: \(peripheral.name ?? "Unknown") - Identifier: \(peripheral.identifier.uuidString)")
        }
    }
}
