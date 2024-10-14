//
//  SvgaPlayerViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 05/07/23.
//

import UIKit
import SVGAPlayer

class SvgaPlayerViewController: UIViewController {

    let remoteSVGAUrl = "https://imgzeeplive.oss-ap-south-1.aliyuncs.com/zeepliveStoreImagesAnimation/2023/03/18/1679086469.svga"//"https://gitee.com/jijiucheng/MyFile/raw/master/airplane.svga"
        let localSVGAName = "chat_motion_connection"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
               
               setupSVGAAnimation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create an instance of UIAlertController with style .actionSheet
//        let actionSheet = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet)
//
//        // Add actions to the action sheet
//        actionSheet.addAction(UIAlertAction(title: "Option 1", style: .default) { _ in
//            // Handle option 1 action
//            print("Option 1 selected")
//        })
//
//        actionSheet.addAction(UIAlertAction(title: "Option 2", style: .default) { _ in
//            // Handle option 2 action
//            print("Option 2 selected")
//        })
//
//        // Add cancel action
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
//            // Handle cancel action
//            print("Action sheet canceled")
//        })
//
//        // Present the action sheet on your view controller
//        present(actionSheet, animated: true, completion: nil)

        
        let alertController = UIAlertController(title: "Action Sheet", message: "What would you like to do?", preferredStyle: .actionSheet)

           let sendButton = UIAlertAction(title: "Send now", style: .default, handler: { (action) -> Void in
               print("Ok button tapped")
           })

           let  deleteButton = UIAlertAction(title: "Delete forever", style: .destructive, handler: { (action) -> Void in
               print("Delete button tapped")
           })

           let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
               print("Cancel button tapped")
           })


           alertController.addAction(sendButton)
           alertController.addAction(deleteButton)
           alertController.addAction(cancelButton)

        self.navigationController?.present(alertController, animated: true, completion: nil)
           
       }

    func setupSVGAAnimation() {
            
            //MARK: - Local
            
            let localLabel = UILabel(frame: CGRect(x: 20, y: 100, width: UIScreen.main.bounds.size.width - 20*2, height: 25))
            localLabel.text = "Local SVGA Animation"
            localLabel.textAlignment = .center
            localLabel.font = UIFont.boldSystemFont(ofSize: 18)
            view.addSubview(localLabel)
            
            let localSVGAPlayer = SVGAPlayer(frame: CGRect(x: 20, y: 150, width: 130, height: 130))
            localSVGAPlayer.backgroundColor = .darkGray
            localSVGAPlayer.delegate = self
            localSVGAPlayer.loops = 0       // repeat count，0 means infinite
            localSVGAPlayer.clearsAfterStop = false     // Remove or clear after stop
            view.addSubview(localSVGAPlayer)

            let localSVGAParser = SVGAParser()
            localSVGAParser.parse(withNamed: localSVGAName, in: nil, completionBlock: { (svgaItem) in
                localSVGAPlayer.videoItem = svgaItem
                localSVGAPlayer.startAnimation()
            }, failureBlock: nil)
            
            
            //MARK: - Remote
            
            let remoteLabel = UILabel(frame: CGRect(x: 20, y: 400, width: UIScreen.main.bounds.size.width - 20*2, height: 25))
            remoteLabel.text = "Remote SVGA Animation"
            remoteLabel.textAlignment = .center
            remoteLabel.font = UIFont.boldSystemFont(ofSize: 18)
            view.addSubview(remoteLabel)

            let remoteSVGAPlayer = SVGAPlayer(frame: CGRect(x: 20, y: 450, width: 150, height: 150))
            remoteSVGAPlayer.backgroundColor = .darkGray
            view.addSubview(remoteSVGAPlayer)

            if let url = URL(string: remoteSVGAUrl) {
                let remoteSVGAParser = SVGAParser()
                remoteSVGAParser.parse(with: url, completionBlock: { (svgaItem) in
                    remoteSVGAPlayer.videoItem = svgaItem
                    remoteSVGAPlayer.startAnimation()
                }, failureBlock: { (error) in
                    print("--------------------- \(String(describing: error))")
                })
            }
        }
    }

extension SvgaPlayerViewController: SVGAPlayerDelegate {
    
    /// SVGA animation progress
    func svgaPlayerDidAnimated(toPercentage percentage: CGFloat) {
        print("precent ------- \(percentage)")
    }
    
    /// SVGA frame index with images resource
    func svgaPlayerDidAnimated(toFrame frame: Int) {
        print("frame ------- \(frame)")
    }
    
    /// doing after SVGA animation end or stop
    func svgaPlayerDidFinishedAnimation(_ player: SVGAPlayer!) {
        print("play end ---------------")
    }
}
