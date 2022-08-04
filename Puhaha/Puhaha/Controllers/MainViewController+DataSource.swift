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
            return firestoreManager.meals.count
        case familyFilterCollectionView:
            return firestoreManager.families.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case mealCardCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCardCollectionViewCell.identifier, for: indexPath) as? MealCardCollectionViewCell else { return UICollectionViewCell() }
            
            let meal = firestoreManager.meals[indexPath.row]
            cell.configureMealCard(with: meal, familyCode: familyCode, date: today)
            
            return cell
        case familyFilterCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FamilyFilterCollectionViewCell.identifier, for: indexPath) as? FamilyFilterCollectionViewCell else { return UICollectionViewCell() }
            
            let family = firestoreManager.families[indexPath.row]
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
            mealDetailViewController.meal = firestoreManager.meals[indexPath.row]
            navigationController?.pushViewController(mealDetailViewController, animated: true)
        case familyFilterCollectionView:
            filter = firestoreManager.families[indexPath.row].user.getName()
            firestoreManager.families[selectedCellIndex].isSelected = false
            selectedCellIndex = indexPath.row
            tableLabel.text = "\(filter)의 식탁"
            if filter == "모두" {
                meals = firestoreManager.meals
                firestoreManager.families[indexPath.row].isSelected = true
            } else {
                meals = firestoreManager.meals.filter { $0.uploadUser == filter }
                firestoreManager.families[indexPath.row].isSelected = true
            }
            mealCardCollectionView.reloadData()
            familyFilterCollectionView.reloadData()
            
            mealCardViewHidden()
        default:
            return
        }
    }
}
