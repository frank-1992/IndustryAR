//
//  ViewController.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/6/23.
//

import UIKit
import SnapKit

class HomeMenuViewController: UIViewController {

    private let homeMenuTableViewCell = "homeMenuTableViewCell"
    
    private var assetModels: [AssetModel] = [AssetModel]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.separatorStyle = .none
        tableView.rowHeight = 120
        tableView.register(HomeMenuTableViewCell.self, forCellReuseIdentifier: homeMenuTableViewCell)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupAssetsContainer()
        getAssets()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
    }

    // create assets container
    private func setupAssetsContainer() {
        ARFileManager.shared.setupAssetsContainer()
    }
    
    // get assets
    private func getAssets() {
        ARFileManager.shared.traverseContainer { [weak self] assetModels in
            guard let self = self else { return }
            self.assetModels = assetModels
            self.tableView.reloadData()
        }
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = assetModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: homeMenuTableViewCell, for: indexPath) as? HomeMenuTableViewCell ?? HomeMenuTableViewCell()
        cell.reloadUIWith(model)
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

