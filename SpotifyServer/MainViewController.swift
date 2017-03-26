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
    var segmentedContoller: UISegmentedControl!
    
    var isExcludingSearch = false
    var searchBranch: Branch {
        if segmentedContoller.selectedSegmentIndex == 0 {
            return .name
        } else {
            return .city
        }
    }
    
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
                self.users = self.users.sorted(by: {
                    $0.0.id < $0.1.id
                })
                self.tableView.reloadData()
            }
        }
        
        constrain()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        print("VIEW DID APPEAR")
        APIClient.getSpotifyUsersData(branch: "people", not: false, nameOrID: nil) { (jsonData) in
            self.users = []
            for response in jsonData {
                let newUser = User(herokuJSON: response)
                self.users.append(newUser)
            }
            OperationQueue.main.addOperation {
                self.users = self.users.sorted(by: {
                    $0.0.id < $0.1.id
                })
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    func configure() {
        view.backgroundColor = UIColor.cyan
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add User", style: .plain, target: self, action: #selector(presentAddUserController))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "🔎", style: .plain, target: self, action: #selector())
        
        let paddingview = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.backgroundColor = UIColor.lightText
        textField.placeholder = "Search for names or cities"
        textField.leftView = paddingview
        textField.leftViewMode = UITextFieldViewMode.always
        
        
        searchButton.setTitle("Search", for: .normal)
        searchButton.backgroundColor = UIColor.green
        searchButton.addTarget(self, action: #selector(searchFor), for: .touchUpInside)
        
        excludeButton.backgroundColor = UIColor.white
        excludeButton.addTarget(self, action: #selector(exclude), for: .touchUpInside)
        
        excludeLabel.text = "Excluding"
        
        let items = ["Names", "Cities"]
        segmentedContoller = UISegmentedControl(items: items)
        segmentedContoller.selectedSegmentIndex = 0
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "User")

    }

    func constrain() {
        view.addSubview(textField)
        textField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(80)
            $0.width.equalToSuperview().multipliedBy(0.66)
            $0.height.equalToSuperview().dividedBy(20)
        }
        
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.centerY.equalTo(textField.snp.centerY)
            $0.leading.equalTo(textField.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().offset(-5)
        }
        
        view.addSubview(excludeButton)
        excludeButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalToSuperview().dividedBy(15)
            $0.height.equalTo(excludeButton.snp.width)
        }
        
        view.addSubview(excludeLabel)
        excludeLabel.snp.makeConstraints {
            $0.centerY.equalTo(excludeButton.snp.centerY)
            $0.leading.equalTo(excludeButton.snp.trailing).offset(5)
            $0.height.equalTo(excludeButton.snp.height)
        }
        
        view.addSubview(segmentedContoller)
        segmentedContoller.snp.makeConstraints {
            $0.centerY.equalTo(excludeLabel.snp.centerY)
            $0.leading.equalTo(excludeLabel.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.bottom.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.75)
        }
        
        

    }
    
    
    func searchFor() {
        var branch: String

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
                self.users = self.users.sorted(by: {
                    $0.0.id < $0.1.id
                })
                self.tableView.reloadData()
                // tableview stuff goes here
            }
        }
    }
    
    
    func presentAddUserController() {
        addUserViewController = AddUserViewController()
        addUserViewController.parentVC = self
        view.addSubview(addUserViewController.view)
        addUserViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        addUserViewController.didMove(toParentViewController: nil)
        view.layoutIfNeeded()
        
        print("PARENT = \(addUserViewController.parent)")

        navigationItem.rightBarButtonItem?.title = "Dismiss"
        navigationItem.rightBarButtonItem?.action = #selector(dismissViewAddUSerController)
    }
    
    func dismissViewAddUSerController() {
        APIClient.getSpotifyUsersData(branch: "people", not: false, nameOrID: nil) { (jsonData) in
            self.users = []
            for response in jsonData {
                let newUser = User(herokuJSON: response)
                self.users.append(newUser)
            }
            OperationQueue.main.addOperation {
                print("number of users is \(self.users.count)")
                self.users = self.users.sorted(by: {
                    $0.0.id < $0.1.id
                })
                self.tableView.reloadData()
            }
        }
        
        navigationItem.rightBarButtonItem?.title = "Add User"
        navigationItem.rightBarButtonItem?.action = #selector(presentAddUserController)

        willMove(toParentViewController: nil)
        addUserViewController.view.removeFromSuperview()
        addUserViewController = nil
    
        
    
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
