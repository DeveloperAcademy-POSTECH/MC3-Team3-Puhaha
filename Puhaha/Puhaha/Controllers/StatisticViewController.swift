//
//  StatisticViewController.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/20.
//

import UIKit

class StatisticViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(mainLabel)
        
        setConstraints()
    }
    
    var mainLabel: UILabel = {
        var label = UILabel()
        label.text = "준비중입니다."
        return label
    }()
    
    func setConstraints() {
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
