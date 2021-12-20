//
//  ViewController.swift
//  StudentSystem
//
//  Created by DCS on 15/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    private var checkArray=[Student]()
    private var checkArray2=[Student]()
    private let lbl:UILabel = {
        let labl = UILabel()
        labl.text = "Login"
        labl.font = UIFont(name: "Cochin", size: 40.0)
        labl.textAlignment = .center
        labl.textColor = .init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)
        return labl
    }()
    private let txt1:UITextField = {
        let txt = UITextField()
        txt.font = UIFont(name: "", size: 20.0)
        txt.backgroundColor = UIColor.clear
        txt.textAlignment = .center
        txt.backgroundColor = .init(red: 0.921, green: 0.941, blue: 0.953, alpha: 1)
        txt.attributedPlaceholder = NSAttributedString(string: "USERNAME", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)])
        txt.layer.cornerRadius = 8
        return txt
    }()
    private let txt2:UITextField = {
        let txt = UITextField()
        txt.font = UIFont(name: "", size: 20.0)
        txt.backgroundColor = UIColor.clear
        txt.textAlignment = .center
        txt.backgroundColor = .init(red: 0.921, green: 0.941, blue: 0.953, alpha: 1)
        txt.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)])
        txt.layer.cornerRadius = 8
        return txt
    }()
    private let btn:UIButton = {
        let btnx = UIButton()
        btnx.setTitle("LOGIN", for: .normal)
        btnx.layer.cornerRadius = 8
        btnx.addTarget(self, action: #selector(loginclicked), for: .touchUpInside)
        btnx.backgroundColor = .init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)
        return btnx
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(lbl)
        view.addSubview(txt1)
        view.addSubview(txt2)
        view.addSubview(btn)       
    }
    @objc private func loginclicked() {
        checkArray=SQLiteHandler.shared.fetchname()
        let studs = checkArray[0]
        let studid = "\(studs.id)"
        if(studs.name == txt1.text){
          UserDefaults.standard.setValue("Kinjal", forKey: "uname")
       UserDefaults.standard.setValue("123", forKey: "pass")
            let uName = UserDefaults.standard.string(forKey: "uname")
            let uPassword = UserDefaults.standard.string(forKey: "pass")
            if (txt1.text == uName && txt2.text == uPassword ){
                let vc = MainAdmin()
                navigationController?.pushViewController(vc, animated: true)
           }else{
             print("enetr valid username or password")
          }
        }else{
            var id = Int(txt1.text!)
            checkArray2=SQLiteHandler.shared.fetchrecord(for: id!)
            print(checkArray2.count)
            let pass = checkArray2[0].pass
            let data = checkArray2[0]
            if(pass == txt2.text){
                let vc = MainStudVC()
                UserDefaults.standard.setValue(txt1.text, forKey: "spid")
                UserDefaults.standard.setValue(data.name, forKey: "name")
                UserDefaults.standard.setValue(data.age, forKey: "age")
                UserDefaults.standard.setValue(data.pass, forKey: "pass")
                UserDefaults.standard.setValue(data.classes, forKey: "class")
                UserDefaults.standard.setValue(data.contactno, forKey: "cno")
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lbl.frame = CGRect(x: 20, y: Int(view.height/5), width: Int(view.width-40), height: 40)
        txt1.frame = CGRect(x: 80, y: Int(view.height/4)+120, width: Int(view.width-160), height: 40)
        txt2.frame = CGRect(x: 80, y: Int(view.height/4)+180, width: Int(view.width-160), height: 40)
        btn.frame = CGRect(x: 80, y: Int(view.height/4)+240, width: Int(view.width-160), height: 40)
    }


}

