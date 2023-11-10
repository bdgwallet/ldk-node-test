//
//  ContentView.swift
//  ldk-node-test
//
//  Created by Daniel Nordh on 10/11/2023.
//

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
                storageDirPath: "tmp/ldk-node",
                network: Network.testnet,
                listeningAddress: nil,
                defaultCltvExpiryDelta: UInt32(2016)
            )
                
            let nodeBuilder = Builder.fromConfig(config: nodeConfig)
            
            do {
                let node = try nodeBuilder.build()
                text = "Node built"
                debugPrint("LDKNodeManager: Started with nodeId: \(node.nodeId())")
            } catch {
                text = "Node failed to build"
                debugPrint("LDKNodeManager: Error starting node: \(error.localizedDescription)")
            }
        }
    }
}


// -- Write test file to directory to check availability
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
