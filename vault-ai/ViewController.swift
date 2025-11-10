//
//  ViewController.swift
//  vault-ai
//
//  Created by Lukas Tomasek on 2025-11-09.
//

import SnapKit
import UIKit

class ViewController: UIViewController {
    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        label.text = "Vault AI"
        label.textColor = .black

        view.addSubview(label)

        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
