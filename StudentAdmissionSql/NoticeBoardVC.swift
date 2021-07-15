//
//  NoticeBoardVC.swift
//  StudentAdmissionSql
//
//  Created by Akshay Jangir on 14/07/21.
//  Copyright © 2021 Akshay Jangir. All rights reserved.
//

import UIKit

class NoticeBoardVC: UIViewController {

    private var noticeArray = [Notice]()
    
    private let noticeTable = UITableView()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        noticeArray = SQLiteNoticeHandler.shared.fetch()
        noticeTable.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notice"
        view.addSubview(noticeTable)
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNotice))
        navigationItem.setRightBarButton(addItem, animated: true)

        setuptableview()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        noticeTable.frame = view.bounds
    }
    
    @objc private func addNewNotice()
    {
        let alert = UIAlertController(title: "Add SNotice", message: "Please Write Down The Notice", preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "Notice"
        }
        let action = UIAlertAction(title:"Submit", style: .default) { (_) in
            guard let notice = alert.textFields?[0].text
                 
            else{
                return
            }
            let note = Notice(id: 0, notice: notice)
            SQLiteNoticeHandler.shared.insert(note: note) { [weak self] success in
                if success
                {
                    let alert = UIAlertController(title: "Inserted Succesfully", message: "Success !", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "dismiss", style: .cancel,handler: { [weak self] _ in
                        let vc = NoticeBoardVC()
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
            }
        }
                
        alert.addAction(action)

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
            
        }

    }
    

}
extension NoticeBoardVC: UITableViewDataSource ,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noticeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stud", for: indexPath)
        let note = noticeArray[indexPath.row]
        cell.textLabel?.text = "\(note.notice)"
        return cell
    }
    
    /*func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let stud = noticeArray[indexPath.row] // passing reference for deleting
        CoreNoticeHandler.shared.delete(stud: stud) { [weak self] in
            
            self?.studArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        // delettion to be done
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let alert = UIAlertController(title: "Update Notice", message: "Please Update The Notice", preferredStyle: .alert)
        let note = noticeArray[indexPath.row]
        let idd = noticeArray[indexPath.row].id
        alert.addTextField { (tf) in
            tf.text = "\(String(note.notice))"
        }
        let action = UIAlertAction(title:"Submit", style: .default) { (_) in
            guard let notice = alert.textFields?[0].text
            else{
                return
            }
            
            let not = Notice(id: idd, notice: notice)
            SQLiteNoticeHandler.shared.update(note: not) { [weak self] success in
                if success
                {
                    let alert = UIAlertController(title: "Updated Succesfully", message: "Success !", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "dismiss", style: .cancel,handler: { [weak self] _ in
                        let vc = NoticeBoardVC()
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
            }
        }
        alert.addAction(action)

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func setuptableview()
    {
        noticeTable.register(UITableViewCell.self, forCellReuseIdentifier: "stud")
        noticeTable.delegate = self
        noticeTable.dataSource = self
    }
    
    
}
