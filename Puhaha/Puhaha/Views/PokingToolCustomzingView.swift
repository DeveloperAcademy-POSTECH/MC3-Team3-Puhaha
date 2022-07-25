//
//  PokingToolCustomzingView.swift
//  Puhaha
//
//  Created by 김보영 on 2022/07/25.
//

import UIKit
import SceneKit

class ToolScene: SCNView {
    
    private let sceneView: SCNView = {
        
        let objectMaterial = SCNMaterial()
        objectMaterial.isDoubleSided = false
        objectMaterial.diffuse.contents = sample.color
        
        let sceneView = SCNView()
        let sceneInsideSceneView = SCNScene(named: "Tools.scn")
        
        // 모든 도구 오브젝트들을 숨깁니다.
        sceneInsideSceneView?.rootNode.childNode(withName: "Spoon", recursively: true)?.isHidden = true
        sceneInsideSceneView?.rootNode.childNode(withName: "Fork", recursively: true)?.isHidden = true
        sceneInsideSceneView?.rootNode.childNode(withName: "Whisk", recursively: true)?.isHidden = true
        
        // 선택된 도구 오브젝트만 화면에 그려냅니다.
        sceneInsideSceneView?.rootNode.childNode(withName: sample.toolToString(), recursively: true)?.isHidden = false
        
        sceneInsideSceneView?.rootNode.childNode(withName: "Spoon", recursively: true)?.geometry?.firstMaterial = objectMaterial
        sceneInsideSceneView?.rootNode.childNode(withName: "Fork", recursively: true)?.geometry?.firstMaterial = objectMaterial
        sceneInsideSceneView?.rootNode.childNode(withName: "Whisk", recursively: true)?.geometry?.firstMaterial = objectMaterial
        
        // 오브젝트가 회전하는 애니메이션(액션)을 추가합니다.
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(GLKMathDegreesToRadians(-360)), z: 0, duration: 12)
        let rotateForever = SCNAction.repeatForever(action)
        sceneInsideSceneView?.rootNode.childNode(withName: "Tools", recursively: true)?.runAction(rotateForever)
        
        // 렌더될 화면을 촬영할 카메라 노드를 생성합니다.
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.fieldOfView = 60.0
        
        // 카메라가 있을 위치를 지정해줍니다.
        cameraNode.position = SCNVector3(x: 0, y: 2, z: 8)
        
        // 카메라를 Scene 안에 배치합니다.
        sceneInsideSceneView?.rootNode.addChildNode(cameraNode)
        
        // 조명을 추가합니다.
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 35)
        sceneInsideSceneView?.rootNode.addChildNode(lightNode)
        
        // Ambient light 조명을 추가합니다.
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.gray
        sceneInsideSceneView?.rootNode.addChildNode(ambientLightNode)
        
        sceneView.scene = sceneInsideSceneView
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.backgroundColor = .clear
        sceneView.allowsCameraControl = true
        
        return sceneView
    }()
}
