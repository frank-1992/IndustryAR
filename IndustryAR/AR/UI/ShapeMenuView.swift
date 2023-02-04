//
//  ShapeMenuView.swift
//  IndustryAR
//
//  Created by 吴熠 on 2/4/23.
//

import UIKit

class ShapeMenuView: UIView {

    private let shapeTableViewCell = "shapeTableViewCell"
    
    private let icons = ["quxian", "quxian", "quxian", "quxian", "quxian", "quxian", "quxian", "quxian", "quxian"]
    private let names = ["徒手画", "徒手画", "徒手画", "徒手画", "徒手画", "徒手画", "徒手画", "徒手画", "徒手画", "徒手画"]
    
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
        
    }
}
