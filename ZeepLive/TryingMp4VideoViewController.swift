import UIKit

class TryingMp4VideoViewController: UIViewController {

    var videoGiftView: VideoGiftView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create an instance of VideoGiftView and add it to the view hierarchy
        videoGiftView = VideoGiftView(frame: CGRect(x: 0, y: 50, width: 400, height: 400))
        view.addSubview(videoGiftView)

        // Attach the view to the VideoGiftView
        videoGiftView.attachView()

        // Download and play the video
        downloadFile()
    }

    func downloadFile() {
        // URL of the video you want to download
        guard let videoURL = URL(string: "https://zeeplivesg.oss-ap-southeast-1.aliyuncs.com/zeepliveMomentVideos/1717611226.mp4") else {
            print("Invalid video URL.")
            return
        }

        URLSession.shared.dataTask(with: videoURL) { data, _, error in
            if let error = error {
                print("Error downloading video: \(error)")
                return
            }

            guard let videoData = data else {
                print("Invalid video data.")
                return
            }

            // Save the downloaded video to local storage
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let localURL = documentsDirectory.appendingPathComponent("downloaded_video.mp4")
                do {
                    try videoData.write(to: localURL)
                    print("Video downloaded and saved to: \(localURL)")

                    // Start playing the downloaded video
                    DispatchQueue.main.async {
                        let videoFilePath = localURL.absoluteString
                        self.videoGiftView.startVideoGift(filePath: videoFilePath)
                    }
                } catch {
                    print("Error saving video data: \(error)")
                }
            }
        }.resume()
    }
}
