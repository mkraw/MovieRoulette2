//
//  RouletteViewController.swift
//  MovieRoulette2
//
//  Created by Marta Krawiec on 4/12/17.
//  Copyright © 2017 Marta Krawiec. All rights reserved.
//

import UIKit
class RouletteViewController: UIViewController {
    
    var rotation: CGFloat = 0
    @IBOutlet weak var rouletteBtn: UIButton!
    var moviesD = [String: String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovie()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    //c749c4e60598ba93981b5be8d9035aba
    //get a random number from 0-100 to get page number V
    //make an api call V
    //once you select a movie, make a second api call 
    //get a video url from the second api call
    //display a video in webview
    
    
    
    func getMovie() {
        
        let randomPageNumber = arc4random_uniform(120) + 1;
        let requestString = "https://api.themoviedb.org/3/discover/movie?api_key=c749c4e60598ba93981b5be8d9035aba&language=en-US&include_adult=false&include_video=true&page=\(randomPageNumber)"
        let url = URL(string: requestString)

        let urlRequest = URLRequest(url: url!)
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        
        let task = session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
            
            if error != nil {
                print("There was an error")
                
            }
            else if data != nil {
              let resp = response as! HTTPURLResponse
                if resp.statusCode == 200 {
                
                if let content = data {
                        let json = JSON(data: content)
                        let randomresult = Int(arc4random_uniform(19))
                        let jsonResult = json["results"][randomresult]
                        //print(jsonResult)
                    
                        let id = jsonResult["id"].stringValue
                        let title = jsonResult["title"].stringValue
                        let overview = jsonResult["overview"].stringValue
                        let votes = jsonResult["vote_average"].stringValue
                        let img = jsonResult["poster_path"].stringValue
                        self.moviesD["id"] = id
                        self.moviesD["title"] = title
                        self.moviesD["overview"] = overview
                        self.moviesD["vote_average"] = votes
                        self.moviesD["imgId"] = img
                        //print(jsonResult)
                    }
                }
            }
        
            else {
            print("Error occured")
            
            }

        })
        
            task.resume()
    }
    
    //get the trailer for the movie 
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetailSegue" {
            let vc = segue.destination as! MovieViewController
            getMovie()
            vc.movieDictionary = moviesD
            vc.btnTitle = "Spin Again!"
            vc.watchDelete = "Add To Watch List"
            
        }
    
    }
    
    

    
//code for spinning the wheel animation
    @IBAction func dragInside(_ sender: Any) {
     
        self.rotation += CGFloat(M_PI_2)
      
        UIView.animate(withDuration: 1.0, animations: {
            
            self.rouletteBtn.transform = CGAffineTransform(rotationAngle: self.rotation)
        }, completion: { (finished: Bool) in
            if finished {
            if self.moviesD.count != 0 {
                self.performSegue(withIdentifier: "movieDetailSegue", sender: self)
            }
            else {
                let alert = UIAlertController(title: "Couldn't connect", message: "Please try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok!", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                } }
            
        })
        
    }
    
    
  
    
    
    
}

