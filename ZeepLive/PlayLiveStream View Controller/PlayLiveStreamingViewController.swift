//
//  PlayLiveStreamingViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 03/07/23.
//

import UIKit
import ZegoExpressEngine

class PlayLiveStreamingViewController: UIViewController {

    lazy var roomState = ZegoRoomState.disconnected
    lazy var playerState = ZegoPlayerState.noPlay
     
    lazy var videoSize = CGSize(width: 0, height: 0)
    lazy var videoRecvFPS : Double = 0.0
    lazy var videoDecodeFPS : Double = 0.0
    lazy var videoRenderFPS : Double = 0.0
    lazy var videoBitrate : Double = 0.0
    lazy var videoNetworkQuality = ""
    lazy var isHardwareDecode = false
     
    lazy var playViewMode = ZegoViewMode.aspectFill
    lazy var playCanvas = ZegoCanvas()
    
    lazy var roomId = String()
    lazy var streamId = String()
    lazy var userId = String()
    @IBOutlet weak var btnBackOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.isHidden = true
        print(roomId)
        print("The Stream Id is\(streamId)")
        userId = UserDefaults.standard.string(forKey: "UserProfileId") ?? ""
        print(userId)
        
        createEngine(playView: self.view)
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        print("Back Button Pressed")
        stopPlayingStream(streamID: streamId)
        stopLive(roomID: roomId)
        destroyEngine()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnExitLiveBroadcastPressed(_ sender: Any) {
        
        print("Button Exit Live Broad Pressed")
        stopPlayingStream(streamID: streamId)
        stopLive(roomID: roomId)
        destroyEngine()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        print("Play Live Streaming vale ka view will disappear call hua hai")
        stopPlayingStream(streamID: streamId)
        stopLive(roomID: roomId)
        destroyEngine()

        print("Play Live Streaming vale pr ab broad band hua hai")
        
    }
    
}

// MARK: - EXTENSION FOR USING FUNCTIONS TO CREATE ENGINE FOR ZEGO, START WATCHING LIVE, STOP WATCHING LIVE AND LEAVE ROOM AND DESTROY ZEGO ENGINE

extension PlayLiveStreamingViewController {
    
    private func createEngine(playView:UIView) {
         
         NSLog(" 🚀 Create ZegoExpressEngine")
         let profile = ZegoEngineProfile()
         profile.appID = KeyCenter.appID
         profile.appSign = KeyCenter.appSign
         
         print(KeyCenter.appID)
         print(KeyCenter.appSign)
         
         profile.scenario = .broadcast
         
         ZegoExpressEngine.createEngine(with: profile, eventHandler: self)
         
         ZegoExpressEngine.shared().muteMicrophone(false)
         ZegoExpressEngine.shared().muteSpeaker(false)
         ZegoExpressEngine.shared().enableCamera(true)
         ZegoExpressEngine.shared().enableHardwareEncoder(false)
       //  ZegoExpressEngine.shared().createRealTimeSequentialDataManager("123456")
         
         playCanvas.view = playView
         playCanvas.viewMode = playViewMode
         
         DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
             print("The Stream id in zego is \(self.streamId)")
             self.startLive(roomID: self.roomId, streamID: self.streamId)
             
         }
         
     }

 // MARK: - FUNCTION TO START PLAYING LIVE STREAM / JOIN A LIVE ROOM
    
    private func startLive(roomID: String, streamID: String) {
         NSLog(" 🚪 Start login room, roomID: \(roomID)")
         
         let config = ZegoRoomConfig()
         config.isUserStatusNotify = true
         ZegoExpressEngine.shared().loginRoom(roomID, user: ZegoUser(userID: userId), config: config)
       //  ZegoExpressEngine.shared().createRealTimeSequentialDataManager("123456")
         
         NSLog(" 📥 Start playing stream, streamID: \(streamID)")
         ZegoExpressEngine.shared().startPlayingStream(streamID, canvas: playCanvas)
        
         //updateFirebaseDatabase()
     }

// MARK: - FUNCTION TO LOGOUT FROM LIVE STREAM
    
    private func stopLive(roomID: String) {
         NSLog(" 🚪 Logout room")
         ZegoExpressEngine.shared().logoutRoom(roomID)
         
         videoSize = CGSize(width: 0, height: 0)
         videoRecvFPS = 0.0
         videoDecodeFPS = 0.0
         videoRenderFPS = 0.0
         videoBitrate = 0.0
         videoNetworkQuality = ""
        
     }
  
 // MARK: - FUNCTION TO STOP PLAYING STREAM
    
    private func stopPlayingStream(streamID: String) {
         
         ZegoExpressEngine.shared().stopPlayingStream(streamID)
         
     }
 
  // MARK: - FUNCTION TO DESTROY ZEGO ENGINE
    
    private func destroyEngine() {
         NSLog(" 🏳️ Destroy ZegoExpressEngine")
         ZegoExpressEngine.destroy(nil)
         
     }
     
}
// MARK: - EXTENSION FOR USING ZEGO DELEGATE PROPERTIES AND FUNCTIONS TO KNOW THE JOINED ROOM STATE

extension PlayLiveStreamingViewController: ZegoEventHandler {
    
    func onRoomStateUpdate(_ state: ZegoRoomState, errorCode: Int32, extendedData: [AnyHashable : Any]?, roomID: String) {
        NSLog(" 🚩 🚪 Room state update, state: \(state.rawValue), errorCode: \(errorCode), roomID: \(roomID)")
        roomState = state
        print(errorCode)
        print(state)
        
    }
    
    func onPlayerStateUpdate(_ state: ZegoPlayerState, errorCode: Int32, extendedData: [AnyHashable : Any]?, streamID: String) {
        NSLog(" 🚩 📥 Player state update, state: \(state.rawValue), errorCode: \(errorCode), streamID: \(streamID)")
        playerState = state
        print(state)
        print(errorCode)
        
    }
    
    func onPlayerQualityUpdate(_ quality: ZegoPlayStreamQuality, streamID: String) {
        
        videoRecvFPS = quality.videoRecvFPS
        videoDecodeFPS = quality.videoDecodeFPS
        videoRenderFPS = quality.videoRenderFPS
        videoBitrate = quality.videoKBPS
        isHardwareDecode = quality.isHardwareDecode
        
        switch (quality.level) {
        case .excellent:
            videoNetworkQuality = "☀️"
            break
        case .good:
            videoNetworkQuality = "⛅️"
            break
        case .medium:
            videoNetworkQuality = "☁️"
            break
        case .bad:
            videoNetworkQuality = "🌧"
            break
        case .die:
            videoNetworkQuality = "❌"
            break
        default:
            break
        }
        
    }
    
    func onPlayerVideoSizeChanged(_ size: CGSize, streamID: String) {
      
        videoSize = size
        print(videoSize)
        
    }

    func onRoomUserUpdate(_ updateType: ZegoUpdateType, userList: [ZegoUser], roomID: String) {
    
        print(userList)
        print(userList.count)
        print(roomID)
        print(updateType.rawValue)
        print(userList[0].userID)
        print(userList[0].userName)
        
    }
    
    func onIMRecvBarrageMessage(_ messageList: [ZegoBarrageMessageInfo], roomID: String) {
        
        print(messageList)
        print(messageList.count)
        print(messageList[0].description)
        print(messageList[0].message)
        print(messageList[0].messageID)
        print(messageList[0].fromUser.userName)
        print(messageList[0].fromUser.userID)
        print(messageList[0].fromUser)
        
        var result = messageList[0].message.contains("action_type")
        print(result)
        
        if (result == true) {
          
        print("Pehli condition Shi hai bhai....")
        var result1 = messageList[0].message.contains("kickout_all_user_from_app")
        print(result1)
        
            if result1 == true {
               
                print("Doosri condition bhi shi ho gyi bhai....badhaai ho..nikal lo....")
                stopPlayingStream(streamID: streamId)
                stopLive(roomID: roomID)
                destroyEngine()
                
            } else {
                
                let imageDataDict:[String: String] = ["message": messageList[0].message, "userName": messageList[0].fromUser.userName]
                
            }
            
        }  else {
            
            let imageDataDict:[String: String] = ["message": messageList[0].message, "userName": messageList[0].fromUser.userName]
            
        }
        
    }

    
}
