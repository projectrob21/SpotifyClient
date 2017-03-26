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


    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        constrain()
        
    }

    func configure() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissView))
        
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        blurView.alpha = 0.8
        
        addUserView = UIView()
        addUserView.backgroundColor = UIColor.white
        
        postButton.setTitle("Post", for: .normal)
        postButton.backgroundColor = UIColor.purple
        postButton.addTarget(self, action: #selector(post), for: .touchUpInside)
        
        nameTextField.placeholder = "Name"
        nameTextField.backgroundColor = UIColor.lightGray
        cityTextField.placeholder = "City"
        cityTextField.backgroundColor = UIColor.lightGray

    }
    
    func constrain() {
        view.addSubview(blurView)
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        blurView.addSubview(addUserView)
        addUserView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(addUserView.snp.width)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
        }
        
        addUserView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
        
        addUserView.addSubview(cityTextField)
        cityTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameTextField.snp.bottom).offset(20)
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
        
        addUserView.addSubview(postButton)
        postButton.snp.makeConstraints {
            $0.width.centerX.bottom.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(8)
        }
    }
    
    func dismissView() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
