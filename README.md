# ldk-node-test

This Xcode project reproduces an issue with ldk-node's .build() function.

Expected behavior:
App runs and node builds every time.

Observed behavior:
App runs and node builds on first execution.
On second run, node fails to build with error 7.


```swift
import SwiftUI
import LDKNode

struct ContentView: View {
    @State var text = "Node has not started"
    let DEFAULT_STORAGE_PATH = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path
    
    var body: some View {
        VStack {
            Text(text)
        }
        .padding().task {
            let nodeConfig = Config(
                storageDirPath: DEFAULT_STORAGE_PATH,
                network: Network.testnet,
                listeningAddress: nil,
                defaultCltvExpiryDelta: UInt32(2016)
            )
                
            let nodeBuilder = Builder.fromConfig(config: nodeConfig)

            // -- Optional, write test file to directory to check availability
            //let str = "Wrote and read from directory"
            //let path = DEFAULT_STORAGE_PATH + "message.txt"
            //
            //do {
            //    let url = URL(filePath: path)
            //    try str.write(to: url, atomically: true, encoding: .utf8)
            //    let input = try String(contentsOf: url)
            //    print(input)
            //} catch {
            //    print(error.localizedDescription)
            //}
            // --
            
            do {
                let node = try nodeBuilder.build()
                try node.start()
                text = "Node started"
                debugPrint("LDKNodeManager: Started with nodeId: \(node.nodeId())")
            } catch {
                text = "Node failed to start"
                debugPrint("LDKNodeManager: Error starting node: \(error.localizedDescription)")
            }
        }
    }
} 
```

