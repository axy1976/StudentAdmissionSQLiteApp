//
//  ViewController.swift
//  StudentAdmissionSql
//
//  Created by Akshay Jangir on 14/07/21.
//  Copyright © 2021 Akshay Jangir. All rights reserved.
//

import UIKit

class StudentListVC: UIViewController {

    private var studArray = [Student]()
    
    private let studTable = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        studArray = SQLiteHandler.shared.fetch()
        studTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Student"
        view.addSubview(studTable)
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewStudent))
        navigationItem.setRightBarButton(addItem, animated: true)

        setuptableview()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        studTable.frame = view.bounds
    }
    
    @objc private func addNewStudent()
    {
        let alert = UIAlertController(title: "Add Student", message: "Please Fill Down The Details", preferredStyle: .alert)

        alert.addTextField { (tf) in
            tf.placeholder = "Email"
        }
        alert.addTextField { (tf) in
            tf.placeholder = "Name"
        }
        alert.addTextField { (tf) in
            tf.placeholder = "Department"
        }
        let action = UIAlertAction(title:"Submit", style: .default) { (_) in
            guard let email = alert.textFields?[0].text,
                  let name = alert.textFields?[1].text,
                  let dept = alert.textFields?[2].text
            else{
                return
            }
            
            let stud = Student(id: 0, name: name, email: email, dept: dept, pwd: email)
            SQLiteHandler.shared.insert(stud: stud) { [weak self] success in
                if success
                {
                    let alert = UIAlertController(title: "Inserted Succesfully", message: "Success !", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "dismiss", style: .cancel,handler: { [weak self] _ in
                        let vc = StudentListVC()
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
extension StudentListVC: UITableViewDataSource ,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        studArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stud", for: indexPath)
        let stud = studArray[indexPath.row]
        cell.textLabel?.text = "\(stud.name) \t | \t \(stud.email) \t | \t \(stud.dept) \t | \(stud.pwd) "
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let id = studArray[indexPath.row].id // passing reference for deleting
        SQLiteHandler.shared.delete(for: id, completion: { [weak self] success in
            if success
            {
                self?.studArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                let alert = UIAlertController(title: "Deleted Succesfully", message: "Success !", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "dismiss", style: .cancel,handler: { [weak self] _ in
                    let vc = StudentListVC()
                    self?.navigationController?.pushViewController(vc, animated: false)
                    //self?.navigationController?.popViewController(animated: true)
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
        })
        // delettion to be done
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let alert = UIAlertController(title: "Update Student", message: "Please Update The Details", preferredStyle: .alert)
        let stud = studArray[indexPath.row]

        alert.addTextField { (tf) in
            tf.text = "\(String(stud.id))"
            tf.isHidden = true
        }
        alert.addTextField { (tf) in
            tf.text = "\(String(stud.name))"
        }
        alert.addTextField { (tf) in
            tf.text = "\(String(stud.email))"
        }
        alert.addTextField { (tf) in
            tf.text = "\(String(stud.dept))"
        }
        alert.addTextField { (tf) in
            tf.text = "\(String(stud.pwd))"
        }
        let action = UIAlertAction(title:"Submit", style: .default) { (_) in
            guard let id = Int((alert.textFields?[0].text)!),
                  let name = alert.textFields?[1].text,
                  let email = alert.textFields?[2].text,
                  let dept = alert.textFields?[3].text,
                  let pwd = alert.textFields?[4].text

            else{
                return
            }
            
            let stud = Student(id: id, name: name, email: email, dept: dept, pwd: pwd)
            SQLiteHandler.shared.update(stud: stud, completion: { [weak self] success in
                if success
                {
                    let alert = UIAlertController(title: "Updated Succesfully", message: "Success !", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "dismiss", style: .cancel,handler: { [weak self] _ in
                        let vc = StudentListVC()
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
            })
  
        }
        alert.addAction(action)

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
            
        }

    }
    
    private func setuptableview()
    {
        studTable.register(UITableViewCell.self, forCellReuseIdentifier: "stud")
        studTable.delegate = self
        studTable.dataSource = self
    }
    
    
}


