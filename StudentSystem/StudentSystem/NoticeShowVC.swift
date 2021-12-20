//
//  NoticeShowVC.swift
//  StudentSystem
//
//  Created by DCS on 18/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class NoticeShowVC: UIViewController {
       private var nameArray = [Notice]()
    private let lbl:UILabel = {
        let labl = UILabel()
        labl.text = "Notice"
        labl.font = UIFont(name: "Cochin", size: 40.0)
        labl.textAlignment = .center
        labl.textColor = .init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)
        return labl
    }()
private let myTableView=UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(lbl)
        view.addSubview(myTableView)
        // Do any additional setup after loading the view.
        setupTableView()
        let additem = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(logoutclicked))
        additem.width = 10
        navigationItem.setRightBarButton(additem, animated: true)
        view.backgroundColor = .white
        
    }
    @objc private func logoutclicked(){
        UserDefaults.standard.set(false, forKey: "uname")
        UserDefaults.standard.set(false, forKey: "pass")
        UserDefaults.standard.synchronize()
        navigationController?.popToRootViewController(animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tabBarController?.navigationItem.hidesBackButton = true
        //let temp=SQLiteHandler.shared
        
        nameArray=SQLiteHandlerNotice.shared.fetch()
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        myTableView.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // lbl.frame = CGRect(x: 20, y: Int(view.height/5), width: Int(view.width-40), height: 40)
        myTableView.frame=CGRect(x: 0,
                                 y:view.safeAreaInsets.top+70,
                                 width: view.frame.size.width,
                                 height: view.frame.size.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
        
    }

}
extension NoticeShowVC:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath) as! NoticeCell
        let not = nameArray[indexPath.row]
        cell.textLabel?.text = "\(not.n_name)"
        //cell.setupNameCellWith(student: stud)
        return cell
    }
    
    private func setupTableView(){
        myTableView.dataSource=self
        myTableView.delegate=self
        myTableView.register(NoticeCell.self, forCellReuseIdentifier: "NoticeCell")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let not = nameArray[indexPath.row]
        let alertController = UIAlertController(title: "Notice", message: "\(not.dis)", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction!) in
            print("Ok button tapped");
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
