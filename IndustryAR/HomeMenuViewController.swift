//
//  ViewController.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/6/23.
//

import UIKit

class HomeMenuViewController: UIViewController {

    private var assetModels: [AssetModel] = [AssetModel]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAssetsContainer()
        getAssets()
    }

    // 创建container
    private func setupAssetsContainer() {
        ARFileManager.shared.setupAssetsContainer()
    }
    
    // 获取资源
    private func getAssets() {
        ARFileManager.shared.traverseContainer { [weak self] assetModels in
            guard let self = self else { return }
            self.assetModels = assetModels
        }
    }
    
    

}

