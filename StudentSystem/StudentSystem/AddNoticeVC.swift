//
//  AddNoticeVC.swift
//  StudentSystem
//
//  Created by DCS on 18/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class AddNoticeVC: UIViewController {
    var noti:Notice?
    
    private var idArray=[Notice]()
    private let txt1:UITextField = {
        let txt = UITextField()
        txt.font = UIFont(name: "", size: 20.0)
        txt.backgroundColor = UIColor.clear
        txt.textAlignment = .center
        txt.backgroundColor = .init(red: 0.921, green: 0.941, blue: 0.953, alpha: 1)
        txt.attributedPlaceholder = NSAttributedString(string: "NOTICENAME", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)])
        txt.layer.cornerRadius = 8
        return txt
    }()
    private let txt2:UITextField = {
        let txt = UITextField()
        txt.font = UIFont(name: "", size: 20.0)
        txt.backgroundColor = UIColor.clear
        txt.textAlignment = .center
        txt.backgroundColor = .init(red: 0.921, green: 0.941, blue: 0.953, alpha: 1)
        txt.attributedPlaceholder = NSAttributedString(string: "DISCRIPTION", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)])
        txt.layer.cornerRadius = 8
        return txt
    }()
    private let btn:UIButton = {
        let btnx = UIButton()
        btnx.setTitle("SAVE", for: .normal)
        btnx.layer.cornerRadius = 8
        btnx.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        btnx.backgroundColor = .init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)
        return btnx
    }()
    @objc private func saveData(){
        let n_name=txt1.text!
        let dis=txt2.text!
        if let not = noti{
            let updatenot = Notice(id: not.id, n_name: not.n_name,  dis:not.dis)
            print("update\(updatenot)")
            update(not: updatenot)
        }else{
            print("INSERT \(n_name), \(dis)")
            let not = Notice(id: 0, n_name: n_name, dis:dis)
            insert(not: not)
            
        }
    }
    func update(not: Notice){
        SQLiteHandlerNotice.shared.update(not: not){ success in
            if success{
                print("update")
                self.resetFields()
            }
            else{
                print("not update")
            }
        }
        resetFields()
        
    }
    
    func insert(not: Notice){
        SQLiteHandlerNotice.shared.insert(not: not){ success in
            if success{
                print("insert")
                self.resetFields()
            }
            else{
                print("not inset")
            }
        }
        resetFields()
    }
    private func resetFields(){
        noti = nil
        txt1.text = ""
        txt2.text = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(txt1)
        view.addSubview(txt2)
        view.addSubview(btn)
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        if let not = noti {
            txt1.text=not.n_name
            txt2.text=not.dis
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        txt1.frame = CGRect(x: 40, y: 100, width: view.frame.size.width - 80, height: 40)
        txt2.frame = CGRect(x: 40, y: txt1.bottom+30, width: view.frame.size.width - 80, height: 40)
        btn.frame = CGRect(x: 40, y: txt2.bottom+30, width: view.frame.size.width - 80, height: 40)
    }
   

}
