//
//  MainViewController.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/18.
//

import UIKit

class MainViewController: UIViewController {
    var meals: [Meal] = Meal.sampleMeals
    var familyMembers: [Family] = Family.sampleFamilyMembers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        [todayDateLabel, plusButton, settingButton, tableLabel, mealCardCollectionView, familyFilterCollectionView].forEach {
            view.addSubview($0)
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
    
    private var tableLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 식탁"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private var mealCardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 32
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MealCardCollectionViewCell.self, forCellWithReuseIdentifier: MealCardCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private var familyFilterCollectionView: UICollectionView = {
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
        
        mealCardCollectionView.translatesAutoresizingMaskIntoConstraints = false
        familyFilterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            todayDateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            todayDateLabel.leadingAnchor.constraint(equalTo: super.view.leadingAnchor, constant: 22),
            
            settingButton.centerYAnchor.constraint(equalTo: todayDateLabel.centerYAnchor),
            settingButton.trailingAnchor.constraint(equalTo: super.view.trailingAnchor, constant: -22),
            
            plusButton.centerYAnchor.constraint(equalTo: todayDateLabel.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: settingButton.leadingAnchor, constant: -20),
            
            tableLabel.topAnchor.constraint(equalTo: todayDateLabel.bottomAnchor, constant: 91),
            tableLabel.leadingAnchor.constraint(equalTo: super.view.leadingAnchor, constant: 25),
            
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

}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mealCardCollectionView {
            return meals.count
        } else {
            return familyMembers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mealCardCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCardCollectionViewCell.identifier, for: indexPath) as? MealCardCollectionViewCell else { return UICollectionViewCell() }
            cell.layer.cornerRadius = 33
            cell.layer.masksToBounds = true
            
            let meal = self.meals[indexPath.row]
            cell.configureMealCard(with: meal)
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FamilyFilterCollectionViewCell.identifier, for: indexPath) as? FamilyFilterCollectionViewCell else { return UICollectionViewCell() }
            cell.layer.cornerRadius = 16
            cell.layer.masksToBounds = true
            
            let family = self.familyMembers[indexPath.row]
            cell.configureFilterCell(with: family)
            
            return cell
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mealCardCollectionView {
            return CGSize(width: UIScreen.main.bounds.width / 1.86, height: UIScreen.main.bounds.height / 2)
        } else {
            return CGSize(width: 50 + 15 * familyMembers[indexPath.row].name.count, height: 32)
        }
    }
}
