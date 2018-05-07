//
//  CustomViewController.swift
//  MovieRoulette2
//
//  Created by Marta Krawiec on 4/12/17.
//  Copyright © 2017 Marta Krawiec. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {

    
    @IBOutlet weak var advBtn: UIButton!
    @IBOutlet weak var horrorBtn: UIButton!
    @IBOutlet weak var goBtn: ButtonBounce!
    @IBOutlet weak var comedyBtn: UIButton!
    @IBOutlet weak var thrillerBtn: UIButton!
    @IBOutlet weak var dramaBtn: UIButton!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var onlyHighestRated: UISwitch!
    var genre = Int()
    var moviesD = [[String: String]]()
    var buttonsArray = [UIButton]()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        goBtn.isEnabled = false
        buttonsArray += [comedyBtn, thrillerBtn, dramaBtn, actionBtn, advBtn, horrorBtn]
        for button in buttonsArray {
            
            button.addTarget(self, action: #selector(selectButton(sender:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(getBtnValue(sender:)), for: .touchUpInside)

        }

        comedyBtn.tag = 35
        actionBtn.tag = 28
        dramaBtn.tag = 18
        thrillerBtn.tag = 53
        advBtn.tag = 12
        horrorBtn.tag = 27
    }
    
    
  
    //https://api.themoviedb.org/3/discover/movie?api_key=<<api_key>>&language=en-US&include_adult=false&include_video=false&page=1&with_genres=5
    
    
       
    func selectButton(sender: UIButton!) {
        sender.isSelected = true
        goBtn.isEnabled = true
        sender.setBackgroundImage(UIImage(named: "selectedBtn") , for: .selected)
        for button in buttonsArray {
            if button.tag != sender.tag {
                button.isSelected = false
            }
        }
    }
    
    func getBtnValue(sender: UIButton) {
        if sender.isSelected {
            genre = sender.tag
        }
    
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(genre)
        if segue.identifier == "movieListSegue" {
                let vc = segue.destination as! MovieListViewController
                vc.genre = genre
            if onlyHighestRated.isOn {
                vc.filter = "&vote_average.gte=6.2"
            }
            else {
                vc.filter = ""
            
            }
            }
        }
    
    
    
    @IBAction func goTapped(_ sender: Any) {

            performSegue(withIdentifier: "movieListSegue", sender: self)
   
    }
    
    

}
