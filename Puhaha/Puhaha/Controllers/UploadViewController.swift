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

    var loginedUserEmail: String = UserDefaults.standard.string(forKey: "loginedUserEmail") ?? String()
    var loginedUser: User = User(accountId: UserDefaults.standard.string(forKey: "loginedUserEmail") ?? String())
    
    let familyCode: String = UserDefaults.standard.string(forKey: "familyCode") ?? " "
    
    
    var meal = Meal.init(mealImage: UIImage(),
                        mealImageName: "-",
                         uploadUser: "-",
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
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var tagMenuLabel: UILabel = {
       let label = UILabel()
        label.text = "메뉴"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var tagEmotionLabel: UILabel = {
       let label = UILabel()
        label.text = "기분"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var tagTimeContentCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 11
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
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
        
        [pictureImageView, tagTimeLabel, tagTimeContentCollectionView, firstDividerView, tagMenuLabel, tagMenuContentCollectionView, secondDividerView, tagEmotionLabel, tagEmotionContentCollectionView].forEach { view.addSubview($0) }
        
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
        
        //        storageManager.uploadMealImage(image: pictureImageView.image ?? UIImage(),
        
        firestoreManager.setUpMeals(image: pictureImageView.image ?? UIImage(),
                                    userEmail: loginedUserEmail,
                                    familyCode: familyCode,
                                    tags: Array(selectedTags.values))
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
        pictureImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        pictureImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
        pictureImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        pictureImageView.bottomAnchor.constraint(equalTo: tagTimeLabel.topAnchor, constant: -26),
        
        tagTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
        tagTimeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height / 1.76),
        
        tagTimeContentCollectionView.topAnchor.constraint(equalTo: tagTimeLabel.bottomAnchor, constant: 14),
        tagTimeContentCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        tagTimeContentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
        tagTimeContentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tagTimeContentCollectionView.heightAnchor.constraint(equalToConstant: 30),
        tagTimeContentCollectionView.bottomAnchor.constraint(equalTo: firstDividerView.topAnchor, constant: -34),
        
        firstDividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
        firstDividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
        firstDividerView.heightAnchor.constraint(equalToConstant: 1),
        firstDividerView.bottomAnchor.constraint(equalTo: tagMenuLabel.topAnchor, constant: -26),
        
        tagMenuLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
        
        tagMenuContentCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        tagMenuContentCollectionView.topAnchor.constraint(equalTo: tagMenuLabel.bottomAnchor, constant: 14),
        tagMenuContentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
        tagMenuContentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tagMenuContentCollectionView.heightAnchor.constraint(equalToConstant: 30),
        tagMenuContentCollectionView.bottomAnchor.constraint(equalTo: secondDividerView.topAnchor, constant: -34),
        
        secondDividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
        secondDividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
        secondDividerView.heightAnchor.constraint(equalToConstant: 1),
        secondDividerView.bottomAnchor.constraint(equalTo: tagEmotionLabel.topAnchor, constant: -26),
        
        tagEmotionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
        
        tagEmotionContentCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        tagEmotionContentCollectionView.topAnchor.constraint(equalTo: tagEmotionLabel.bottomAnchor, constant: 14),
        tagEmotionContentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
        tagEmotionContentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tagEmotionContentCollectionView.heightAnchor.constraint(equalToConstant: 30)
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
        
        cell.contentLabel.textColor = UIColor.customBlack
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        
        switch collectionView {
        case tagTimeContentCollectionView:
            cell.contentLabel.textColor = .black
            cell.contentLabel.text = tagContentsArray[0].tagContents[indexPath.row].content
            cell.layer.borderColor = tagContentsArray[0].tagContents[indexPath.row].backgroundColor?.cgColor
            print(tagContentsArray[0].tagContents[indexPath.row])
            
        case tagMenuContentCollectionView:
            cell.contentLabel.textColor = .black
            cell.contentLabel.text = tagContentsArray[1].tagContents[indexPath.row].content
            cell.layer.borderColor = tagContentsArray[1].tagContents[indexPath.row].backgroundColor?.cgColor
            print(tagContentsArray[1].tagContents[indexPath.row])
        
        case tagEmotionContentCollectionView:
            cell.contentLabel.textColor = .black
            cell.contentLabel.text = tagContentsArray[2].tagContents[indexPath.row].content
            cell.layer.borderColor = tagContentsArray[2].tagContents[indexPath.row].backgroundColor?.cgColor
            print(tagContentsArray[2].tagContents[indexPath.row])
            
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case tagTimeContentCollectionView, tagMenuContentCollectionView, tagEmotionContentCollectionView:
            let width = 80
            let height = 30
            return CGSize(width: width, height: height)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TagContentCollectionViewCell {
            
            switch collectionView {
            case tagTimeContentCollectionView:
                cell.contentLabel.textColor = .white
                cell.layer.backgroundColor = tagContentsArray[0].tagContents[indexPath.row].backgroundColor?.cgColor
                    selectedTags.updateValue(cell.contentLabel.text ?? String(), forKey: "time")
                    print(selectedTags)
            
            case tagMenuContentCollectionView:
                cell.contentLabel.textColor = .white
                cell.layer.backgroundColor = tagContentsArray[1].tagContents[indexPath.row].backgroundColor?.cgColor
                    selectedTags.updateValue(cell.contentLabel.text ?? String(), forKey: "menu")
                    print(selectedTags)
                print(tagContentsArray[1].tagContents[indexPath.row])
            
            case tagEmotionContentCollectionView:
                cell.contentLabel.textColor = .white
                cell.layer.backgroundColor = tagContentsArray[2].tagContents[indexPath.row].backgroundColor?.cgColor
                    selectedTags.updateValue(cell.contentLabel.text ?? String(), forKey: "emotion")
                    print(selectedTags)
                print(tagContentsArray[2].tagContents[indexPath.row])
                
            default:
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TagContentCollectionViewCell {
            cell.backgroundColor = .white
            cell.contentLabel.textColor = .black
            
            switch collectionView {
            case tagTimeContentCollectionView:
                selectedTags.removeValue(forKey: "time")
            case tagMenuContentCollectionView:
                selectedTags.removeValue(forKey: "menu")
            case tagEmotionContentCollectionView:
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
