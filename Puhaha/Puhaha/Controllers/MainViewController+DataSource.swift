//
//  MainViewController+DataSource.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/27.
//

import UIKit

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case mealCardCollectionView:
            return meals.count
        case familyFilterCollectionView:
            return familyMembers.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case mealCardCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCardCollectionViewCell.identifier, for: indexPath) as? MealCardCollectionViewCell else { return UICollectionViewCell() }
            
            let meal = self.meals[indexPath.row]
            cell.configureMealCard(with: meal)
            
            return cell
        case familyFilterCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FamilyFilterCollectionViewCell.identifier, for: indexPath) as? FamilyFilterCollectionViewCell else { return UICollectionViewCell() }
            
            let family = self.familyMembers[indexPath.row]
            cell.configureFilterCell(with: family)
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case mealCardCollectionView:
            let mealDetailViewController = MealDetailViewController()
            mealDetailViewController.meal = meals[indexPath.row]
            navigationController?.pushViewController(mealDetailViewController, animated: true)
        case familyFilterCollectionView:
            filter = familyMembers[indexPath.row].name
            familyMembers[selectedCellIndex].isSelected = false
            selectedCellIndex = indexPath.row
            tableLabel.text = "\(filter)의 식탁"
            if filter == "모두" {
                meals = Meal.sampleMeals
                familyMembers[indexPath.row].isSelected = true
            } else {
                meals = Meal.sampleMeals.filter { $0.uploadUser == filter }
                familyMembers[indexPath.row].isSelected = true
            }
            mealCardCollectionView.reloadData()
            familyFilterCollectionView.reloadData()
            
            mealCardViewHidden()
        default:
            return
        }
    }
}
