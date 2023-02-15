//
//  RecorderResultViewController.swift
//  IndustryAR
//
//  Created by  吴 熠 on 2023/2/14.
//

import UIKit
import AVKit

enum ARResultMediaType {
    case none
    case image(UIImage?)
    case video(URL?)
}

class RecorderResultViewController: UIViewController {

    public var mediaType: ARResultMediaType = .none

    init(mediaType: ARResultMediaType) {
        super.init(nibName: nil, bundle: nil)
        self.mediaType = mediaType
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var player: AVQueuePlayer?
    private var playerLooper: AVPlayerLooper?

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "close"), for: .normal)
        backButton.layer.zPosition = 1000
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        return backButton
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "save"), for: .normal)
        button.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true

        definesPresentationContext = true

        switch mediaType {
        case .image(let image):
            imageView.image = image
            initImageView()
        case .video(let videoURL):
            NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] _ in
                self?.playBackIfNeeded()
            }
            guard let url = videoURL else { return }
            let playerItem = AVPlayerItem(url: url)
            initPlayer(with: playerItem)
        case .none:
            break
        }
        initSubviews()
    }
    
    
    private func playBackIfNeeded() {
        if player == nil { return }
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        player?.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playBackIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }
    
    private func initSubviews() {
        let statusHeight: CGFloat
        if #available(iOS 13.0, *) {
            statusHeight = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            // Fallback on earlier versions
            statusHeight = UIApplication.shared.statusBarFrame.height
        }

        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.top.equalTo(view.snp.top).offset(15)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }

        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(-30)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
    }
    
    @objc
    private func saveButtonClicked() {
        saveMediaToAlbum()
    }
    
    private func saveMediaToAlbum() {
        switch mediaType {
        case .image(let image):
            DispatchQueue.global().async {
                guard let image = image else {
                    return
                }
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.didFinishSavingImage(_:error:contextInfo:)), nil)
            }
        case .video(let videoURL):
            DispatchQueue.global().async {
                guard let url = videoURL else {
                    return
                }
                let filePath = url.path
                let videoCompatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(filePath)
                if videoCompatible {
                    UISaveVideoAtPathToSavedPhotosAlbum(filePath, self, #selector(self.didFinishSavingVideo(videoPath:error:contextInfo:)), nil)
                } else {
                    self.showAlert(with: "该视频无法保存至相册")
                }
            }
        case .none:
            break
        }
    }
    
    @objc
    private func didFinishSavingVideo(videoPath: String, error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        if error != nil {
            showAlert(with: "保存失败")
        } else {
            showAlert(with: "保存成功")
        }
    }
    
    @objc
    func didFinishSavingImage(_ image: UIImage, error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        if error != nil {
            showAlert(with: "保存失败")
        } else {
            showAlert(with: "保存成功")
        }
    }
    
    private func showAlert(with message: String) {
//        let alert = XYAlert.createTextItemWithText(onMiddle: message)
//        alert?.show()
    }
    
    private func initImageView() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func initPlayer(with playerItem: AVPlayerItem?) {
        guard let playerItem = playerItem else {
            return
        }
        let videoPlayer = AVQueuePlayer(playerItem: playerItem)
        videoPlayer.actionAtItemEnd = .none
        videoPlayer.rate = 1.0
        self.player = videoPlayer

        playerLooper = AVPlayerLooper(player: videoPlayer, templateItem: playerItem)
        let playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)
    }
    
    @objc
    private func backButtonClicked() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
