//
//  MovieViewController.swift
//  MovieRoulette2
//
//  Created by Marta Krawiec on 4/12/17.
//  Copyright © 2017 Marta Krawiec. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {

    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var bottomBtn: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imbdLabel: UILabel!
    @IBOutlet weak var videoView: UIWebView!

    @IBOutlet weak var snippet: UITextView!
    var btnTitle: String?
    var watchDelete: String?
    var trailer = Trailer()
    var movieDictionary = [String: String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movieDictionary["title"]
        snippet.text = movieDictionary["overview"] 
        if let id = movieDictionary["id"] {
            print(id)
            getVideo(id: id)
        
        }
        if let votes = movieDictionary["vote_average"] {
            imbdLabel.text = "Vote Average: \(votes)/10"
        }
        else {
            imbdLabel.text = "Rating Unavailable"
        
        }
        addBtn.isEnabled = true
    
        if let btnTitle = btnTitle {
            bottomBtn.title = btnTitle
        }
        // checking if the movie is accessed from watchlist or the wheel spin
        if let addOrDelete = watchDelete {
            addBtn.setTitle(addOrDelete, for: .normal)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    func getVideo(id: String) {
        
        let requestString = "http://api.themoviedb.org/3/movie/\(id)/videos?api_key=c749c4e60598ba93981b5be8d9035aba"
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
                        let youtubeId = json["results"][0]["key"].stringValue
                        // Here you will set up the webview for youtube trailer.
                        let youtube = "<iframe width=\"100%\" height=\"90%\" src=\"https://www.youtube.com/embed/\(youtubeId)\" frameborder=\"0\" allowfullscreen></iframe>"
                            //print(youtube)
                            self.videoView.loadHTMLString(youtube, baseURL: nil)
                        self.movieDictionary["youtube"] = youtube
                        self.movieDictionary["youtubeId"] = youtubeId
                    
                        
                    }
                }
            }
                
            else {
                print("Error occured")
                
            }
            
        })
        
        task.resume()
    }
    func saveTitle() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let trailer = Trailer(context: context)
        trailer.title = movieDictionary["title"]
        trailer.overview = movieDictionary["overview"]
        trailer.img = movieDictionary["imgId"]
        if let youtube = movieDictionary["youtube"] {
            trailer.youtube = youtube
        }
        if let id = movieDictionary["id"] {
        trailer.id = "\(id)"
        }
        //print("movieDictionary[\"votes\"]")
        let votes = movieDictionary["vote_average"]
        trailer.votes = votes
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        addBtn.isEnabled = false

    
    }
    func deleteTitle() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(trailer)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        print("&&&&&&&&&&&&&")
    }
    
    
    @IBAction func addToWatchList(_ sender: Any) {
        
        if let watchDeleteText = watchDelete {
        if watchDeleteText == "Add To Watch List" {
            saveTitle()
            
        } else if watchDeleteText == "Delete Title" {
            deleteTitle()
            self.dismiss(animated: true, completion: nil)

        }
        }
        
        
          }
    
    @IBAction func spinTapped(_ sender: Any) {
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
 
    @IBAction func share(_ sender: Any) {
        
        if let youtube = movieDictionary["youtubeId"] {
        let youtubeLink = "https://youtu.be/\(youtube)"
        print(youtubeLink)
        let activityVc = UIActivityViewController(activityItems: [youtubeLink], applicationActivities: nil)
        activityVc.popoverPresentationController?.sourceView = self.view
        self.present(activityVc, animated: true, completion: nil)
        }
        
    }

}
