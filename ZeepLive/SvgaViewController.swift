//
//  SvgaViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 07/07/23.
//

import UIKit
import SVGAPlayer

class SvgaViewController: UIViewController, SVGAPlayerDelegate {

    @IBOutlet weak var aPlayer: SVGAPlayer!
    private var parser: SVGAParser!
    
    private var isAnimationStarted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

            aPlayer.delegate = self
              aPlayer.loops = 1
              aPlayer.clearsAfterStop = false
              parser = SVGAParser()
              
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
        parser.parse(with: URL(string: "https://imgzeeplive.oss-ap-south-1.aliyuncs.com/zeepliveStoreImagesAnimation/2023/03/18/1679086469.svga")!) { videoItem in
                   UIApplication.shared.isNetworkActivityIndicatorVisible = false
                   if let videoItem = videoItem {
                       self.aPlayer.videoItem = videoItem
                       let para = NSMutableParagraphStyle()
                       para.lineBreakMode = .byTruncatingTail
                       para.alignment = .center
                       let str = NSAttributedString(string: "Hello, World! Hello, World!", attributes: [
                           NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28),
                           NSAttributedString.Key.foregroundColor: UIColor.white,
                           NSAttributedString.Key.paragraphStyle: para
                       ])
                       self.aPlayer.contentMode = .scaleToFill

                       self.aPlayer.setAttributedText(str, forKey: "banner")
                       self.aPlayer.startAnimation()
                   }
               } failureBlock: { error in
                   print("Parsing failed: \(error)")
               }
        
    }
    
    func svgaPlayerDidAnimated(toPercentage percentage: CGFloat) {
         //  aSlider.value = Float(percentage)
            print(Float(percentage))
        if !isAnimationStarted {
                    isAnimationStarted = true
                    print("Animation started")
                }
       }
       
       func svgaPlayerDidFinishedAnimation(_ player: SVGAPlayer) {
         //  onBeginButton.isSelected = true
           print(player)
           isAnimationStarted = false
                  print("Animation finished")
       }
    
}
