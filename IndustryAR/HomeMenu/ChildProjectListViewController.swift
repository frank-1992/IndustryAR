//
//  ViewController.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/6/23.
//

import UIKit
import SnapKit

class ChildProjectListViewController: UIViewController {

    var projectModel: FileModel?
    
    private let childProjectTableViewCell = "childProjectTableViewCell"
    
    private var assetModels: [AssetModel] = [AssetModel]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.rowHeight = 200
        tableView.register(ChildProjectTableViewCell.self, forCellReuseIdentifier: childProjectTableViewCell)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getAssets()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    // get assets
    private func getAssets() {
        guard let projectModel = projectModel else { return }
        let dirs = projectModel.childDirectory
        for dirURL in dirs {
            ARFileManager.shared.getDirectoryChilds(with: dirURL) { [weak self] asssetModel in
                guard let self = self else { return }
                self.assetModels.append(asssetModel)
            }
        }
        tableView.reloadData()
    }

}

// MARK: - UITableViewDataSource
extension ChildProjectListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = assetModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: childProjectTableViewCell, for: indexPath) as? ChildProjectTableViewCell ?? ChildProjectTableViewCell()
        cell.setupUIWith(model)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ChildProjectListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = assetModels[indexPath.row]
        let arVC = ARViewController()
        arVC.assetModel = model
        navigationController?.pushViewController(arVC, animated: true)
    }
}

