//
//  PokeToolViewController.swift
//  Puhaha
//
//  Created by 김보영 on 2022/07/25.
//

import UIKit
import SceneKit

class PokeToolCustomizingViewController: UIViewController {
    
    // MARK: forkCustomView 선언
    private let forkCustomView: UIView = {
        
        let myView = UIView()
        
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.backgroundColor = .white
        
        return myView
    }()
    
    // MARK: sceneView 선언
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
        sceneInsideSceneView?.rootNode.childNode(withName: "Spatula", recursively: true)?.isHidden = true
        
        // 선택된 도구 오브젝트만 화면에 그려냅니다.
        sceneInsideSceneView?.rootNode.childNode(withName: sample.toolToString(), recursively: true)?.isHidden = false
        
        sceneInsideSceneView?.rootNode.childNode(withName: "Spoon", recursively: true)?.geometry?.firstMaterial = objectMaterial
        sceneInsideSceneView?.rootNode.childNode(withName: "Fork", recursively: true)?.geometry?.firstMaterial = objectMaterial
        sceneInsideSceneView?.rootNode.childNode(withName: "Whisk", recursively: true)?.geometry?.firstMaterial = objectMaterial
        sceneInsideSceneView?.rootNode.childNode(withName: "Spatula", recursively: true)?.geometry?.firstMaterial = objectMaterial
        
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
    
    // MARK: stack of image buttons View 선언
    private let styleButtonsStackView: UIStackView = {
        
        // 구분선을 만듭니다.
        let divider = UIView()
        divider.backgroundColor = UIColor.customLightGray
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        // 그룹명을 표시해주는 라벨을 만듭니다.
        let label = UILabel()
        label.text = " 종류"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // 스택 뷰를 만들고 그 안에 버튼들을 모아둡니다.
        let buttonsStackView = UIStackView(arrangedSubviews: [])
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 16
        
        for toolImageIndex in 0..<toolImages.count {
            let button = UIButton()
            button.setImage(toolImages[toolImageIndex], for: .normal)
            button.backgroundColor = UIColor.customLightGray
            button.layer.borderColor = UIColor.customBlack.cgColor
            button.layer.borderWidth = { sample.toolToInt() == toolImageIndex ? 2 : 0 }()
            
            // Button Action
            button.addTarget(self, action: #selector(styleButtonPressed(_ :)), for: .touchUpInside)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            // button의 사이즈를 정해줍니다.
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 101),
                button.heightAnchor.constraint(equalToConstant: 138)
            ])
            
            buttonsStackView.addArrangedSubview(button)
        }
        
        let stackView = UIStackView(arrangedSubviews: [divider, label, buttonsStackView])
        stackView.axis = .vertical
        stackView.alignment = .leading
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // StackView 속 label뷰가 차지하는 비율, buttonStackView가 차지하는 비율을 정해줍니다.
        NSLayoutConstraint.activate([
            
            // divider
            divider.topAnchor.constraint(equalTo: stackView.topAnchor),
            divider.heightAnchor.constraint(equalToConstant: 2),
            divider.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
            // label
            label.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            label.heightAnchor.constraint(equalToConstant: 24),
            label.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
            // buttonStackView
            buttonsStackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 18),
            buttonsStackView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.6),
            buttonsStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
        
        return stackView
        
    }()
    
    // MARK: stack of colored buttons View 선언
    private let colorButtonsStackView: UIStackView = {
        
        let divider = UIView()
        divider.backgroundColor = UIColor.customLightGray
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = " 색상"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonsStackView = UIStackView(arrangedSubviews: [])
        buttonsStackView.distribution = .equalSpacing
        buttonsStackView.spacing = 16
        buttonsStackView.alignment = .center
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        for toolImageIndex in 0..<toolColors.count {
            
            let button = UIButton(type: .custom)
            button.layer.cornerRadius = 30
            button.layer.masksToBounds = true
            button.clipsToBounds = true
            button.backgroundColor = toolColors[toolImageIndex]
            button.layer.borderWidth = { sample.color == toolColors[toolImageIndex] ? 2 : 0 }()
            button.layer.borderColor = UIColor.customBlack.cgColor
            
            // Button Action
            button.addTarget(self, action: #selector(colorButtonPressed(_ :)), for: .touchUpInside)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            // MARK: 버튼의 property
            let buttonSize: CGFloat = 60
            
            // button의 사이즈를 정해줍니다.
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: buttonSize),
                button.heightAnchor.constraint(equalToConstant: buttonSize)
            ])
            
            buttonsStackView.addArrangedSubview(button)
        }
        
        let stackView = UIStackView(arrangedSubviews: [divider, label, buttonsStackView])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // StackView 속 label뷰가 차지하는 비율, buttonStackView가 차지하는 비율을 정해줍니다.
        NSLayoutConstraint.activate([
            // divider
            divider.topAnchor.constraint(equalTo: stackView.topAnchor),
            divider.heightAnchor.constraint(equalToConstant: 2),
            divider.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
            // label
            label.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            label.heightAnchor.constraint(equalToConstant: 24),
            label.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
            // buttonStackView
            buttonsStackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 18),
            buttonsStackView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.6),
            buttonsStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
        
        return stackView
        
    }()
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        title = "찌르기 도구"
        
        view.addSubview(forkCustomView)
        forkCustomView.addSubview(sceneView)
        forkCustomView.addSubview(styleButtonsStackView)
        forkCustomView.addSubview(colorButtonsStackView)
        
        configureConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))

    }
    
    @objc func didTapDone() {
        // container에 지금 오브젝트의 값을 저장합니다.
        // 무엇을? 툴타입 & 색상 정보를.
    }
    
    private func configureConstraints() {
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(forkCustomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(forkCustomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12))
        constraints.append(forkCustomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12))
        constraints.append(forkCustomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        
        constraints.append(sceneView.widthAnchor.constraint(equalTo: forkCustomView.widthAnchor, multiplier: 1))
        constraints.append(sceneView.heightAnchor.constraint(equalTo: forkCustomView.heightAnchor, multiplier: 0.5))
        constraints.append(sceneView.topAnchor.constraint(equalTo: forkCustomView.topAnchor))
        
        constraints.append(colorButtonsStackView.topAnchor.constraint(equalTo: styleButtonsStackView.bottomAnchor, constant: 32))
        constraints.append(colorButtonsStackView.leadingAnchor.constraint(equalTo: forkCustomView.leadingAnchor))
        
        constraints.append(colorButtonsStackView.widthAnchor.constraint(equalTo: forkCustomView.widthAnchor, multiplier: 1))
        constraints.append(colorButtonsStackView.heightAnchor.constraint(equalTo: forkCustomView.heightAnchor, multiplier: 0.2))
        
        constraints.append(styleButtonsStackView.topAnchor.constraint(equalTo: sceneView.bottomAnchor))
        constraints.append(styleButtonsStackView.widthAnchor.constraint(equalTo: forkCustomView.widthAnchor, multiplier: 1))
        constraints.append(styleButtonsStackView.heightAnchor.constraint(equalTo: forkCustomView.heightAnchor, multiplier: 0.25))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func willRenderSelectedToolOnly() {
        
        let root = sceneView.scene?.rootNode
        
        root?.childNode(withName: "Fork", recursively: true)?.isHidden = true
        root?.childNode(withName: "Spoon", recursively: true)?.isHidden = true
        root?.childNode(withName: "Spatula", recursively: true)?.isHidden = true
        root?.childNode(withName: "Whisk", recursively: true)?.isHidden = true
        
        root?.childNode(withName: sample.toolToString(), recursively: true)?.isHidden = false
    }
    
    @objc func styleButtonPressed(_ sender: UIButton) {
        
        // 클릭된 버튼에 따라서
        // 1. 유저의 정보에 선택한 값 띄워주기
        // 2. 선택된 오브젝트만 화면에 띄우기
        
        switch sender.imageView!.image {
            
        case UIImage(systemName: "cloud") :
            sample.tool = Tool.Fork
            willHideBorders(view: styleButtonsStackView)
            willRenderSelectedToolOnly()
                        
        case UIImage(systemName: "bookmark") :
            sample.tool = Tool.Spoon
            willHideBorders(view: styleButtonsStackView)
            willRenderSelectedToolOnly()
            
        case UIImage(systemName: "heart"):
            sample.tool = Tool.Whisk
            willHideBorders(view: styleButtonsStackView)
            willRenderSelectedToolOnly()
            
        default:
            sample.tool = Tool.Spatula
            willHideBorders(view: styleButtonsStackView)
            willRenderSelectedToolOnly()
        }
        
        // 클릭된 버튼에 border값 주기
        sender.layer.borderWidth = 2
    }
    
    @objc func colorButtonPressed(_ sender: UIButton) {
        
        willHideBorders(view: colorButtonsStackView)
        
        // 모든 Material의 색상을 선택된 색상으로 설정
        sceneView.scene?.rootNode.childNode(withName: "Fork", recursively: true)?.geometry?.firstMaterial?.diffuse.contents = sender.backgroundColor
        sceneView.scene?.rootNode.childNode(withName: "Spoon", recursively: true)?.geometry?.firstMaterial?.diffuse.contents = sender.backgroundColor
        sceneView.scene?.rootNode.childNode(withName: "Whisk", recursively: true)?.geometry?.firstMaterial?.diffuse.contents = sender.backgroundColor
        sceneView.scene?.rootNode.childNode(withName: "Spatula", recursively: true)?.geometry?.firstMaterial?.diffuse.contents = sender.backgroundColor
        
        sender.layer.borderWidth = 2
        sample.color = sender.backgroundColor!
    }
    
    private func willHideBorders(view: UIView) {
        for buttonView in view.subviews.last!.subviews {
            buttonView.layer.borderWidth = 0
        }
    }
}

#if DEBUG
var sample = PokeTool(tool: Tool.Fork, color: UIColor.customBlue)
#endif
