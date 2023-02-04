//
//  ARViewController.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/9/23.
//

import UIKit
import ARKit
import SceneKit
import SnapKit

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
    
    private lazy var sceneView: ARSCNView = {
        let sceneView = ARSCNView(frame: view.bounds)
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
    
    private lazy var shapeMenuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.addTarget(self, action: #selector(showShapeMenuView(sender:)), for: .touchUpInside)
        button.tag = 100
        return button
    }()
    
    private var shapeMenuView: ShapeMenuView = {
        let view = ShapeMenuView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()

    @objc
    private func backButtonClicked() {
        dismiss(animated: true, completion: nil)
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
        
        sceneView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.top.equalTo(sceneView.snp.top).offset(statusHeight + 10)
        }
        
        sceneView.addSubview(shapeMenuButton)
        shapeMenuButton.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.top.equalTo(sceneView.snp.top).offset(statusHeight + 10)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        
        sceneView.addSubview(shapeMenuView)
        shapeMenuView.snp.makeConstraints { make in
            make.left.equalTo(sceneView.snp.right)
            make.top.equalTo(shapeMenuButton)
            make.size.equalTo(CGSize(width: 300, height: 540))
        }
    }
    
    private func loadARModel() {
        guard let assetModel = assetModel else { return }
        let usdzFiles = assetModel.usdzFilePaths
        let scnFiles = assetModel.scnFilePaths
        if !usdzFiles.isEmpty {
            for usdzFile in usdzFiles {
                if let usdzObject = VirtualObject(filePath: usdzFile.relativePath, fileName: assetModel.assetName) {
                    usdzObjects.append(usdzObject)
                    showVirtualObject(with: usdzObject)
                }
            }
        }
        
        if !scnFiles.isEmpty {
            for scnFile in scnFiles {
                if let scnObject = VirtualObject(filePath: scnFile.relativePath, fileName: assetModel.assetName) {
                    scnObjects.append(scnObject)
                    showVirtualObject(with: scnObject)
                }
            }
        }
    }
    
    private func showVirtualObject(with model: VirtualObject) {
        let boundingBox = model.boundingBox
        let bmax = boundingBox.max
        let bmin = boundingBox.min
        let width = bmax.x - bmin.x
        let depth = bmax.z - bmin.z
        let height = bmax.y - bmin.y

        model.scale = SCNVector3(1, 1, 1)
        model.simdWorldPosition = simd_float3(x: 0, y: -height / 2.0, z: -1 - depth)
        sceneView.scene.rootNode.addChildNode(model)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // circle
//        let circleNode = Circle()
//        circleNode.simdWorldPosition = simd_float3(x: 0, y: 0, z: 0)
//        sceneView.scene.rootNode.addChildNode(circleNode)
//
//
//        // square
//        let squareNode = Square()
//        squareNode.simdWorldPosition = simd_float3(x: 0, y: 0.2, z: -0.5)
//        sceneView.scene.rootNode.addChildNode(squareNode)
//        
//        // triangle
//        let triangleNode = Triangle()
//        triangleNode.simdWorldPosition = simd_float3(x: 0, y: -0.2, z: -0.5)
//        sceneView.scene.rootNode.addChildNode(triangleNode)

        
        // line
    }
    
    @objc
    private func showShapeMenuView(sender: UIButton) {
        if sender.tag == 100 {
            sender.tag = 101
            UIView.animate(withDuration: 0.3) {
                sender.transform = CGAffineTransform(translationX: -300, y: 0)
                self.shapeMenuView.transform = CGAffineTransform(translationX: -300, y: 0)
            } completion: { _ in
                sender.setImage(UIImage(named: "close"), for: .normal)
            }
        } else {
            sender.tag = 100
            UIView.animate(withDuration: 0.3) {
                sender.transform = CGAffineTransformIdentity
                self.shapeMenuView.transform = CGAffineTransformIdentity
            } completion: { _ in
                sender.setImage(UIImage(named: "menu"), for: .normal)
            }
        }
    }

}

// MARK: - ARSCNViewDelegate
extension ARViewController: ARSCNViewDelegate {
    
}

// MARK: - ARSessionDelegate
extension ARViewController: ARSessionDelegate {
    
}
