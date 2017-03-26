//
//  AddUserViewController.swift
//  SpotifyServer
//
//  Created by Robert Deans on 3/25/17.
//  Copyright © 2017 Robert Deans. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController {
    
    var blurView: UIVisualEffectView!
    var addUserView: UIView!
    var postButton = UIButton()
    
    let nameTextField = UITextField()
    let cityTextField = UITextField()
    
    var parentVC: MainViewController?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        constrain()
        
    }
    
    func configure() {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        blurView.alpha = 0.8
        
        addUserView = UIView()
        addUserView.backgroundColor = UIColor.blue
        
        postButton.setTitle("Post", for: .normal)
        postButton.backgroundColor = UIColor.purple
        postButton.addTarget(self, action: #selector(post), for: .touchUpInside)

        nameTextField.backgroundColor = UIColor.lightText
        nameTextField.placeholder = "Name"
        nameTextField.textAlignment = .center
        
        cityTextField.backgroundColor = UIColor.lightText
        cityTextField.placeholder = "City"
        cityTextField.textAlignment = .center
        
    }
    
    
    func dismissView() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
        parentVC?.dismissViewAddUSerController()
    }
    
    func post() {
        guard let name = nameTextField.text else { return }
        guard let city = cityTextField.text else { return }
        
        if name != "" && city != "" {
            APIClient.postSpotifyUserData(name: name, city: city)
        }
        
        dismissView()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension AddUserViewController {
    
    func constrain() {
        view.addSubview(blurView)
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        blurView.addSubview(addUserView)
        addUserView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(addUserView.snp.width).dividedBy(2)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
        }
        
        addUserView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
            $0.height.equalToSuperview().dividedBy(5)
        }
        
        addUserView.addSubview(cityTextField)
        cityTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.top.equalTo(nameTextField.snp.bottom).offset(10)
            $0.height.equalToSuperview().dividedBy(5)
        }
        
        addUserView.addSubview(postButton)
        postButton.snp.makeConstraints {
            $0.width.centerX.bottom.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(3)
        }
    }
    
}

