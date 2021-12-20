//
//  MainAdmin.swift
//  StudentSystem
//
//  Created by DCS on 15/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class MainAdmin: UIViewController {

    private let lbl:UILabel = {
        let labl = UILabel()
        labl.text = "Hello Admin"
        labl.font = UIFont(name: "Cochin", size: 40.0)
        labl.textAlignment = .center
        labl.textColor = .init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)
        return labl
    }()
    private let tool:UIToolbar = {
        let tul = UIToolbar()
        let add = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(SearchStud))
        tul.items = [add]
        tul.backgroundColor = .init(red: 0.921, green: 0.941, blue: 0.953, alpha: 0.3)
        tul.clipsToBounds = true
        tul.layer.cornerRadius = 18
        return tul
    }()
    private let btn1:UIButton = {
        let btnx = UIButton()
        btnx.setTitle("Student", for: .normal)
        btnx.layer.cornerRadius = 8
        btnx.addTarget(self, action: #selector(studentClicked), for: .touchUpInside)
        btnx.backgroundColor = .init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)
        return btnx
    }()
    
    private let btn2:UIButton = {
        let btnx = UIButton()
        btnx.setTitle("Notice", for: .normal)
        btnx.layer.cornerRadius = 8
        btnx.addTarget(self, action: #selector(noticeClicked), for: .touchUpInside)
        btnx.backgroundColor = .init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)
        return btnx
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(lbl)
        view.addSubview(tool)
        view.addSubview(btn1)
        view.addSubview(btn2)
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
    @objc private func SearchStud(){
        let vc = SearchStudVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lbl.frame = CGRect(x: 20, y: Int(view.height/5), width: Int(view.width-40), height: 40)
        let toolBarHeight:CGFloat = view.safeAreaInsets.top + 10.0
        tool.frame=CGRect(x: 300, y: 45, width: view.frame.size.width, height: toolBarHeight)
        btn1.frame = CGRect(x: 80, y: Int(view.height/4)+140, width: Int(view.width-160), height: 40)
        btn2.frame = CGRect(x: 80, y: Int(view.height/4)+240, width: Int(view.width-160), height: 40)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    @objc private func studentClicked(){
        let vc = MainStudent()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func noticeClicked(){
        let vc = MainNoticeVC()
        navigationController?.pushViewController(vc, animated: true)
    }

}
