//
//  BottomMenuView.swift
//  IndustryAR
//
//  Created by  吴 熠 on 2023/2/13.
//

import UIKit

class BottomMenuView: UIView {
    
    var takePictureClosure: (() -> Void)?
    var recordVideoClosure: (() -> Void)?
    var alignClosure: (() -> Void)?
    var saveSCNClosure: (() -> Void)?
    var autoSettingClosure: ((UIButton) -> Void)?


    private lazy var takePhotoButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "paizhao"), for: .normal)
        button.addTarget(self, action: #selector(takePicture), for: .touchUpInside)
        return button
    }()
    
    private lazy var recordVideoButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "luzhi"), for: .normal)
        button.addTarget(self, action: #selector(recordVideo), for: .touchUpInside)
        return button
    }()
    
    private lazy var alignButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "duiqi"), for: .normal)
        button.addTarget(self, action: #selector(alignModel), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveSCNButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "baocun"), for: .normal)
        button.addTarget(self, action: #selector(saveSCN), for: .touchUpInside)
        return button
    }()
    
    lazy var autoButton: UIButton = {
        let button = UIButton()
        button.setTitle("SHOW", for: .normal)
        button.titleLabel?.textColor = .black
        button.titleLabel?.font = UIFont(name: "PingFang-SC-Medium", size: 28)
        button.titleLabel?.textAlignment = .center
        button.sizeToFit()
        button.addTarget(self, action: #selector(autoSetting(sender:)), for: .touchUpInside)
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
        
        addSubview(alignButton)
        alignButton.snp.makeConstraints { make in
            make.left.equalTo(recordVideoButton.snp.right).offset(20)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
        
        addSubview(saveSCNButton)
        saveSCNButton.snp.makeConstraints { make in
            make.left.equalTo(alignButton.snp.right).offset(20)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
        
        addSubview(autoButton)
        autoButton.snp.makeConstraints { make in
            make.left.equalTo(saveSCNButton.snp.right).offset(20)
            make.centerY.equalTo(self)
            make.height.equalTo(48)
        }
    }
    
    @objc
    private func takePicture() {
        takePictureClosure?()
    }
    
    @objc
    private func recordVideo() {
        recordVideoClosure?()
    }
    
    @objc
    private func alignModel() {
        alignClosure?()
    }
    
    @objc
    private func saveSCN() {
        saveSCNClosure?()
    }
    
    @objc
    private func autoSetting(sender: UIButton) {
        autoSettingClosure?(sender)
    }
    
    private func AlphaLight(time: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation.init(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0
        animation.autoreverses = true
        animation.duration = CFTimeInterval(time)
        animation.repeatCount = 1000
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction.init(name: .easeIn)
        return animation
    }
    
    func startRecording() {
        recordVideoButton.setBackgroundImage(UIImage(named: "luzhi_ing"), for: .normal)
        recordVideoButton.layer.add(AlphaLight(time: 1), forKey: "alpha")
    }
    
    func stopRecording() {
        recordVideoButton.layer.removeAnimation(forKey: "alpha")
        recordVideoButton.setBackgroundImage(UIImage(named: "luzhi"), for: .normal)
    }
}

