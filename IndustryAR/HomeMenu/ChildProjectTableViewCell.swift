//
//  HomeMenuTableViewCell.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/6/23.
//

import UIKit

class ChildProjectTableViewCell: UITableViewCell {

    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .systemOrange
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "PingFang-SC-Medium", size: 30)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-10)
            make.top.equalTo(contentView).offset(10)
            make.bottom.equalTo(contentView).offset(-10)
            make.width.equalTo(200)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(60)
        }
    }
    
    func setupUIWith(_ assetModel: AssetModel) {
        guard let modelThumbnailPath = assetModel.assetThumbnailPath else { return }
        iconView.image = UIImage(contentsOfFile: modelThumbnailPath.relativePath)
        nameLabel.text = assetModel.assetName
    }

}
