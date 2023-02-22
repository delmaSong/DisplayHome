//
//  ViewController.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import UIKit
import RxSwift

final class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let useCase = DisplayServiceUseCase()
        
        useCase.fetchList()
            .subscribe { event in
                switch event {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error)
                }
            }.disposed(by: disposeBag)
    }
}
