//
//  MainViewController.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/18.
//

import UIKit

import FirebaseFirestore
import FirebaseStorage

class MainViewController: UIViewController {
    var userIdentifier: String = UserDefaults.standard.string(forKey: "userIdentifier") ?? ""
    var loginedUser: User = User(accountId: UserDefaults.standard.string(forKey: "userIdentifier") ?? "")
    
    var filter: String = "모두"
    var selectedCellIndex: Int = 0
    var today: Date = Date.now
    var familyCode: String = UserDefaults.standard.string(forKey: "roomCode") ?? ""
    var familyMembers: [Family] = []
    
    @Published var baseMeals: [Meal] = []
    @Published var meals: [Meal] = []
    
    let firestoreManager = FirestoreManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        tabBarController?.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        getFamilyMemeber()
        getLoginedUser()
        
        [todayDateLabel, settingButton, tableLabel, emptyMealCardView, mealCardCollectionView, familyFilterCollectionView].forEach {
            view.addSubview($0)
        }
        todayDateLabel.text = today.dayText
        
        mealCardViewHidden()
        
        setConstraints()
        mealCardCollectionView.delegate = self
        mealCardCollectionView.dataSource = self
        
        familyFilterCollectionView.delegate = self
        familyFilterCollectionView.dataSource = self
    }
    
    private var todayDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()
     
    lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "gearshape"), for: .normal)
        button.sizeThatFits(CGSize(width: 28, height: 28))
        button.tintColor = .black
        button.addTarget(self, action: #selector(navigateToSettingView), for: .touchUpInside)
        return button
    }()
    
    var tableLabel: UILabel = {
        let label = UILabel()
        label.text = "모두의 식탁"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    let emptyMealCardView: EmptyMealCardView = {
        let view: EmptyMealCardView = EmptyMealCardView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.layer.zPosition = 10
        return view
    }()
    
    var mealCardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 32
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MealCardCollectionViewCell.self, forCellWithReuseIdentifier: MealCardCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    var familyFilterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FamilyFilterCollectionViewCell.self, forCellWithReuseIdentifier: FamilyFilterCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    func setConstraints() {
        todayDateLabel.translatesAutoresizingMaskIntoConstraints = false
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        tableLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emptyMealCardView.translatesAutoresizingMaskIntoConstraints = false
        mealCardCollectionView.translatesAutoresizingMaskIntoConstraints = false
        familyFilterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            todayDateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            todayDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            
            settingButton.centerYAnchor.constraint(equalTo: todayDateLabel.centerYAnchor),
            settingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
             
            tableLabel.topAnchor.constraint(equalTo: todayDateLabel.bottomAnchor, constant: 91),
            tableLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            
            emptyMealCardView.topAnchor.constraint(equalTo: tableLabel.bottomAnchor),
            emptyMealCardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(UIScreen.main
                .bounds.height / 6.48)),
            emptyMealCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyMealCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            mealCardCollectionView.topAnchor.constraint(equalTo: tableLabel.bottomAnchor),
            mealCardCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(UIScreen.main
                .bounds.height / 6.48)),
            mealCardCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mealCardCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            familyFilterCollectionView.topAnchor.constraint(equalTo: todayDateLabel.bottomAnchor, constant: 20),
            familyFilterCollectionView.bottomAnchor.constraint(equalTo: tableLabel.topAnchor, constant: -39),
            familyFilterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            familyFilterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func navigateToSettingView() {
        let settingViewController = SettingViewController()
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    func mealCardViewHidden() {
        if meals.isEmpty {
            emptyMealCardView.isHidden = false
            mealCardCollectionView.isHidden = true
            if filter == "모두" {
                emptyMealCardView.pokeButton.isHidden = true
            } else {
                emptyMealCardView.pokeButton.isHidden = false
            }
        } else {
            emptyMealCardView.isHidden = true
            mealCardCollectionView.isHidden = false
        }
        // 콕찌르기 알림 구현 후 아래 코드 지우기
        emptyMealCardView.pokeButton.isHidden = true
        // 콕찌르기 알림 구현 후 위 코드 지우기
    }
    
    private func getFamilyMemeber() {
        firestoreManager.getFamilyMember(familyCode: familyCode) { [self] in
            
            filter = firestoreManager.families[selectedCellIndex].user.getName()
            tableLabel.text = "\(filter)의 식탁"
            
            if filter != "모두" {
                firestoreManager.families[0].isSelected = false
            } else {
                firestoreManager.families[0].isSelected = true
            }
            firestoreManager.families[selectedCellIndex].isSelected = true
            familyMembers = firestoreManager.families
            
            tableLabel.reloadInputViews()
            familyFilterCollectionView.reloadData()
            mealCardCollectionView.reloadData()
        }
    }
    
    private func getLoginedUser() {
        firestoreManager.getSignInUser(userIdentifier: userIdentifier) { [self] in
            loginedUser = firestoreManager.loginedUser
            emptyMealCardView.setButtonImage(toolImage: firestoreManager.loginedUser.getToolImage())
            emptyMealCardView.reloadInputViews()
        }
    }
}


