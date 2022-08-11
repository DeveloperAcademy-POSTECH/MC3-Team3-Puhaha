//
//  EmoticonView.swift
//  Puhaha
//
//  Created by JiwKang on 2022/08/08.
//

import UIKit

class EmoticonView: UIView {
    var familyCode = ""
    let firebaseManager = FirestoreManager()
    var meal: Meal!
    var loginedUser: String = UserDefaults.standard.string(forKey: "name") ?? ""
    
    private let emoji: [String] = [
        "😀", "😃", "😄", "😁", "😆", "🥹", "😅", "😂", "🤣", "🥲", "☺️", "😊", "😇", "🙂", "🙃", "😉", "😌", "😍", "🥰",
        "😘", "😗", "😙", "😚", "😋", "😛", "😝", "😜", "🤪", "🤨", "🧐", "🤓", "😎", "🥸", "🤩", "🥳", "😏", "😒", "😞",
        "😔", "😟", "😕", "🙁", "☹️", "😣", "😖", "😫", "😩", "🥺", "😢", "😭", "😤", "😠", "😡", "🤬", "🤯", "😳", "🥵",
        "🥶", "😶‍🌫️", "😱", "😨", "😰", "😥", "😓", "🤗", "🤔", "🫣", "🤭", "🫢", "🫡", "🤫", "🫠", "🤥", "😶", "🫥", "😐",
        "🫤", "😑", "😬", "🙄", "😯", "😦", "😧", "😮", "😲", "🥱", "😴", "🤤", "😪", "😮‍💨", "😵", "😵‍💫", "🤐", "🥴", "🤢",
        "🤮", "🤧", "😷", "🤒", "🤕", "🤑", "🤠", "😈", "👿"
    ]
    
    private let emoticonTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "SMILEYS & PEOPLE"
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .customLabelColor
        label.frame = CGRect(x: 0, y: 0, width: 154, height: 14)
        return label
    }()
    
    private let emoticonCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EmoticonCell.self, forCellWithReuseIdentifier: EmoticonCell.identifier)
        collectionView.backgroundColor = .customReactionSelectBackgroundColor
        collectionView.contentInset = UIEdgeInsets(top: 49, left: 15, bottom: 17, right: 15)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        backgroundColor = UIColor(named: "ReactionCollectionBackgroundColor") ?? UIColor()
        
        emoticonCollectionView.delegate = self
        emoticonCollectionView.dataSource = self
        
        [
            emoticonCollectionView,
            emoticonTitleLabel
        ].forEach {
            addSubview($0)
        }
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        emoticonCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emoticonTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emoticonTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emoticonTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 19),
            
            emoticonCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emoticonCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emoticonCollectionView.topAnchor.constraint(equalTo: topAnchor),
            emoticonCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension EmoticonView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 27, height: 27)
    }
}

extension EmoticonView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emoji.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonCell.identifier, for: indexPath) as? EmoticonCell else { return UICollectionViewCell() }
        cell.backgroundColor = .clear
        cell.configureEmoji(emoji: emoji[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if loginedUser != "" {
            firebaseManager.addReaction(familyCode: familyCode, meal: meal, newReaction: [loginedUser: emoji[indexPath.row]])
            print(emoji[indexPath.row])
            collectionView.reloadData()
        }
        
        self.isHidden = true
    }
}
