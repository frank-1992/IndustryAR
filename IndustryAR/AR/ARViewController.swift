//
//  ARViewController.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/9/23.
//

import UIKit
import ARKit
import SceneKit

let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .compactMap({$0 as? UIWindowScene})
        .first?.windows
        .filter({$0.isKeyWindow}).first

let statusHeight = keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

class ARViewController: UIViewController {
    
    var assetModel: AssetModel?
    
    var usdzObjects: [VirtualObject] = []
    var scnObjects: [VirtualObject] = []
    
    private lazy var sceneView: ARView = {
        let sceneView = ARView(frame: view.bounds)
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        return sceneView
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
        dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadARModel()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    private func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.isLightEstimationEnabled = true
        configuration.environmentTexturing = .automatic
       
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
            fatalError("People occlusion is not supported on this device.")
        }
        switch configuration.frameSemantics {
        case [.personSegmentationWithDepth]:
            configuration.frameSemantics.remove(.personSegmentationWithDepth)
        default:
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        }
//        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        sceneView.session.run(configuration)
    }
    
    private func setupUI() {
        view.addSubview(sceneView)
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.top.equalTo(view.snp.top).offset(statusHeight + 10)
        }
    }
    
    private func loadARModel() {
        guard let assetModel = assetModel else { return }
        let usdzFiles = assetModel.usdzFilePaths
        let scnFiles = assetModel.scnFilePaths
        if !usdzFiles.isEmpty {
            for usdzFile in usdzFiles {
                if let usdzObject = VirtualObject(filePath: usdzFile.relativePath, fileName: assetModel.modelName) {
                    usdzObjects.append(usdzObject)
                    showVirtualObject(with: usdzObject)
                }
            }
        }
        
        if !scnFiles.isEmpty {
            for scnFile in scnFiles {
                if let scnObject = VirtualObject(filePath: scnFile.relativePath, fileName: assetModel.modelName) {
                    scnObjects.append(scnObject)
                    showVirtualObject(with: scnObject)
                }
            }
        }
    }
    
    private func showVirtualObject(with model: VirtualObject) {
        sceneView.scene.rootNode.addChildNode(model)
        model.scale = SCNVector3(1, 1, 1)
        model.simdWorldPosition = simd_float3(x: 0, y: -1, z: -2)
    }

}

// MARK: - ARSCNViewDelegate
extension ARViewController: ARSCNViewDelegate {
    
}

// MARK: - ARSessionDelegate
extension ARViewController: ARSessionDelegate {
    
}
