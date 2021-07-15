//
//  StudentVC.swift
//  StudentAdmissionSql
//
//  Created by Akshay Jangir on 14/07/21.
//  Copyright © 2021 Akshay Jangir. All rights reserved.
//

import UIKit

class StudentVC: UIViewController {

    let email = UserDefaults.standard.string(forKey: "email")
    let name = UserDefaults.standard.string(forKey: "name")
    let dept = UserDefaults.standard.string(forKey: "dept")
    
    private var studArray = [Student]()
    private var noticeArray = [Notice]()
    
    private let dlblnm:UILabel = {
        let label = UILabel()
        label.text = "Department"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let dlbl:UILabel = {
        let label = UILabel()
        label.text = ""
        return label
    }()
    
    private let noticenm:UILabel = {
        let label = UILabel()
        label.text = "Notice"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let noticelbl : UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.backgroundColor = .clear
        textView.font = .boldSystemFont(ofSize: 15)
        return textView
    }()
    
    private let changepwd : UIButton = {
        let pwd = UIButton()
        pwd.setTitle("Change Password", for: .normal)
        pwd.backgroundColor = .init(red: 0.793, green: 0.232, blue: 0.026, alpha: 1)
        pwd.addTarget(self, action: #selector(changepassword), for: .touchUpInside)
        pwd.layer.cornerRadius = 10
        return pwd
    } ()

    @objc private func changepassword()
    {
        let cnt = studArray.count
        for i in 0..<cnt
        {
            if (email == studArray[i].email)
            {
                let ids = Int(self.studArray[i].id)
                let names = self.studArray[i].name
                let depts = self.studArray[i].dept
                let emails = self.studArray[i].email
                
                let alert = UIAlertController(title: "Add New Password", message: "Please Change Your Password", preferredStyle: .alert)
              
                alert.addTextField { (tf) in
                    tf.text = "\(self.studArray[i].pwd)"
                }
                let action = UIAlertAction(title:"Submit", style: .default) { (_) in
                    guard let pwd = alert.textFields?[0].text
                    else{
                        return
                    }
                    let stud = Student(id: ids, name: names, email: emails, dept: depts, pwd: pwd)
                    SQLiteHandler.shared.changepwd(stud: stud) { [weak self] success in
                        if success
                        {
                            let alert = UIAlertController(title: "Updated Successfully", message: "Success !", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "dismiss", style: .cancel,handler: { [weak self] _ in
                                let vc = StudentVC()
                                self?.navigationController?.pushViewController(vc, animated: false)
                            }))
                            DispatchQueue.main.async
                            {
                                self!.present(alert, animated: true, completion: nil)
                            }
                        }
                        else
                        {
                            let alert = UIAlertController(title: "Oops", message: "There Was An Error !", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "dismiss", style: .cancel))
                            DispatchQueue.main.async
                            {
                                self!.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
                alert.addAction(action)

                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        studArray = SQLiteHandler.shared.fetch()
        noticeArray = SQLiteNoticeHandler.shared.fetch()
        title = "Welcome \(name!)"
        view.addSubview(dlblnm)
        view.addSubview(dlbl)
        view.addSubview(noticenm)
        view.addSubview(noticelbl)
        view.addSubview(changepwd)
        print(name!)
        print(dept!)
        print(email!)
        dlbl.text = dept
        
        let ntcnt = noticeArray.count
        for i in 0..<ntcnt
        {
            noticelbl.text = noticeArray[i].notice
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dlblnm.frame = CGRect(x: 80, y: 100, width: view.width-160, height: 30)
        dlbl.frame = CGRect(x: 80, y: dlblnm.bottom + 6, width: view.width-160, height: 30)
        noticenm.frame = CGRect(x: 80, y: dlbl.bottom + 20, width: view.width-160, height: 30)
        noticelbl.frame = CGRect(x: 80, y: noticenm.bottom + 6, width: view.width-160, height: 80)
        changepwd.frame = CGRect(x: 80, y: noticelbl.bottom + 20, width: view.width-160, height: 50)
    }
}
