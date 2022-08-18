//
//  UploadViewController.swift
//  Puhaha
//
//  Created by Lena on 2022/07/20.
//

import UIKit

class UploadViewController: UIViewController {
    
    private let firestoreManager = FirestoreManager()
    private let storageManager = StorageManager()

    private let customWidth22 = UIScreen.main.bounds.width / 17.73
    private let customHeight22 = UIScreen.main.bounds.height / 38.36
    private let systemframe = UIScreen.main.bounds
    
    var tagLabel: TagLabel = TagLabel()
    
    var loginedUserEmail: String = UserDefaults.standard.string(forKey: "loginedUserEmail") ?? String()
    var loginedUser: User = User(accountId: UserDefaults.standard.string(forKey: "loginedUserEmail") ?? String())
    
    let familyCode: String = UserDefaults.standard.string(forKey: "roomCode") ?? "-"
    
    var meal = Meal.init(mealImage: UIImage(),
                        mealImageName: "-",
                         uploadUser: "-",
                         uploadUserEmail: "-",
                         userIcon: UIImage(),
                         tags: [Tag.init(content: ""), Tag.init(content: ""), Tag.init(content: "")],
                         uploadedDate: Date().dateText,
                         uploadedTime: Date().timeText,
                         reactions: [])
    
    let tagContentsArray = UploadTag.uploadTags
    var selectedTags: [String: String] = ["time": "", "menu": "", "emotion": ""]
    
    // MARK: UI
    
    lazy var pictureImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var tagTimeLabel: UILabel = {
       let label = UILabel()
        label.text = "시간"
        label.font = .boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var tagMenuLabel: UILabel = {
       let label = UILabel()
        label.text = "메뉴"
        label.font = .boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var tagEmotionLabel: UILabel = {
       let label = UILabel()
        label.text = "기분"
        label.font = .boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var tagTimeContentCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 11
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width / 17.73, bottom: 0, right: UIScreen.main.bounds.width / 17.73)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TagContentCollectionViewCell.self, forCellWithReuseIdentifier: TagContentCollectionViewCell.reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private var tagEmotionContentCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 11
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width / 17.73, bottom: 0, right: UIScreen.main.bounds.width / 17.73)
        
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TagContentCollectionViewCell.self, forCellWithReuseIdentifier: TagContentCollectionViewCell.reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private let firstDividerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let secondDividerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var tagMenuContentCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 11
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width / 17.73, bottom: 0, right: UIScreen.main.bounds.width / 17.73)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TagContentCollectionViewCell.self, forCellWithReuseIdentifier: TagContentCollectionViewCell.reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    // MARK: viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        [pictureImageView, tagLabel, tagTimeLabel, tagTimeContentCollectionView, firstDividerView, tagMenuLabel, tagMenuContentCollectionView, secondDividerView, tagEmotionLabel, tagEmotionContentCollectionView].forEach { view.addSubview($0) }
        
        tagTimeContentCollectionView.dataSource = self
        tagTimeContentCollectionView.delegate = self
        
        tagMenuContentCollectionView.dataSource = self
        tagMenuContentCollectionView.delegate = self
        
        tagEmotionContentCollectionView.dataSource = self
        tagEmotionContentCollectionView.delegate = self
        
        configureConstraints()
    }
    
    public func setMealInfo() {
        let fetchedTimeTag = selectedTags["time"] ?? String()
        let fetchedMenuTag = selectedTags["menu"] ?? String()
        let fetchedEmotionTag = selectedTags["emotion"] ?? String()
        
        firestoreManager.setUpMeals(image: pictureImageView.image ?? UIImage(),
                                    userEmail: loginedUserEmail,
                                    familyCode: familyCode,
                                    tags: Array(selectedTags.values))
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
        pictureImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        pictureImageView.widthAnchor.constraint(equalToConstant: systemframe.width),
        pictureImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        pictureImageView.bottomAnchor.constraint(equalTo: tagTimeLabel.topAnchor, constant: -systemframe.height / 32.46),
        
        tagTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: systemframe.width / 17.73),
        tagTimeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: systemframe.height / 1.76),
        
        tagTimeContentCollectionView.topAnchor.constraint(equalTo: tagTimeLabel.bottomAnchor, constant: systemframe.height / 60.29),
        tagTimeContentCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        tagTimeContentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tagTimeContentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tagTimeContentCollectionView.heightAnchor.constraint(equalToConstant: systemframe.height / 28.13),
        tagTimeContentCollectionView.bottomAnchor.constraint(equalTo: firstDividerView.topAnchor, constant: -systemframe.height / 24.82),
        
        firstDividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: customWidth22),
        firstDividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -customWidth22),
        firstDividerView.heightAnchor.constraint(equalToConstant: systemframe.height / 844),
        firstDividerView.bottomAnchor.constraint(equalTo: tagMenuLabel.topAnchor, constant: -systemframe.height / 32.46),
        
        tagMenuLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: customWidth22),
        
        tagMenuContentCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        tagMenuContentCollectionView.topAnchor.constraint(equalTo: tagMenuLabel.bottomAnchor, constant: systemframe.height / 60.28),
        tagMenuContentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tagMenuContentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tagMenuContentCollectionView.heightAnchor.constraint(equalToConstant: systemframe.height / 28.13),
        tagMenuContentCollectionView.bottomAnchor.constraint(equalTo: secondDividerView.topAnchor, constant: -systemframe.height / 24.82),
        
        secondDividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: customWidth22),
        secondDividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -customWidth22),
        secondDividerView.heightAnchor.constraint(equalToConstant: systemframe.height / 844),
        secondDividerView.bottomAnchor.constraint(equalTo: tagEmotionLabel.topAnchor, constant: -systemframe.height / 34.46),
        
        tagEmotionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: customWidth22),
        
        tagEmotionContentCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        tagEmotionContentCollectionView.topAnchor.constraint(equalTo: tagEmotionLabel.bottomAnchor, constant: systemframe.height / 60.28),
        tagEmotionContentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tagEmotionContentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tagEmotionContentCollectionView.heightAnchor.constraint(equalToConstant: systemframe.height / 28.13),
        tagEmotionContentCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -systemframe.height / 30)
        ])
    }
}

extension UploadViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case tagTimeContentCollectionView:
            return tagContentsArray[0].tagContents.count
        case tagMenuContentCollectionView:
            return tagContentsArray[1].tagContents.count
        case tagEmotionContentCollectionView:
            return tagContentsArray[2].tagContents.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagContentCollectionViewCell.reuseIdentifier, for: indexPath) as? TagContentCollectionViewCell else { return UICollectionViewCell() }
 
        switch collectionView {
        case tagTimeContentCollectionView:

            cell.tagLabel.setSelectedTextAndBackground(tag: tagContentsArray[0].tagContents[indexPath.row], fontSize: 16, isSelected: false)

        case tagMenuContentCollectionView:

                cell.tagLabel.setSelectedTextAndBackground(tag: tagContentsArray[1].tagContents[indexPath.row], fontSize: 16, isSelected: false)
        
        case tagEmotionContentCollectionView:

                cell.tagLabel.setSelectedTextAndBackground(tag: tagContentsArray[2].tagContents[indexPath.row], fontSize: 16, isSelected: false)
    
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case tagTimeContentCollectionView, tagMenuContentCollectionView, tagEmotionContentCollectionView:
            let width = systemframe.width / 5.87
            let height = systemframe.height / 28.13
            return CGSize(width: width, height: height)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TagContentCollectionViewCell {
            
            switch collectionView {
            case tagTimeContentCollectionView:
                    cell.tagLabel.setSelectedTextAndBackground(tag: tagContentsArray[0].tagContents[indexPath.row], fontSize: 16, isSelected: true)

                    selectedTags.updateValue(cell.tagLabel.getTagContent(), forKey: "time")
                    print(selectedTags)
            
            case tagMenuContentCollectionView:
                    cell.tagLabel.setSelectedTextAndBackground(tag: tagContentsArray[1].tagContents[indexPath.row], fontSize: 16, isSelected: true)

                    selectedTags.updateValue(cell.tagLabel.getTagContent(), forKey: "menu")
                    print(selectedTags)
            
            case tagEmotionContentCollectionView:
                    cell.tagLabel.setSelectedTextAndBackground(tag: tagContentsArray[2].tagContents[indexPath.row], fontSize: 16, isSelected: true)

                    selectedTags.updateValue(cell.tagLabel.getTagContent(), forKey: "emotion")
                    print(selectedTags)
                
            default:
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TagContentCollectionViewCell {
            
            switch collectionView {
            case tagTimeContentCollectionView:
                    cell.tagLabel.setSelectedTextAndBackground(tag: tagContentsArray[0].tagContents[indexPath.row], fontSize: 16, isSelected: false)
                selectedTags.removeValue(forKey: "time")
            case tagMenuContentCollectionView:
                    cell.tagLabel.setSelectedTextAndBackground(tag: tagContentsArray[1].tagContents[indexPath.row], fontSize: 16, isSelected: false)
                selectedTags.removeValue(forKey: "menu")
            case tagEmotionContentCollectionView:
                    cell.tagLabel.setSelectedTextAndBackground(tag: tagContentsArray[2].tagContents[indexPath.row], fontSize: 16, isSelected: false)
                selectedTags.removeValue(forKey: "emotion")
            default:
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let cell = collectionView.cellForItem(at: indexPath) {
            if cell.isSelected {
                collectionView.deselectItem(at: indexPath, animated: false)
                collectionView.delegate?.collectionView?(collectionView, didDeselectItemAt: indexPath)
                return false
            }
        }
        return true
    }
}
