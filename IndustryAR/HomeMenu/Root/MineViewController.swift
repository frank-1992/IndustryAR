//
//  DownloadViewController.swift
//  IndustryAR
//
//  Created by 吴熠 on 3/20/23.
//

import UIKit
import PKHUD
import Zip

class MineViewController: UIViewController {

    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "PingFang-SC-Medium", size: 22)
        label.textColor = UIColor.black
        label.text = download_url.localizedString()
        label.textAlignment = .left
        return label
    }()
    
    private lazy var urlTextField: LineTextField = {
        let textField = LineTextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 4
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.black.cgColor
        textField.placeholder = ""
        textField.textColor = .black
        return textField
    }()
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "PingFang-SC-Medium", size: 18)
        label.textColor = UIColor.systemPink
        label.text = "0%"
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle(download.localizedString(), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFang-SC-Medium", size: 20)
        button.addTarget(self, action: #selector(downloadAsset), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    

    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(300)
            make.left.equalTo(view).offset(50)
        }
        
        view.addSubview(urlTextField)
        urlTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(30)
            make.left.equalTo(nameLabel)
            make.right.equalTo(view).offset(-50)
            make.height.equalTo(44)
        }
        
        view.addSubview(progressLabel)
        progressLabel.snp.makeConstraints { make in
            make.left.equalTo(urlTextField)
            make.top.equalTo(urlTextField.snp.bottom).offset(8)
        }
        
        view.addSubview(downloadButton)
        downloadButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(urlTextField.snp.bottom).offset(80)
            make.size.equalTo(CGSize(width: 160, height: 50))
        }
    }
    
    @objc
    private func downloadAsset() {
        // https://github.com/marmelroy/Zip
        // https://www.cnuseful.com/down/
//        guard let urlString = urlTextField.text else { return }
        progressLabel.isHidden = false
        DownloaderManager.shared.download(url: URL(string: "https://www.dismall.com/forum.php?mod=attachment&aid=MzA4fDdmYTBhMzBifDE2Nzk4MzY2Mzh8MHw1ODU%3D")!, progress: { (progress) in
            DispatchQueue.main.async {
                self.progressLabel.text = String(Int(progress * 100))+"%"
            }

        }, completion: { (filePath) in
//            print("下载完成：\(filePath)")
            self.unzipFile(filePath: filePath)
//            DispatchQueue.main.async {
//                HUD.flash(.labeledSuccess(title: "下载完成", subtitle: ""))
//            }
        }) { (error) in
            DispatchQueue.main.async {
                HUD.flash(.labeledError(title: "错误", subtitle: "下载失败"))
            }
        }
    }
    
    private func unzipFile(filePath: String) {
        do {
            guard let fileURL = URL(string: filePath) else { return }
            let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(containerName, isDirectory: true)
            let destinationPath = dirURL.appendingPathComponent(filePath.md5)
            try Zip.unzipFile(fileURL, destination: destinationPath, overwrite: true, password: nil, progress: { progress in
                if progress >= 1.0 {
                    DispatchQueue.main.async {
                        HUD.flash(.labeledSuccess(title: "解压完成", subtitle: ""))
                    }
                }
            })
        } catch {
          print("Something went wrong")
        }
    }

}
