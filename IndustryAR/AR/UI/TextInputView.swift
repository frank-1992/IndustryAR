//
//  TextInputView.swift
//  IndustryAR
//
//  Created by 吴熠 on 2/23/23.
//

import UIKit

class TextInputView: UIView {

    var confirmTextClosure: ((String) -> Void)?
    var cancelClosure: (() -> Void)?
    
    lazy var textField: LineTextField = {
        let textField = LineTextField(frame: .zero)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 4
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.black.cgColor
        textField.placeholder = enter_text.localizedString()
        textField.textColor = .black
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(cancel.localizedString(), for: .normal)
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFang-SC-Medium", size: 20)
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle(confirm.localizedString(), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFang-SC-Medium", size: 20)
        button.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        backgroundColor = UIColor.white
        
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(self).offset(20)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(44)
        }
        
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(-10)
            make.left.equalTo(textField)
            make.size.equalTo(CGSize(width: 100, height: 40))
        }
        
        addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(-10)
            make.right.equalTo(textField)
            make.size.equalTo(CGSize(width: 100, height: 40))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func confirmAction() {
        if let content = textField.text {
            if let confirmTextClosure = confirmTextClosure {
                confirmTextClosure(content)
            }
        }
//        self.removeFromSuperview()
    }
    
    @objc
    private func cancelAction() {
        if let cancelClosure = cancelClosure {
            cancelClosure()
        }
        self.removeFromSuperview()
    }
}
