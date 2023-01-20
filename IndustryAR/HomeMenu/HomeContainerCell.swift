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
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "PingFang-SC-SemiBold", size: 30)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(iconView)
            make.top.equalTo(iconView).offset(10)
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
}
