//
//  SettingsViewController.swift
//  IndustryAR
//
//  Created by 吴熠 on 2/4/23.
//

import UIKit

enum ColorType {
    case line
    case text
}

enum LineType {
    case normal
    case dash
}

struct Settings {
    var lineColor: StrokeColor = .white
    var lineWidth: CGFloat = 0.002
    var lineType: LineType = .normal
    var textColor: StrokeColor = .white
    var fontSize: CGFloat = 24
    var fontName: String = "PingFang-SC-Medium"
}


class SettingsViewController: UIViewController {
    
    var settingsClosure: ((Settings) -> Void)?

    private let settingsTableViewCellID = "settingsTableViewCell"
    private let colorsCollectionViewCellID = "colorsCollectionViewCell"
    
    private let settingsName = ["线色:", "线粗:", "线种:", "文字颜色:", "文字字号:", "文字字体:"]
    private let detailName = ["", "", "", "", "24", "PingFang"]
    
    private let colors: [StrokeColor] = [.black,
                                   .blue,
                                   .yellow,
                                   .white,
                                   .green,
                                   .systemOrange,
                                   .systemPink,
                                   .red,
                                   .orange,
                                   .purple]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 8
        tableView.layer.masksToBounds = true
        tableView.rowHeight = 80
        tableView.isScrollEnabled = false
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: settingsTableViewCellID)
        return tableView
    }()
    
    private let space: CGFloat = 8
    private lazy var colorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 40, height: 40)
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: colorsCollectionViewCellID)
        collectionView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        collectionView.layer.cornerRadius = 20
        collectionView.layer.masksToBounds = true
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private var currentLineColor: StrokeColor = .white
    private var currentLineWidth: CGFloat = 0.002
    private var currentLineType: LineType = .normal
    private var currentTextColor: StrokeColor = .white
    private var currentTextSize: CGFloat = 24
    private var currentTextFontName: String = "PingFang-SC-Medium"

    
    private var colorType: ColorType = .line
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.center.equalTo(view)
            let height = 80 * settingsName.count
            make.size.equalTo(CGSize(width: 300, height: height))
        }
        
        view.addSubview(colorsCollectionView)
        colorsCollectionView.snp.makeConstraints { make in
            make.centerX.equalTo(tableView)
            make.top.equalTo(tableView.snp.bottom).offset(30)
            let colorsViewWidth: CGFloat = CGFloat(colors.count * 40) + CGFloat((colors.count - 1)) * space
            make.size.equalTo(CGSize(width: colorsViewWidth, height: 40))
        }
        colorsCollectionView.alpha = 0
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.removeFromParent()
//        self.view.removeFromSuperview()
        self.view.isHidden = true
        if let settingsClosure = settingsClosure {
            let settings = Settings(lineColor: currentLineColor,
                                    lineWidth: currentLineWidth,
                                    lineType: .normal,
                                    textColor: currentTextColor,
                                    fontSize: currentTextSize,
                                    fontName: currentTextFontName)
            settingsClosure(settings)
        }
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = settingsName[indexPath.row]
        let icon = detailName[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsTableViewCellID, for: indexPath) as? SettingsTableViewCell ?? SettingsTableViewCell()
        if indexPath.row == 0 {
            cell.iconView.backgroundColor = currentLineColor.uiColor
            cell.nameLabel.text = settingsName[0]
            cell.detailLabel.text = detailName[0]
        } else if indexPath.row == 3 {
            cell.iconView.backgroundColor = currentTextColor.uiColor
            cell.nameLabel.text = settingsName[3]
            cell.detailLabel.text = detailName[3]
        } else {
            cell.iconView.backgroundColor = .clear
            cell.nameLabel.text = title
            cell.detailLabel.text = icon
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row == 3 {
            if indexPath.row == 0 {
                colorType = .line
            }
            if indexPath.row == 3 {
                colorType = .text
            }
            UIView.animate(withDuration: 0.3) {
                self.colorsCollectionView.alpha = 1.0
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SettingsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let color = colors[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: colorsCollectionViewCellID, for: indexPath) as? ColorCollectionViewCell ?? ColorCollectionViewCell()
        cell.backgroundColor = color.uiColor
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = colors[indexPath.row]
        switch colorType {
        case .line:
            currentLineColor = color
        case .text:
            currentTextColor = color
        }
        UIView.animate(withDuration: 0.3) {
            self.colorsCollectionView.alpha = 0
        }
        tableView.reloadData()
    }
}
