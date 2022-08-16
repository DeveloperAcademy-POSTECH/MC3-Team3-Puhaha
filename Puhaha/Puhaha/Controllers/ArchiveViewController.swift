//
//  ArchiveViewController.swift
//  Puhaha
//
//  Created by JiwKang on 2022/08/11.
//

import UIKit

class ArchiveViewController: UIViewController {
    var selectedDate: Date = Date.now
    
    @Published var baseMeals: [Meal] = []
    @Published var meals: [Meal] = []
    
    private let familyCode: String = UserDefaults.standard.string(forKey: "roomCode") ?? ""
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [titleLabel, calendar, dateLabel, archiveCollectionView, emptyLabel].forEach {
            view.addSubview($0)
        }
        
        archiveCollectionView.delegate = self
        archiveCollectionView.dataSource = self
        
        configureConstraints()
        calendar.setShadow(radius: 13, opacity: 0.1, offset: CGSize(width: 0.0, height: 1.0), pathSize: CGSize(width: UIScreen.main.bounds.width / 1.13, height: UIScreen.main.bounds.height / 2.81))
    }
    
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        calendar.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        archiveCollectionView.translatesAutoresizingMaskIntoConstraints = false
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
            
            archiveCollectionView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            archiveCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            archiveCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            archiveCollectionView.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16 + 190),
            
            emptyLabel.centerXAnchor.constraint(equalTo: archiveCollectionView.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: archiveCollectionView.centerYAnchor)
        ])
    }
    
    @objc private func uiPickerDateChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        archiveCollectionView.reloadData()
        dateLabel.text = selectedDate.dateTextWithDot
        
        collectionViewHiddenToggle()
    }
    
    func collectionViewHiddenToggle() {
        if meals.filter({ $0.uploadedDate == selectedDate.dateText }).isEmpty {
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
        return CGSize(width: 150, height: 182)
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
