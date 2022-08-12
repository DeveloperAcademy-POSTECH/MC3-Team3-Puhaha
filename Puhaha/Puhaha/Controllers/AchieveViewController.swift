//
//  AchieveViewController.swift
//  Puhaha
//
//  Created by JiwKang on 2022/08/11.
//

import UIKit

class AchieveViewController: UIViewController {
    private var selectedDate: Date = Date.now
    
    private var firestoreManager: FirestoreManager = FirestoreManager()
    private var storageManager: StorageManager = StorageManager()
    private var meals: [Meal] = []
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "모아보기"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
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
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .customDateLabelBlack
        label.text = Date.now.dateTextWithDot
        return label
    }()
    
    private let achieveCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 14
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AchieveCell.self, forCellWithReuseIdentifier: AchieveCell.identifier)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [titleLabel, calendar, dateLabel, achieveCollectionView, emptyLabel].forEach {
            view.addSubview($0)
        }
        
        achieveCollectionView.delegate = self
        achieveCollectionView.dataSource = self
        
        configureConstraints()
        calendar.setCalendarShadow(radius: 13, opacity: 0.1, offset: CGSize(width: 0.0, height: 1.0), width: calendar.bounds.width, height: UIScreen.main.bounds.height / 2.81)
        
        fetchMeals()
    }
    
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        calendar.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        achieveCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            
            calendar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            calendar.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2.81),
            
            dateLabel.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 22),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            
            achieveCollectionView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            achieveCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            achieveCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            achieveCollectionView.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16 + 190),
            
            emptyLabel.centerXAnchor.constraint(equalTo: achieveCollectionView.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: achieveCollectionView.centerYAnchor)
        ])
    }
    
    @objc private func uiPickerDateChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        meals = firestoreManager.meals.filter { $0.uploadedDate == selectedDate.dateText }
        achieveCollectionView.reloadData()
        dateLabel.text = selectedDate.dateTextWithDot
        
        collectionViewHiddenToggle()
    }
    
    private func fetchMeals() {
        let familyCode: String = UserDefaults.standard.string(forKey: "familyCode") ?? " "
        
        firestoreManager.fetchMeals(familyCode: familyCode, date: nil) { [self] in
            achieveCollectionView.reloadData()
            
            for i in 0..<firestoreManager.meals.count {
                storageManager.getMealImage(familyCode: familyCode, date: firestoreManager.meals[i].uploadedDate, imageName: firestoreManager.meals[i].mealImageName) { [self] in
                    firestoreManager.meals[i].mealImage = storageManager.mealImage
                    firestoreManager.getUploadUser(userEmail: firestoreManager.meals[i].uploadUserEmail) { [self] in
                        firestoreManager.meals[i].uploadUser = firestoreManager.user.getName()
                        firestoreManager.meals[i].userIcon = firestoreManager.user.getToolImage()
                        achieveCollectionView.reloadData()
                        collectionViewHiddenToggle()
                    }
                    meals = firestoreManager.meals.filter { $0.uploadedDate == selectedDate.dateText }
                    achieveCollectionView.reloadData()
                }
            }
        }
    }
    
    private func collectionViewHiddenToggle() {
        if meals.isEmpty {
            emptyLabel.isHidden = false
            achieveCollectionView.isHidden = true
        } else {
            emptyLabel.isHidden = true
            achieveCollectionView.isHidden = false
        }
    }
}

extension AchieveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 182)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mealDetailViewController = MealDetailViewController()
        mealDetailViewController.meal = meals[indexPath.row]
        navigationController?.pushViewController(mealDetailViewController, animated: true)
    }
}

extension AchieveViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AchieveCell.identifier, for: indexPath) as? AchieveCell else { return UICollectionViewCell() }
        
        cell.configureCell(meal: meals[indexPath.row])
        
        return cell
    }
    
    
}
