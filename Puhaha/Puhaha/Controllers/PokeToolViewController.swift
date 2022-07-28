//
//  PokeToolViewController.swift
//  Puhaha
//
//  Created by 김보영 on 2022/07/25.
//

import UIKit
import SceneKit

class PokeToolCustomizingViewController: UIViewController {
    
    // SceneView 속 3D 오브젝트에 입혀질 Material
    static var objectMaterial = SCNMaterial()
    
    // MARK: forkCustomView 선언
    private let forkCustomView: UIView = {
        
        let myView = UIView()
        
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.backgroundColor = .white
        
        return myView
    }()
    
    // MARK: sceneView 선언
    private let sceneView: SCNView = {
        
        objectMaterial.isDoubleSided = false
        objectMaterial.diffuse.contents = sample.color
        objectMaterial.roughness.intensity = 0.2
        
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
        
        willSetEnvironmentNodes(inside: sceneInsideSceneView!)
        
        sceneView.scene = sceneInsideSceneView
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.backgroundColor = .clear
        sceneView.allowsCameraControl = true
        
        return sceneView
    }()
    
    // MARK: stack of image buttons View 선언
    private let styleButtonsStackView: UIStackView = {
        
        // 구분선을 만듭니다.
        let divider = UIHorizontalDividerView(height: 2, color: UIColor.customLightGray)
        
        // 그룹명을 표시해주는 라벨을 만듭니다.
        let label = willReturnGroupLabel(labelName: "종류")
        
        // 스택 뷰를 만들고 그 안에 버튼들을 모아둡니다.
        let buttonsStackView = UIStackView()
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 16
        
        for toolImageIndex in 0..<toolImages.count {
            let button = UIButton()
            let imageOpacity: CGFloat = { sample.toolToInt() == toolImageIndex ? 1 : 0.3 }()
            let buttonImage = UIImage(named: toolImages[toolImageIndex])!.alpha(imageOpacity)
            button.setImage(buttonImage, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit

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
            
            divider.topAnchor.constraint(equalTo: stackView.topAnchor),
            divider.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
            label.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            label.heightAnchor.constraint(equalToConstant: 24),
            label.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
            buttonsStackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 18),
            buttonsStackView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.6),
            buttonsStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
        
        return stackView
        
    }()
    
    // MARK: stack of colored buttons View 선언
    private let colorButtonsStackView: UIStackView = {
        
        let divider = UIHorizontalDividerView(height: 2, color: UIColor.customLightGray)
        
        let label = willReturnGroupLabel(labelName: "색상")
        
        let buttonsStackView = UIStackView()
        buttonsStackView.distribution = .equalSpacing
        buttonsStackView.spacing = 16
        buttonsStackView.alignment = .center
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        for toolColorIndex in 0..<toolColors.count {
            
            let button = UIButton(type: .custom)
            button.layer.cornerRadius = 30
            button.layer.masksToBounds = true
            button.clipsToBounds = true
            button.backgroundColor = UIColor.white
            button.layer.borderWidth = { sample.color == toolColors[toolColorIndex] ? 12 : 100 }()
            
            button.layer.borderColor = toolColors[toolColorIndex].cgColor
            
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
            divider.topAnchor.constraint(equalTo: stackView.topAnchor),
            divider.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
            label.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            label.heightAnchor.constraint(equalToConstant: 24),
            label.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
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
        [sceneView, styleButtonsStackView, colorButtonsStackView].forEach {
            forkCustomView.addSubview($0)
        }
        
        configureConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        
    }
    
    @objc func didTapDone() {
        // container에 지금 오브젝트의 값을 저장합니다.
        // 무엇을? 툴타입 & 색상 정보를.
    }
    
    private func configureConstraints() {
        
        NSLayoutConstraint.activate([
            
            forkCustomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            forkCustomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            forkCustomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            forkCustomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            sceneView.widthAnchor.constraint(equalTo: forkCustomView.widthAnchor, multiplier: 1),
            sceneView.heightAnchor.constraint(equalTo: forkCustomView.heightAnchor, multiplier: 0.5),
            sceneView.topAnchor.constraint(equalTo: forkCustomView.topAnchor),
            
            colorButtonsStackView.topAnchor.constraint(equalTo: styleButtonsStackView.bottomAnchor, constant: 32),
            colorButtonsStackView.leadingAnchor.constraint(equalTo: forkCustomView.leadingAnchor),
            
            colorButtonsStackView.widthAnchor.constraint(equalTo: forkCustomView.widthAnchor, multiplier: 1),
            colorButtonsStackView.heightAnchor.constraint(equalTo: forkCustomView.heightAnchor, multiplier: 0.2),
            
            styleButtonsStackView.topAnchor.constraint(equalTo: sceneView.bottomAnchor),
            styleButtonsStackView.widthAnchor.constraint(equalTo: forkCustomView.widthAnchor, multiplier: 1),
            styleButtonsStackView.heightAnchor.constraint(equalTo: forkCustomView.heightAnchor, multiplier: 0.25)
        ])
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
        // TODO: 클릭된 버튼에 따라 버튼 속 이미지 투명도 조절하기
        // 선택된 이미지는 1로, 선택받지 못한 이미지는 0.3
        
        // 선택된 버튼의 이미지는 선명해지고
//        sender.imageView?.image = sender.imageView?.image?.alpha(1)
        
        switch sender.imageView!.image {
            
        case UIImage(systemName: "cloud"):
            sample.tool = Tool.Fork
            willHideBorders(view: styleButtonsStackView)
            willRenderSelectedToolOnly()
            
        case UIImage(systemName: "bookmark"):
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
        PokeToolCustomizingViewController.objectMaterial.diffuse.contents = sender.layer.borderColor

        sender.layer.borderWidth = 12
        
        sample.color = sender.backgroundColor!
    }
    
    private func willHideBorders(view: UIView) {
        for buttonView in view.subviews.last!.subviews {
            buttonView.layer.borderWidth = 100
        }
    }
}

func willReturnGroupLabel(labelName: String) -> UILabel {
    
    let label = UILabel()
    label.text = " " + labelName
    label.textColor = UIColor(rgb: 0x272727)
    label.textAlignment = .left
    label.font = .systemFont(ofSize: 22, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
}

func willSetEnvironmentNodes(inside scene: SCNScene) {
    
    // 렌더될 화면을 촬영할 카메라 노드를 생성합니다.
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.camera?.fieldOfView = 60.0
    
    // 카메라가 있을 위치를 지정해줍니다.
    cameraNode.position = SCNVector3(x: 0, y: 2, z: 8)
    
    // 카메라를 Scene 안에 배치합니다.
    scene.rootNode.addChildNode(cameraNode)
    
    // 조명을 추가합니다.
    let lightNode = SCNNode()
    lightNode.light = SCNLight()
    lightNode.light?.type = .omni
    lightNode.position = SCNVector3(x: 0, y: 10, z: 35)
    scene.rootNode.addChildNode(lightNode)
    
    // Ambient light 조명을 추가합니다.
    let ambientLightNode = SCNNode()
    ambientLightNode.light = SCNLight()
    ambientLightNode.light?.type = .ambient
    ambientLightNode.light?.color = UIColor.gray
    scene.rootNode.addChildNode(ambientLightNode)
}

#if DEBUG
var sample = PokeTool(tool: Tool.Fork, color: UIColor.customBlue)
#endif
