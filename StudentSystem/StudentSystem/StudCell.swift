//
//  StudCell.swift
//  StudentSystem
//
//  Created by DCS on 16/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class StudCell: UITableViewCell {

    private let myLable:UILabel={
        let label = UILabel()
        label.font = .boldSystemFont(ofSize:22)
        return label
    }()
    
    func setupNameCellWith(student stud: Student){
        contentView.addSubview(myLable)
        myLable.frame=CGRect(x: 20 , y: 20, width: 200, height:40)
        myLable.text=stud.name
    }

}
