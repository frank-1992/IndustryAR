//
//  HomeContentCell.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/20/23.
//

import UIKit

class HomeContainerCell: UICollectionViewCell {
    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "PingFang-SC-Medium", size: 26)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.left.right.top.equalTo(contentView)
            make.height.equalTo(260)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(iconView)
            make.top.equalTo(iconView.snp.bottom).offset(5)
            make.width.equalTo(180)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUIWith(_ projectModel: FileModel) {
        guard let modelThumbnailPath = projectModel.fileThumbnail else { return }
        iconView.image = UIImage(contentsOfFile: modelThumbnailPath.relativePath)
        nameLabel.text = projectModel.fileName
    }
    
    func setupHistoryUIWith(_ historyModel: HistoryModel) {
        guard let modelThumbnailPath = historyModel.fileThumbnail else { return }
        if !modelThumbnailPath.relativePath.isEmpty {
            guard let image = UIImage(contentsOfFile: modelThumbnailPath.relativePath), let ciImage = CIImage(image: image) else { return }
            
            let orientation = CGImagePropertyOrientation(cameraOrientation: UIDevice.current.orientation)
            let context = CIContext(options: [.useSoftwareRenderer: false])
            guard let data = context.jpegRepresentation(of: ciImage.oriented(orientation),
                                                        colorSpace: CGColorSpaceCreateDeviceRGB(),
                                                        options: [kCGImageDestinationLossyCompressionQuality as CIImageRepresentationOption: 0.7])
                else { return }
            
            iconView.image = UIImage(data: data)
        }
        nameLabel.text = historyModel.fileName
    }
}

extension CGImagePropertyOrientation {
    /// Preferred image presentation orientation respecting the native sensor orientation of iOS device camera.
    init(cameraOrientation: UIDeviceOrientation) {
        switch cameraOrientation {
        case .portrait:
            self = .leftMirrored
        case .portraitUpsideDown:
            self = .left
        case .landscapeLeft:
            self = .up
        case .landscapeRight:
            self = .down
        default:
            self = .leftMirrored
        }
    }
}
