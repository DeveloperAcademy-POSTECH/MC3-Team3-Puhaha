//
//  AccountSettingViewController.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/23.
//

import UIKit
import Firebase
import FirebaseAuth

class AccountSettingViewController: UIViewController {
    private let SettingSections: [String] = ["이름 변경", "로그아웃", "탈퇴하기"]
    
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
        return SettingSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionTableViewCell", for: indexPath)
        cell.textLabel?.text = "\(SettingSections[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.textLabel?.text == "로그아웃" {
            let firebaseAuth = Auth.auth()

            do {
                try firebaseAuth.signOut()
                self.navigationController?.popToRootViewController(animated: true)
                // TODO: main으로 돌아가도록 재설정
                
            } catch let signOutError as NSError {
                print("ERROR: signout \(signOutError.localizedDescription)")
            }
        }
    }
}
