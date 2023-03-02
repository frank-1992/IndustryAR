//
//  HistoryProjectListController.swift
//  IndustryAR
//
//  Created by 吴熠 on 2/27/23.
//

import UIKit

class HistoryProjectListController: UIViewController {

    private lazy var historyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        let space = (UIScreen.main.bounds.width - itemWidth * column) / (column + 1)
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(HomeContainerCell.self, forCellWithReuseIdentifier: historyCellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private var historyModels: [HistoryModel] = [HistoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadHistoryData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(historyCollectionView)
        historyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func reloadHistoryData() {
        ARFileManager.shared.getHistoryChilds { [weak self] historyList in
            guard let self = self else { return }

            let sortedHistoryModels = historyList.sorted (by: { historyModel1, historyModel2 in
                return historyModel1.fileName.localizedCompare(historyModel2.fileName) == .orderedAscending
            })
            
            self.historyModels = sortedHistoryModels
            
            
            self.historyCollectionView.reloadData()
        }
    }
}

extension HistoryProjectListController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let historyModel = historyModels[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: historyCellID, for: indexPath) as? HomeContainerCell ?? HomeContainerCell()
        cell.setupHistoryUIWith(historyModel)
        return cell
    }
}

extension HistoryProjectListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = historyModels[indexPath.row]
        let arVC = ARViewController()
        arVC.historyModel = model
        navigationController?.pushViewController(arVC, animated: true)
    }
}
