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

extension ARViewController {
    func addFontPickerView() {
        view.addSubview(fontPickerView)
        fontPickerView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(200)
        }
        
        view.addSubview(fontToolBar)
        fontToolBar.snp.makeConstraints { make in
            make.left.right.equalTo(fontPickerView)
            make.bottom.equalTo(fontPickerView.snp.top)
            make.height.equalTo(45)
        }
        
    }
    
    @objc
    func cancelAction() {
        fontPickerView.removeFromSuperview()
        fontToolBar.removeFromSuperview()
    }
    
    @objc
    func confirmAction() {
        ShapeSetting.fontName = currentFontName
        settingsVC?.tableView.reloadData()
        fontPickerView.removeFromSuperview()
        fontToolBar.removeFromSuperview()
    }
}

extension ARViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ShapeSetting.fontNameList.count
    }
}


extension ARViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let fontName = ShapeSetting.fontNameList[row]
        if row == 0 {
            pickerView.selectRow(0, inComponent: component, animated: true)
            currentFontName = fontName
        }
        return fontName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let fontName = ShapeSetting.fontNameList[row]
        currentFontName = fontName
    }
}
