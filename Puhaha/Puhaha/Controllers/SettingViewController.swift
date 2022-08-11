//
//  SettingViewController.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/22.
//

import UIKit

class SettingViewController: UIViewController {
    
    // 유저의 값을 가지고 있는 변수들
    
    
    private let settingSectionNames: [String] = ["내 정보 편집", "그룹원 관리"]
    private let myInfoSettingList: [String] = ["계정 설정", "도구 편집"]
    private let familySettingList: [String] = ["식구 추가"]
    static let cellIdentifier = "sectionTableViewCell"
    
    lazy var tableView: UITableView = {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height * 3
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        let tableView: UITableView = UITableView(frame: CGRect(x: 0,
                                                               y: barHeight,
                                                               width: displayWidth,
                                                               height: displayHeight - barHeight))
        
        tableView.backgroundColor = UIColor.customLightGray
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: SettingViewController.cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "설정"
        view.addSubview(self.tableView)
    }
}

extension SettingViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingSectionNames.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingSectionNames[section]
    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewController.cellIdentifier, for: indexPath)

        if indexPath.section == 0 {
            cell.textLabel?.text = myInfoSettingList[indexPath.row]
        } else if indexPath.section == 1 {
            cell.textLabel?.text = familySettingList[indexPath.row]
        } else {
            return UITableViewCell()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let cellTextLabel = cell?.textLabel?.text
        
        switch cellTextLabel {
        case "계정 설정":
            let accountSettingViewController = AccountSettingViewController()
            self.navigationController?.pushViewController(accountSettingViewController, animated: true)
            
        case "도구 편집":
            let pokeToolCustomizingViewController = PokeToolCustomizingViewController()
            pokeToolCustomizingViewController.loginedUserData = sampleUser
            self.navigationController?.pushViewController(pokeToolCustomizingViewController, animated: true)
            
        case "식구 추가":
            let inviteFamilyViewController = InviteFamilyViewController()
            self.navigationController?.pushViewController(inviteFamilyViewController, animated: true)
            
        default:
            return
        }
    }
}
