//
//  ARViewController+Extension.swift
//  IndustryAR
//
//  Created by 吴熠 on 2/28/23.
//

import UIKit
import ARKit
import SceneKit
import SnapKit
import HandyJSON
import PKHUD

enum PickerViewType {
    case lineType
    case fontName
}

extension ARViewController {
    func addPickerView() {
        view.addSubview(customerPickerView)
        customerPickerView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(200)
        }
        customerPickerView.reloadAllComponents()
        
        view.addSubview(fontToolBar)
        fontToolBar.snp.makeConstraints { make in
            make.left.right.equalTo(customerPickerView)
            make.bottom.equalTo(customerPickerView.snp.top)
            make.height.equalTo(45)
        }
        
        switch currentPickerViewType {
        case .lineType:
            if let row = ShapeSetting.lineTypeList.firstIndex(of: ShapeSetting.lineType.value) {
                customerPickerView.selectRow(row, inComponent: 0, animated: true)
            } else {
                customerPickerView.selectRow(0, inComponent: 0, animated: true)
            }
        case .fontName:
            if let row = ShapeSetting.fontNameList.firstIndex(of: ShapeSetting.fontName) {
                customerPickerView.selectRow(row, inComponent: 0, animated: true)
            } else {
                customerPickerView.selectRow(0, inComponent: 0, animated: true)
            }
        }
    }
    
    @objc
    func cancelAction() {
        customerPickerView.removeFromSuperview()
        fontToolBar.removeFromSuperview()
    }
    
    @objc
    func confirmAction() {
        switch currentPickerViewType {
        case .lineType:
            ShapeSetting.lineType = currentLineType
        case .fontName:
            ShapeSetting.fontName = currentFontName
        }
        settingsVC?.tableView.reloadData()
        customerPickerView.removeFromSuperview()
        fontToolBar.removeFromSuperview()
    }
}

extension ARViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch currentPickerViewType {
        case .lineType:
            return ShapeSetting.lineTypeList.count

        case .fontName:
            return ShapeSetting.fontNameList.count
        }
    }
}


extension ARViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch currentPickerViewType {
        case .lineType:
            let lineTypeName = ShapeSetting.lineTypeList[row]
            if row == 0 {
                currentLineType = .normal
            } else {
                currentLineType = .dash
            }
            return lineTypeName

        case .fontName:
            let fontName = ShapeSetting.fontNameList[row]
            currentFontName = fontName
            return fontName
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch currentPickerViewType {
        case .lineType:
            if row == 0 {
                currentLineType = .normal
            } else {
                currentLineType = .dash
            }
        case .fontName:
            let fontName = ShapeSetting.fontNameList[row]
            currentFontName = fontName
        }
    }
}
