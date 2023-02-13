//
//  HomeContainerViewController.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/20/23.
//

import UIKit

class HomeContainerViewController: UIViewController {
    
    private let itemWidth: CGFloat = 220
    private let itemHeight: CGFloat = 300
    private let column: CGFloat = 3
    private let containerCellID = "containerCellID"

    private lazy var collectionView: UICollectionView = {
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
        view.addSubview(collectionView)
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
            self.collectionView.reloadData()
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
