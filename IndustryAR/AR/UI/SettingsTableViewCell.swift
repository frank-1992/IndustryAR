//
//  SettingsTableViewCell.swift
//  IndustryAR
//
//  Created by 吴熠 on 2/4/23.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    var textClosure: ((String) -> Void)?
    
    lazy var iconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .systemFill
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "PingFang-SC-Medium", size: 16)
        label.textColor = .black
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "PingFang-SC-Medium", size: 16)
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()
    
    lazy var textField: LineTextField = {
        let textField = LineTextField(frame: .zero)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 4
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.black.cgColor
        textField.placeholder = ""
        textField.keyboardType = .numberPad
        textField.textColor = .black
        textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        return textField
    }()
    
    lazy var checkBox: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "checkbox")
        imageView.highlightedImage = UIImage(named: "checkboxchecked")
        imageView.isHidden = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = SSColorWithHex(0xE3E3E3, 1)
        
        addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-10)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 100, height: 40))
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(contentView).offset(10)
            make.width.equalTo(140)
        }
        
        addSubview(detailLabel)
        detailLabel.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-10)
            make.centerY.equalTo(contentView)
            make.left.equalTo(nameLabel.snp.right).offset(10)
        }
        
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-10)
            make.size.equalTo(CGSize(width: 100, height: 40))
        }
        
        addSubview(checkBox)
        checkBox.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-10)
            make.size.equalTo(CGSize(width: 26, height: 26))
        }
    }
    
    @objc
    private func textFieldDidChange(textField: LineTextField) {
        if let textClosure = textClosure {
            textClosure(textField.text ?? "")
        }
    }
}

class LineTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: 12, y: 0, width: bounds.width, height: bounds.height)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: 12, y: 0, width: bounds.width, height: bounds.height)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: 12, y: 0, width: bounds.width, height: bounds.height)
    }
}
