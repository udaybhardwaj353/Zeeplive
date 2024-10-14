//
//  GiftManagerClass.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 16/01/24.
//

import Foundation
import UIKit
import Lottie
import SVGAPlayer
import AVFoundation
import SwiftUI
import BDAlphaPlayer
import SwiftyJSON

class ZLGiftManager: NSObject, AVAudioPlayerDelegate, SVGAPlayerDelegate, BDAlphaPlayerMetalViewDelegate {
    
    weak var presentVC = UIViewController()
    static let share = ZLGiftManager()
    let group = DispatchGroup()
    var giftData = [giftResult]()
    var currentGift: Gift?
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var audioPlayer: AVAudioPlayer?
    var animationView: LottieAnimationView?
    var metalView : BDAlphaPlayerMetalView?
    var configurations = BDAlphaPlayerMetalConfiguration()
    
    lazy var svgaPlayer: SVGAPlayer = {
        let v = SVGAPlayer(frame: UIScreen.main.bounds)
        v.contentMode = .scaleAspectFit
        v.isUserInteractionEnabled = false
        v.delegate = self
        v.loops = 1
        return v
    }()
    lazy var giftList = [giftResult]()
    
    var isMp3Finished: Bool?
    var isSvgaFinished: Bool?
    
    // MARK: - gift source download
    func isFileExists(atPath path: String) -> Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: path)
    }
    
    func isDirectoryExists(atPath path: String) -> Bool {
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        return fileManager.fileExists(atPath: path, isDirectory: &isDirectory) && isDirectory.boolValue
    }
    
    func loadAllGiftFile() {
        var needLoadGift = [Gift]()
        for categoryList in giftList {
            for gift in categoryList.gifts! {
                let giftFilePath = GlobalClass.sharedInstance.documentsPath.appendingPathComponent(String(format: "gift/%d", gift.id!))
                if !isDirectoryExists(atPath: giftFilePath) {
                    needLoadGift.append(gift)
                }
            }
        }
        
        if needLoadGift.count > 0 {
            for loadGift in needLoadGift {
                loadGiftFile(gift: loadGift,isplay: false)
            }
        }
        group.notify(queue: .main) {
            print("All downloads are complete.")
        }
    }
    
    func loadGiftFile(gift: Gift,isplay : Bool) {
        let soundFile = gift.soundFile
        let animationFile = gift.animationFile
        
        // load animation file
        var giftFilePath = GlobalClass.sharedInstance.documentsUrl.appendingPathComponent(String(format: "gift/%d", gift.id!))
        
        do{
            if !FileManager.default.fileExists(atPath: giftFilePath.path) {
                try FileManager.default.createDirectory(at: giftFilePath, withIntermediateDirectories: true, attributes: nil)
            }
        }catch{}
        
        var sourceType = "svga"
        if gift.animationType == 2 {
            sourceType = "json"
        } else if gift.animationType == 3 {
            sourceType = "mp4"
        }
        giftFilePath = giftFilePath.appendingPathComponent(String(format: "%d.%@", gift.id!, sourceType))
        
        if (animationFile?.count ?? 0) > 0 {
            group.enter()
            ApiWrapper.sharedManager().downloadFile(fileURL: URL(string: animationFile!)!, destinationURL: giftFilePath) { result in
                print(result)
                self.group.leave()
                //            if isplay {
                //                self.prepareGiftList.append(gift)
                //                self.checkPrepareGiftList(isMp4: false)
                //            }
            }
        }
        
        // load sound file
        if (soundFile?.count ?? 0) > 0 {
            group.enter()
            let giftPath = GlobalClass.sharedInstance.documentsUrl.appendingPathComponent(String(format: "gift/%d", gift.id!))
            let soundFilePath = giftPath.appendingPathComponent(String(format: "%d.mp3", gift.id!))
            ApiWrapper.sharedManager().downloadFile(fileURL: URL(string: soundFile!)!, destinationURL: soundFilePath) { result in
                print(result)
                self.group.leave()
            }
        }
        if ("mp4" == sourceType){
            let fileName = String(format: "%d.mp4", gift.id!)
            let portMap = ["align" : 2,"path":fileName] as [String : Any]
            let landMap = ["align" : 8,"path":fileName] as [String : Any]
            let map = ["portrait":portMap,"landscape":landMap]
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: map, options: []) {
                let jsonString = String(data: jsonData, encoding: .utf8)
                var configFilePath = GlobalClass.sharedInstance.documentsUrl.appendingPathComponent(String(format: "gift/%d/config.json", gift.id!))
                do {
                    try jsonString!.write(to: configFilePath, atomically: false, encoding: .utf8)
                }catch {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func remove() {
    
        metalView?.stop()
            player = nil
               playerLayer = nil
               audioPlayer = nil
               animationView = nil
               metalView = nil
               svgaPlayer.stopAnimation()
            
    }
    
    func playAnimation(gift: Gift, vc: UIViewController) {
        DispatchQueue.main.async { [weak self, weak vc] in
                guard let self = self else { return }
                
                // Check if vc is still alive before accessing its view property
                guard let viewController = vc else {
                    // Handle the case where vc is nil
                    return
                }
             
            // 检测当前控制器是直播间
            if self.metalView != nil {
                self.metalView?.stop()
            } else if self.animationView != nil {
                self.animationView?.stop()
            }
            if self.svgaPlayer != nil {
                self.svgaPlayer.stopAnimation()
            }
            
            var sourceType = "svga"
            if gift.animationType == 2 {
                sourceType = "json"
            } else if gift.animationType == 3 {
                sourceType = "mp4"
            }
            
            let a = type(of: gift.id!)
            print("The type of gift id is: \(a)")
            
            print("The animation type here is: \(gift.animationType)")
            
            print("The gift id we are looking for is: \(gift.id!)")
            
            let giftFilePath = GlobalClass.sharedInstance.documentsUrl.appendingPathComponent(String(format: "gift/%d/%d.%@", (gift.id)!,(gift.id)!,sourceType))
            
            print("the gift file path is: \(giftFilePath)")
           
            
            if !FileManager.default.fileExists(atPath: giftFilePath.path) {
                group.notify(queue: .main) {
                    print("gift downloads are complete.")
                    self.playAnimation(gift: gift, vc: viewController)
                }
                self.loadGiftFile(gift: gift, isplay: false)
                //checkPrepareGiftList(isMp4: false)
                return
            }
//            guard let giftId = gift.id else {
//                return
//            }
//            guard let giftName = gift.giftName else {
//                return
//            }
            
//            print("the gift name is: \(giftName)")
//            print("The of gift id is: \(giftId)")
            
            self.currentGift = gift
            self.presentVC = viewController
            
            if gift.animationType == 3 {
                let mp4Path = GlobalClass.sharedInstance.documentsUrl.appendingPathComponent(String(format: "gift/%d/", (gift.id!)))
                self.metalView?.isHidden = false
                self.metalView = BDAlphaPlayerMetalView(delegate: self)
                self.metalView?.isUserInteractionEnabled = false
                self.metalView?.frame = CGRect(x: 0, y: 0, width: GlobalClass.sharedInstance.SCREEN_WIDTH, height: GlobalClass.sharedInstance.SCREEN_HEIGHT)
                viewController.view.addSubview(self.metalView!)
                viewController.view.isUserInteractionEnabled = false
                if let reelsViewController = presentVC as? ReelsViewController {
                    viewController.view.isUserInteractionEnabled = true
                } else {
                    viewController.view.isUserInteractionEnabled = false
                }
               // self.presentVC = viewController
                
                let configuration = BDAlphaPlayerMetalConfiguration()
                configuration.directory = mp4Path.path
                configuration.renderSuperViewFrame = viewController.view.frame
                configuration.orientation = .portrait;
                self.metalView?.play(with: configuration)
                configurations = configuration
                
            } else {
                let soundPath = GlobalClass.sharedInstance.documentsUrl.appendingPathComponent(String(format: "gift/%d/%d.mp3", (gift.id)!, (gift.id)!))
                self.audioPlayer = try? AVAudioPlayer(contentsOf: soundPath)
                self.audioPlayer?.delegate = self
                self.audioPlayer?.prepareToPlay()
                self.audioPlayer?.play()
                
                if gift.animationType == 1 {
                    let svgaPath = GlobalClass.sharedInstance.documentsUrl.appendingPathComponent(String(format: "gift/%d/%d.svga", (gift.id)!, (gift.id)!))
                    let parser = SVGAParser()
                    parser.parse(with: svgaPath) { (videoItem) in
                        print("videoItem=======")
                        print(videoItem as Any)
                        self.svgaPlayer.videoItem = videoItem
                        self.svgaPlayer.startAnimation()
                    } failureBlock: { (error) in
                        //        self.checkPrepareGiftList(isMp4: false)
                        print("SVGA parsing error: \(String(describing: error))")
                    }
                    viewController.view.addSubview(self.svgaPlayer)
                }
                
                if gift.animationType == 2 {
                    let jsonPath = GlobalClass.sharedInstance.documentsPath.appendingPathComponent(String(format: "gift/%d/%d.json", (gift.id)!, (gift.id)!))
                    self.animationView?.isHidden = false
                    self.animationView = LottieAnimationView(filePath: jsonPath)
                    self.animationView?.loopMode = .playOnce
                    self.animationView?.frame = UIScreen.main.bounds
                    viewController.view.addSubview(self.animationView!)
                    self.animationView?.play { _ in
                        self.animationView?.removeFromSuperview()
                        if self.isMp3Finished == true {
                            //             self.checkPrepareGiftList(isMp4: false)
                        } else {
                            self.isSvgaFinished = true
                        }
                    }
                }
            }
        }
    }


    
    func metalView(_ metalView: BDAlphaPlayerMetalView, didFinishPlayingWithError error: Error) {
        
       // metalView.removeFromSuperview()
      //  checkPrepareGiftList(isMp4: false)
        print("The current view controller is: \(presentVC)")
        
            metalView.removeFromSuperview()
            presentVC?.view.isUserInteractionEnabled = true
            remove()
            print("The current view controller not playing reels video.")
       // remove()
        //presentVC?.removeFromParent()
        
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        playerLayer.removeFromSuperlayer()
       // checkPrepareGiftList(isMp4: true)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("Audio playback finished successfully")
        } else {
            print("Audio playback finished with an error")
        }
        if self.isSvgaFinished == true {
          //  self.checkPrepareGiftList(isMp4: false)
        } else {
            self.isMp3Finished = true
        }
    }
    
    
    
    func svgaPlayerDidFinishedAnimation(_ player: SVGAPlayer!) {
        svgaPlayer.removeFromSuperview()
        
        if isMp3Finished == true {
            //self.checkPrepareGiftList(isMp4: false)
            isMp3Finished = false
        } else {
            self.isSvgaFinished = true
        }
    }
    
    func getGiftFromServer() {
        // gift list
        DispatchQueue.global(qos: .background).async {
            ApiWrapper.sharedManager().getGiftsList(url: AllUrls.getUrl.getAllGifts) { [weak self] (data, value) in
                guard let self = self else { return }
             
                
                if (value["success"] as? Bool == true) {
                    print(data)
                    print(value)
                    
                    print(data?.count)
                    giftList = data ?? giftList
                    print("The gift list count is: \(giftList.count)")
                    GiftsManager.shared.giftResults = giftList
                    print("The number of gifts in the giftsmanager store is: \(GiftsManager.shared.giftResults?.count)")
                    loadAllGiftFile()
                    
                } else {
                    
                    print("Image wale data main success false aa rha hai")
                    
                }
            }
        }
    }

 // MARK - Function to send FCM token to the backend
    
    func sendFCMToken(token:String) {
        
        let params = [
            "token": token ,//UserDefaults.standard.string(forKey: "Firebasetoken") ?? "",
            "app_version": GlobalClass.sharedInstance.appVersion ?? "1.0"
           
        ] as [String : Any]
        
        print("The params we are sending for fcm token is: \(params)")
        
        ApiWrapper.sharedManager().sendFcmTokenToBackend(url: AllUrls.getUrl.updateFcmToken,parameters: params ,completion: { [weak self] (data) in
            guard let self = self else {
                // The object has been deallocated
               
                return
            }
                print(data)
                print("Sab kuch sahi hai")
                
            if (data["success"] as? Bool == true) {
                
                print("Api se response true aaya hai. matlab data aaya hai.")
               
            } else {
                
                print("Api se response mai false aaya hai. matlab kuch gadbad hai.")
               
                
            }
                
           
        })
    }
    
}

//    func playAnimation(gift: Gift,vc:UIViewController) {
//        // 检测当前控制器是直播间
//
//        if (metalView != nil)  {
//
//            metalView?.stop()
//
//        } else if (animationView != nil) {
//            animationView?.stop()
//
//        }
//        if svgaPlayer != nil {
//
//            svgaPlayer.stopAnimation()
//
//        }
//
//        var sourceType = "svga"
//        if gift.animationType == 2 {
//            sourceType = "json"
//        } else if gift.animationType == 3 {
//            sourceType = "mp4"
//        }
//        let giftFilePath = GlobalClass.sharedInstance.documentsUrl.appendingPathComponent(String(format: "gift/%d/%d.%@", (gift.id)!,(gift.id)!,sourceType))
//
//        if !FileManager.default.fileExists(atPath: giftFilePath.path) {
//            group.notify(queue: .main) {
//                print("gift downloads are complete.")
//                self.playAnimation(gift: gift, vc: vc)
//            }
//            loadGiftFile(gift: gift,isplay: false)
//            //checkPrepareGiftList(isMp4: false)
//            return
//        }
//        guard let giftId = gift.id else {
//            return
//        }
//        guard let giftName = gift.giftName else {
//            return
//        }
//
//        currentGift = gift
//
//        if gift.animationType == 3 {
//            let mp4Path = GlobalClass.sharedInstance.documentsUrl.appendingPathComponent(String(format: "gift/%d/", giftId))
//            metalView?.isHidden = false
//            metalView = BDAlphaPlayerMetalView(delegate: self)
//            metalView?.isUserInteractionEnabled = false
//            metalView?.frame = CGRect(x: 0, y: 0, width: GlobalClass.sharedInstance.SCREEN_WIDTH, height: GlobalClass.sharedInstance.SCREEN_HEIGHT)
//            vc.view.addSubview(metalView!)
//            vc.view.isUserInteractionEnabled = false
//            presentVC = vc
//
//            let configuration = BDAlphaPlayerMetalConfiguration()
//            configuration.directory = mp4Path.path
//            configuration.renderSuperViewFrame = vc.view.frame
//            configuration.orientation = .portrait;
//            metalView?.play(with: configuration)
//
//
//        } else {
//
//            let soundPath = GlobalClass.sharedInstance.documentsUrl.appendingPathComponent(String(format: "gift/%d/%d.mp3", giftId, giftId))
//            audioPlayer = try? AVAudioPlayer(contentsOf: soundPath)
//            audioPlayer?.delegate = self
//            audioPlayer?.prepareToPlay()
//            audioPlayer?.play()
//            if gift.animationType == 1 {
//                let svgaPath = GlobalClass.sharedInstance.documentsUrl.appendingPathComponent(String(format: "gift/%d/%d.svga", giftId, giftId))
//                let parser = SVGAParser()
//                parser.parse(with: svgaPath) { (videoItem) in
//                    print("videoItem=======")
//                    print(videoItem as Any)
//                    self.svgaPlayer.videoItem = videoItem
//                    self.svgaPlayer.startAnimation()
//
//                } failureBlock: { (error) in
//            //        self.checkPrepareGiftList(isMp4: false)
//                    print("SVGA parsing error: \(String(describing: error))")
//                }
//                vc.view.addSubview(svgaPlayer)
//            }
//
//            if gift.animationType == 2 {
//                let jsonPath = GlobalClass.sharedInstance.documentsPath.appendingPathComponent(String(format: "gift/%d/%d.json", giftId, giftId))
//                animationView?.isHidden = false
//                animationView = LottieAnimationView(filePath: jsonPath)
//                animationView?.loopMode = .playOnce
//                animationView?.frame = UIScreen.main.bounds
//                vc.view.addSubview(animationView!)
//                animationView?.play { _ in
//                    self.animationView?.removeFromSuperview()
//                    if self.isMp3Finished == true {
//           //             self.checkPrepareGiftList(isMp4: false)
//                    } else {
//                        self.isSvgaFinished = true
//                    }
//                }
//            }
//        }
//    }
