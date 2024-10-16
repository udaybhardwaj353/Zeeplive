//
//  ExtensionsAdditionViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 14/04/23.
//

import UIKit
import Kingfisher
import CryptoKit
import CommonCrypto
import AVFoundation
import CommonCrypto
import CoreImage

class ExtensionsAdditionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
}

extension UITableViewCell {
    
    func addGradient(to button: UIButton, width: CGFloat, height: CGFloat, cornerRadius: CGFloat, startColor: UIColor, endColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        gradientLayer.colors = [
            startColor.cgColor,
            endColor.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = cornerRadius  // Set the corner radius for the gradient layer

        // Inserting the gradient layer below all other layers
        button.layer.insertSublayer(gradientLayer, at: 0)
        
        // Adjusting the button's corner radius
        button.layer.cornerRadius = cornerRadius
        
        // Clipping the button's sublayers to its bounds
        button.clipsToBounds = true
    }
    
}


extension UIView {
    
    func applyGradientBackgroundView(colors: [UIColor], locations: [NSNumber]? = nil, startPoint: CGPoint = CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint = CGPoint(x: 1.0, y: 0.5)) {
        
        // Remove existing gradient layers
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
//    override open func layoutSubviews() {
//        super.layoutSubviews()
//        // Reapply the gradient when the view's bounds change
//        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.frame = bounds }
//    }
}

// Generate a random alphanumeric string of a specified length . Added on 1st February
func generateRandomString(length: Int) -> String {
    let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let randomString = String((0..<length).map { _ in characters.randomElement()! })
    return randomString
}

// Function for getting the settings value and check if the given setting is present or not.

func getSettingValue(forKey key: String, settings: [settingsResult]?) -> (isPresent: Bool, value: String?) {
    if let settings = settings,
        let gameSetting = settings.first(where: { $0.settingKey == key }) {
        if let value = gameSetting.settingValue {
            print("The setting '\(key)' is present with value: \(value)")
            return (true, value)
        } else {
            print("The setting '\(key)' is present, but its value is not available.")
            return (true, nil)
        }
    } else {
        print("The setting '\(key)' is not present.")
        return (false, nil)
    }
}

// MARK: - Function to blur the image to show in background when the user is busy on a call . Added on 29 January

func blurImage(image: UIImage) -> UIImage? {
    guard let ciImage = CIImage(image: image) else {
        return nil
    }

    let filter = CIFilter(name: "CIGaussianBlur")
    filter?.setValue(ciImage, forKey: kCIInputImageKey)
    filter?.setValue(10.0, forKey: kCIInputRadiusKey) // Adjust the blur radius as needed

    guard let outputCIImage = filter?.outputImage else {
        return nil
    }

    let context = CIContext()
    guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
        return nil
    }

    return UIImage(cgImage: cgImage)
}


// MARK: - function to show the weekly coins of the user in the live broad section

func formatNumber(_ number: Int) -> String {
    if number < 1000 {
        return "\(number)"
    } else {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .down
        
        let formattedNumber = Double(number) / 1000.0
        
        if let formattedString = formatter.string(from: NSNumber(value: formattedNumber)) {
            return "\(formattedString)K"
        } else {
            return "\(formattedNumber)K"
        }
    }
}

// MARK: - function to show the attributed gift string in the live message section

func formatAttributedString(giftCount: String, sendGiftName: String, sendGiftTo: String, sendGiftToColor: UIColor) -> NSAttributedString {
    // Create the full string
    let fullString = "Send \(giftCount) \(sendGiftName) to \(sendGiftTo)"
    
    // Create an attributed string
    let attributedString = NSMutableAttributedString(string: fullString)
    
    // Find the range of the 'sendGiftTo' part in the full string
    if let sendGiftToRange = fullString.range(of: sendGiftTo) {
        let nsRange = NSRange(sendGiftToRange, in: fullString)
        
        // Apply the color to the 'sendGiftTo' part
        attributedString.addAttribute(.foregroundColor, value: sendGiftToColor, range: nsRange)
    }
    
    return attributedString
}

// Added on 20 December for the generation of hashkey use

func hexString(_ iterator:Array<UInt8>.Iterator) -> String{
    return iterator.map{
        String(format: "%02x", $0)
    }.joined().uppercased() //字符串转成大写
}

extension UIViewController {
    
    // Function to show loader
      func showLoader() {
          // Create and configure the loader
          let loader = UIActivityIndicatorView(style: .large)
          loader.color = .gray
          loader.translatesAutoresizingMaskIntoConstraints = false
          loader.tag = 999 // A tag to identify the loader
          
          // Add the loader to the view
          self.view.addSubview(loader)
          
          // Center the loader in the view
          NSLayoutConstraint.activate([
              loader.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
              loader.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
          ])
          
          // Start animating the loader
          loader.startAnimating()
      }
      
      // Function to hide loader
      func hideLoader() {
          // Find the loader by tag and remove it from the view
          if let loader = self.view.viewWithTag(999) as? UIActivityIndicatorView {
              loader.stopAnimating()
              loader.removeFromSuperview()
          }
      }
    
    func stripHTMLTags(from string: String) -> String {
        // Define a regular expression pattern to match HTML tags
        let pattern = "<[^>]+>"
        
        // Create a regular expression object
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        // Replace all matches of the pattern with an empty string
        let range = NSRange(location: 0, length: string.utf16.count)
        let htmlLessString = regex?.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "") ?? string
        
        return htmlLessString
    }
    
    func replaceNumbersWithAsterisks(_ string: String) -> String {
        let regex = try! NSRegularExpression(pattern: "[0-9]")
        let range = NSRange(location: 0, length: string.utf16.count)
        return regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "*")
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func performSegueToReturnBack()  {
          if let nav = self.navigationController {
              nav.popViewController(animated: true)
          } else {
              self.dismiss(animated: true, completion: nil)
          }
      }
    
    func openWebView(withURL url: String) {
           if let webViewVC = storyboard?.instantiateViewController(withIdentifier: "WebViewViewController") as? WebViewViewController {
               webViewVC.url = url
               self.navigationController?.pushViewController(webViewVC, animated: true)
           }
       }
    

    // MARK: - FUNCTION TO LOAD IMAGE FROM GIVEN URL AND SET IMAGE TO THE GIVEN IMAGE VIEW
    
    func loadImage(from urlString: String?, into imageView: UIImageView) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            imageView.image = UIImage(named: "UserPlaceHolderImageForCell")
            return
        }

        KF.url(url)
            .cacheOriginalImage()
            .onSuccess { result in
                DispatchQueue.main.async {
                    imageView.image = result.image
                }
            }
            .onFailure { error in
                print("Image loading failed with error: \(error)")
                imageView.image = UIImage(named: "UserPlaceHolderImageForCell")
            }
            .set(to: imageView)
    }

    
 // MARK: - FUNCTION TO CONVERT "Mon May 22 2023 ~ Sun May 28 2023" LIKE DATE INTO 19/JUN - 25/JUN FORMAT
    
    func convertDateRange(dateRange: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM d yyyy"
        
        let components = dateRange.components(separatedBy: " ~ ")
        
        if let startDate = dateFormatter.date(from: components[0]), let endDate = dateFormatter.date(from: components[1]) {
            dateFormatter.dateFormat = "d.MMM"
            
            let startDateString = dateFormatter.string(from: startDate)
            let endDateString = dateFormatter.string(from: endDate)
            
            return "\(startDateString) - \(endDateString)"
        }
        
        return nil
    }
    
    func compareDates(date1: Date, date2: Date) -> ComparisonResult {
        return date1.compare(date2)
    }
    
    func showAlert(title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
  
    func showAlertwithButtonAction(title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
        
            self.navigationController?.popViewController(animated: true)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func downloadImage(from url: URL, into imageView: UIImageView) {

        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)

    }
    
    func downloadImageFromURL(_ urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let downloader = ImageDownloader.default
        let options: KingfisherOptionsInfo = [
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(0.5))
        ]

        downloader.downloadImage(with: url, options: options) { result in
            switch result {
            case .success(let value):
                completion(value.image)
            case .failure(let error):
                print("Error downloading image: \(error)")
                completion(nil)
            }
        }
    }

    
    func setGradientBackground(for button: UIButton, colorLeft: UIColor, colorMiddle: UIColor, colorRight: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.colors = [colorLeft.cgColor, colorMiddle.cgColor, colorRight.cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        button.layer.insertSublayer(gradientLayer, at: 0)
    }


 // MARK: - FUNCTION TO CALCULATE THE NO. OF YEARS DIFFERENCE BETWEEN CURRENT DATE AND GIVEN DATE
    
    func calculateYearDifference(from dateString: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" //"yyyy-MM-dd" // Format of the input date string
        
        // Convert the input date string to a Date object
        guard let date = dateFormatter.date(from: dateString) else {
            return nil // Return nil if the date conversion fails
        }
        
        let calendar = Calendar.current
        
        // Calculate the difference in years between the current date and the input date
        let currentDate = Date()
        let dateComponents = calendar.dateComponents([.year], from: date, to: currentDate)
        
        return dateComponents.year
    }
    
    // MARK: - FUNCTION TO CALCULATE THE NO. OF YEARS DIFFERENCE BETWEEN CURRENT DATE AND GIVEN DATE FOR SEARCH LIST USERS
       
       func calculateYearDifferenceForSearchList(from dateString: String) -> Int? {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MM-dd-yyyy" //"yyyy-MM-dd" // Format of the input date string
           
           // Convert the input date string to a Date object
           guard let date = dateFormatter.date(from: dateString) else {
               return nil // Return nil if the date conversion fails
           }
           
           let calendar = Calendar.current
           
           // Calculate the difference in years between the current date and the input date
           let currentDate = Date()
           let dateComponents = calendar.dateComponents([.year], from: date, to: currentDate)
           
           return dateComponents.year
       }
    
    func timeFormatted(_ totalSeconds: Int) -> String {     // Added on 20 December
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func viewGradient(view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        let endColor = UIColor.white.cgColor
        let startColor = UIColor.white.withAlphaComponent(0.0).cgColor
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)

        // Insert the gradient layer below any existing layers
        if let existingLayers = view.layer.sublayers {
            view.layer.insertSublayer(gradientLayer, at: UInt32(existingLayers.count))
        } else {
            view.layer.insertSublayer(gradientLayer, at: 0)
        }

        // Set the corner radius of the view
        view.layer.cornerRadius = view.bounds.height / 2
        view.clipsToBounds = true
    }
    
//    func viewGradient(view: UIView) {                  // Added on 21 December for giving gradient to lines in the first page
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = view.bounds
//        let endColor = UIColor.white.cgColor
//        let startColor = UIColor.white.withAlphaComponent(0.0).cgColor
//        gradientLayer.colors = [startColor, endColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
//        
//       // view.layer.cornerRadius = view.frame.height / 2
//        
//        view.layer.insertSublayer(gradientLayer, at: 0)
//        gradientLayer.cornerRadius = view.frame.height/2
//    }
    
    func viewGradientRight(view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        let startColor =  UIColor.white.cgColor
        let endColor = UIColor.white.withAlphaComponent(0.0).cgColor
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
       // view.layer.cornerRadius = view.frame.height / 2
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.cornerRadius = view.frame.height/2
        
    }
    
    // Added on 26 December for giving gradient on the background of submit button on gender choose page
    
//    func addGradient(to button: UIButton, width: CGFloat, height: CGFloat, cornerRadius: CGFloat) {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
//        gradientLayer.colors = [
//            UIColor(hexString: "EA55FF")?.cgColor as Any,
//            UIColor(hexString: "A659FD")?.cgColor as Any
//        ]
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        gradientLayer.cornerRadius = cornerRadius  // Set the corner radius for the gradient layer
//
//        // Inserting the gradient layer below all other layers
//        button.layer.insertSublayer(gradientLayer, at: 0)
//        
//        // Adjusting the button's corner radius
//        button.layer.cornerRadius = cornerRadius
//        
//        // Clipping the button's sublayers to its bounds
//        button.clipsToBounds = true
//    }

    func addGradient(to button: UIButton, width: CGFloat, height: CGFloat, cornerRadius: CGFloat, startColor: UIColor, endColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        gradientLayer.colors = [
            startColor.cgColor,
            endColor.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = cornerRadius  // Set the corner radius for the gradient layer

        // Inserting the gradient layer below all other layers
        button.layer.insertSublayer(gradientLayer, at: 0)
        
        // Adjusting the button's corner radius
        button.layer.cornerRadius = cornerRadius
        
        // Clipping the button's sublayers to its bounds
        button.clipsToBounds = true
    }

    

    // Added on 7 February for giving gradient to the view with two different colours
    
    func addGradientToView(to view: UIView, cornerRadius: CGFloat, colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
            gradientLayer.frame = view.bounds
            gradientLayer.colors = colors.map { $0.cgColor }
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            gradientLayer.cornerRadius = cornerRadius
            
            // Adding the gradient layer to the view's layer
            view.layer.insertSublayer(gradientLayer, at: 0)
    }

    
    // ADDED ON 27 DECEMBER TO DOWNLOAD IMAGE AND ASSIGN IT TO A VARIABLE OF TYPE IMAGE
    
    func downloadImageLocal(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let downloader = ImageDownloader.default
        let processor = DownsamplingImageProcessor(size: CGSize(width: 100, height: 100)) // Adjust size as needed

        downloader.downloadImage(with: url, options: [.processor(processor)], progressBlock: nil) { result in
            switch result {
            case .success(let value):
                completion(value.image)
            case .failure(let error):
                print("Error downloading image: \(error)")
                completion(nil)
            }
        }
    }
    
    func convertDateStringForMoment(_ dateString: String) -> String? {
        let fromFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ" // Input date format
        let toFormat = "E MMM dd yyyy" // Output date format
        let locale = Locale(identifier: "en_US_POSIX") // Locale for date parsing

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.locale = locale

        guard let date = dateFormatter.date(from: dateString) else {
            return nil // Failed to convert the date string
        }

        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: date)
    }
     // Added On 4 January to generate thumbnail image from the video url
    
    func generateThumbnail(from videoURL: URL) -> UIImage? {
            let asset = AVAsset(url: videoURL)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            
            do {
                let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
                return UIImage(cgImage: cgImage)
            } catch {
                print("Error generating thumbnail: \(error.localizedDescription)")
                return nil
            }
        }
    
//    func formatTimestampForCommentList(_ timestampString: String) -> String {   // Added on 5 January for time format in comment list
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        
//        if let date = dateFormatter.date(from: timestampString) {
//            let outputDateFormatter = DateFormatter()
//            outputDateFormatter.dateFormat = "EEEE, HH:mm" // Customize the output format here
//            
//            return outputDateFormatter.string(from: date)
//        } else {
//            return "Invalid Date"
//        }
//    }

    func formatTimestampForCommentList(_ timestampString: String) -> String {   // Added on 12 June for time format in comment list
        let dateFormatRequire = "EEE HH:mm"
            let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            if let date = dateFormatter.date(from: timestampString) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = dateFormatRequire
                outputFormatter.timeZone = TimeZone.current
                return outputFormatter.string(from: date)
            } else {
                print("Failed to parse date string.")
                return ""
            }
    }
    
//    func formatTimestampForCommentList(_ dateString: String) -> String? {
//        let fromFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'" // Input date format
//        let toFormat = "E, HH:mm" // Output date format
//        let locale = Locale(identifier: "en_US_POSIX") // Locale for date parsing
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = fromFormat
//        dateFormatter.locale = locale
//
//        guard let date = dateFormatter.date(from: dateString) else {
//            return nil // Failed to convert the date string
//        }
//
//        dateFormatter.dateFormat = toFormat
//        dateFormatter.timeZone = TimeZone.current // Set desired timezone if needed
//
//        return dateFormatter.string(from: date)
//    }
    
    func showOptionsFromBelow(on viewController: UIViewController, followAction: (() -> Void)? = nil) {   // Added on 5 January For Action Sheet From Below
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let followButton = UIAlertAction(title: "Follow", style: .default) { (action) in
            print("Follow button tapped")
            followAction?() // Execute follow action closure if provided
        }

        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel button tapped")
            // No specific action needed for cancel
        }

        alertController.addAction(followButton)
        alertController.addAction(cancelButton)

        viewController.present(alertController, animated: true, completion: nil)
    }

    // Added on 16 January to shake the gift image when teh animation type is 0
    func shakeAnimation(for view: UIView) {
       
        let shakeAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")

           shakeAnimation.values = [0, 0.30, -0.30, 0.30, -0.30, 0.30, -0.30, 0]
           shakeAnimation.keyTimes = [0, 0.1, 0.2, 0.3, 0.5, 0.6, 0.7, 0.8]
           shakeAnimation.duration = 4.0
           shakeAnimation.isAdditive = true

           view.layer.add(shakeAnimation, forKey: "shakeClockwise")
        
       }
    
    func addLineBelowButton(button: UIButton, lineColor: UIColor, lineSpacing: CGFloat, lineHeight: CGFloat) {
        let lineView = UIView()
        lineView.backgroundColor = lineColor
        button.superview?.addSubview(lineView)
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.leadingAnchor.constraint(equalTo: button.leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
        lineView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: lineSpacing).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: lineHeight).isActive = true
    }

    
    
//    func encrypt(dictionary: [String: Any], key: String, iv: String) throws -> String {
//        let jsonData = try JSONSerialization.data(withJSONObject: dictionary)
//        
//        guard let keyData = Data(base64Encoded: key),
//              let ivData = Data(base64Encoded: iv) else {
//            throw NSError(domain: "Invalid key or IV", code: 0, userInfo: nil)
//        }
//
//        let symmetricKey = SymmetricKey(data: keyData)
//        let sealedBox = try AES.GCM.seal(jsonData, using: symmetricKey, nonce: AES.GCM.Nonce(data: ivData))
//
//        guard let combined = sealedBox.combined else {
//            throw NSError(domain: "Combined data is nil", code: 0, userInfo: nil)
//        }
//
//        return combined.base64EncodedString()
//    }
    
//    func highlightSubstring(_ originalString: String, substring: String?, highlightColor: UIColor) -> NSMutableAttributedString {
//        let spannableString = NSMutableAttributedString(string: originalString)
//
//        if let substring = substring, let range = originalString.range(of: substring) {
//            let nsRange = NSRange(range, in: originalString)
//            spannableString.addAttribute(NSAttributedString.Key.foregroundColor, value: highlightColor, range: nsRange)
//        }
//
//        return spannableString
//    }
    
}
 
extension String {
    func removingHTMLTags() -> String {
        let regex = try! NSRegularExpression(pattern: "<.*?>", options: .caseInsensitive)
        let range = NSRange(location: 0, length: self.utf16.count)
        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
    }
   
    var applyingTransform: String {
        let data = self.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII) ?? self
    }
    
    // Check if the string contains an email address
      func containsEmail() -> Bool {
          let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
          return emailTest.evaluate(with: self)
      }

      // Check if the string contains a phone number
      func containsPhoneNumber() -> Bool {
          let phoneRegex = "^[+]?[0-9]{10,15}$"  // Matches 10 to 15 digits
          let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
          return phoneTest.evaluate(with: self)
      }

      // Check if the string contains any emojis
      func containsEmoji() -> Bool {
          for scalar in unicodeScalars {
              switch scalar.value {
              case 0x1F600...0x1F64F, // Emoticons
                   0x1F300...0x1F5FF, // Misc Symbols and Pictographs
                   0x1F680...0x1F6FF, // Transport and Map
                   0x1F700...0x1F77F, // Alchemical Symbols
                   0x1F780...0x1F7FF, // Geometric Shapes Extended
                   0x1F800...0x1F8FF, // Supplemental Arrows-C
                   0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
                   0x1FA00...0x1FA6F, // Chess Symbols
                   0x1FA70...0x1FAFF: // Symbols and Pictographs Extended-A
                  return true
              default:
                  continue
              }
          }
          return false
      }

      // Check if the string contains anything other than phone or email
      func containsNonPhoneOrEmailCharacters() -> Bool {
          if containsEmail() || containsPhoneNumber() {
              return false
          }
          return true
      }
    
}

extension UITableViewCell {
    
    // MARK: - FUNCTION TO LOAD IMAGE FROM GIVEN URL AND SET IMAGE TO THE GIVEN IMAGE VIEW
    
    func loadImageForCell(from urlString: String?, into imageView: UIImageView) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            imageView.image = UIImage(named: "UserPlaceHolderImageForCell")
            return
        }

        KF.url(url)
            .cacheOriginalImage()
            .onSuccess { result in
                DispatchQueue.main.async {
                    imageView.image = result.image
                }
            }
            .onFailure { error in
                print("Image loading failed with error: \(error)")
                imageView.image = UIImage(named: "UserPlaceHolderImageForCell")
            }
            .set(to: imageView)
    }
    
    func replaceNumbersWithAsterisks(_ string: String) -> String {
        let regex = try! NSRegularExpression(pattern: "[0-9]")
        let range = NSRange(location: 0, length: string.utf16.count)
        return regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "*")
    }
    
    // Function to show loader in a table view cell
      func showLoader() {
          // Create and configure the loader
          let loader = UIActivityIndicatorView(style: .medium)
          loader.color = .gray
          loader.translatesAutoresizingMaskIntoConstraints = false
          loader.tag = 999 // A tag to identify the loader
          
          // Add the loader to the cell's contentView
          self.contentView.addSubview(loader)
          
          // Center the loader in the contentView
          NSLayoutConstraint.activate([
              loader.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
              loader.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
          ])
          
          // Start animating the loader
          loader.startAnimating()
      }
      
      // Function to hide loader in a table view cell
      func hideLoader() {
          // Find the loader by tag and remove it from the contentView
          if let loader = self.contentView.viewWithTag(999) as? UIActivityIndicatorView {
              loader.stopAnimating()
              loader.removeFromSuperview()
          }
      }
    
}
extension UITextField {
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
           let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
           self.rightView = paddingView
           self.rightViewMode = .always
       }
    
}

extension UIColor {
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
            fallthrough
        case 6:
            chars = ["F","F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            return nil
        }
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
    
    convenience init?(hex: String) {
          var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
          hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

          var rgb: UInt64 = 0

          Scanner(string: hexSanitized).scanHexInt64(&rgb)

          self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                    green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                    blue: CGFloat(rgb & 0x0000FF) / 255.0,
                    alpha: 1.0)
      }
    
}

extension UIView {

    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }


    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 20
       // gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
           let maskPath = UIBezierPath(
               roundedRect: bounds,
               byRoundingCorners: corners,
               cornerRadii: CGSize(width: radius, height: radius)
           )
           
           let maskLayer = CAShapeLayer()
           maskLayer.frame = bounds
           maskLayer.path = maskPath.cgPath
           
           layer.mask = maskLayer
       }
    
}

extension UITextView {
    func addPlaceholder(_ text: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = text
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(placeholderLabel)
        
        // Set constraints for the placeholder label
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            placeholderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            placeholderLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -8)
        ])
        
        // Show or hide the placeholder based on the text view's content
        NotificationCenter.default.addObserver(self, selector: #selector(updatePlaceholder), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc private func updatePlaceholder() {
        if let placeholderLabel = subviews.first(where: { $0 is UILabel }) as? UILabel {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
}

extension UITextField{
    func setUnderLineOfColor(color:UIColor,width:Float)  {
        let border = CALayer()
        let width = CGFloat(width)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
         self.borderStyle = .none
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    func setPlaceholderColor(placeholder:String,textField:UITextField) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
    }
}

// MARK: -  Extension for the creation of hashkey .
extension Data {
    /// 扩展data支持将字符串进行sha256加密
    var sha256: String {
        if #available(iOS 13.0, *) {
            return hexString(SHA256.hash(data: self).makeIterator())
        } else {
            // Fallback on earlier versions
            var disest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            self.withUnsafeBytes {
                bytes in
                _ = CC_SHA256(bytes.baseAddress,CC_LONG(self.count),&disest)
            }
            return hexString(disest.makeIterator())
        }
    }
}

//extension String {
//   
//}

