//
//  HomeSocketConnection.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import Foundation
extension DelegateHomeVC {
    
    @objc func disConnectSocket(){
        SocketConnection.sharedInstance.socket.off("unsubscribe")
        SocketConnection.sharedInstance.socket.off("sendMessage")
        let jsonDic = [
            "lat": Double(defult.shared.getData(forKey: .userLat) ?? "") ?? 0.0,
            "long": Double(defult.shared.getData(forKey: .userLong) ?? "") ?? 0.0,
            "user_id": defult.shared.user()?.user?.id ?? 0
        ] as [String : Any]
        
        SocketConnection.sharedInstance.socket.emit("unsubscribe", jsonDic)
        print("💂🏻‍♀️exitUser")
        SocketConnection.sharedInstance.socket.disconnect()
    }
    
    @objc func ConnectToSocket() {
        if(SocketConnection.sharedInstance.socket.status == .notConnected){
            print("Not connected")
            SocketConnection.sharedInstance.manager.connect()
            SocketConnection.sharedInstance.socket.connect()
        }
        
        if(SocketConnection.sharedInstance.socket.status == .disconnected){
            print("Disconnected")
            SocketConnection.sharedInstance.manager.connect()
            SocketConnection.sharedInstance.socket.connect()
        }
        
        if(SocketConnection.sharedInstance.socket.status == .connecting){
            print("Trying To Connect...")
            SocketConnection.sharedInstance.manager.connect()
            SocketConnection.sharedInstance.socket.connect()
        }
        
        print(SocketConnection.sharedInstance.socket.status)
        
        SocketConnection.sharedInstance.socket.once(clientEvent: .connect) { (data, ack) in
            let jsonDic = [
                "lat": Double(defult.shared.getData(forKey: .userLat) ?? "") ?? 0.0,
                "long": Double(defult.shared.getData(forKey: .userLong) ?? "") ?? 0.0,
                "user_id": defult.shared.user()?.user?.id ?? 0
            ] as [String : Any]

            SocketConnection.sharedInstance.socket.emit("updatelocation", jsonDic)
            print("💂🏻‍♀️AdddUssser : \(jsonDic)")
        }
        
        if(SocketConnection.sharedInstance.socket.status == .connected){
            let jsonDic = [
                "lat": Double(defult.shared.getData(forKey: .userLat) ?? "") ?? 0.0,
                "long": Double(defult.shared.getData(forKey: .userLong) ?? "") ?? 0.0,
                "user_id": defult.shared.user()?.user?.id ?? 0
            ] as [String : Any]

            SocketConnection.sharedInstance.socket.emit("updatelocation", jsonDic)
            print("💂🏻‍♀️connected : \(jsonDic)")
        }

        SocketConnection.sharedInstance.socket.on(clientEvent: .error) { (data, ack) in
            print("🍋Error")
            print("🍉\(data)")
        }
        
        SocketConnection.sharedInstance.socket.on(clientEvent: .disconnect) { (data, ack) in
            print("🍋disconnect")
            print("🍉\(data)")
            print("💂🏻‍♀️exitUser")
        }
        
        SocketConnection.sharedInstance.socket.on(clientEvent: .ping) { (data, ack) in
            print("🍋Ping")
            print("🍉\(data)")
        }
        
        SocketConnection.sharedInstance.socket.on(clientEvent: .reconnect) { (data, ack) in
            print("🍋reconnect")
            print("🍉\(data)")
        }
    }
}
