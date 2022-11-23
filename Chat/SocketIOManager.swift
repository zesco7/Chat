//
//  SocketIOManager.swift
//  Chat
//
//  Created by Mac Pro 15 on 2022/11/23.
//

import Foundation
import SocketIO

class SocketIOManager {
    static let shared = SocketIOManager()
    
    //서버와 메시지를 주고받기 위한 클래스
    var manager: SocketManager!
    
    var socket: SocketIOClient!
    
    private init() {
        manager = SocketManager(socketURL: URL(string: APIKey.socket)!, config: [
            .log(true), .extraHeaders(["auth": APIKey.header])
        ])
        
        socket = manager.defaultSocket
        
        //연결
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED", data, ack)
        }
        
        //연결해제
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
        
        //이벤트 수신
        socket.on("sesac") { dataArray, ack in
            print("SESAC RECEIVED", dataArray, ack)
            
            let data = dataArray[0] as! NSDictionary
            let chat = data["text"] as! String
            let name = data["name"] as! String
            let userId = data["userId"] as! String
            let createdAt = data["createdAt"] as! String
            
            print("CHECK >>>", chat, name, createdAt)
            
            //서버에서 받은 이벤트 채팅창에 실시간 표시
            NotificationCenter.default.post(name: NSNotification.Name("getMessage"), object: self, userInfo: ["chat": chat, "name": name, "createdAt": createdAt, "userId": userId])
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
