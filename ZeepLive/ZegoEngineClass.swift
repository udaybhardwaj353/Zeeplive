//
//  ZegoEngineClass.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 08/05/24.
//

import Foundation
import ZegoExpressEngine

class ZegoManager {
    static let shared = ZegoManager()
    private var engineInitialized = false
    
    var engine: ZegoExpressEngine?
  //  lazy var playCanvas = ZegoCanvas()
    
    private init() {}
    
    func initializeEngine() {
        NSLog(" 🚀 Create ZegoExpressEngine")
        let profile = ZegoEngineProfile()
        profile.appID = KeyCenter.appID
        profile.appSign = KeyCenter.appSign
        profile.scenario = .broadcast//ZegoScenario.general
        
        print(KeyCenter.appID)
        print(KeyCenter.appSign)
        
        ZegoExpressEngine.setRoomMode(.multiRoom)
        engine = ZegoExpressEngine.createEngine(with: profile, eventHandler: nil)
        
        engine?.muteMicrophone(false)
        engine?.muteSpeaker(false)
        engine?.enableCamera(true)
        engine?.enableHardwareEncoder(false)
        let videoConfig = ZegoVideoConfig()
        videoConfig.fps = 30
        videoConfig.bitrate = 2400
        ZegoExpressEngine.shared().setVideoConfig(videoConfig)
        ZegoExpressEngine.shared().setVideoMirrorMode(ZegoVideoMirrorMode.onlyPreviewMirror)
        
    }
    
    func initializeHostEngine() {
        guard !engineInitialized else {
                 NSLog("Engine already initialized")
                 return
             }
             
             NSLog("🚀 Create ZegoExpressEngine")
             let profile = ZegoEngineProfile()
             profile.appID = KeyCenter.appID
             profile.appSign = KeyCenter.appSign
             profile.scenario = .broadcast
             
             ZegoExpressEngine.createEngine(with: profile, eventHandler: nil)
             
             ZegoExpressEngine.shared().enableHardwareEncoder(false)
             
             // Configure video settings
             let videoConfig = ZegoVideoConfig()
             videoConfig.fps = 30
             videoConfig.bitrate = 2400
             ZegoExpressEngine.shared().setVideoConfig(videoConfig)
             ZegoExpressEngine.shared().setVideoMirrorMode(ZegoVideoMirrorMode.onlyPreviewMirror)
             
             NSLog("🔌 Start preview")
             
             engineInitialized = true
        
    }
    
}

//        playCanvas.viewMode = ZegoViewMode.aspectFill
//        // Set video configuration
//          let videoConfig = ZegoVideoConfig(preset: .preset1080P)
//          videoConfig.fps = 30
//          videoConfig.bitrate = 2400
//          engine?.setVideoConfig(videoConfig)

