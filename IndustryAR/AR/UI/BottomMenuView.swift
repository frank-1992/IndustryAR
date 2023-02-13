//
//  BottomMenuView.swift
//  IndustryAR
//
//  Created by  吴 熠 on 2023/2/13.
//

import UIKit

class BottomMenuView: UIView {

    private lazy var takePhotoButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "paizhao"), for: .normal)
        return button
    }()
    
    private lazy var recordVideoButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "luzhi"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        addSubview(takePhotoButton)
        takePhotoButton.snp.makeConstraints { make in
            make.left.equalTo(self).offset(20)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
        
        addSubview(recordVideoButton)
        recordVideoButton.snp.makeConstraints { make in
            make.left.equalTo(takePhotoButton.snp.right).offset(20)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
    }

}
