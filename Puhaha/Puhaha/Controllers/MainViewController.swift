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
    var loginedUserEmail: String = UserDefaults.standard.string(forKey: "userEmail") ?? "ipkjw2@gmail.com"
    var loginedUser: User = User(accountId: UserDefaults.standard.string(forKey: "userEmail") ?? "")
    
    var filter: String = "모두"
    var selectedCellIndex: Int = 0
    let today: Date = Date.now
    let familyCode: String = UserDefaults.standard.string(forKey: "familyCode") ?? " "
    var familyMembers: [Family] = []
    
    var meals: [Meal] = []
    
    let firestoreManager = FirestoreManager()
    private var storageManager = StorageManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        tabBarController?.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        getFamilyMemeber()
        getLoginedUser()
        fetchMeals()
        
        [todayDateLabel, /* plusButton, */settingButton, tableLabel, emptyMealCardView, mealCardCollectionView, familyFilterCollectionView].forEach {
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

    /*
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.sizeThatFits(CGSize(width: 28, height: 28))
        button.tintColor = .black
        return button
    }()
    */
     
    lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "gearshape"), for: .normal)
        button.sizeThatFits(CGSize(width: 28, height: 28))
        button.tintColor = .black
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
        /* plusButton.translatesAutoresizingMaskIntoConstraints = false */
        tableLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emptyMealCardView.translatesAutoresizingMaskIntoConstraints = false
        mealCardCollectionView.translatesAutoresizingMaskIntoConstraints = false
        familyFilterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            todayDateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            todayDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            
            settingButton.centerYAnchor.constraint(equalTo: todayDateLabel.centerYAnchor),
            settingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            
            /*
            plusButton.centerYAnchor.constraint(equalTo: todayDateLabel.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: settingButton.leadingAnchor, constant: -20),
            */
             
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

    func mealCardViewHidden() {
        if firestoreManager.meals.isEmpty {
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
    }
    
    private func getFamilyMemeber() {
        firestoreManager.getFamilyMember(familyCode: familyCode) { [self] in
            familyMembers = firestoreManager.families
            familyFilterCollectionView.reloadData()
        }
    }
    
    private func getLoginedUser() {
        firestoreManager.getSignInUser(userEmail: loginedUserEmail) { [self] in
            loginedUser = firestoreManager.loginedUser
            emptyMealCardView.setButtonImage(toolImage: loginedUser.getToolImage())
            emptyMealCardView.reloadInputViews()
        }
    }
    
    private func fetchMeals() {
        firestoreManager.fetchMeals(familyCode: familyCode, date: .now) { [self] in
            mealCardCollectionView.reloadData()
            
            for i in 0..<firestoreManager.meals.count {
                storageManager.getMealImage(familyCode: familyCode, date: Date.now.dateText, imageName: "\(i + 1)") { [self] in
                    firestoreManager.meals[i].mealImage = storageManager.mealImage
                    firestoreManager.getUploadUser(userEmail: firestoreManager.meals[i].uploadUser) { [self] in
                        firestoreManager.meals[i].uploadUser = firestoreManager.user.getName()
                        firestoreManager.meals[i].userIcon = firestoreManager.user.getToolImage()
                        meals = firestoreManager.meals
                        mealCardCollectionView.reloadData()
                    }
                    
                    mealCardCollectionView.reloadData()
                }
            }
            meals = firestoreManager.meals
            mealCardViewHidden()
        }
    }
}


