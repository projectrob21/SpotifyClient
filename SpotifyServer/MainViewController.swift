//
//  ViewController.swift
//  SpotifyServer
//
//  Created by Robert Deans on 3/25/17.
//  Copyright © 2017 Robert Deans. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    var users = [User]()
    
    let tableView = UITableView()
    let textField = UITextField()
    let searchButton = UIButton()
    let excludeButton = UIButton()
    let excludeLabel = UILabel()
    
    var isExcludingSearch = false
    var searchBranch: Branch = .name
    
    var addUserViewController: AddUserViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        APIClient.getSpotifyUsersData(branch: "people", not: false, nameOrID: nil) { (jsonData) in
            self.users = []
            for response in jsonData {
                let newUser = User(herokuJSON: response)
                self.users.append(newUser)
            }
            OperationQueue.main.addOperation {
                print("number of users is \(self.users.count)")
                self.tableView.reloadData()
            }
        }
        
        constrain()

        
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func configure() {
        view.backgroundColor = UIColor.cyan
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add User", style: .plain, target: self, action: #selector(presentAddUserController))
        
        textField.backgroundColor = UIColor.lightGray
        textField.placeholder = "Search for names or cities"
        
        
        searchButton.setTitle("Search", for: .normal)
        searchButton.backgroundColor = UIColor.green
        searchButton.addTarget(self, action: #selector(searchFor), for: .touchUpInside)
        
        excludeButton.backgroundColor = UIColor.white
        excludeButton.addTarget(self, action: #selector(exclude), for: .touchUpInside)
        
        excludeLabel.text = "Excluding"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "User")

    }

    func constrain() {
        view.addSubview(textField)
        textField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(150)
            $0.width.equalToSuperview().dividedBy(2)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.bottom.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.66)
        }
        
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.bottom.equalTo(tableView.snp.top).offset(-20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(excludeButton)
        excludeButton.snp.makeConstraints {
            $0.bottom.equalTo(tableView.snp.top).offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalToSuperview().dividedBy(10)
            $0.height.equalTo(excludeButton.snp.width)
        }
        
        view.addSubview(excludeLabel)
        excludeLabel.snp.makeConstraints {
            $0.centerX.equalTo(excludeButton.snp.centerX)
            $0.leading.equalTo(excludeButton.snp.trailing)
        }
    }
    
    
    func searchFor() {
        var branch: String
        searchBranch = .name
        switch searchBranch {
        case .name:
            branch = "name"
        case .city:
            branch = "cities"
        default:
            branch = "people"
        }
        
        
        APIClient.getSpotifyUsersData(branch: branch, not: isExcludingSearch, nameOrID: textField.text) { (jsonData) in
            
            print("textField is \(self.textField.text)")
            print("isExcludingSearch is \(self.isExcludingSearch)")
            self.users = []
            for response in jsonData {
                let newUser = User(herokuJSON: response)
                self.users.append(newUser)
            }
            OperationQueue.main.addOperation {
                print("number of users is \(self.users.count)")
                self.tableView.reloadData()
                // tableview stuff goes here
            }
        }
    }
    
    func presentAddUserController() {
        addUserViewController = AddUserViewController()
        
        view.addSubview(addUserViewController.view)
        addUserViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        addUserViewController.didMove(toParentViewController: nil)
        view.layoutIfNeeded()
    }
    
    func exclude() {
        isExcludingSearch = !isExcludingSearch
        if isExcludingSearch {
            excludeButton.backgroundColor = UIColor.red
        } else {
            excludeButton.backgroundColor = UIColor.white
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "User", for: indexPath)
    

        let user = users[indexPath.row]

        
        cell.textLabel?.text = user.name
        
        // *** NOT SHOWING UP ***
        cell.detailTextLabel?.text = user.favoriteCity
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        let userViewController = UserViewController()
        
        userViewController.user = selectedUser
            
        navigationController?.pushViewController(userViewController, animated: true)
            
        
    }
    

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let user = self.users[indexPath.row]
            self.users.remove(at: indexPath.row)
            APIClient.deleteSpotifyUserData(userID: user.id)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
        }
        return [delete]
    }
    
}
