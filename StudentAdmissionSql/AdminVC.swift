//
//  AdminVC.swift
//  StudentAdmissionSql
//
//  Created by Akshay Jangir on 14/07/21.
//  Copyright © 2021 Akshay Jangir. All rights reserved.
//

import UIKit

class AdminVC: UIViewController {

    private let StudentDetails : UIButton = {
        let btn = UIButton()
        btn.setTitle("StudentDetails", for: .normal)
        btn.backgroundColor = .init(red: 0.793, green: 0.232, blue: 0.026, alpha: 1)
        btn.addTarget(self, action: #selector(StudentDetail), for: .touchUpInside)
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    @objc private func StudentDetail()
    {
        let vc = StudentListVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private let NoticeBoard : UIButton = {
        let btn = UIButton()
        btn.setTitle("NoticeBoard", for: .normal)
        btn.backgroundColor = .init(red: 0.793, green: 0.232, blue: 0.026, alpha: 1)
        btn.addTarget(self, action: #selector(NoticeBoards), for: .touchUpInside)
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    @objc private func NoticeBoards()
    {
        let vc = NoticeBoardVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Admin Panel"
        view.backgroundColor = .init(red: 0.918, green: 0.918, blue: 0.918, alpha: 1)
        view.addSubview(StudentDetails)
        view.addSubview(NoticeBoard)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        StudentDetails.frame = CGRect(x: 100, y: 300, width: view.width-200, height: 50)
        NoticeBoard.frame = CGRect(x: 100, y: 370, width: view.width-200, height: 50)
    }
}
