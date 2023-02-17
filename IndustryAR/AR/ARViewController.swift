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

let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

class ARViewController: UIViewController {
    
    var assetModel: AssetModel?
    
    var usdzObjects: [VirtualObject] = []
    var scnObjects: [VirtualObject] = []
    
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
    
    var settingsVC: SettingsViewController?
    
    var isRecordingVideo: Bool = false
    
    @objc
    private func backButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadARModel()
        setupUI()
        setupRecorder()
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
        
        
        //_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____DIPRO_START_2023/02/09_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____
//        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) else {
//            fatalError("People occlusion is not supported on this device.")
//        }
//        switch configuration.frameSemantics {
//        case [.sceneDepth]:
//            configuration.frameSemantics.remove(.sceneDepth)
//        default:
//            configuration.frameSemantics.insert(.sceneDepth)
//        }
        //_____AAAAAAAAAAAAAAAAAAAAAAAAAAAAA______DIPRO_END_2023/02/09______AAAAAAAAAAAAAAAAAAAAAAAAAAAAA_____
        
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        currentStrokeAnchorNode = nil
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
            make.size.equalTo(CGSize(width: 300, height: 540))
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
            showBottomMenuView(sender: bottomMenuButton)
            bottomMenuView.autoButton.setTitle("AUTO", for: .normal)
        }
        
        showSettingsVC()
        
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
//                self.showSettingsVC()
                self.settingsVC?.view.isHidden = false
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
            
        }
        
        // save SCN file
        bottomMenuView.saveSCNClosure = { [weak self]  in
            guard let self = self else { return }
            guard let assetModel = self.assetModel else { return }
            let fileName = assetModel.assetName.md5
            let scene = self.sceneView.scene
            let url = documentsPath.appendingPathComponent(fileName + ".scn")
            scene.write(to: url, options: nil, delegate: nil, progressHandler: nil)
        }
        
        // auto settings
        bottomMenuView.autoSettingClosure = { [weak self] sender in
            guard let self = self else { return }
            if !UserDefaults.hasAutoShowBottomMenu {
                UserDefaults.hasAutoShowBottomMenu = true
                sender.setTitle("AUTO", for: .normal)
            } else {
                UserDefaults.hasAutoShowBottomMenu = false
                sender.setTitle("SHOW", for: .normal)
            }
        }
    }
    
    // test geometry surface
    @objc
    private func tapAction(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)
        guard let hitResult = self.sceneView.hitTest(location, options: [SCNHitTestOption.searchMode: SCNHitTestSearchMode.closest.rawValue as NSNumber]).first else { return }
        
        //_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____DIPRO_START_2023/02/09_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____
        //let tapPoint_world = hitResult.simdWorldCoordinates
        
        let tapPoint_local = hitResult.localCoordinates
        let tapNode = hitResult.node
        let tapPoint_world_scn = tapNode.convertPosition(tapPoint_local, to: cadModelRoot)
        let tapPoint_world = simd_float3(tapPoint_world_scn.x, tapPoint_world_scn.y, tapPoint_world_scn.z);
        //_____AAAAAAAAAAAAAAAAAAAAAAAAAAAAA______DIPRO_END_2023/02/09______AAAAAAAAAAAAAAAAAAAAAAAAAAAAA_____
        
        guard let function = function else { return }
        if function == .triangle {
            let triangleNode = Triangle()
            
            //_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____DIPRO_START_2023/02/09_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____
            
            //triangleNode.simdWorldPosition = tapPoint_world
            triangleNode.simdScale = simd_float3(1, 1, 1)
            
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
            //_____AAAAAAAAAAAAAAAAAAAAAAAAAAAAA______DIPRO_END_2023/02/09______AAAAAAAAAAAAAAAAAAAAAAAAAAAAA_____
            
            /*
            triangleNode.simdScale = simd_float3(3, 3, 3)
            sceneView.scene.rootNode.addChildNode(triangleNode)
             */
        }
        
        if function == .square {
            let squareNode = Square()
            
            //_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____DIPRO_START_2023/02/09_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____
            
            //squareNode.simdWorldPosition = tapPoint_world
            squareNode.simdScale = simd_float3(1, 1, 1)
            
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
            //_____AAAAAAAAAAAAAAAAAAAAAAAAAAAAA______DIPRO_END_2023/02/09______AAAAAAAAAAAAAAAAAAAAAAAAAAAAA_____
             
            /*
            squareNode.simdScale = simd_float3(3, 3, 3)
            sceneView.scene.rootNode.addChildNode(squareNode)
            */
        }
        
        if function == .circle {
            let circleNode = Circle()
            
            //_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____DIPRO_START_2023/02/09_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____
            
            //circleNode.simdWorldPosition = tapPoint_world
            circleNode.simdScale = simd_float3(1, 1, 1)
            
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
            //_____AAAAAAAAAAAAAAAAAAAAAAAAAAAAA______DIPRO_END_2023/02/09______AAAAAAAAAAAAAAAAAAAAAAAAAAAAA_____
             
            /*
             circleNode.simdScale = simd_float3(3, 3, 3)
            sceneView.scene.rootNode.addChildNode(circleNode)
            */
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
                      //print("prevTwoFingerDelta = ", prevTwoFingerDelta)
                      //print("delta = ", delta)

                      //print("camera coordinate delta = ", delta)
                      
                      var orig = SCNVector3(0,0,0)
                      if let camera = sceneView.pointOfView { // カメラを取得
                          orig = camera.convertPosition(orig, to: nil)
                          delta = camera.convertPosition(delta, to: nil)
                          delta = delta - orig
                          
                          let moveAction = SCNAction.move(by: delta, duration: 0)
                          cadModelNode.runAction(moveAction)
                      }
                      
                      //print("world coordinate delta = ", delta)
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

        /*
        model.scale = SCNVector3(1, 1, 1)
        model.simdWorldPosition = simd_float3(x: 0, y: -height / 2.0, z: -1 - depth)

        sceneView.scene.rootNode.addChildNode(model)
        */
        
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
//                sender.setImage(UIImage(named: "close"), for: .normal)
            }
        } else {
            sender.tag = 100
            UIView.animate(withDuration: 0.3) {
                sender.transform = CGAffineTransformIdentity
                self.shapeMenuView.transform = CGAffineTransformIdentity
            } completion: { _ in
//                sender.setImage(UIImage(named: "menu"), for: .normal)
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
        
        settingsVC.settingsClosure = { [weak self] settings in
            guard let self = self else { return }
            self.currentStrokeColor = settings.lineColor
        }
    }
    
    @objc
    private func showBottomMenuView(sender: UIButton) {
        if sender.tag == 200 {
            sender.tag = 201
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
        let location = touch.location(in: sceneView)
        guard let hitResult = sceneView.hitTest(location, options: [SCNHitTestOption.searchMode: SCNHitTestSearchMode.closest.rawValue as NSNumber]).first else { return }
        let tapPoint_world = hitResult.simdWorldCoordinates
        let frame = sceneView.session.currentFrame
        guard let transform = frame?.camera.transform else { return }
        distanceFromCamera = calculateDistance(firstPosition: tapPoint_world, secondPosition: transform.translation)

        
        let touchPositionInFrontOfCamera = tapPoint_world//getPosition(ofPoint: touch.location(in: sceneView), atDistanceFromCamera: distanceFromCamera, inView: sceneView) else { return }
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
            
            //_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____DIPRO_START_2023/02/09_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____
            markerRoot?.addChildNode(node)
            //_____AAAAAAAAAAAAAAAAAAAAAAAAAAAAA______DIPRO_END_2023/02/09______AAAAAAAAAAAAAAAAAAAAAAAAAAAAA_____
            
            strokeAnchorIDs.append(strokeAnchor.identifier)
            for sphereLocation in strokeAnchor.sphereLocations {
                createSphereAndInsert(atPosition: SCNVector3Make(sphereLocation[0], sphereLocation[1], sphereLocation[2]), andAddToStrokeAnchor: strokeAnchor)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        // Remove the anchorID from the strokes array
        strokeAnchorIDs.removeAll(where: { $0 == anchor.identifier })
        
        //_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____DIPRO_START_2023/02/09_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____
        node.removeFromParentNode()
        //_____AAAAAAAAAAAAAAAAAAAAAAAAAAAAA______DIPRO_END_2023/02/09______AAAAAAAAAAAAAAAAAAAAAAAAAAAAA_____
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
//            guard let location = currentFingerPosition else { return }
//            guard let hitResult = sceneView.hitTest(location, options: [SCNHitTestOption.searchMode: SCNHitTestSearchMode.closest.rawValue as NSNumber]).first else { return }
//            let tapPoint_world = hitResult.simdWorldCoordinates
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
    
    func calculateDistance(firstPosition: SIMD3<Float>, secondPosition: SIMD3<Float>) -> Float{
        let start = firstPosition
        let end = secondPosition
        
        let distance = sqrt(
            pow(end.x - start.x, 2) +
            pow(end.y - start.y, 2) +
            pow(end.z - start.z, 2)
        )
        
        return distance
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
