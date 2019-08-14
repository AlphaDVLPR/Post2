//
//  PostListViewController.swift
//  Post
//
//  Created by AlphaDVLPR on 8/12/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //SO WE ARE GOING TO CREATE A SHARED INSTANCE
    
    let postController = PostController()
    
    //NEXT WE WANT TO CREATE A REFRESHCONTROL
    
    var refreshControl = UIRefreshControl()
    
    //THIS IS GOING TO BE OUR IBOUTLET
    
    @IBOutlet weak var tableView: UITableView!
    
    
//----------------------------------------------------------------------
    
    //OUR LIFE CYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //THIS IS WHERE WE ARE GOING TO SET THE TABLEVIEW DATASOURCE AND DELAGATE
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //NOW WE ARE GOING TO SET THE TABLEVIEWCELLS DYNAMIC HEIGHTS
        
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableView.automaticDimension
        
        //THIS IS GOING TO BE THE REFRESH CONTROL FOR THE TABLEVIEW
        
        tableView.refreshControl = refreshControl
        
        //NOW THIS IS GOING TO BE HOW THE USER WOULD ACTUALLY USE THE REFRESH. WE ARE GOING TO MAKE IT SO WHEN THEY SWIPE DOWN THEN THE SCREEN WILL REFRESH
        
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        
        //THIS CHECKS TO SEE IF THERE IS NETWORK CONNECTIVITY TO REFRESH

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        //THEN THIS RELOADS THE DAYA INTO THE TABLEVIEW
        
        postController.fetchPosts {
            self.reloadTableView()
            
        }
    }
    
//----------------------------------------------------------------------
   
    //THIS IS THE REFRESH CONTROL PULLED FUNCTION
    
    @objc func refreshControlPulled() {
        
        //THIS CHECKS TO SEE IF THERE IS NETWORK CONNECTIVITY TO REFRESH
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        postController.fetchPosts {
            self.reloadTableView()
            
            //DISPATCHQUEUE THEN BRINGS THIS BACK TO THE MAIN THREAD FOR IT TO BE VISIBLE TO THE USER
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
//----------------------------------------------------------------------

    //THIS IS GOING TO BE THE RELOADTABLEVIEW FUNCTION
    
    func reloadTableView () {
        
        DispatchQueue.main.async {
            
        //THIS DOES NOT NEED TO BE ONLINE FOR IT TO RUN
            
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
            self.tableView.reloadData()
        }
    }
    
//----------------------------------------------------------------------
    
    //THIS IS JUST CONFIGURING THE CELLS

    //THIS IS TO CONFIGURE THE SECTIONS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    //THIS IS TO CONFIGURE WHAT GOES IN THE CELLS
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        let post = postController.posts[indexPath.row]
        
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(post.username) - \(Date(timeIntervalSince1970: post.timestamp))"
        
        return cell
    }
   
//----------------------------------------------------------------------

    
    //ACTION BUTTONS
    
    @IBAction func barButtonTapped(_ sender: Any) {
        
        presentNewPostAlert()
    
}

    func presentNewPostAlert() {
        //INITIALIZING AN ALERT CONTROLLER
        let alert = UIAlertController(title: "CREATE A NEW THING", message: nil, preferredStyle: .alert)
        
        //SO THIS IS GOING TO BE THE USERNAME TEXT FIELD WITHIN THE ALERT
        alert.addTextField { (usernameTextField) in }
        alert.addTextField { (messageTextField) in }
        
        alert.addAction(UIAlertAction(title: "ADD", style: .default, handler: { (action) in
            
            guard let addUser = alert.textFields?[0].text, let addMessage = alert.textFields?[1].text else { return }
            
            self.postController.addNewPostWith(username: addUser, text: addMessage, completion: { (success) in
                if success == true {
                    
                    self.reloadTableView()
                    
                } else {
                    
                    print("There was a problem creating an post")
                    
                }
            })
        }))
        
        self.present(alert, animated: true, completion: nil)
        
}
    
    func presentErrorAlert() {
        
        
    }
    
    
}
