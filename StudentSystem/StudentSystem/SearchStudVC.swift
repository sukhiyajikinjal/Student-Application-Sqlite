//
//  SearchStudVC.swift
//  StudentSystem
//
//  Created by DCS on 18/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit
class SearchStudVC: UIViewController {
    private let segment:UISegmentedControl = {
        let item = ["FY","SY","TY"]
        let s = UISegmentedControl(items: item)
        return s
    }()
    private let btn:UIButton = {
        let btnx = UIButton()
        btnx.setTitle("SHOW", for: .normal)
        btnx.layer.cornerRadius = 8
        btnx.addTarget(self, action: #selector(showData), for: .touchUpInside)
        btnx.backgroundColor = .init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)
        return btnx
    }()
    private let myTableView=UITableView()
    private var nameArray=[Student]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(segment)
        view.addSubview(btn)
        view.addSubview(myTableView)
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        segment.frame = CGRect(x: 40, y: 100, width: view.frame.size.width - 80, height: 40)
        btn.frame = CGRect(x: 40, y: segment.bottom+30, width: view.frame.size.width - 80, height: 40)
        myTableView.frame=CGRect(x: 0,
                                 y:view.safeAreaInsets.top+160,
                                 width: view.frame.size.width,
                                 height: view.frame.size.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
    }
    @objc private func showData(){
        nameArray=SQLiteHandler.shared.fetchclass(for: segment.titleForSegment(at: segment.selectedSegmentIndex)!)
        myTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // nameArray=SQLiteHandler.shared.fetchclass(for: segment.titleForSegment(at: segment.selectedSegmentIndex)!)
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        myTableView.reloadData()
    }
}
extension SearchStudVC:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "StudCell", for: indexPath) as! StudCell
        let stud = nameArray[indexPath.row]
        cell.textLabel?.text = "\(stud.name) \t | \(stud.age) \t | \(stud.pass) \t | \(stud.contactno) \t | \(stud.classes)"
        //cell.setupNameCellWith(student: stud)
        return cell
    }
    
    private func setupTableView(){
        myTableView.dataSource=self
        myTableView.delegate=self
        myTableView.register(StudCell.self, forCellReuseIdentifier: "StudCell")
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
}
}
