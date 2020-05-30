//
//  UITableView+Ext.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 30/05/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import UIKit

extension UITableView {

    func registerCellWithNibName(_ name: String, cellId: String) {
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forCellReuseIdentifier: cellId)
    }
}
