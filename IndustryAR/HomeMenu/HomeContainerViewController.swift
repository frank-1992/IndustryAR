//
//  HomeContainerViewController.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/20/23.
//

import UIKit
import BetterSegmentedControl

class HomeContainerViewController: UIViewController {
    
    private let itemWidth: CGFloat = 220
    private let itemHeight: CGFloat = 300
    private let column: CGFloat = 3
    private let containerCellID = "containerCellID"

    private lazy var currentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        let space = (UIScreen.main.bounds.width - itemWidth * column) / (column + 1)
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(HomeContainerCell.self, forCellWithReuseIdentifier: containerCellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var historyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        let space = (UIScreen.main.bounds.width - itemWidth * column) / (column + 1)
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(HomeContainerCell.self, forCellWithReuseIdentifier: containerCellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private var projectModels: [FileModel] = [FileModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupAssetsContainer()
        getProjects()
    }

    private func setupUI() {
        view.addSubview(currentCollectionView)
        currentCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(88)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        view.addSubview(historyCollectionView)
        historyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(88)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        let control = BetterSegmentedControl(frame: CGRect(x: 100.0,
                                                           y: 44,
                                                           width: view.bounds.width - 200,
                                                           height: 44.0))
        control.segments = LabelSegment.segments(withTitles: ["Current", "History"],
                                                          normalTextColor: UIColor(red: 0.48, green: 0.48, blue: 0.51, alpha: 1.00))
        control.addTarget(self, action: #selector(segmentedControl1ValueChanged(_:)), for: .valueChanged)
        view.addSubview(control)
    }
    
    @objc
    private func segmentedControl1ValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            // current
            currentCollectionView.isHidden = false
            historyCollectionView.isHidden = true
        } else {
            // history
            currentCollectionView.isHidden = true
            historyCollectionView.isHidden = false
            
            // reload history list
            
        }
    }
    
    private func reloadHistoryData() {
        
    }
    
    // create assets container
    private func setupAssetsContainer() {
        ARFileManager.shared.setupAssetsContainer()
    }
    
    // get assets
    private func getProjects() {
        ARFileManager.shared.traverseContainer { [weak self] projectModels in
            guard let self = self else { return }
            self.projectModels = projectModels
            self.currentCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeContainerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let projectModel = projectModels[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: containerCellID, for: indexPath) as? HomeContainerCell ?? HomeContainerCell()
        cell.setupUIWith(projectModel)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeContainerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let projectModel = projectModels[indexPath.row]
        let childVC = ChildProjectListViewController()
        childVC.modalPresentationStyle = .overFullScreen
        childVC.projectModel = projectModel
        present(childVC, animated: true)
    }
}
