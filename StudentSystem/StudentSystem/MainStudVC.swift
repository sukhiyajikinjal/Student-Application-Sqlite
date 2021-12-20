//
//  MainStudVC.swift
//  StudentSystem
//
//  Created by DCS on 18/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit
class MainStudVC: UIViewController {
    let spid = UserDefaults.standard.string(forKey: "spid")
    let name = UserDefaults.standard.string(forKey: "name")
    let age = UserDefaults.standard.string(forKey: "age")
    //let pass = UserDefaults.standard.string(forKey: "pass")
    let clas = UserDefaults.standard.string(forKey: "class")
    let cno = UserDefaults.standard.string(forKey: "cno")
    private var studArray = [Student]()
    
    private let lbl:UILabel = {
        let labl = UILabel()
        labl.text = "Hello"
        labl.font = UIFont(name: "Cochin", size: 40.0)
        labl.textAlignment = .center
        labl.textColor = .init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)
        return labl
    }()
    private let tool:UIToolbar = {
        let tul = UIToolbar()
        let add = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.bookmarks, target: self, action: #selector(NoticeShow))
        tul.items = [add]
        tul.backgroundColor = .init(red: 0.921, green: 0.941, blue: 0.953, alpha: 0.3)
        tul.clipsToBounds = true
        tul.layer.cornerRadius = 18
        return tul
    }()
    private let lbl1:UILabel = {
        let labl = UILabel()
        labl.text = ""
        labl.font = UIFont(name: "Cochin", size: 40.0)
        labl.textAlignment = .center
        labl.textColor = .init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)
        return labl
    }()
    private let lbl2:UILabel = {
        let labl = UILabel()
        labl.text = ""
        labl.font = UIFont(name: "Cochin", size: 40.0)
        labl.textAlignment = .center
        labl.textColor = .init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)
        return labl
    }()
    private let lbl3:UILabel = {
        let labl = UILabel()
        labl.text = ""
        labl.font = UIFont(name: "Cochin", size: 40.0)
        labl.textAlignment = .center
        labl.textColor = .init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)
        return labl
    }()
    private let lbl4:UILabel = {
        let labl = UILabel()
        labl.text = ""
        labl.font = UIFont(name: "Cochin", size: 40.0)
        labl.textAlignment = .center
        labl.textColor = .init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)
        return labl
    }()
    private let changepwd : UIButton = {
        let pwd = UIButton()
        pwd.setTitle("Change Password", for: .normal)
        pwd.backgroundColor = .black
        pwd.addTarget(self, action: #selector(changepassword), for: .touchUpInside)
        pwd.layer.cornerRadius = 6
        return pwd
    } ()
    @objc private func changepassword()
    {
        let cnt = studArray.count
        for i in 0..<cnt
        {
            if (Int(spid!) == Int(studArray[i].id))
            {
                let id = Int(self.studArray[i].id)
                let name = self.studArray[i].name
                let age=self.studArray[i].age
                //let pass = self.studArray[i].pass
                let cno = self.studArray[i].contactno
                let clas = self.studArray[i].classes
                
                
                
                let alert = UIAlertController(title: "Add New Password", message: "Please Change Your Password", preferredStyle: .alert)
                
                alert.addTextField { (tf) in
                    tf.text = "\(self.studArray[i].pass)"
                }
                let action = UIAlertAction(title:"Submit", style: .default) { (_) in
                    guard let pass = alert.textFields?[0].text
                        else{
                            return
                    }
                    //let stud = Student(id: id, name:name , age:age, pass:pass , contactno: cno, classes: clas)
                    SQLiteHandler.shared.updatepwd(pass:pass,id:id) { [weak self] success in
                        if success
                        {
                            let alert = UIAlertController(title: "Updated Succesfully", message: "Success !", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "dismiss", style: .cancel,handler: { [weak self] _ in
                                let vc = MainStudVC()
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
                    }//sqlhandler
                }//let action
                alert.addAction(action)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            
        }
    }
    @objc private func NoticeShow()
    {
        let vc = NoticeShowVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        studArray = SQLiteHandler.shared.fetch()
        view.addSubview(lbl)
        view.addSubview(tool)
        view.addSubview(lbl1)
        view.addSubview(lbl2)
        view.addSubview(lbl3)
        view.addSubview(lbl4)
        view.addSubview(changepwd)
        //print(name)
        //print(spid!)
        lbl1.text = "Welcome \(name!)"
        lbl2.text = age
        lbl3.text = clas
        lbl4.text = cno
        let additem = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(logoutclicked))
        additem.width = 10
        navigationItem.setRightBarButton(additem, animated: true)
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    @objc private func logoutclicked(){
        UserDefaults.standard.set(false, forKey: "uname")
        UserDefaults.standard.set(false, forKey: "pass")
        UserDefaults.standard.synchronize()
        navigationController?.popToRootViewController(animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lbl.frame = CGRect(x: 20, y: Int(view.height/5), width: Int(view.width-40), height: 40)
        let toolBarHeight:CGFloat = view.safeAreaInsets.top + 10.0
        tool.frame=CGRect(x: 300, y: 45, width: view.frame.size.width, height: toolBarHeight)
        lbl1.frame = CGRect(x: 20, y: Int(lbl.bottom + 10), width: Int(view.width-40), height: 40)
        lbl2.frame = CGRect(x: 20, y: Int(lbl1.bottom + 10), width: Int(view.width-40), height: 40)
        lbl3.frame = CGRect(x: 20, y: Int(lbl2.bottom + 10), width: Int(view.width-40), height: 40)
        lbl4.frame = CGRect(x: 20, y: Int(lbl3.bottom + 10), width: Int(view.width-40), height: 40)
         changepwd.frame = CGRect(x: 20, y: Int(lbl4.bottom + 10), width: Int(view.width-40), height: 40)
    }
}
