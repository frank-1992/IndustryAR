//
//  ShapeMenuView.swift
//  IndustryAR
//
//  Created by 吴熠 on 2/4/23.
//

import UIKit

enum Function {
    case line
    case triangle
    case square
    case circle
    case text
    case depthSegmentation
    case delete
    case showSymbol
}

class ShapeMenuView: UIView {
    
    private let shapeTableViewCell = "shapeTableViewCell"
    
    private let icons = ["quxian", "sanjiaoxing", "cub", "yuanxing", "wenzi", "zhedang", "shanchu", "shezhi", "biaoji"]
    private let names = ["徒手画", "三角形", "四边形", "圆", "文字注解", "遮挡剔除", "删除", "设置", "标记显示"]
    private let functions: [Function] = [.line, .triangle, .square, .circle, .text, .depthSegmentation, .delete, .showSymbol]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.bounds)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 8
        tableView.layer.masksToBounds = true
        tableView.rowHeight = 60
        tableView.isScrollEnabled = false
        tableView.register(ShapeTypeTableViewCell.self, forCellReuseIdentifier: shapeTableViewCell)
        return tableView
    }()
    
    var selectShapeTypeClosure: ((Function) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }

}

// MARK: - UITableViewDataSource
extension ShapeMenuView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let icon = icons[indexPath.row]
        let name = names[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: shapeTableViewCell, for: indexPath) as? ShapeTypeTableViewCell ?? ShapeTypeTableViewCell()
        cell.setupUIWith(icon, name)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ShapeMenuView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let function = functions[indexPath.row]
        if let selectShapeTypeClosure = selectShapeTypeClosure {
            selectShapeTypeClosure(function)
        }
    }
}
