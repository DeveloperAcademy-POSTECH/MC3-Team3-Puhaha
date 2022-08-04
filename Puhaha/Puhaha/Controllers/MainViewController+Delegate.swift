//
//  MainViewController+Delegate.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/27.
//

import UIKit

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case mealCardCollectionView:
            return CGSize(width: UIScreen.main.bounds.width / 1.86, height: UIScreen.main.bounds.height / 2)
        case familyFilterCollectionView:
            let label = UILabel()
            label.text = firestoreManager.families[indexPath.row].user.getName()
            return CGSize(width: 50 + label.intrinsicContentSize.width, height: 32)
        default:
            return CGSize()
        }
    }
}
