//
//  MealDetailViewController.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/23.
//

import UIKit

class MealDetailViewController: UIViewController {
    var meal: Meal!
    
    #if DEBUG
    let tags: [Tag] = Tag.sampleTag
    let reactions: [Reaction?] = Reaction.sampleReaction
    let uploadedTime: Date = Date() // 현재 오늘의 날짜를 가져오지만 추후 뷰 연결 시 받아 오는 것으로 바꿀 것
    #endif
    
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
    
    private let uploadedTimeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textColor = .white
        return label
    }()
    
    private var tagLabels: [TagLabel] = []
    
    private var tagStack: UIStackView = {
        var stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 14
        return stackView
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
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.backItem?.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.masksToBounds = true
        
        reactionCollectionView.delegate = self
        reactionCollectionView.dataSource = self
        
        [mealImageView, gradient, uploadedTimeLabel, tagStack, reactionCollectionView].forEach {
            view.addSubview($0)
        }
        
        mealImageView.image = meal.mealImage
        uploadedTimeLabel.text = "\(uploadedTime.ampm)\n\(uploadedTime.timeText)"
        
        for tag in tags {
            let tagLabel = TagLabel()
            tagLabel.setTextAndBackgroundColor(tag: tag, fontSize: 16)
            tagLabels.append(tagLabel)
        }
        
        tagLabels.forEach {
            tagStack.addArrangedSubview($0)
        }
        
        setConstraints()
    }
    
    private func setConstraints() {
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        gradient.translatesAutoresizingMaskIntoConstraints = false
        uploadedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        tagStack.translatesAutoresizingMaskIntoConstraints = false
        reactionCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: view.topAnchor),
            mealImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mealImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mealImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            gradient.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gradient.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradient.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            uploadedTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 34),
            uploadedTimeLabel.bottomAnchor.constraint(equalTo: tagStack.topAnchor, constant: -26),
            
            tagStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            tagStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
            tagStack.bottomAnchor.constraint(equalTo: reactionCollectionView.topAnchor),
            
            reactionCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reactionCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reactionCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(UIScreen.main.bounds.height / 25.57 + 95)),
            reactionCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: UIScreen.main.bounds.height / 25.57)
        ])
    }
}

extension MealDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reactions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReactionCollectionViewCell.identifier, for: indexPath) as? ReactionCollectionViewCell else { return UICollectionViewCell() }
        
        let reaction = self.reactions[indexPath.row]
        cell.configureEmojiImage(with: reaction)
        
        return cell
    }
}

extension MealDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 95)
    }
}
