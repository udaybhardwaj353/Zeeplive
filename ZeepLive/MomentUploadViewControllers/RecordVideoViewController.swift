//
//  RecordVideoViewController.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 03/01/24.
//

import UIKit
import AVKit
import AVFoundation

class RecordVideoViewController: UIViewController {


    @IBOutlet weak var btnStartRecordingOutlet: UIButton!
    @IBOutlet weak var btnCloseOutlet: UIButton!
    @IBOutlet weak var btnSubmitVideoOutlet: UIButton!
    @IBOutlet weak var btnRetakeVideoOutlet: UIButton!
    
      let captureSession = AVCaptureSession()
      let movieOutput = AVCaptureMovieFileOutput()
      var previewLayer: AVCaptureVideoPreviewLayer!
     // let faceDetectionRequest = VNDetectFaceRectanglesRequest()
    var circularProgressView: CircularProgressView!
    var countdownTimer: Timer?
    lazy var totalTime = 15
    let progressUpdateInterval: TimeInterval = 0.1
     var videoUrl: URL?
    lazy var selectedImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("record video wale view controller par aaya hai.")
        tabBarController?.tabBar.isHidden = true

        setupCaptureSession()
        setupPreview()
        startSession()
//        setUpProgressBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        btnStartRecordingOutlet.isHidden = false
        btnCloseOutlet.isHidden = false
//        circularProgressView.isHidden = true
//        btnRetakeVideoOutlet.isHidden = true
//        btnSubmitVideoOutlet.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        videoUrl = nil
        selectedImages.removeAll()
//        circularProgressView.isHidden = true
//        btnRetakeVideoOutlet.isHidden = true
//        btnSubmitVideoOutlet.isHidden = true
        if let circularProgressView = circularProgressView {
                circularProgressView.isHidden = true
            }
            
            // Check if btnRetakeVideoOutlet and btnSubmitVideoOutlet are not nil before accessing their properties
            if let btnRetakeVideoOutlet = btnRetakeVideoOutlet, let btnSubmitVideoOutlet = btnSubmitVideoOutlet {
                btnRetakeVideoOutlet.isHidden = true
                btnSubmitVideoOutlet.isHidden = true
            }
        
    }
    
    @IBAction func btnStartRecordingPressed(_ sender: Any) {
        
        print("Button Start Recording Pressed")
      
        btnStartRecordingOutlet.isHidden = true
        setUpProgressBar()
        startResendTimer()
        startRecording()
      
    }
    
    @IBAction func btnClosePressed(_ sender: Any) {
        
        print("Button Close recording Pressed")
        videoUrl = nil
        selectedImages.removeAll()
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnSubmitVideoPressed(_ sender: Any) {
        
        print("Button Submit Video Pressed")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PostMomentViewController") as! PostMomentViewController
        nextViewController.optionName = "recordvideo"
        nextViewController.videoUrl = videoUrl
        nextViewController.selectedImages = selectedImages
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    @IBAction func btnRetakeVideoPressed(_ sender: Any) {
        
        print("Button Retake Video Recording Pressed")
        circularProgressView.progress = 0
        btnRetakeVideoOutlet.isHidden = true
        btnSubmitVideoOutlet.isHidden = true
        startResendTimer()
        startRecording()
        
    }
    
}

extension RecordVideoViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func setupPreview() {
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = self.view.bounds
        view.layer.addSublayer(previewLayer)
        view.addSubview(btnStartRecordingOutlet)
        view.addSubview(btnCloseOutlet)
        
    }

    func setupCaptureSession() {
           captureSession.sessionPreset = .high
           
           guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
           
           do {
               let input = try AVCaptureDeviceInput(device: captureDevice)
               captureSession.addInput(input)
               
               let videoOutput = AVCaptureVideoDataOutput()
               videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
               captureSession.addOutput(videoOutput)
               
               let audioDevice = AVCaptureDevice.default(for: .audio)
               let audioInput = try AVCaptureDeviceInput(device: audioDevice!)
               captureSession.addInput(audioInput)
               
               captureSession.addOutput(movieOutput)
           } catch {
               print(error)
           }
       }
    
 func startSession() {
     DispatchQueue.global(qos: .userInitiated).async { [weak self] in
         self?.captureSession.startRunning()
     }
 }

    func stopSession() {
        captureSession.stopRunning()
    }

    func startRecording() {
        let outputPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video.mov")
        movieOutput.startRecording(to: outputPath, recordingDelegate: self)
    }

    func stopRecording() {
        movieOutput.stopRecording()
    }
    
}

extension RecordVideoViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Video recording finished with error: \(error)")
        } else {
            print("Video recording finished: \(outputFileURL.absoluteString)")
            // playRecordedVideo(at: outputFileURL)
          
            if let thumbnail = generateThumbnail(from: outputFileURL) {
                videoUrl = outputFileURL
                selectedImages.append(thumbnail)
                
            }
        }
    }
}

extension RecordVideoViewController {
    
    func setUpProgressBar() {
        
        let screenWidth = view.bounds.width
        let circularViewSize: CGFloat = 80 // Set your desired size
        let circularViewX = (screenWidth - circularViewSize) / 2
        let circularViewY = view.bounds.height - circularViewSize - 40 // Adjust bottom margin as needed

        circularProgressView = CircularProgressView(frame: CGRect(x: circularViewX, y: circularViewY, width: circularViewSize, height: circularViewSize))
    
            circularProgressView.lineWidth = 10.0
            circularProgressView.progressColor = UIColor.purple
            circularProgressView.trackColor = UIColor.lightGray
            view.addSubview(circularProgressView)
            
            // Update progress (0.0 to 1.0)
          //  circularProgressView.progress = 0.7
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(circularViewTapped))
          circularProgressView.addGestureRecognizer(tapGesture)
          circularProgressView.isUserInteractionEnabled = true
        
    }
    
    @objc func circularViewTapped() {
           // Handle the tap on CircularProgressView here
           print("Circular Progress View Tapped!")
      //  startResendTimer()
        circularProgressView.isUserInteractionEnabled = false
        
       }
    
    func startResendTimer() {
        
        totalTime = 15
        btnCloseOutlet.isHidden = true
        startRecording()
        startTimer()
        
    }
    
    func startTimer() {
       
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
       
        
        if totalTime != 0 {
            totalTime -= 1
            let remainingTime = TimeInterval(totalTime)
                  let elapsedDuration = TimeInterval(15 - totalTime) // Assuming 15 seconds total
                  let progress = CGFloat(elapsedDuration / 15.0) // Update 15.0 with your total duration

                  // Update the progress bar
                  circularProgressView.progress = progress
            
        } else {
            endTimer()
            
        }
    }
    
    func endTimer() {
        
        view.addSubview(btnRetakeVideoOutlet)
        view.addSubview(btnSubmitVideoOutlet)
      //  view.addSubview(btnCloseOutlet)
        btnCloseOutlet.isHidden = false
        btnSubmitVideoOutlet.isHidden = false
        btnRetakeVideoOutlet.isHidden = false
        stopRecording()
        countdownTimer?.invalidate()
        
    }
    
}
