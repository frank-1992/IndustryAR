//
//  CurrentProjectListController.swift
//  IndustryAR
//
//  Created by 吴熠 on 2/27/23.
//

import UIKit

class CurrentProjectListController: UIViewController {

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
    
    private var projectModels: [FileModel] = [FileModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAllFonts()
        setupAssetsContainer()
        getProjects()
        setupUI()
    }
    
    private func showAllFonts() {
        let familyNames = UIFont.familyNames
        for familyName in familyNames {
            let fontNames = UIFont.fontNames(forFamilyName: familyName as String)
            for fontName in fontNames {
                ShapeSetting.fontNameList.append(fontName)
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(currentCollectionView)
        currentCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupAssetsContainer() {
        ARFileManager.shared.setupAssetsContainer()
    }
    
    private func getProjects() {
        ARFileManager.shared.traverseContainer { [weak self] projectModels in
            guard let self = self else { return }
            self.projectModels = projectModels
            self.currentCollectionView.reloadData()
        }
    }
}

extension CurrentProjectListController: UICollectionViewDataSource {
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

extension CurrentProjectListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let projectModel = projectModels[indexPath.row]
        let childVC = ChildProjectListViewController()
        childVC.projectModel = projectModel
        navigationController?.pushViewController(childVC, animated: true)
    }
}
