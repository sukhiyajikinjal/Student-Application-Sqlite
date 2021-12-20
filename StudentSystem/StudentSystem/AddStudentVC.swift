//
//  AddStudentVC.swift
//  StudentSystem
//
//  Created by DCS on 16/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class AddStudentVC: UIViewController {
    
    var student:Student?
    
    private var idArray=[Student]()
    
    
    private let txt1:UITextField = {
        let txt = UITextField()
        txt.font = UIFont(name: "", size: 20.0)
        txt.backgroundColor = UIColor.clear
        txt.textAlignment = .center
        txt.backgroundColor = .init(red: 0.921, green: 0.941, blue: 0.953, alpha: 1)
        txt.attributedPlaceholder = NSAttributedString(string: "STUDENTNAME", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)])
        txt.layer.cornerRadius = 8
        return txt
    }()
    private let txt2:UITextField = {
        let txt = UITextField()
        txt.font = UIFont(name: "", size: 20.0)
        txt.backgroundColor = UIColor.clear
        txt.textAlignment = .center
        txt.backgroundColor = .init(red: 0.921, green: 0.941, blue: 0.953, alpha: 1)
        txt.attributedPlaceholder = NSAttributedString(string: "AGE", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)])
        txt.layer.cornerRadius = 8
        return txt
    }()
    private let txt3:UITextField = {
        let txt = UITextField()
        txt.font = UIFont(name: "", size: 20.0)
        txt.backgroundColor = UIColor.clear
        txt.textAlignment = .center
        txt.backgroundColor = .init(red: 0.921, green: 0.941, blue: 0.953, alpha: 1)
        txt.attributedPlaceholder = NSAttributedString(string: "CONTACTNO", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)])
        txt.layer.cornerRadius = 8
        return txt
    }()
    private let txt4:UITextField = {
        let txt = UITextField()
        txt.font = UIFont(name: "", size: 20.0)
        txt.backgroundColor = UIColor.clear
        txt.textAlignment = .center
        txt.backgroundColor = .init(red: 0.921, green: 0.941, blue: 0.953, alpha: 1)
        txt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(red: 0.234, green: 0.289, blue: 0.294, alpha: 1)])
        txt.layer.cornerRadius = 8
        return txt
    }()
    private let segment:UISegmentedControl = {
        let item = ["FY","SY","TY"]
       let s = UISegmentedControl(items: item)
        return s
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
        let name=txt1.text!
        let age=Int(txt2.text!)!
        let pass=txt4.text!
        let cno=txt3.text!
        let cl=segment.titleForSegment(at: segment.selectedSegmentIndex)!
        if let stud = student{
            let updatestud = Student(id: stud.id, name: name, age: Int(age), pass:pass, contactno: cno, classes: cl)
            print("update\(updatestud)")
            update(stud: updatestud)
        }else{
            print("INSERT \(name), \(age),\(pass), \(cno)")
            let stud = Student(id: 0, name: name, age: age, pass:pass, contactno:  cno,classes: cl)
            insert(stud: stud)
            
        }
    }
    func update(stud: Student){
        SQLiteHandler.shared.update(stud: stud){ success in
            if success{
                print("insert")
                self.resetFields()
            }
            else{
                print("not insert")
            }
        }
        resetFields()
        
    }
    
    func insert(stud: Student){
        SQLiteHandler.shared.insert(stud:stud){ success in
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
    private func resetFields(){
        student = nil
        txt1.text = ""
        txt2.text = ""
        txt3.text = ""
        txt4.text = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(txt1)
        view.addSubview(txt2)
        view.addSubview(txt3)
        view.addSubview(txt4)
        view.addSubview(segment)
        view.addSubview(btn)
       idArray=SQLiteHandler.shared.fetchid()
        let studs = idArray[0]
        let studid = "\(studs.id+1)"
        txt4.text=studid
        if let stud = student {
            txt1.text=stud.name
            txt2.text=String(stud.age)
            txt4.text=stud.pass
            txt3.text=stud.contactno
            if(stud.classes == "FY"){
                segment.selectedSegmentIndex = 0
            }
            if(stud.classes == "SY"){
                segment.selectedSegmentIndex = 1
            }
            if(stud.classes == "TY"){
                segment.selectedSegmentIndex = 2
            }
        }
        let additem = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(logoutclicked))
        additem.width = 10
        navigationItem.setRightBarButton(additem, animated: true)
        // Do any additional setup after loading the view.
    }
    @objc private func logoutclicked(){
        UserDefaults.standard.set(false, forKey: "uname")
        UserDefaults.standard.set(false, forKey: "pass")
        UserDefaults.standard.synchronize()
        navigationController?.popToRootViewController(animated: true)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        txt1.frame = CGRect(x: 40, y: 100, width: view.frame.size.width - 80, height: 40)
        txt2.frame = CGRect(x: 40, y: txt1.bottom+30, width: view.frame.size.width - 80, height: 40)
        txt3.frame = CGRect(x: 40, y: txt2.bottom+30, width: view.frame.size.width - 80, height: 40)
        //btn.frame = CGRect(x: 40, y: txt3.bottom+30, width: view.frame.size.width - 80, height: 40)
        txt4.frame = CGRect(x: 40, y: txt3.bottom+30, width: view.frame.size.width - 80, height: 40)
        segment.frame = CGRect(x: 40, y: txt4.bottom+30, width: view.frame.size.width - 80, height: 40)
        btn.frame = CGRect(x: 40, y: segment.bottom+30, width: view.frame.size.width - 80, height: 40)
    }
}
