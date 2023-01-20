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
//        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.rowHeight = 200
        tableView.register(ChildProjectTableViewCell.self, forCellReuseIdentifier: childProjectTableViewCell)
        return tableView
    }()
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        return backButton
    }()

    @objc
    private func backButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getAssets()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.top.equalTo(view.snp.top).offset(statusHeight + 10)
        }
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

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ChildProjectListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = assetModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: childProjectTableViewCell, for: indexPath) as? ChildProjectTableViewCell ?? ChildProjectTableViewCell()
        cell.setupUIWith(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = assetModels[indexPath.row]
        let arVC = ARViewController()
        arVC.assetModel = model
        arVC.modalPresentationStyle = .overFullScreen
        present(arVC, animated: true)
    }
}

