//
//  SettingViewController.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/22.
//

import UIKit

class SettingViewController: UIViewController {
    
    private let settingSections: [String] = ["내 정보 편집", "그룹원 관리"]
    private let myInfoSettingList: [String] = ["계정 설정", "도구 편집"]
    private let familySettingList: [String] = ["식구 추가"]
    
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
        return settingSections[section]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "설정"
        view.addSubview(self.tableView)
    }
}

class TableViewCell: UITableViewCell {
    let cellButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        return button
    }()
}

extension SettingViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingSections.count
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return myInfoSettingList.count
        } else if section == 1 {
            return familySettingList.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionTableViewCell", for: indexPath)

        if indexPath.section == 0 {
            cell.textLabel?.text = "\(myInfoSettingList[indexPath.row])"
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "\(familySettingList[indexPath.row])"
        } else {
            return UITableViewCell()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.textLabel?.text == "계정 설정" {
            let accountSettingViewController = AccountSettingViewController()
            self.navigationController?.pushViewController(accountSettingViewController, animated: true)
        }
    }
}
