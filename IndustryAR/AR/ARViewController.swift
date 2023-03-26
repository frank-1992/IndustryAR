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
import HandyJSON
import PKHUD

let keyWindow = UIApplication.shared.connectedScenes
    .filter({$0.activationState == .foregroundActive})
    .compactMap({$0 as? UIWindowScene})
    .first?.windows
    .filter({$0.isKeyWindow}).first

let statusHeight = keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let historyPath = documentsPath.appendingPathComponent("History", isDirectory: true)

private extension SCNVector3 {
    func distance(to vector: SCNVector3) -> Float {
        let diff = SCNVector3(x - vector.x, y - vector.y, z - vector.z)
        return sqrt(diff.x * diff.x + diff.y * diff.y + diff.z * diff.z)
    }
}

class ARViewController: UIViewController {
    
    var assetModel: AssetModel?
    var historyModel: HistoryModel?
    
    var usdzObjects: [SCNNode] = []
    var scnObjects: [SCNNode] = []
    
    //_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____DIPRO_START_2023/02/09_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____
    var bGestureRemoved: Bool = false
    var oneFingerPanGesture: UIPanGestureRecognizer?
    var twoFingerPanGesture: UIPanGestureRecognizer?
    var rotateZGesture: UIRotationGestureRecognizer?
    
    var cadModelRoot: SCNNode?
    var markerRoot: SCNNode?
    var lightRoot: SCNNode?
    
    var prevOneFingerLocation: CGPoint?
    var currOneFingerLocation: CGPoint?
    
    var prevTwoFingerLocation: CGPoint?
    var currTwoFingerLocation: CGPoint?
    var prevTwoFingerDelta: SCNVector3 = SCNVector3(0,0,0)
    
    var panDirection: String?
    var lastAngle: Float = 0.0
    //_____AAAAAAAAAAAAAAAAAAAAAAAAAAAAA______DIPRO_END_2023/02/09______AAAAAAAAAAAAAAAAAAAAAAAAAAAAA_____
    
    private lazy var sceneView: ARSCNView = {
        let sceneView = ARSCNView(frame: view.bounds)
        sceneView.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        sceneView.preferredFramesPerSecond = 60
        return sceneView
    }()
    
    //    var configuration = ARWorldTrackingConfiguration()
    
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
    
    private lazy var shapeMenuView: ShapeMenuView = {
        let view = ShapeMenuView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var bottomMenuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "zhankai"), for: .normal)
        button.addTarget(self, action: #selector(showBottomMenuView(sender:)), for: .touchUpInside)
        button.tag = 200
        return button
    }()
    
    private lazy var bottomMenuView: BottomMenuView = {
        let view = BottomMenuView(frame: .zero)
        view.isHidden = true
        return view
    }()
    
    lazy var customerPickerView: UIPickerView = {
        let fontPickerView = UIPickerView()
        fontPickerView.dataSource = self
        fontPickerView.delegate = self
        fontPickerView.backgroundColor = .white
        return fontPickerView
    }()
    
    lazy var fontToolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: .zero)
        toolBar.barStyle = UIBarStyle.black
        toolBar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: cancel.localizedString(), style: .plain, target: self, action: #selector(cancelAction))
        let confirmButton = UIBarButtonItem(title: confirm.localizedString(), style: .plain, target: self, action: #selector(confirmAction))
        let flexSpace = UIBarButtonItem(systemItem: .flexibleSpace)
        toolBar.setItems([cancelButton, flexSpace, confirmButton], animated: true)
        return toolBar
    }()
    
    var currentFontName: String = "PingFang-SC-Regular"
    var currentLineType: LineType = .normal

    
    // SCNLine
    var pointTouching: CGPoint = .zero
    var isDrawing: Bool = false
    var drawingNode: SCNLineNode?
    var centerVerticesCount: Int32 = 0
    var hitVertices: [SCNVector3] = []
    var lastPoint = SCNVector3Zero
    var minimumMovement: Float = 0.005
    
    // ========================
    var function: Function?
    
    var settingsVC: SettingsViewController?
    
    var isRecordingVideo: Bool = false
    
    // SCNTetx
    var textGeometry: SCNGeometry?
    
    // SCNNode-----Circle
    var circleNodes: [Circle] = [Circle]()
    
    // SCNNode-----Square
    var squareNodes: [Square] = [Square]()
    
    // SCNNode-----Triangle
    var triangleNodes: [Triangle] = [Triangle]()
    
    // SCNNode-----Text
    var textNodes: [SCNTextNode] = [SCNTextNode]()
    
    // SCNNode-----Line
    var lineNodes: [SCNLineNode] = [SCNLineNode]()
    
    var removedOcclusion: Bool = false
    var backgroundPhotography: Bool = false
    
    var currentPickerViewType: PickerViewType = .fontName
    
    var isSavedScene: Bool = false
    
    @objc
    private func backButtonClicked() {
        if isSavedScene {
            navigationController?.popViewController(animated: true)
        } else {
            // show save tip window
            let alert = UIAlertController(title: save_window_tip.localizedString(), message: "", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: cancel.localizedString(), style: UIAlertAction.Style.default, handler: { _ in
                //cancel Action
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: save.localizedString(),
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                //save action
                self.saveScene(true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadARModel()
        setupUI()
        setupRecorder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        UIApplication.shared.isIdleTimerDisabled = true
        resetTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        sceneView.session.pause()
    }
    
    private func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.isLightEstimationEnabled = true
        configuration.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            configuration.sceneReconstruction = .mesh
        }
        
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    private func setupRecorder() {
        sceneView.prepareForRecording()
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
            make.size.equalTo(CGSize(width: 300, height: 600))
        }
        
        sceneView.addSubview(bottomMenuButton)
        bottomMenuButton.snp.makeConstraints { make in
            make.bottom.equalTo(sceneView.safeAreaLayoutGuide).offset(-20)
            make.left.equalTo(sceneView).offset(10)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        
        sceneView.addSubview(bottomMenuView)
        bottomMenuView.snp.makeConstraints { make in
            make.right.equalTo(sceneView.snp.left)
            make.centerY.equalTo(bottomMenuButton)
            make.height.equalTo(60)
            make.width.equalTo(400)
        }
        
        if UserDefaults.hasAutoShowBottomMenu {
            bottomMenuView.autoButton.setTitle("AUTO", for: .normal)
        }
        
        showSettingsVC()
        
        shapeMenuView.deselectShapeTypeClosure = { [weak self] function in
            guard let self = self else { return }
            self.function = function
            self.setDeleteFlagHiddenState(isHidden: true, completion: nil)
            if(self.bGestureRemoved)
            {
                self.sceneView.addGestureRecognizer(self.oneFingerPanGesture!)
                self.sceneView.addGestureRecognizer(self.twoFingerPanGesture!)
                self.sceneView.addGestureRecognizer(self.rotateZGesture!)
                self.bGestureRemoved = false;
            }
        }
        
        shapeMenuView.selectShapeTypeClosure = { [weak self] function in
            guard let self = self else { return }
            self.function = function
            
            //_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____DIPRO_START_2023/02/09_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____
            if function == .line {
                if(!self.bGestureRemoved)
                {
                    self.sceneView.removeGestureRecognizer(self.oneFingerPanGesture!)
                    self.sceneView.removeGestureRecognizer(self.twoFingerPanGesture!)
                    self.sceneView.removeGestureRecognizer(self.rotateZGesture!)
                    self.bGestureRemoved = true;
                }
            }
            else {
                if(self.bGestureRemoved)
                {
                    self.sceneView.addGestureRecognizer(self.oneFingerPanGesture!)
                    self.sceneView.addGestureRecognizer(self.twoFingerPanGesture!)
                    self.sceneView.addGestureRecognizer(self.rotateZGesture!)
                    self.bGestureRemoved = false;
                }
            }
            //_____AAAAAAAAAAAAAAAAAAAAAAAAAAAAA______DIPRO_END_2023/02/09______AAAAAAAAAAAAAAAAAAAAAAAAAAAAA_____
            
            if function == .settings {
                // settings vc
                self.settingsVC?.view.isHidden = false
            }
            
            if function == .text {
                let textInputView = TextInputView(frame: .zero)
                self.view.addSubview(textInputView)
                
                textInputView.snp.makeConstraints { make in
                    make.center.equalTo(self.view)
                    make.size.equalTo(CGSize(width: 300, height: 140))
                }
                
                textInputView.confirmTextClosure = { content in
                    let text = SCNText(string: content, extrusionDepth: 0.01)
                    text.font = UIFont(name: "PingFang-SC-Regular", size: ShapeSetting.fontSize)
                    let material = SCNMaterial()
                    material.diffuse.contents = ShapeSetting.textColor
                    material.writesToDepthBuffer = false
                    material.readsFromDepthBuffer = false
                    text.materials = [material]
                    self.textGeometry = text
                    
                    self.shapeMenuView.resetUI()
                }
                
                textInputView.cancelClosure = {
                    self.shapeMenuView.resetUI()
                }
            }
            
            if function == .occlusion {
                if self.removedOcclusion {
                    self.removedOcclusion = false
                    let configuration = ARWorldTrackingConfiguration()
                    configuration.planeDetection = [.horizontal, .vertical]
                    configuration.isLightEstimationEnabled = true
                    configuration.environmentTexturing = .automatic
                    
                    if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
                        configuration.sceneReconstruction = .mesh
                    }
                    self.sceneView.session.run(configuration, options: [.resetSceneReconstruction])
                    
                    self.shapeMenuView.resetOcclusionTitleState(title: remove_occlusion.localizedString())
                } else {
                    self.removedOcclusion = true
                    let configuration = ARWorldTrackingConfiguration()
                    configuration.planeDetection = [.horizontal, .vertical]
                    configuration.isLightEstimationEnabled = true
                    configuration.environmentTexturing = .automatic
                    self.sceneView.session.run(configuration, options: [.resetSceneReconstruction])
                    
                    self.shapeMenuView.resetOcclusionTitleState(title: insert_occlusion.localizedString())
                }
            }
            
            if function == .showSymbol {
                guard let markerRoot = self.markerRoot else { return }
                markerRoot.isHidden = !markerRoot.isHidden
                if markerRoot.isHidden {
                    self.shapeMenuView.resetMarkerTitleState(title: marker_local.localizedString())
                } else {
                    self.shapeMenuView.resetMarkerTitleState(title: none_marker_local.localizedString())
                }
                self.shapeMenuView.resetUI()
            }
            
            if function == .delete {
                self.setDeleteFlagHiddenState(isHidden: false, completion: nil)
            }
            
            if function == .background {
                // 背景摄影（Background Photography）->删除背景（Delete Background）
                if self.backgroundPhotography {
                    self.backgroundPhotography = false
                    self.shapeMenuView.resetBackgroundTitleState(title: background_photography.localizedString())
                } else {
                    self.backgroundPhotography = true
                    self.shapeMenuView.resetBackgroundTitleState(title: delete_background_photography.localizedString())
                }
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        tap.delegate = self
        sceneView.addGestureRecognizer(tap)
        
        //_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____DIPRO_START_2023/02/09_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____
        // rotate around x, y axis
        oneFingerPanGesture = UIPanGestureRecognizer(target: self, action: #selector(didRotateXYAxis(_:)))
        oneFingerPanGesture?.minimumNumberOfTouches = 1;
        oneFingerPanGesture?.maximumNumberOfTouches = 1;
        sceneView.addGestureRecognizer(oneFingerPanGesture!)
        
        // translate x, y, z axis
        twoFingerPanGesture = UIPanGestureRecognizer(target: self, action: #selector(didTranslateXYZAxis(_:)))
        twoFingerPanGesture?.minimumNumberOfTouches = 2;
        twoFingerPanGesture?.maximumNumberOfTouches = 2;
        sceneView.addGestureRecognizer(twoFingerPanGesture!)
        
        //rotate around z axis
        rotateZGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotateZAxis(_:)))
        sceneView.addGestureRecognizer(rotateZGesture!)
        //_____AAAAAAAAAAAAAAAAAAAAAAAAAAAAA______DIPRO_END_2023/02/09______AAAAAAAAAAAAAAAAAAAAAAAAAAAAA_____
        
        // take photo
        bottomMenuView.takePictureClosure = { [weak self]  in
            guard let self = self else { return }
            self.sceneView.takePhoto { (photo: UIImage) in
                let controller = RecorderResultViewController(mediaType: .image(photo))
                self.addChild(controller)
                self.view.addSubview(controller.view)
                controller.view.snp.makeConstraints { make in
                    make.center.equalTo(self.view)
                    make.width.equalTo(self.view.frame.width * 0.8)
                    make.height.equalTo(self.view.frame.height * 0.8)
                }
            }
            // auto show
            self.resetBottomMenuView()
        }
        
        // record video
        bottomMenuView.recordVideoClosure = { [weak self]  in
            guard let self = self else { return }
            if !self.isRecordingVideo {
                do {
                    try self.sceneView.startVideoRecording()
                    self.isRecordingVideo = true
                    self.bottomMenuView.startRecording()
                } catch {
                    print("record video has error")
                }
            } else {
                self.sceneView.finishVideoRecording { (videoRecording) in
                    // auto show
                    self.resetBottomMenuView()
                    
                    self.isRecordingVideo = false
                    self.bottomMenuView.stopRecording()
                    /* Process the captured video. Main thread. */
                    let controller = RecorderResultViewController(mediaType: .video(videoRecording.url))
                    self.addChild(controller)
                    self.view.addSubview(controller.view)
                    controller.view.snp.makeConstraints { make in
                        make.center.equalTo(self.view)
                        make.width.equalTo(self.view.frame.width * 0.8)
                        make.height.equalTo(self.view.frame.height * 0.8)
                    }
                }
            }
        }
        
        // align
        bottomMenuView.alignClosure = { [weak self]  in
            guard let self = self else { return }
            
            // auto show
            self.resetBottomMenuView()
        }
        
        // save SCN file
        bottomMenuView.saveSCNClosure = { [weak self]  in
            guard let self = self else { return }
            self.saveScene()
        }
        
        // auto settings
        bottomMenuView.autoSettingClosure = { sender in
            if !UserDefaults.hasAutoShowBottomMenu {
                UserDefaults.hasAutoShowBottomMenu = true
                sender.setTitle("AUTO", for: .normal)
            } else {
                UserDefaults.hasAutoShowBottomMenu = false
                sender.setTitle("SHOW", for: .normal)
            }
        }
    }
    
    private func saveScene(_ needBack: Bool = false) {
        let textInputView = TextInputView(frame: .zero)
        self.view.addSubview(textInputView)
        
        textInputView.snp.makeConstraints { make in
            make.center.equalTo(self.view)
            make.size.equalTo(CGSize(width: 300, height: 140))
        }
        
        // save with name
        textInputView.confirmTextClosure = { [weak self] name in
            guard let self = self else { return }
            let fileName = name
            
//            // check if the file name exists
//            let fileNamesString = UserDefaults.fileNamesString
//            let fileNameModels = JsonUtil.jsonArrayToModel(fileNamesString, SceneModel.self)
//            let fileNameIsExist = fileNameModels.contains(where: {$0.fileName == fileName})
//            if fileNameIsExist {
//                //
//            }
                        
            let dirURL = historyPath.appendingPathComponent(fileName, isDirectory: true)
            var isDirectory: ObjCBool = ObjCBool(false)
            let isExist = FileManager.default.fileExists(atPath: dirURL.path, isDirectory: &isDirectory)
            if isExist {
                // show the tip window
                let alert = UIAlertController(title: save_cover_tip.localizedString(), message: "", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: cancel.localizedString(), style: UIAlertAction.Style.default, handler: { _ in
                    //cancel Action
                    
                }))
                alert.addAction(UIAlertAction(title: save.localizedString(),
                                              style: UIAlertAction.Style.default,
                                              handler: {(_: UIAlertAction!) in
                    //save action
                    self.saveTheScene(with: fileName, dirURL: dirURL, needBack: needBack)
                    textInputView.removeFromSuperview()
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.saveTheScene(with: fileName, dirURL: dirURL, needBack: needBack)
                textInputView.removeFromSuperview()
            }
        }
    }
    
    private func saveTheScene(with fileName: String, dirURL: URL, needBack: Bool) {
        do {
            try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("createDirectory error:\(error)")
        }
        
        setDeleteFlagHiddenState(isHidden: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.sceneView.takePhoto { (photo: UIImage) in
                    let photoURL = dirURL.appendingPathComponent(fileName + ".png")
                    let imageData = photo.pngData()
                    try? imageData?.write(to: photoURL)
                }
            }
        }
        
        // save marker names
        for (index, circle) in circleNodes.enumerated() {
            let name = "circle" + "\(index)"
            circle.name = name
        }
        for (index, square) in squareNodes.enumerated() {
            let name = "square" + "\(index)"
            square.name = name
        }
        for (index, triangle) in triangleNodes.enumerated() {
            let name = "triangle" + "\(index)"
            triangle.name = name
        }
        for (index, textNode) in textNodes.enumerated() {
            let name = "text" + "\(index)"
            textNode.name = name
        }
        for (index, lineNode) in lineNodes.enumerated() {
            let name = "line" + "\(index)"
            lineNode.name = name
        }
        
        let fileURL = dirURL.appendingPathComponent(fileName + ".scn")
        sceneView.scene.write(to: fileURL, options: nil, delegate: nil, progressHandler: nil)
        // auto show
        resetBottomMenuView()
        isSavedScene = true
        HUD.flash(.label(save_success.localizedString()), delay: 1) { _ in
            if needBack {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func resetBottomMenuView() {
        if UserDefaults.hasAutoShowBottomMenu {
            bottomMenuButton.tag = 201
            showBottomMenuView(sender: bottomMenuButton)
        } else {
            bottomMenuButton.tag = 200
            showBottomMenuView(sender: bottomMenuButton)
        }
    }
    
    private func setDeleteFlagHiddenState(isHidden: Bool, completion: (() -> Void)?) {
        for circleNode in self.circleNodes {
            for deleteFlagNode in circleNode.childNodes {
                if let flagName = deleteFlagNode.name, flagName.contains("plane_for_hit") {
                    deleteFlagNode.isHidden = isHidden
                }
            }
        }
        for squareNode in self.squareNodes {
            for deleteFlagNode in squareNode.childNodes {
                if let flagName = deleteFlagNode.name, flagName.contains("plane_for_hit") {
                    deleteFlagNode.isHidden = isHidden
                }
            }
        }
        for triangleNode in self.triangleNodes {
            for deleteFlagNode in triangleNode.childNodes {
                if let flagName = deleteFlagNode.name, flagName.contains("plane_for_hit") {
                    deleteFlagNode.isHidden = isHidden
                }
            }
        }
        for textNode in self.textNodes {
            for deleteFlagNode in textNode.childNodes {
                if let flagName = deleteFlagNode.name, flagName.contains("plane_for_hit") {
                    deleteFlagNode.isHidden = isHidden
                }
            }
        }
        for lineNode in self.lineNodes {
            for deleteFlagNode in lineNode.childNodes {
                if let flagName = deleteFlagNode.name, flagName.contains("plane_for_hit") {
                    deleteFlagNode.isHidden = isHidden
                }
            }
        }
        completion?()
    }
    
    // test geometry surface
    @objc
    private func tapAction(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)
        guard let hitResult = self.sceneView.hitTest(location, options: [SCNHitTestOption.searchMode: SCNHitTestSearchMode.closest.rawValue as NSNumber]).first else { return }
        
        if function == .delete {
            let hitNode = hitResult.node
            if hitNode.name == "plane_for_hit" {
                hitNode.parent?.removeFromParentNode()
            }
        } else {
            //_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____DIPRO_START_2023/02/09_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____
            
            let tapPoint_local = hitResult.localCoordinates
            let tapNode = hitResult.node
            let tapPoint_world_scn = tapNode.convertPosition(tapPoint_local, to: cadModelRoot)
            let tapPoint_world = simd_float3(tapPoint_world_scn.x, tapPoint_world_scn.y, tapPoint_world_scn.z)
            //_____AAAAAAAAAAAAAAAAAAAAAAAAAAAAA______DIPRO_END_2023/02/09______AAAAAAAAAAAAAAAAAAAAAAAAAAAAA_____
            
            guard let function = function else { return }
            if function == .triangle {
                let triangleNode = Triangle()
                //_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____DIPRO_START_2023/02/09_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____
                
                triangleNode.simdScale = simd_float3(1, 1, 1)
                //            let boundingbox = triangleNode.boundingBox
                //            print("三角形boundingbox: \(boundingbox)")
                
                let constraint = SCNBillboardConstraint()
                constraint.freeAxes = SCNBillboardAxis.Y
                triangleNode.constraints = [constraint]
                
                //cadModelRoot
                guard let cadModelRootNode = cadModelRoot else { return }
                
                // Convert the camera matrix to the nodes coordinate space
                guard let camera = sceneView.pointOfView else { return }
                let transform = camera.transform
                var localTransform = cadModelRootNode.convertTransform(transform, from: nil)
                localTransform.m41 = tapPoint_world.x
                localTransform.m42 = tapPoint_world.y
                localTransform.m43 = tapPoint_world.z
                triangleNode.transform = localTransform
                
                markerRoot?.addChildNode(triangleNode)
                triangleNodes.append(triangleNode)
                //_____AAAAAAAAAAAAAAAAAAAAAAAAAAAAA______DIPRO_END_2023/02/09______AAAAAAAAAAAAAAAAAAAAAAAAAAAAA_____
            }
            
            if function == .square {
                let squareNode = Square()
                //_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____DIPRO_START_2023/02/09_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____
                
                squareNode.simdScale = simd_float3(1, 1, 1)
                
                let constraint = SCNBillboardConstraint()
                constraint.freeAxes = SCNBillboardAxis.Y
                squareNode.constraints = [constraint]
                
                //cadModelRoot
                guard let cadModelRootNode = cadModelRoot else { return }
                
                // Convert the camera matrix to the nodes coordinate space
                guard let camera = sceneView.pointOfView else { return }
                let transform = camera.transform
                var localTransform = cadModelRootNode.convertTransform(transform, from: nil)
                localTransform.m41 = tapPoint_world.x
                localTransform.m42 = tapPoint_world.y
                localTransform.m43 = tapPoint_world.z
                squareNode.transform = localTransform
                
                markerRoot?.addChildNode(squareNode)
                squareNodes.append(squareNode)
                //_____AAAAAAAAAAAAAAAAAAAAAAAAAAAAA______DIPRO_END_2023/02/09______AAAAAAAAAAAAAAAAAAAAAAAAAAAAA_____
            }
            
            if function == .circle {
                let circleNode = Circle()
                //_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____DIPRO_START_2023/02/09_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____
                
                circleNode.simdScale = simd_float3(1, 1, 1)
                
                let constraint = SCNBillboardConstraint()
                constraint.freeAxes = SCNBillboardAxis.Y
                circleNode.constraints = [constraint]
                
                //cadModelRoot
                guard let cadModelRootNode = cadModelRoot else { return }
                
                // Convert the camera matrix to the nodes coordinate space
                guard let camera = sceneView.pointOfView else { return }
                let transform = camera.transform
                var localTransform = cadModelRootNode.convertTransform(transform, from: nil)
                localTransform.m41 = tapPoint_world.x
                localTransform.m42 = tapPoint_world.y
                localTransform.m43 = tapPoint_world.z
                circleNode.transform = localTransform
                
                markerRoot?.addChildNode(circleNode)
                circleNodes.append(circleNode)
                //_____AAAAAAAAAAAAAAAAAAAAAAAAAAAAA______DIPRO_END_2023/02/09______AAAAAAAAAAAAAAAAAAAAAAAAAAAAA_____
            }
            
            if function == .text {
                guard let textGeometry = textGeometry else {
                    return
                }
                
                let newTextNode = SCNTextNode(geometry: textGeometry)
                
                
                let constraint = SCNBillboardConstraint()
                constraint.freeAxes = SCNBillboardAxis.Y
                newTextNode.constraints = [constraint]
                
                let min = newTextNode.boundingBox.min * ShapeSetting.textScale
                let max = newTextNode.boundingBox.max * ShapeSetting.textScale
                let width = max.x - min.x
                let depth = max.z - min.z
                
                let centerX = tapPoint_world.x//- width/2.0
                let centerY = tapPoint_world.y
                let centerZ = tapPoint_world.z - depth/2.0
                
                newTextNode.position = SCNVector3(x: centerX, y: centerY, z: centerZ)
                
                markerRoot?.addChildNode(newTextNode)
                textNodes.append(newTextNode)
            }
        }
    }
    
    //_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____DIPRO_START_2023/02/09_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____
    
    //rotate around x or y axis
    @objc func didRotateXYAxis(_ panGesture: UIPanGestureRecognizer) {
        //print("didOneFingerPan")
        
        if(self.function == .line) {
            return
        }
        
        guard let cadModelNode = cadModelRoot else {
            return
        }
        
        if panGesture.state == .began {
            lastAngle = 0.0   // reset last angle
            return
        }
        
        let cadModelBBox = cadModelNode.getCadModelWorldBoundingBox(cadModelRoot: cadModelNode)
        let cx = (cadModelBBox.max.x + cadModelBBox.min.x) / 2
        let cy = (cadModelBBox.max.y + cadModelBBox.min.y) / 2
        let cz = (cadModelBBox.max.z + cadModelBBox.min.z) / 2
        
        /*
         if(cadModelBBox.min.x == Float.greatestFiniteMagnitude || cadModelBBox.max.x == -Float.greatestFiniteMagnitude) {
         let model = cadModelNode.childNodes[0]
         let cx1 = (model.boundingBox.max.x + model.boundingBox.min.x) / 2
         let cy1 = (model.boundingBox.max.y + model.boundingBox.min.y) / 2
         let cz1 = (model.boundingBox.max.z + model.boundingBox.min.z) / 2
         
         cadModelNode.simdWorldTransform = simd_float4x4(
         SIMD4(1, 0, 0, 0),
         SIMD4(0, 1, 0, 0),
         SIMD4(0, 0, 1, 0),
         SIMD4(0, 0, 0, 1)
         )
         cadModelNode.transform = SCNMatrix4(
         m11:1, m12:0, m13:0, m14:0,
         m21:0, m22:1, m23:0, m24:0,
         m31:0, m32:0, m33:1, m34:0,
         m41:0, m42:0, m43:0, m44:1)
         
         cadModelNode.scale = SCNVector3(1, 1, 1)
         cadModelNode.position = SCNVector3(x: 0, y: -cy1, z: -0.5)
         return
         }
         */
        
        cadModelNode.pivot = SCNMatrix4MakeTranslation(
            cx,
            cy,
            cz
        )
        let savePosition = cadModelNode.position
        cadModelNode.position = SCNVector3(x: 0, y: 0, z: 0)
        
        // get pan direction
        let velocity: CGPoint = panGesture.velocity(in: self.view!)
        if self.panDirection == nil {
            self.panDirection = getPanDirectionForRotation(velocity: velocity)
        }
        
        let translation = panGesture.translation(in: panGesture.view!)
        let anglePan = (self.panDirection == "horizontal") ?  deg2rad(deg: Float(translation.x)) :
        deg2rad(deg: Float(translation.y))
        
        var x:Float = (self.panDirection == "vertical" ) ? 1.0 : 0.0
        var y:Float = (self.panDirection == "horizontal" ) ?  1.0 : 0.0
        
        // calculate the angle change from last call
        let fraction = anglePan - lastAngle
        lastAngle = anglePan
        
        //カメラ座標系からワールド座標系に変換
        var orig = SCNVector3(0,0,0)
        var axis = SCNVector3(x,y,0)
        if let camera = sceneView.pointOfView { // カメラを取得
            orig = camera.convertPosition(orig, to: nil)
            axis = camera.convertPosition(axis, to: nil)
            axis = axis - orig
            axis = axis.normalized();
        }
        if((axis.x == 0.0 && axis.y == 0.0 && axis.z == 0.0) || axis.x.isNaN || axis.y.isNaN || axis.z.isNaN) {
            x = 1.0
            y = 1.0
            orig = SCNVector3(0,0,0)
            axis = SCNVector3(x,y,0)
            if let camera = sceneView.pointOfView { // カメラを取得
                orig = camera.convertPosition(orig, to: nil)
                axis = camera.convertPosition(axis, to: nil)
                axis = axis - orig
                axis = axis.normalized();
            }
            if((axis.x == 0.0 && axis.y == 0.0 && axis.z == 0.0) || axis.x.isNaN || axis.y.isNaN || axis.z.isNaN) {
                cadModelNode.position = savePosition
                return;
            }
        }
        
        cadModelNode.transform = SCNMatrix4Mult(cadModelNode.transform,SCNMatrix4MakeRotation(fraction,  axis.x, axis.y, axis.z))
        //cadModelNode.transform = SCNMatrix4Mult(cadModelNode.transform,SCNMatrix4MakeRotation(fraction,  x, y, 0))
        
        if(panGesture.state == .ended) {
            self.panDirection = nil
        }
        
        cadModelNode.position = savePosition
    }
    
    //rotate around z axis
    @objc func didRotateZAxis(_ rotationGesture: UIRotationGestureRecognizer) {
        //print("didRotateZ")
        if(self.function == .line) {
            return
        }
        
        guard let cadModelNode = cadModelRoot else {
            return
        }
        
        let cadModelBBox = cadModelNode.getCadModelWorldBoundingBox(cadModelRoot: cadModelNode)
        let cx = (cadModelBBox.max.x + cadModelBBox.min.x) / 2
        let cy = (cadModelBBox.max.y + cadModelBBox.min.y) / 2
        let cz = (cadModelBBox.max.z + cadModelBBox.min.z) / 2
        
        /*
         if(cadModelBBox.min.x == Float.greatestFiniteMagnitude || cadModelBBox.max.x == -Float.greatestFiniteMagnitude) {
         let model = cadModelNode.childNodes[0]
         let cx1 = (model.boundingBox.max.x + model.boundingBox.min.x) / 2
         let cy1 = (model.boundingBox.max.y + model.boundingBox.min.y) / 2
         let cz1 = (model.boundingBox.max.z + model.boundingBox.min.z) / 2
         
         cadModelNode.simdWorldTransform = simd_float4x4(
         SIMD4(1, 0, 0, 0),
         SIMD4(0, 1, 0, 0),
         SIMD4(0, 0, 1, 0),
         SIMD4(0, 0, 0, 1)
         )
         cadModelNode.transform = SCNMatrix4(
         m11:1, m12:0, m13:0, m14:0,
         m21:0, m22:1, m23:0, m24:0,
         m31:0, m32:0, m33:1, m34:0,
         m41:0, m42:0, m43:0, m44:1)
         
         cadModelNode.scale = SCNVector3(1, 1, 1)
         cadModelNode.position = SCNVector3(x: 0, y: -cy1, z: -0.5)
         return
         }
         */
        
        cadModelNode.pivot = SCNMatrix4MakeTranslation(
            cx,
            cy,
            cz
        )
        let savePosition = cadModelNode.position
        cadModelNode.position = SCNVector3(x: 0, y: 0, z: 0)
        
        if rotationGesture.state == .changed {
            
            //カメラ座標系からワールド座標系に変換
            var orig = SCNVector3(0,0,0)
            var axis = SCNVector3(0,0,-1)
            if let camera = sceneView.pointOfView { // カメラを取得
                orig = camera.convertPosition(orig, to: nil)
                axis = camera.convertPosition(axis, to: nil)
                axis = axis - orig
                axis = axis.normalized();
            }
            if((axis.x == 0.0 && axis.y == 0.0 && axis.z == 0.0) || axis.x.isNaN || axis.y.isNaN || axis.z.isNaN) {
                orig = SCNVector3(0,0,0)
                axis = SCNVector3(0.01,00.01,-1)
                if let camera = sceneView.pointOfView { // カメラを取得
                    orig = camera.convertPosition(orig, to: nil)
                    axis = camera.convertPosition(axis, to: nil)
                    axis = axis - orig
                    axis = axis.normalized();
                }
                if((axis.x == 0.0 && axis.y == 0.0 && axis.z == 0.0) || axis.x.isNaN || axis.y.isNaN || axis.z.isNaN) {
                    cadModelNode.position = savePosition
                    return;
                }
            }
            
            if rotationGesture.rotation < 0 { // clockwise
                let rotationAction = SCNAction.rotate(by: rotationGesture.rotation * 0.05, around: axis, duration: 0)
                cadModelNode.runAction(rotationAction)
                //model3d?.runAction(rotationAction)
            } else { // counterclockwise
                let rotationAction = SCNAction.rotate(by: rotationGesture.rotation * 0.05, around: axis, duration: 0)
                cadModelNode.runAction(rotationAction)
                //model3d?.runAction(rotationAction)
            }
        }
        
        cadModelNode.position = savePosition
    }
    
    
    // translate along x, y, z axis
    @objc func didTranslateXYZAxis(_ panGesture: UIPanGestureRecognizer) {
        //print("didTwoFingerPan")
        if(self.function == .line) {
            return
        }
        
        guard let cadModelNode = cadModelRoot else {
            return
        }
        
        // get pan direction
        let velocity: CGPoint = panGesture.velocity(in: self.view!)
        if self.panDirection == nil {
            self.panDirection = getPanDirectionForTranslation(velocity: velocity)
        }
        
        //print("pan direction : ", self.panDirection ?? "nil")
        
        let location = panGesture.location(in: self.sceneView)
        
        switch panGesture.state {
        case .began:
            prevTwoFingerLocation = location
            prevTwoFingerDelta = SCNVector3(0,0,0)
            
        case .changed:
            currTwoFingerLocation = location
            
            if let lastLocation = prevTwoFingerLocation {
                var delta = SCNVector3(0,0,0)
                var dirSign:Float = 1
                
                if(panDirection == "x-axis"){
                    delta.x = Float(location.x - lastLocation.x)/1000.0
                    //if((prevTwoFingerDelta.x > 0 && delta.x < 0) || (prevTwoFingerDelta.x < 0 && delta.x > 0)){
                    //    dirSign = -1
                    //}
                    if(abs(prevTwoFingerDelta.x) > 0 && abs(delta.x) > abs(prevTwoFingerDelta.x)*5.0){
                        //dirSign = -1
                        delta.x = prevTwoFingerDelta.x * 5.0
                    }
                    if(delta.x == 0){
                        dirSign = -1
                    }
                }
                else if(panDirection == "y-axis"){
                    delta.y = -Float(location.y - lastLocation.y)/1000.0
                    //if((prevTwoFingerDelta.y > 0 && delta.y < 0) || (prevTwoFingerDelta.y < 0 && delta.y > 0)){
                    //    dirSign = -1
                    //}
                    if(abs(prevTwoFingerDelta.y) > 0 && abs(delta.y) > abs(prevTwoFingerDelta.y)*5.0){
                        //dirSign = -1
                        delta.y = prevTwoFingerDelta.y * 5.0
                    }
                    if(delta.y == 0){
                        dirSign = -1
                    }
                }
                else if(panDirection == "z-axis"){
                    delta.z = sqrt(Float(location.x - lastLocation.x) * Float(location.x - lastLocation.x) + Float(location.y - lastLocation.y) * Float(location.y - lastLocation.y))/1000.0
                    if(location.y - lastLocation.y < 0.0){
                        delta.z = -delta.z
                    }
                    //if((prevTwoFingerDelta.z > 0 && delta.z < 0) || (prevTwoFingerDelta.z < 0 && delta.z > 0)){
                    //    dirSign = -1
                    //}
                    if(abs(prevTwoFingerDelta.z) > 0 && abs(delta.z) > abs(prevTwoFingerDelta.z)*5.0){
                        //dirSign = -1
                        delta.z = prevTwoFingerDelta.z * 5.0
                    }
                    if(delta.z == 0){
                        dirSign = -1
                    }
                }
                
                prevTwoFingerDelta = delta
                if(dirSign == 1) {
                    var orig = SCNVector3(0,0,0)
                    if let camera = sceneView.pointOfView { // カメラを取得
                        orig = camera.convertPosition(orig, to: nil)
                        delta = camera.convertPosition(delta, to: nil)
                        delta = delta - orig
                        
                        let moveAction = SCNAction.move(by: delta, duration: 0)
                        cadModelNode.runAction(moveAction)
                    }
                }
                
                prevTwoFingerLocation = location
            }
            
        case .ended, .cancelled:
            panDirection = nil
            prevTwoFingerLocation = nil
            prevTwoFingerDelta = SCNVector3(0,0,0)
        default:
            break
        }
    }
    
    //_____AAAAAAAAAAAAAAAAAAAAAAAAAAAAA______DIPRO_END_2023/02/09______AAAAAAAAAAAAAAAAAAAAAAAAAAAAA_____
    
    private func loadARModel() {
        if let assetModel = assetModel {
            let usdzFiles = assetModel.usdzFilePaths
            let scnFiles = assetModel.scnFilePaths
            if !usdzFiles.isEmpty {
                for usdzFile in usdzFiles {
                    
                    let usdzObject = try? SCNScene(url: usdzFile)
                    if let rootNode = usdzObject?.rootNode {
                        usdzObjects.append(rootNode)
                        showVirtualObject(with: rootNode)
                    }
                }
            }
            
            if !scnFiles.isEmpty {
                for scnFile in scnFiles {
                    let scnObject = try? SCNScene(url: scnFile)
                    if let rootNode = scnObject?.rootNode {
                        scnObjects.append(rootNode)
                        showVirtualObject(with: rootNode)
                    }
                }
            }
        } else if let historyModel = historyModel {
            guard let scnFileURL = historyModel.fileSCNPath else {
                return
            }
            
            do {
                if let savedScene = try? SCNScene(url: scnFileURL) {
                    sceneView.scene = savedScene
                    
                    for modelRoot in savedScene.rootNode.childNodes {
                        if modelRoot.name == "ModelRoot" {
                            self.cadModelRoot = modelRoot
                            for markerRoot in modelRoot.childNodes {
                                if markerRoot.name == "MarkerRoot" {
                                    self.markerRoot = markerRoot
                                    for childNode in markerRoot.childNodes {
                                        if let marker = childNode.name {
                                            if marker.contains("circle") {
                                                if let childNode = childNode as? Circle {
                                                    circleNodes.append(childNode)
                                                }
                                            }
                                            if marker.contains("square") {
                                                if let childNode = childNode as? Square {
                                                    squareNodes.append(childNode)
                                                }
                                            }
                                            if marker.contains("triangle") {
                                                if let childNode = childNode as? Triangle {
                                                    triangleNodes.append(childNode)
                                                }
                                            }
                                            if marker.contains("text") {
                                                if let childNode = childNode as? SCNTextNode {
                                                    textNodes.append(childNode)
                                                }
                                            }
                                            if marker.contains("line") {
                                                if let childNode = childNode as? SCNLineNode {
                                                    lineNodes.append(childNode)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func showVirtualObject(with model: SCNNode) {
        let boundingBox = model.boundingBox
        let bmax = boundingBox.max
        let bmin = boundingBox.min
        let width = bmax.x - bmin.x
        let depth = bmax.z - bmin.z
        let height = bmax.y - bmin.y
        
        
        //_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____DIPRO_START_2023/02/09_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____
        
        let cx = (model.boundingBox.max.x + model.boundingBox.min.x) / 2
        let cy = (model.boundingBox.max.y + model.boundingBox.min.y) / 2
        let cz = (model.boundingBox.max.z + model.boundingBox.min.z) / 2
        
        //model.name = "VirtualObject"
        if(cadModelRoot == nil) {
            let cadModelRoot1 = SCNNode()
            cadModelRoot = cadModelRoot1
            cadModelRoot1.name = "ModelRoot"
            
            cadModelRoot1.addChildNode(model)
            presetCadModel(cadModelNode: cadModelRoot1, bPivot: true, bSubdLevel: true)
            
            let markerRoot1 = SCNNode()
            markerRoot = markerRoot1
            
            markerRoot1.name = "MarkerRoot"
            cadModelRoot1.addChildNode(markerRoot1)
            
            cadModelRoot1.scale = SCNVector3(1, 1, 1)
            cadModelRoot1.position = SCNVector3(x: 0, y: -cy, z: -0.5)
            
            sceneView.scene.rootNode.addChildNode(cadModelRoot1)
        }
        else {
            cadModelRoot?.addChildNode(model)
            presetCadModel(cadModelNode: model, bPivot: true, bSubdLevel: true)
        }
        
        if(lightRoot == nil) {
            let lightRoot1 = SCNNode()
            let lightNode1 = SCNNode()
            lightRoot1.addChildNode(lightNode1)
            lightNode1.light = SCNLight()
            lightNode1.light!.type = .omni
            lightNode1.position = SCNVector3(x: 0, y: 5, z: 5)
            
            lightRoot = lightRoot1
            
            sceneView.scene.rootNode.addChildNode(lightRoot1)
        }
        
        //_____AAAAAAAAAAAAAAAAAAAAAAAAAAAAA______DIPRO_END_2023/02/09______AAAAAAAAAAAAAAAAAAAAAAAAAAAAA_____
    }
    
    @objc
    private func showShapeMenuView(sender: UIButton) {
        if sender.tag == 100 {
            sender.tag = 101
            UIView.animate(withDuration: 0.3) {
                sender.transform = CGAffineTransform(translationX: -300, y: 0)
                self.shapeMenuView.transform = CGAffineTransform(translationX: -300, y: 0)
                if self.function != .delete {
                    self.shapeMenuView.resetUI()
                    self.function = Function.none
                }
            } completion: { _ in
            }
        } else {
            sender.tag = 100
            UIView.animate(withDuration: 0.3) {
                sender.transform = CGAffineTransformIdentity
                self.shapeMenuView.transform = CGAffineTransformIdentity
            } completion: { _ in
            }
        }
    }
    
    private func showSettingsVC() {
        let settingsVC = SettingsViewController()
        self.addChild(settingsVC)
        view.addSubview(settingsVC.view)
        settingsVC.view.isHidden = true
        self.settingsVC = settingsVC
        settingsVC.view.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        settingsVC.settingsClosure = { [weak self] in
            guard let self = self else { return }
            self.shapeMenuView.resetUI()
        }
        
        settingsVC.selectFontClosure = { [weak self] in
            guard let self = self else { return }
            self.currentPickerViewType = .fontName
            self.addPickerView()
        }
        
        settingsVC.selectLineTypeClosure = { [weak self] in
            guard let self = self else { return }
            self.currentPickerViewType = .lineType
            self.addPickerView()
        }
        
        settingsVC.backgroundMoveSelectedClosure = { [weak self] isSelected in
            guard let self = self else { return }
            print("选中state: \(isSelected)")
        }
    }
    
    @objc
    private func showBottomMenuView(sender: UIButton) {
        if sender.tag == 200 {
            sender.tag = 201
            bottomMenuView.isHidden = false
            UIView.animate(withDuration: 0.3) {
                sender.transform = CGAffineTransform(translationX: 400, y: 0)
                self.bottomMenuView.transform = CGAffineTransform(translationX: 400, y: 0)
            } completion: { _ in
                let anim = CABasicAnimation()
                anim.keyPath = "transform.rotation"
                anim.toValue = Double.pi
                anim.duration = 0.3
                anim.isRemovedOnCompletion = false
                anim.fillMode = CAMediaTimingFillMode.forwards
                sender.imageView?.layer.add(anim, forKey: nil)
            }
        } else {
            sender.tag = 200
            bottomMenuView.isHidden = true
            UIView.animate(withDuration: 0.3) {
                sender.transform = CGAffineTransformIdentity
                self.bottomMenuView.transform = CGAffineTransformIdentity
            } completion: { _ in
                let anim = CABasicAnimation()
                anim.keyPath = "transform.rotation"
                anim.toValue = 0
                anim.duration = 0.3
                anim.isRemovedOnCompletion = false
                anim.fillMode = CAMediaTimingFillMode.forwards
                sender.imageView?.layer.add(anim, forKey: nil)
            }
        }
    }
    
    var touchPoints: [CGPoint] = [CGPoint]()
    
    var firstPoint: CGPoint = .zero
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //MARK: 1
        guard let function = function, function == .line, let location = touches.first?.location(in: nil) else {
            return
        }
        
        pointTouching = location
        touchPoints.append(pointTouching)
        
        guard let location = touches.first?.location(in: nil),
              let lastHit = sceneView.hitTest(location, options: [SCNHitTestOption.searchMode: SCNHitTestSearchMode.closest.rawValue as NSNumber]).first else {
            return
        }
        
        begin(hit: lastHit)
        isDrawing = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //MARK: 1
        guard let function = function, function == .line, let location = touches.first?.location(in: nil) else {
            return
        }
        pointTouching = location
        touchPoints.append(pointTouching)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //MARK: 1
        isDrawing = false
        reset()
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    private func begin(hit: SCNHitTestResult) {
        let drawingNode = SCNLineNode(with: [], radius: ShapeSetting.lineThickness, edges: 12, maxTurning: 12)
        let material = SCNMaterial()
        material.diffuse.contents = ShapeSetting.lineColor
        material.isDoubleSided = true
        material.writesToDepthBuffer = false
        material.readsFromDepthBuffer = false
        material.isDoubleSided = true
        material.ambient.contents = UIColor.black
        material.lightingModel = .constant
        material.emission.contents = ShapeSetting.lineColor
        drawingNode.lineMaterials = [material]
        self.drawingNode = drawingNode
        
        guard let markerRoot = markerRoot else { return }
        markerRoot.addChildNode(drawingNode)
        drawingNode.addDeleteFlagNode(initialHitTest: hit)
        
        lineNodes.append(drawingNode)
    }
    
    private func addPointAndCreateVertices() {
        guard let lastHit = sceneView.hitTest(self.pointTouching, options: [SCNHitTestOption.searchMode: SCNHitTestSearchMode.closest.rawValue as NSNumber]).first else {
            return
        }
        
        if lastHit.worldCoordinates.distance(to: lastPoint) > minimumMovement {
            hitVertices.append(lastHit.worldCoordinates)
            let tapPoint_local = lastHit.localCoordinates
            let tapNode = lastHit.node
            let lastPoint = tapNode.convertPosition(tapPoint_local, to: markerRoot)
            updateGeometry(with: lastPoint)
        }
    }
    
    private func updateGeometry(with point: SCNVector3) {
        guard hitVertices.count > 1, let drawNode = drawingNode else {
            return
        }
        drawNode.add(point: point)
    }
    
    private func reset() {
        hitVertices.removeAll()
        drawingNode = nil
    }
    
    deinit {
        sceneView.removeFromSuperview()
        assetModel = nil
        historyModel = nil
    }
}

// MARK: - ARSCNViewDelegate
extension ARViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let meshAnchor = anchor as? ARMeshAnchor else {
            return nil
        }
        
        let geometry = createGeometryFromAnchor(meshAnchor: meshAnchor)
        
        //apply occlusion material
        geometry.firstMaterial?.colorBufferWriteMask = []
        geometry.firstMaterial?.writesToDepthBuffer = true
        geometry.firstMaterial?.readsFromDepthBuffer = true
        
        
        let node = SCNNode(geometry: geometry)
        //change rendering order so it renders before  our virtual object
        node.renderingOrder = -1
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if isDrawing {
            addPointAndCreateVertices()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        //_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____DIPRO_START_2023/02/09_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____
        node.removeFromParentNode()
        //_____AAAAAAAAAAAAAAAAAAAAAAAAAAAAA______DIPRO_END_2023/02/09______AAAAAAAAAAAAAAAAAAAAAAAAAAAAA_____
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let meshAnchor = anchor as? ARMeshAnchor else {
            return
        }
        let geometry = createGeometryFromAnchor(meshAnchor: meshAnchor)
        
        // Optionally hide the node from rendering as well
        geometry.firstMaterial?.colorBufferWriteMask = []
        geometry.firstMaterial?.writesToDepthBuffer = true
        geometry.firstMaterial?.readsFromDepthBuffer = true
        
        node.geometry = geometry
    }
    
    
    func createGeometryFromAnchor(meshAnchor: ARMeshAnchor) -> SCNGeometry {
        let meshGeometry = meshAnchor.geometry
        let vertices = meshGeometry.vertices
        let normals = meshGeometry.normals
        let faces = meshGeometry.faces
        
        let vertexSource = SCNGeometrySource(buffer: vertices.buffer, vertexFormat: vertices.format, semantic: .vertex, vertexCount: vertices.count, dataOffset: vertices.offset, dataStride: vertices.stride)
        
        let normalsSource = SCNGeometrySource(buffer: normals.buffer, vertexFormat: normals.format, semantic: .normal, vertexCount: normals.count, dataOffset: normals.offset, dataStride: normals.stride)
        let faceData = Data(bytes: faces.buffer.contents(), count: faces.buffer.length)
        
        let geometryElement = SCNGeometryElement(data: faceData, primitiveType: primitiveType(type: faces.primitiveType), primitiveCount: faces.count, bytesPerIndex: faces.bytesPerIndex)
        
        return SCNGeometry(sources: [vertexSource, normalsSource], elements: [geometryElement])
    }
    
    func primitiveType(type: ARGeometryPrimitiveType) -> SCNGeometryPrimitiveType {
        switch type {
        case .line: return .line
        case .triangle: return .triangles
        default : return .triangles
        }
    }
}

extension ARViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass((touch.view?.classForCoder)!) == "UITableViewCellContentView" {
            return false
        }
        return true
    }
}
