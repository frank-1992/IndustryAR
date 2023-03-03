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

enum LineType: Int {
    case normal = 0
    case dash = 1
}

class SettingsViewController: UIViewController {
    
    var settingsClosure: (() -> Void)?
    var selectFontClosure: (() -> Void)?

    private let settingsTableViewCellID = "settingsTableViewCell"
    private let colorsCollectionViewCellID = "colorsCollectionViewCell"
    
    private let settingsName = [line_color.localizedString(),
                                line_thickness.localizedString(),
                                line_type.localizedString(),
                                marker_size.localizedString(),
                                text_color.localizedString(),
                                text_size.localizedString(),
                                text_font.localizedString()]
    private let detailName = ["", "", normal_line.localizedString(), "", "", "24", "PingFang"]
    
    private let colors: [UIColor] = [.black,
                                   .blue,
                                   .yellow,
                                   .white,
                                   .green,
                                   .systemOrange,
                                   .systemPink,
                                   .red,
                                   .orange,
                                   .purple]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 8
        tableView.layer.masksToBounds = true
        tableView.rowHeight = 80
        tableView.isScrollEnabled = false
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: settingsTableViewCellID)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tapGesture.delegate = self
        tableView.addGestureRecognizer(tapGesture)
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
    
//    private var currentLineColor: UIColor = .white
    private var currentLineWidth: CGFloat = 0.002
    private var currentLineType: LineType = .normal
//    private var currentTextColor: UIColor = .white
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
        self.view.endEditing(true)
        self.view.isHidden = true
        if let settingsClosure = settingsClosure {
            settingsClosure()
        }
    }
    
    @objc
    private func tapAction() {
        view.endEditing(true)
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
            cell.iconView.backgroundColor = ShapeSetting.lineColor
            cell.nameLabel.text = settingsName[0]
            cell.detailLabel.text = detailName[0]
        } else if indexPath.row == 4 {
            cell.iconView.backgroundColor = ShapeSetting.textColor
            cell.nameLabel.text = settingsName[4]
            cell.detailLabel.text = detailName[4]
        } else if indexPath.row == 6 {
            cell.iconView.backgroundColor = .clear
            cell.nameLabel.text = title
            cell.detailLabel.text = ShapeSetting.fontName
        } else {
            cell.iconView.backgroundColor = .clear
            cell.nameLabel.text = title
            cell.detailLabel.text = icon
        }
        
        if indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 5 {
            cell.textField.isHidden = false
            
            if indexPath.row == 1 {
                cell.textField.text = String(ShapeSetting.lineThickness)
                cell.textClosure = { text in
                    ShapeSetting.lineThickness = Float(text) ?? 1
                }
            }
            if indexPath.row == 3 {
                cell.textField.text = String(ShapeSetting.lineLength)
                cell.textClosure = { text in
                    ShapeSetting.lineLength = Float(text) ?? 100
                }
            }
            if indexPath.row == 5 {
                cell.textField.text = String(Float(ShapeSetting.fontSize))
                cell.textClosure = { text in
                    ShapeSetting.fontSize = CGFloat(Float(text) ?? 1)
                }
            }
            
        } else {
            cell.textField.isHidden = true
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row == 4 {
            if indexPath.row == 0 {
                colorType = .line
                view.endEditing(true)
            }
            if indexPath.row == 4 {
                colorType = .text
            }
            UIView.animate(withDuration: 0.3) {
                self.colorsCollectionView.alpha = 1.0
            }
        }
        if indexPath.row == 6 {
            if let selectFontClosure = selectFontClosure {
                selectFontClosure()
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
        cell.backgroundColor = color
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = colors[indexPath.row]
        switch colorType {
        case .line:
            ShapeSetting.lineColor = color
        case .text:
            ShapeSetting.textColor = color
        }
        UIView.animate(withDuration: 0.3) {
            self.colorsCollectionView.alpha = 0
        }
        tableView.reloadData()
    }
}

extension SettingsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass((touch.view?.classForCoder)!) == "UITableViewCellContentView" {
            view.endEditing(true)
            return false
        }
        return true
    }
}
