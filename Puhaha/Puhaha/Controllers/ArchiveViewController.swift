//
//  ArchiveViewController.swift
//  Puhaha
//
//  Created by JiwKang on 2022/08/11.
//

import UIKit

class ArchiveViewController: UIViewController {
    let calenderWidth = UIScreen.main.bounds.width * 0.88
    var calenderHeight: CGFloat! = UIScreen.main.bounds.height / UIScreen.main.bounds.width > 2 ? UIScreen.main.bounds.width * 0.85 : UIScreen.main.bounds.width * 0.70
    
    let size: CGFloat = UIScreen.main.bounds.height / 6
    
    var selectedDate: Date = Date.now
    
    @Published var baseMeals: [Meal] = []
    @Published var meals: [Meal] = []
    
    private let familyCode: String = UserDefaults.standard.string(forKey: "roomCode") ?? ""
    
    let storageManager = StorageManager()
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "모아보기"
        label.font = .boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title1).pointSize)
        label.textColor = .customTitleBlack
        return label
    }()
    
    lazy var calendar: UIDatePicker = {
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.tintColor = .customYellow
        datePicker.backgroundColor = .clear
        datePicker.maximumDate = Date.now
        datePicker.layer.cornerRadius = 13
        datePicker.addTarget(self, action: #selector(uiPickerDateChanged(_ :)), for: .valueChanged)
        
        return datePicker
    }()
    
    private let dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize)
        label.textColor = .customDateLabelBlack
        label.text = Date.now.dateTextWithDot
        return label
    }()
    
    let archiveCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 14
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ArchiveCell.self, forCellWithReuseIdentifier: ArchiveCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isHidden = true
        return collectionView
    }()
    
    private let emptyLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "식사 사진이 올라오지 않았어요"
        label.textColor = .black
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [titleLabel, calendar, dateLabel, archiveCollectionView, emptyLabel].forEach {
            view.addSubview($0)
        }
        
        archiveCollectionView.delegate = self
        archiveCollectionView.dataSource = self
        
        configureConstraints()
        calendar.setShadow(radius: 13, opacity: 0.1, offset: CGSize(width: 0.0, height: 1.0), pathSize: CGSize(width: calenderWidth, height: calenderHeight))
    }
    
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        calendar.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        archiveCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height / 11.09),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            
            calendar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: UIScreen.main.bounds.height / 52.69),
            calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendar.widthAnchor.constraint(equalToConstant: calenderWidth),
            calendar.heightAnchor.constraint(equalToConstant: calenderHeight),
            
            dateLabel.bottomAnchor.constraint(equalTo: archiveCollectionView.topAnchor, constant: -(UIScreen.main.bounds.height / 76.64)),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            
            archiveCollectionView.heightAnchor.constraint(equalToConstant: 16 + size + 40),
            archiveCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            archiveCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            archiveCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            
            emptyLabel.centerXAnchor.constraint(equalTo: archiveCollectionView.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: archiveCollectionView.centerYAnchor)
        ])
    }
    
    @objc private func uiPickerDateChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        archiveCollectionView.reloadData()
        dateLabel.text = selectedDate.dateTextWithDot
        
        for i in 0..<baseMeals.count where baseMeals[i].uploadedDate == selectedDate.dateText {
            getMealImage(date: selectedDate.dateText, imageName: baseMeals[i].mealImageName, index: i)
        }
        
        meals = baseMeals.filter({ $0.uploadedDate == selectedDate.dateText })
        
        collectionViewHiddenToggle()
    }
    
    private func getMealImage(date: String, imageName: String, index: Int) {
        storageManager.getMealImage(familyCode: familyCode,
                                    date: date,
                                    imageName: imageName) { [self] in
            baseMeals[index].mealImage = storageManager.mealImage
            
            archiveCollectionView.reloadData()
        }
    }
    
    func collectionViewHiddenToggle() {
        if meals.isEmpty {
            emptyLabel.isHidden = false
            archiveCollectionView.isHidden = true
        } else {
            emptyLabel.isHidden = true
            archiveCollectionView.isHidden = false
        }
    }
}

extension ArchiveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: size, height: size + 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mealDetailViewController = MealDetailViewController()
        mealDetailViewController.meal = meals.filter { $0.uploadedDate == selectedDate.dateText }[indexPath.row]
        mealDetailViewController.familyCode = familyCode
        navigationController?.pushViewController(mealDetailViewController, animated: true)
    }
}

extension ArchiveViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals.filter { $0.uploadedDate == selectedDate.dateText }.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArchiveCell.identifier, for: indexPath) as? ArchiveCell else { return UICollectionViewCell() }
        
        cell.configureCell(meal: meals.filter { $0.uploadedDate == selectedDate.dateText }[indexPath.row])
        
        return cell
    }
    
    
}
