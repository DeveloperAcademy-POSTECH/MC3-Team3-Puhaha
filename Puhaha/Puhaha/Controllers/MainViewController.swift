//
//  MainViewController.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/18.
//

import UIKit

class MainViewController: UITabBarController {
    var meals: [Meal] = Meal.sampleMeals
    var familyMembers: [Family] = Family.sampleFamilyMemebers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        [todayDateLabel, plusButton, settingButton, tableLabel, mealCollectionView, familyFilterCollectionView].forEach {
            view.addSubview($0)
        }
        
        setConstraints()
        mealCollectionView.delegate = self
        mealCollectionView.dataSource = self
        
        familyFilterCollectionView.delegate = self
        familyFilterCollectionView.dataSource = self
    }
    
    private var todayDateLabel: UILabel = {
        var todayDate = Date.now
        
        let label = UILabel()
        label.text = todayDate.dayAndTimeText
        label.font = UIFont.boldSystemFont(ofSize: 28)
        
        return label
    }()
    
    private var plusButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.sizeThatFits(CGSize(width: 27, height: 27))
        button.tintColor = .black
        return button
    }()
    
    private var settingButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "gearshape"), for: .normal)
        button.sizeThatFits(CGSize(width: 27, height: 27))
        button.tintColor = .black
        return button
    }()
    
    private var tableLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 식탁"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private var mealCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 32
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MealCollectionViewCell.self, forCellWithReuseIdentifier: "MealCollectionViewCell")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private var familyFilterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FamilyFilterCollectionViewCell.self, forCellWithReuseIdentifier: "FamilyFilterCollectionViewCell")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    func setConstraints() {
        todayDateLabel.translatesAutoresizingMaskIntoConstraints = false
        todayDateLabel.topAnchor.constraint(equalTo: super.view.topAnchor, constant: 59).isActive = true
        todayDateLabel.leadingAnchor.constraint(equalTo: super.view.leadingAnchor, constant: 25).isActive = true
        
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.centerYAnchor.constraint(equalTo: todayDateLabel.centerYAnchor).isActive = true
        settingButton.trailingAnchor.constraint(equalTo: super.view.trailingAnchor, constant: -16).isActive = true
        
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.centerYAnchor.constraint(equalTo: todayDateLabel.centerYAnchor).isActive = true
        plusButton.trailingAnchor.constraint(equalTo: settingButton.leadingAnchor, constant: -15).isActive = true
        
        tableLabel.translatesAutoresizingMaskIntoConstraints = false
        tableLabel.topAnchor.constraint(equalTo: todayDateLabel.bottomAnchor, constant: 91).isActive = true
        tableLabel.leadingAnchor.constraint(equalTo: super.view.leadingAnchor, constant: 25).isActive = true
        
        mealCollectionView.topAnchor.constraint(equalTo: tableLabel.bottomAnchor).isActive = true
        mealCollectionView.bottomAnchor.constraint(equalTo: super.view.bottomAnchor, constant: -130).isActive = true
        mealCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mealCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        familyFilterCollectionView.topAnchor.constraint(equalTo: todayDateLabel.bottomAnchor, constant: 20).isActive = true
        familyFilterCollectionView.bottomAnchor.constraint(equalTo: tableLabel.topAnchor, constant: -39).isActive = true
        familyFilterCollectionView.leadingAnchor.constraint(equalTo: super.view.leadingAnchor).isActive = true
        familyFilterCollectionView.trailingAnchor.constraint(equalTo: super.view.trailingAnchor).isActive = true
    }

}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mealCollectionView {
            return meals.count
        } else {
            return familyMembers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mealCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCollectionViewCell", for: indexPath) as? MealCollectionViewCell else { return UICollectionViewCell() }
            cell.layer.cornerRadius = 33
            cell.layer.masksToBounds = true
            
            let meal = self.meals[indexPath.row]
            cell.configure(with: meal)
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FamilyFilterCollectionViewCell", for: indexPath) as? FamilyFilterCollectionViewCell else { return UICollectionViewCell() }
            cell.layer.cornerRadius = 18
            cell.backgroundColor = .lightGray
            
            let family = self.familyMembers[indexPath.row]
            cell.configure(with: family)
            
            return cell
        }
        
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mealCollectionView {
            return CGSize(width: 209, height: 424)
        } else {
            return CGSize(width: 91, height: 32)
        }
    }
}
