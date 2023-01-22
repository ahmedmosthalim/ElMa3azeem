//
//  socketHandler.swift
//  ElMa3azeem
//
//  Created by Mustafa Abdein on 16/01/2022.
//

import Foundation
import SocketIO

open class SocketConnection {
    public static let sharedInstance = SocketConnection()
    let manager: SocketManager
    public var socket: SocketIOClient
    private init() {
        manager = SocketManager(socketURL: URL(string: URLs.SocketPort)!, config: [.log(false) ,.reconnects(false)]) // ----> make it false
        socket = manager.defaultSocket
    }
}
