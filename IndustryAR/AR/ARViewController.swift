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
        sceneView.preferredFramesPerSecond = 60
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
    
    // About Line
    var strokeAnchorIDs: [UUID] = []
    var currentStrokeAnchorNode: SCNNode?
    var currentStrokeColor: StrokeColor = .white
    let sphereNodesManager = SphereNodesManager()
    var previousPoint: SCNVector3?
    var currentFingerPosition: CGPoint?
    var distanceFromCamera: Float = 1.0
    
    var function: Function?
    
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
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        currentStrokeAnchorNode = nil
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
        
        shapeMenuView.selectShapeTypeClosure = { [weak self] function in
            guard let self = self else { return }
            self.function = function
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
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
//    }
    
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
    
    // MARK: Drawing
    private func createSphereAndInsert(atPositions positions: [SCNVector3], andAddToStrokeAnchor strokeAnchor: StrokeAnchor) {
        for position in positions {
            createSphereAndInsert(atPosition: position, andAddToStrokeAnchor: strokeAnchor)
        }
    }
    
    private func createSphereAndInsert(atPosition position: SCNVector3, andAddToStrokeAnchor strokeAnchor: StrokeAnchor) {
        guard let currentStrokeNode = currentStrokeAnchorNode else {
            return
        }
        // Get the reference sphere node and clone it
        let referenceSphereNode = sphereNodesManager.getReferenceSphereNode(forStrokeColor: strokeAnchor.color)
        let newSphereNode = referenceSphereNode.clone()
        // Convert the position from world transform to local transform (relative to the anchors default node)
        let localPosition = currentStrokeNode.convertPosition(position, from: nil)
        newSphereNode.position = localPosition
        // Add the node to the default node of the anchor
        currentStrokeNode.addChildNode(newSphereNode)
        // Add the position of the node to the stroke anchors sphereLocations array (Used for saving/loading the world map)
        strokeAnchor.sphereLocations.append([newSphereNode.position.x, newSphereNode.position.y, newSphereNode.position.z])
    }
    
    private func anchorForID(_ anchorID: UUID) -> StrokeAnchor? {
        return sceneView.session.currentFrame?.anchors.first(where: { $0.identifier == anchorID }) as? StrokeAnchor
    }
    
    private func sortStrokeAnchorIDsInOrderOfDateCreated() {
        var strokeAnchorsArray: [StrokeAnchor] = []
        for anchorID in strokeAnchorIDs {
            if let strokeAnchor = anchorForID(anchorID) {
                strokeAnchorsArray.append(strokeAnchor)
            }
        }
        strokeAnchorsArray.sort(by: { $0.dateCreated < $1.dateCreated })
        
        strokeAnchorIDs = []
        for anchor in strokeAnchorsArray {
            strokeAnchorIDs.append(anchor.identifier)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let function = function, function == .line else { return }
        guard let touch = touches.first else { return }
        guard let touchPositionInFrontOfCamera = getPosition(ofPoint: touch.location(in: sceneView), atDistanceFromCamera: distanceFromCamera, inView: sceneView) else { return }
        // Convert the position from SCNVector3 to float4x4
        let strokeAnchor = StrokeAnchor(name: "strokeAnchor", transform: float4x4(SIMD4(x: 1, y: 0, z: 0, w: 0),
                                                                                  SIMD4(x: 0, y: 1, z: 0, w: 0),
                                                                                  SIMD4(x: 0, y: 0, z: 1, w: 0),
                                                                                  SIMD4(x: touchPositionInFrontOfCamera.x,
                                                                                        y: touchPositionInFrontOfCamera.y,
                                                                                        z: touchPositionInFrontOfCamera.z,
                                                                                        w: 1)))
        strokeAnchor.color = currentStrokeColor
        sceneView.session.add(anchor: strokeAnchor)
        currentFingerPosition = touch.location(in: sceneView)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let function = function, function == .line else { return }
        guard let touch = touches.first else { return }
        currentFingerPosition = touch.location(in: sceneView)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        previousPoint = nil
        currentStrokeAnchorNode = nil
        currentFingerPosition = nil
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        previousPoint = nil
        currentStrokeAnchorNode = nil
        currentFingerPosition = nil
    }

}

// MARK: - ARSCNViewDelegate
extension ARViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let strokeAnchor = anchor as? StrokeAnchor {
            currentStrokeAnchorNode = node
            strokeAnchorIDs.append(strokeAnchor.identifier)
            for sphereLocation in strokeAnchor.sphereLocations {
                createSphereAndInsert(atPosition: SCNVector3Make(sphereLocation[0], sphereLocation[1], sphereLocation[2]), andAddToStrokeAnchor: strokeAnchor)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        // Remove the anchorID from the strokes array
        strokeAnchorIDs.removeAll(where: { $0 == anchor.identifier })
    }
}

// MARK: - ARSessionDelegate
extension ARViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if !usdzObjects.isEmpty || !scnObjects.isEmpty {
            let camera = frame.camera
            let transform = camera.transform
            if let usdz = usdzObjects.first?.worldPosition {
                calculateDistanceFromCamera(node: SIMD3(usdz.x, usdz.y, usdz.z), camera: transform.translation)
            } else if let scn = scnObjects.first?.worldPosition {
                calculateDistanceFromCamera(node: SIMD3(scn.x, scn.y, scn.z), camera: transform.translation)
            }
            
        }
        
        // Draw the spheres
        guard let currentStrokeAnchorID = strokeAnchorIDs.last else { return }
        let currentStrokeAnchor = anchorForID(currentStrokeAnchorID)
        if currentFingerPosition != nil && currentStrokeAnchor != nil {
            guard let currentPointPosition = getPosition(ofPoint: currentFingerPosition!, atDistanceFromCamera: distanceFromCamera, inView: sceneView) else { return }
            
            if let previousPoint = previousPoint {
                // Do not create any new spheres if the distance hasn't changed much
                let distance = abs(previousPoint.distance(vector: currentPointPosition))
                if distance > 0.00104 {
                    createSphereAndInsert(atPosition: currentPointPosition, andAddToStrokeAnchor: currentStrokeAnchor!)
                    // Draw spheres between the currentPoint and previous point if they are further than the specified distance (Otherwise fast movement will make the line blocky)
                    // TODO: The spacing should depend on the brush size
                    let positions = getPositionsOnLineBetween(point1: previousPoint, andPoint2: currentPointPosition, withSpacing: 0.001)
                    createSphereAndInsert(atPositions: positions, andAddToStrokeAnchor: currentStrokeAnchor!)
                    self.previousPoint = currentPointPosition
                }
            } else {
                createSphereAndInsert(atPosition: currentPointPosition, andAddToStrokeAnchor: currentStrokeAnchor!)
                self.previousPoint = currentPointPosition
            }
        }
        
    }
    
    func calculateDistanceFromCamera(node: SIMD3<Float>, camera: SIMD3<Float>) {
        let start = node
        let end = camera
        
        let distance = sqrt(
            pow(end.x - start.x, 2) +
            pow(end.y - start.y, 2) +
            pow(end.z - start.z, 2)
        )
        
//        distanceFromCamera = distance
    }
}
