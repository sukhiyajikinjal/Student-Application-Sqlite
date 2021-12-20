//
//  MainStudent.swift
//  StudentSystem
//
//  Created by DCS on 15/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class MainStudent: UIViewController {
    private let lbl:UILabel = {
        let labl = UILabel()
        labl.text = "Student Data"
        labl.font = UIFont(name: "Cochin", size: 40.0)
        labl.textAlignment = .center
        labl.textColor = .init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)
        return labl
    }()
    private let tool:UIToolbar = {
        let tul = UIToolbar()
        let add = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addStud))
        tul.items = [add]
        tul.backgroundColor = .init(red: 0.921, green: 0.941, blue: 0.953, alpha: 0.3)
        tul.clipsToBounds = true
        tul.layer.cornerRadius = 18
        return tul
    }()
    private let myTableView=UITableView()
    private var nameArray=[Student]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.addSubview(lbl)
       
        view.addSubview(tool)
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
    @objc private func addStud(){
        let vc = AddStudentVC()
        navigationController?.pushViewController(vc, animated: true)
        //self.present(vc, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tabBarController?.navigationItem.hidesBackButton = true
        //let temp=SQLiteHandler.shared
       
        nameArray=SQLiteHandler.shared.fetch()
      
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        myTableView.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       // lbl.frame = CGRect(x: 20, y: Int(view.height/5), width: Int(view.width-40), height: 40)
        let toolBarHeight:CGFloat = view.safeAreaInsets.top + 40.0
        tool.frame=CGRect(x: 0, y: 40, width: view.frame.size.width, height: toolBarHeight)
        myTableView.frame=CGRect(x: 0,
                                 y:view.safeAreaInsets.top+70,
                                 width: view.frame.size.width,
                                 height: view.frame.size.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
        
    }

}
extension MainStudent:UITableViewDataSource, UITableViewDelegate{
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
    func tableView(_ tableView: UITableView, commit editingStyle:UITableViewCell.EditingStyle, forRowAt indexPath:IndexPath){
        let id = nameArray[indexPath.row].id
        
        SQLiteHandler.shared.delete(for: id) { success in
            if success{
                self.nameArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
            }
            else{
                print("unable delete")
            }
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddStudentVC()
        vc.student = nameArray[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
