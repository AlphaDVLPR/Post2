//
//  PostController.swift
//  Post
//
//  Created by AlphaDVLPR on 8/12/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

//FIRST WE ARE CREATING THE CLASS

class PostController {
    
    let baseURL = URL(string: "https://devmtn-posts.firebaseio.com/posts")
    
    //THIS IS THE SOURCE OF TRUTH
    
    var posts: [Post] = []
    
    
    
    
    //THIS IS THE FETCHPOSTS FUNCTION THAT PROVIDES A COMPLETION CLOSURE
    
    func fetchPosts(completion: @escaping () -> Void) {
        
        //THIS IS THE BASE INSTANCE OF THE UNWRAPPED URL
        
        guard let unwrappedURL = baseURL else { return }
        
        //CONSTANT FOR THE GETTERENDPOINT
        
        let getterEndPoint = unwrappedURL.appendingPathExtension("json")
        
        //NOW WE ARE CREATING AN INSTANCE TO USE THE GETTERENDPOINT
        
        var request = URLRequest(url: getterEndPoint)
        
        //SO THESE ARE THE REQUEST THAT THE JSON NEEDS IN ORDER TO PULL THE INFORMATION
        
        request.httpBody = nil
        request.httpMethod = "GET"
        
        //THIS WILL MAKE THE FUNCTION CALL
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            //THIS IS GOING TO BE THE NETWORK ERROR
            
            //IF THIS PULLS AN ERROR THEN IT WILL DISPLAY AN ERROR
            // This is a networking error
            if let error = error {
                
                print(error.localizedDescription)
                
                //THIS IS THE COMPLETION. THIS WILL ALLOW THE FUNCITON TO STOP IF IT HITS AN ERROR
                
                completion()
                
            }
            
            //IF THERE IS NO ERROR THEN WE CAN MOVE ONTO THIS STEP
            
            //SO HERE THIS IS A SAFE CHECK. IF THERE IS DATA RETRIEVED THEN WE CAN MOVE ONTO THE DO TRY STATEMENT.
            //IF THERE IS NO DATA RETRIEVED THEN IT WILL RUN THE COMPLETION() AND RETURN
            
            guard let data = data else { completion(); return }
            
            //LETS SAY THE DATA GOES THROUGH THEN WE WILL HAVE TO CREATE AN INSTANCE FOR THE JSONDECODER
            
            let decoder = JSONDecoder()
            
            //ONCE WE HAVE THE DECODER SET UP WE CAN THEN FINALLY MOVE ONTO THE DO CATCH STATEMENT
            
            //THE DO
            
            do {
                
                //WE ARE NOW CREATING AN INSTANCE TO THEN TRY AND ATTEMPT TO DECODE THE JSON DICTIONARY.
                
                let postDictionary = try decoder.decode([String : Post].self, from : data)
                
                //WE ARE THEN SETTINGS POSTS TO BE EQUAL TO THE POSTDICTIONARY AND SINCE WE ARE USING THE COMPACT MAP METHOD WE CAN RETURN ONLY THE KEY VALUES THAT ARE NOT NIL
                
                var posts: [Post] = postDictionary.compactMap({ $0.value })
                
                //WE CAN THEN SORT THE POSTS FROM THE EARLIEST TO THE LATEST
                
                posts.sort(by: { $0.timestamp > $1.timestamp })
                
                //LASTLY WE ARE SETTING THE POSTS TO EQUAL ITSELF THAT WAY WE CAN UPDATE IT
                
                self.posts = posts
                
                //ONCE THIS IS ALL DONE WE CAN THEN USE THE COMPLETION METHOD TO END THE FUNCTION
                
                completion()
                
                //IF FOR SOME REASON WE CAN NOT USE THE DO STATEMENT WE MUST CATCH
                
            } catch {
                
                //THIS WILL PRINT THE ERROR
                
                print(error)
                
                //THIS IS GOING TO BE THE COMPLETION METHOD TO END THE FUNCTION
                
                completion()
                
                //RETURN THE ERROR
                
                return
            }
            
        }
        
        //SINCE THE DECODER IS BEING DONE IN THE BACKGROUND. WE CAN USE THIS RESUME METHOD ON DATATASK
        //TO ALLOW THE MAIN THREAD TO KEEP WORKING WHILE THE OTHER THREAD IS RUNNING IN THE BACKGROUND
        
        dataTask.resume()
        
    }
    
//--------------------------------------------------------------------------
    
    //HERE WE ARE GOING TO ADD POSTING FUNCTIONALITY
    
    func addNewPostWith(username : String, text : String, completion : @escaping (Bool) -> Void) {
        
        //NEXT WE ARE GOING TO INITIALIZE POST
        
        let post = Post(text: text , username: username)
        
        var postData : Data
        
        //THIS IS GOING TO BE OUR DO CATCH BLOCK FOR THE JSON ENCODER
        
        do {
            
            let jsonEncoder = JSONEncoder()
            
            postData =  try jsonEncoder.encode(post)
            
        } catch let error {
            
            print("\(error) : \(error.localizedDescription)")
            
            return
            
    }
        
        //THIS IS TO FIND OUT WHERE TO SEND THE DATA
        
        guard let baseURL = self.baseURL else { return }
        
        let postEndpoint = baseURL.appendingPathExtension("json")
        
        var urlRequest = URLRequest(url: postEndpoint)
        
        urlRequest.httpBody = postData
        urlRequest.httpMethod = "POST"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            
            if let error = error {
                
                print("\(error) : \(error.localizedDescription)")
                
                completion(false) ; return

            }
            
            guard let data = data else { return }
            
            if let dataResponseString = String(data: data, encoding: .utf8) {
                
                print(dataResponseString)
            }
            
            self.fetchPosts() {
                
                completion(true)
                
            }
            
            
            }
        
        dataTask.resume()
            
        }
    
        
}
