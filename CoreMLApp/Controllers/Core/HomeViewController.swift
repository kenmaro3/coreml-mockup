//
//  ViewController.swift
//  CoreMLApp
//
//  Created by Kentaro Mihara on 2022/04/09.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "this is a home view controller"
        label.textColor = .label
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemRed
        
        view.addSubview(label)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.sizeToFit()
        label.frame = CGRect(x: view.width/2 - label.width/2, y: view.height/2, width: label.width, height: label.height)
    }


}

