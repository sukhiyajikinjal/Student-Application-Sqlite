//
//  NoticeCell.swift
//  StudentSystem
//
//  Created by DCS on 18/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class NoticeCell: UITableViewCell {

    private let myLable:UILabel={
        let label = UILabel()
        label.font = .boldSystemFont(ofSize:22)
        return label
    }()
    
    func setupNameCellWith(notice not: Notice){
        contentView.addSubview(myLable)
        myLable.frame=CGRect(x: 20 , y: 20, width: 200, height:40)
        myLable.text=not.n_name
    }

}
