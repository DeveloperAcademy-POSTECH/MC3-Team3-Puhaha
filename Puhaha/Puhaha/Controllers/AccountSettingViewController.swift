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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let cellTextLabel = cell?.textLabel?.text
        
        switch cellTextLabel {
        case "이름 변경":
            let nameSettingViewController = NameSettingViewController()
            self.navigationController?.pushViewController(nameSettingViewController, animated: true)
            
        case "로그아웃":
            logOutButtonTapped()

        case "탈퇴하기":
            // TODO: 탈퇴하기 기능
            return
            
        default:
            return
        }
    }
}

extension AccountSettingViewController {
    @objc func logOutButtonTapped() {
        let alert = UIAlertController(title: "알림",
                                      message: "정말 로그아웃 하시겠습니까?",
                                      preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            UserDefaults.standard.set("", forKey: "loginedUserEmail")
            let signInViewController = SignInViewController()
            self?.navigationController?.pushViewController(signInViewController, animated: true)
        })
        
        let no = UIAlertAction(title: "No", style: .destructive, handler: nil)
        alert.addAction(no)
        alert.addAction(yes)
        present(alert, animated: true)
    }
}
