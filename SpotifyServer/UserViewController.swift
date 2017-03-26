//
//  UserViewController.swift
//  SpotifyServer
//
//  Created by Robert Deans on 3/25/17.
//  Copyright © 2017 Robert Deans. All rights reserved.
//

import UIKit
import SnapKit

class UserViewController: UIViewController {

    var user: User?
    var nameTextField: UITextField!
    var cityTextField: UITextField!
    var editUserButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        nameTextField = UITextField()
        nameTextField.text = user?.name
        nameTextField.backgroundColor = UIColor.lightGray
        
        cityTextField = UITextField()
        cityTextField.text = user?.favoriteCity
        cityTextField.backgroundColor = UIColor.lightGray
        
        editUserButton = UIButton()
        editUserButton.backgroundColor = UIColor.purple
        editUserButton.setTitle("Click to Update User Info", for: .normal)
        editUserButton.addTarget(self, action: #selector(postNewUserInfo), for: .touchUpInside)
        
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.top.equalToSuperview().offset(150)
        }
        
        view.addSubview(cityTextField)
        cityTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.top.equalTo(nameTextField.snp.bottom).offset(50)
        }
        
        view.addSubview(editUserButton)
        editUserButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cityTextField.snp.bottom).offset(50)
        }
        print("USER'S ID IS \(user?.id)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func postNewUserInfo() {
        guard let unwrappedUser = user else { print("no user"); return }
        
        guard let city = cityTextField.text else { return }
        guard let name = nameTextField.text else { return }
        
        APIClient.putSpotifyUserData(user: unwrappedUser, newName: name, newCity: city)
        
        navigationController?.popToRootViewController(animated: true)
        
        
        
        
    }
    

}
