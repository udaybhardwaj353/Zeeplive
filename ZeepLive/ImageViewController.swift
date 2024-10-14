//
//  ImageViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 11/05/23.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    let urlStr = "https://cdn.pixabay.com/photo/2017/05/07/08/56/pancakes-2291908_960_720.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.loadImageWithUrl(urlString: urlStr)
        
    }
    

}

extension UIImageView {
    
    func loadImageWithUrl(urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                if let unwrappedError = error {
                    print(unwrappedError)
                    return
                }
                
                if let unwrappedData = data {
                    let image = UIImage(data: unwrappedData)
                    DispatchQueue.main.async(execute: {
                        self.image = image
                    })
                }
                
            }
            dataTask.resume()
        }
    }
}
