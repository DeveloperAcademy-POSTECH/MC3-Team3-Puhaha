//
//  AccountSettingViewController.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/23.
//

import UIKit

class AccountSettingViewController: UIViewController {
    private let firestoreManager =  FirestoreManager()
    private let storageManager = StorageManager()
    private let SettingSectionNames: [String] = ["이름 변경", "로그아웃", "회원탈퇴"]
    

    
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
        case deleteAccount = "회원탈퇴"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let cellTextLabel = cell?.textLabel?.text as? String
        
        // todo: enum으로 선언
        
        switch cellTextLabel {
            case "이름 변경":
                let nameEditingViewController = NameEditingViewController()
                self.navigationController?.pushViewController(nameEditingViewController, animated: true)
                
            case "로그아웃":
                logOutButtonTapped()
                
            case "회원탈퇴":
                deleteAccountButtonTapped()
                
            default:
                return
        }
    }
}

extension AccountSettingViewController {
    @objc func logOutButtonTapped() {
        let alert = UIAlertController(title: "알림",
                                      message: "로그아웃 하시겠습니까?",
                                      preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "예", style: .default, handler: { [weak self] _ in
            UserDefaults.standard.set("", forKey: "roomCode")
            UserDefaults.standard.set("", forKey: "name")
            UserDefaults.standard.set("", forKey: "userIdentifier")
            UserDefaults.standard.set("", forKey: "forUserID")
            self?.navigationController?.popToRootViewController(animated: true)
        })
        let no = UIAlertAction(title: "아니오", style: .default, handler: nil)
        
        alert.addAction(yes)
        alert.addAction(no)
        present(alert, animated: true)
    }
    
    @objc func deleteAccountButtonTapped() {
        let familyCode = UserDefaults.standard.value(forKey: "roomCode") as? String ?? ""
        let uploadUser = UserDefaults.standard.value(forKey: "userIdentifier") as? String ?? ""
        
        let alert = UIAlertController(title: "알림",
                                      message: "정말 탈퇴하시겠습니까?",
                                      preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "예", style: .destructive, handler: { [weak self] _ in
            
            self?.firestoreManager.deleteAccount(roomCode: familyCode, userIdentifier: uploadUser)
            
            UserDefaults.standard.set("", forKey: "roomCode")
            UserDefaults.standard.set("", forKey: "name")
            UserDefaults.standard.set("", forKey: "userIdentifier")
            UserDefaults.standard.set("", forKey: "forUserID")
            self?.navigationController?.popToRootViewController(animated: true)
        })
        
        let no = UIAlertAction(title: "아니오", style: .default)
        
        alert.addAction(no)
        alert.addAction(yes)
        present(alert, animated: true)
    }
}
