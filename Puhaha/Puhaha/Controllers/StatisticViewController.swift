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

        // Do any additional setup after loading the view.
    }
    
    var mainLabel: UILabel = {
        var label = UILabel()
        label.text = "준비중입니다."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setConstraints() {
        mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
