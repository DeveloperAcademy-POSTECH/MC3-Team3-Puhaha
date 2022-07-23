//
//  AccountSettingViewController.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/23.
//

import UIKit

class AccountSettingViewController: UIViewController {
    private let SettingSections: [String] = ["이름 변경", "로그아웃", "탈퇴하기"]
    
    lazy var tableView: UITableView = {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        let tableView: UITableView = UITableView(frame: CGRect(x: 0,
                                                               y: barHeight,
                                                               width: displayWidth,
                                                               height: displayHeight - barHeight))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sectionTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SettingSections[section]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        view.addSubview(self.tableView)
    }
}

extension AccountSettingViewController: UITableViewDelegate {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    section 이름 없애는 과정 필요
}

extension AccountSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionTableViewCell", for: indexPath)
        cell.textLabel?.text = "\(SettingSections[indexPath.row])"
        return cell
    }
}
