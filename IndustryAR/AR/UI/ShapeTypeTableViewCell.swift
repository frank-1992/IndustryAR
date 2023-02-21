//
//  ShapeTypeTableViewCell.swift
//  IndustryAR
//
//  Created by 吴熠 on 2/4/23.
//

import UIKit

class ShapeTypeTableViewCell: UITableViewCell {

    var selectedFlag: Bool = false
    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "PingFang-SC-Medium", size: 22)
        label.textColor = .systemBlue
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(iconView.snp.right).offset(48)
        }
    }
    
    func setupUIWith(_ iconName: String, _ typeName: String) {
        iconView.image = UIImage(named: iconName)
        nameLabel.text = typeName
    }
}
