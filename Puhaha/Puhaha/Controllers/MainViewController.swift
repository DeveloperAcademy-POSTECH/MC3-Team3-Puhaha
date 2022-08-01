//
//  MainViewController.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/18.
//

import UIKit

class MainViewController: UIViewController {
    var filter: String = ""
    var selectedCellIndex: Int = 0
    
    var meals: [Meal] = Meal.sampleMeals
    var familyMembers: [Family] = Family.sampleFamilyMembers
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        tabBarController?.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        [todayDateLabel, plusButton, settingButton, tableLabel, emptyMealCardView, mealCardCollectionView, familyFilterCollectionView].forEach {
            view.addSubview($0)
        }
        
        if meals.isEmpty {
            emptyMealCardView.isHidden = false
            mealCardCollectionView.isHidden = true
        } else {
            emptyMealCardView.isHidden = true
            mealCardCollectionView.isHidden = false
        }
        
        setConstraints()
        mealCardCollectionView.delegate = self
        mealCardCollectionView.dataSource = self
        
        familyFilterCollectionView.delegate = self
        familyFilterCollectionView.dataSource = self
    }
    
    private var todayDateLabel: UILabel = {
        var todayDate = Date.now
        
        let label = UILabel()
        label.text = todayDate.dayText
        label.font = UIFont.boldSystemFont(ofSize: 28)
        
        return label
    }()
    
    private var plusButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.sizeThatFits(CGSize(width: 28, height: 28))
        button.tintColor = .black
        return button
    }()
    
    private var settingButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "gearshape"), for: .normal)
        button.sizeThatFits(CGSize(width: 28, height: 28))
        button.tintColor = .black
        return button
    }()
    
    var tableLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 식탁"
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
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        tableLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emptyMealCardView.translatesAutoresizingMaskIntoConstraints = false
        mealCardCollectionView.translatesAutoresizingMaskIntoConstraints = false
        familyFilterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            todayDateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            todayDateLabel.leadingAnchor.constraint(equalTo: super.view.leadingAnchor, constant: 22),
            
            settingButton.centerYAnchor.constraint(equalTo: todayDateLabel.centerYAnchor),
            settingButton.trailingAnchor.constraint(equalTo: super.view.trailingAnchor, constant: -22),
            
            plusButton.centerYAnchor.constraint(equalTo: todayDateLabel.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: settingButton.leadingAnchor, constant: -20),
            
            tableLabel.topAnchor.constraint(equalTo: todayDateLabel.bottomAnchor, constant: 91),
            tableLabel.leadingAnchor.constraint(equalTo: super.view.leadingAnchor, constant: 25),
            
            emptyMealCardView.topAnchor.constraint(equalTo: tableLabel.bottomAnchor),
            emptyMealCardView.bottomAnchor.constraint(equalTo: super.view.bottomAnchor, constant: -(UIScreen.main
                .bounds.height / 6.48)),
            emptyMealCardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            emptyMealCardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            mealCardCollectionView.topAnchor.constraint(equalTo: tableLabel.bottomAnchor),
            mealCardCollectionView.bottomAnchor.constraint(equalTo: super.view.bottomAnchor, constant: -(UIScreen.main
                .bounds.height / 6.48)),
            mealCardCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mealCardCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            familyFilterCollectionView.topAnchor.constraint(equalTo: todayDateLabel.bottomAnchor, constant: 20),
            familyFilterCollectionView.bottomAnchor.constraint(equalTo: tableLabel.topAnchor, constant: -39),
            familyFilterCollectionView.leadingAnchor.constraint(equalTo: super.view.leadingAnchor),
            familyFilterCollectionView.trailingAnchor.constraint(equalTo: super.view.trailingAnchor)
        ])
    }

    func mealCardViewHidden() {
        if meals.isEmpty {
            emptyMealCardView.isHidden = false
            mealCardCollectionView.isHidden = true
        } else {
            emptyMealCardView.isHidden = true
            mealCardCollectionView.isHidden = false
        }
    }
}
