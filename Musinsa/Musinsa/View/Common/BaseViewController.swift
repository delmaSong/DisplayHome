//
//  BaseViewController.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/24.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    func configure() {
        addSubviews()
        configureConstraints()
        
        view.backgroundColor = .white
    }
    
    func addSubviews() {}
    
    func configureConstraints() {}
}

