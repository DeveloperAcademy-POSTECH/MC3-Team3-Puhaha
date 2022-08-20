//
//  AccountSettingViewController.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/23.
//

import UIKit

class AccountSettingViewController: UIViewController {
    private let SettingSectionNames: [String] = ["이름 변경", "로그아웃", "탈퇴하기"]
    
    lazy var tableView: UITableView = {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height * 3
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
        return String("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "계정 설정"
        navigationController?.setNavigationBarHidden(false, animated: false)
        view.addSubview(self.tableView)
    }
}

extension AccountSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

extension AccountSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingSectionNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionTableViewCell", for: indexPath)
        cell.textLabel?.text = SettingSectionNames[indexPath.row]
        return cell
    }
    
    enum AccountSettingLabel: String {
        case changeName = "이름 변경"
        case logout = "로그아웃"
        case delete = "탈퇴하기"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let cellTextLabel = cell?.textLabel?.text as? String
        
        // TODO: enum으로 선언
        
        switch cellTextLabel {
        case "이름 변경":
            let nameEditingViewController = NameEditingViewController()
            self.navigationController?.pushViewController(nameEditingViewController, animated: true)
            
        case "계정 삭제":
            logOutButtonTapped()
            
        default:
            return
        }
    }
}

extension AccountSettingViewController {
    @objc func logOutButtonTapped() {
        let alert = UIAlertController(title: "알림",
                                      message: "계정 삭제를 위해서는 설정 > 프로필 > 암호 및 보안 > Apple ID를 사용하는 앱 > 밥먹언? > Apple ID 사용 중단 버튼을 눌러주세요",
                                      preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            UserDefaults.standard.set("", forKey: "name")
            UserDefaults.standard.set("", forKey: "roomCode")
            UserDefaults.standard.set("", forKey: "loginedUserEmail")
            UserDefaults.standard.set("", forKey: "forUserID")
            
            self?.navigationController?.popToRootViewController(animated: true)
        })
        
        let no = UIAlertAction(title: "No", style: .destructive, handler: nil)
        alert.addAction(no)
        alert.addAction(yes)
        present(alert, animated: true)
    }
}
