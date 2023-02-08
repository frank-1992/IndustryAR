//
//  ColorCollectionViewCell.swift
//  IndustryAR
//
//  Created by 吴熠 on 2/4/23.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
}
