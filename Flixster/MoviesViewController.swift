//
//  MoviesViewController.swift
//  Flixster
//
//  Created by loan on 9/24/20.
//  Copyright © 2020 naomia2022@hotmail.com. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //want view controller to work with the table view
    
    // properties for screen
    @IBOutlet weak var tableView: UITableView! //access table view
    
    //STEP 2
    var movies = [[String:Any]]() // [] array declaration --> [String:Any] to indicate dict, () --> creating new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //STEP 4
        tableView.dataSource = self
        tableView.delegate = self
        
        //STEP 1
        // downloads list of movie data
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
              print(dataDictionary)
              // TODO: Get the array of movies --> download is complete
              self.movies = dataDictionary["results"] as! [[String:Any]] //results is a list of dicts --> casted as a dict, results key from dict where the value is a list of dicts
            
            self.tableView.reloadData() //.reloadData --> call the tableView functions again

           }
        }
        task.resume()
        // Do any additional setup after loading the view.
    }
    
    //STEP 3: adding both funcs
    // in order to work with the tableView, we need these two funcs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    //this func is called movies.count times --> per cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // for particular row, get cell
        //dequeue resuable cells --. hey if another cell is off screen, give recycled cell --> if no recycled cell, create new one
        
        //can access MovieCell controller file/class where we have our outlets
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row] //1st movie, 2nd... nth
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel!.text = title // \() allows you to embed a variable
        cell.synopsisLabel.text = synopsis
        
        //gettiing photo URL from the API
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL + posterPath) //URL class validates that it is a valid URL instead of an artbitrary string
        
        cell.posterView.af_setImage(withURL: posterURL!)
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
