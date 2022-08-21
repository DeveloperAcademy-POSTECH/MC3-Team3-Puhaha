//
//  MealDetailViewController.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/23.
//

import UIKit

import FirebaseStorage

class MealDetailViewController: UIViewController {
    @Published var meal: Meal!
    var familyCode: String!
    private let storageRef = Storage.storage().reference()
    
    private let mealImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let gradient: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "GradientImage")
        return imageView
    }()
    
    private let uploadedMeridianLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 50, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let uploadedTimeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 50, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private var tagLabels: [TagLabel] = []
    
    private var mealDetailTagStackView: UIStackView = {
        var stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 14
        return stackView
    }()
    
    private let reactionSelectView: EmoticonView = {
        let collectionView = EmoticonView()
        collectionView.isHidden = true
        return collectionView
    }()
    
    private let reactionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 6
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ReactionCollectionViewCell.self, forCellWithReuseIdentifier: ReactionCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 38, bottom: 0, right: 38)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.backItem?.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.layer.masksToBounds = true
        
        reactionCollectionView.delegate = self
        reactionCollectionView.dataSource = self
        
        [mealImageView, gradient, uploadedMeridianLabel, uploadedTimeLabel, mealDetailTagStackView, reactionCollectionView, reactionSelectView].forEach {
            view.addSubview($0)
        }
        
        reactionSelectView.meal = meal
        reactionSelectView.familyCode = familyCode
        mealImageView.image = meal.mealImage
        
        let uploadedTimeText = meal.uploadedTime.transferStringToDate()
        
        uploadedMeridianLabel.text = uploadedTimeText?.meridiem
        
        uploadedTimeLabel.text = uploadedTimeText?.transferDateToStringDay()
        
        for tag in meal.tags {
            let tagLabel = TagLabel()
            tagLabel.setTextAndBackgroundColor(tag: tag, fontSize: 16)
            tagLabels.append(tagLabel)
        }
        
        tagLabels.forEach {
            mealDetailTagStackView.addArrangedSubview($0)
        }
        
        setConstraints()
    }
    
    private func setConstraints() {
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        gradient.translatesAutoresizingMaskIntoConstraints = false
        uploadedMeridianLabel.translatesAutoresizingMaskIntoConstraints = false
        uploadedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        mealDetailTagStackView.translatesAutoresizingMaskIntoConstraints = false
        reactionCollectionView.translatesAutoresizingMaskIntoConstraints = false
        reactionSelectView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: view.topAnchor),
            mealImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mealImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mealImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            gradient.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gradient.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradient.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            uploadedMeridianLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 34),
            uploadedMeridianLabel.bottomAnchor.constraint(equalTo: uploadedTimeLabel.topAnchor),
            uploadedTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 34),
            uploadedTimeLabel.bottomAnchor.constraint(equalTo: mealDetailTagStackView.topAnchor, constant: -26),
            
            mealDetailTagStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            mealDetailTagStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
            mealDetailTagStackView.bottomAnchor.constraint(equalTo: reactionCollectionView.topAnchor),
            
            reactionCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reactionCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reactionCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(UIScreen.main.bounds.height / 25.57 + 95)),
            reactionCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: UIScreen.main.bounds.height / 25.57),
            
            reactionSelectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            reactionSelectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
            reactionSelectView.topAnchor.constraint(equalTo: reactionCollectionView.topAnchor, constant: -232),
            reactionSelectView.bottomAnchor.constraint(equalTo: reactionCollectionView.topAnchor, constant: 10)
        ])
    }
}

extension MealDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meal.reactions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReactionCollectionViewCell.identifier, for: indexPath) as? ReactionCollectionViewCell else { return UICollectionViewCell() }
        
        let reaction = meal.reactions[indexPath.row]
        cell.configureEmojiImage(with: reaction)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            reactionSelectView.isHidden.toggle()
        }
    }
}

extension MealDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 95)
    }
}
