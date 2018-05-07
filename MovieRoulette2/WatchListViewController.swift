//
//  WatchListViewController.swift
//  MovieRoulette2
//
//  Created by Marta Krawiec on 4/12/17.
//  Copyright © 2017 Marta Krawiec. All rights reserved.
//

import UIKit

class WatchListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var movies: [Trailer] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        getSavedMovies()
        //reload table view
        tableView.reloadData()
        for movie in movies {
        print("****************** \(movie.title)")
        }
    }
    
 //fetch the saved results 
   func getSavedMovies() {
    
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            movies = try context.fetch(Trailer.fetchRequest())
        } catch {
            print("There was an error")
    
        }
    
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCell", for: indexPath) as! CellWatchList
        let movie = movies[indexPath.row]
        if let movieTitle = movie.title, let movieImg = movie.img, let rating = movie.overview {
        
            cell.updateUI(movieTitle: movieTitle, imgUrl: movieImg, rating: rating)

        }
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MovieViewController
        let path = self.tableView.indexPathForSelectedRow
        let movie = movies[path!.row]
        if let movieTitle = movie.title, let rating = movie.votes, let youtube = movie.youtube, let overview = movie.overview, let id = movie.id {
            vc.movieDictionary = ["title": movieTitle, "youtube": youtube, "overview": overview, "vote_average": rating, "id": id]
            vc.btnTitle = "Go Back"
            vc.watchDelete = "Delete Title"
            vc.trailer = movie
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMovieDetail", sender: self)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
         let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            let trailer = movies[indexPath.row]
            context.delete(trailer)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                movies = try context.fetch(Trailer.fetchRequest()) }
            catch {
                print("Error occured")
            
            }
        }
        tableView.reloadData()
        
    }

}















