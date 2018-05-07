//
//  MovieListViewController.swift
//  MovieRoulette2
//
//  Created by Marta Krawiec on 4/12/17.
//  Copyright © 2017 Marta Krawiec. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var genre: Int?
    var filter: String?
    var moviesArray = [[String: String]]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let genreNumber = genre,
            let rating = filter {
            
            getMovies(genre: genreNumber, ratingFilter: rating)
            
        }
    }
    
    func getMovies(genre: Int, ratingFilter: String) {
        
        let randomPageNumber = arc4random_uniform(120) + 1;
        
        
        let requestString = "https://api.themoviedb.org/3/discover/movie?api_key=c749c4e60598ba93981b5be8d9035aba&language=en-US&sort_by=vote_count.desc&include_adult=false&page=\(randomPageNumber)&with_genres=\(genre)\(ratingFilter)"
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
                   
                        let results = json["results"].arrayValue
                        DispatchQueue.main.async {
                            
                        for result in results {
                            print(result)
                            let title = result["title"].stringValue
                            let overview = result["overview"].stringValue
                            let id = result["id"].intValue
                            let vote = result["vote_average"].doubleValue
                            let posterPath = result["poster_path"].stringValue
                            let object = ["title": "\(title)", "overview": "\(overview)", "id": "\(id)", "vote_average": "\(vote)", "imgId": posterPath]
                            self.moviesArray.append(object)
                           }
                        }

                    }
                }
            }
                
            else {
                print("Error occured")
                
            }
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                return
            })
        })
        task.resume()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetail" {
            let vc = segue.destination as! MovieViewController
            let path = self.tableView.indexPathForSelectedRow
            vc.movieDictionary = moviesArray[path!.row]
            vc.btnTitle = "Go Back"
            vc.watchDelete = "Add To Watch List"
        }
    }

    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return moviesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellWatchList
        let movie = moviesArray[indexPath.row]
        //cell.title.text = movie["title"]
        cell.updateUI(movieTitle: movie["title"]!, imgUrl: movie["imgId"]!, rating: movie["overview"]!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMovieDetail", sender: self)
    }
    
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

   }
