//
//  HomeMenuTableViewCell.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/6/23.
//

import UIKit

class HomeMenuTableViewCell: UITableViewCell {

    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(iconView)
        iconView.backgroundColor = .red
        iconView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-10)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
    }
    
    func reloadUIWith(_ assetModel: AssetModel) {
        iconView.image = UIImage(contentsOfFile: assetModel.modelThumbnailPath)
    }

}
