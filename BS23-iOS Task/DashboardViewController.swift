//
//  DashboardViewController.swift
//  BS23-iOS Task
//
//  Created by MAHFUJ on 23/11/23.
//

import UIKit
import SDWebImage

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var moviesTableView  : UITableView!
    @IBOutlet weak var searchbar        : UISearchBar!
    @IBOutlet weak var activityView     : UIActivityIndicatorView!
    
    var results: [Movie] = []
    private var isFetching: Bool = false
    private var currentPage = 1
    private var totalPages = 1
    
    
    class func initVC()->DashboardViewController {
        let board = UIStoryboard(name: "Main", bundle: nil)
        let vc = board.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesTableView.register(UINib(nibName: "ContentTableViewCell", bundle: nil), forCellReuseIdentifier: ContentTableViewCell.identifier)
        searchbar.delegate = self
        self.navigationItem.title = "Movie List"
        
        fetchMovies(starting: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    
    private func showLoader() {
        activityView.isHidden = false
        activityView.startAnimating()
    }
    
    
    private func hideLoader() {
        DispatchQueue.main.async {
            self.activityView.isHidden = true
            self.activityView.stopAnimating()
        }
    }
}

// MARK: - Searchbar
extension DashboardViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            fetchMovies(starting: true)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        clear()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        fetchMovies(starting: true)
        /*    if let text = searchBar.text, text.count > 0 {
         clear()
         fetchMovies(starting: true)
         }
         else {
         clear()
         } */
    }
    
    func clear() {
        results = []
        moviesTableView.reloadData()
    }
}


// MARK: - Tableview
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count //results.isEmpty ? 0 : (results.count + (currentPage < totalPages ? 1 : 0))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as! ContentTableViewCell
        cell.selectionStyle = .none
        cell.setUI(movie: results[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailShowVC = DetailShowViewController.initVC(result: results[indexPath.row])
        self.navigationController?.pushViewController(detailShowVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if currentPage <= totalPages && indexPath.row == results.count - 1 - 5 {
            print("fetch API")
            fetchMovies(starting: false)
        }
    }
}

// MARK: - API
extension DashboardViewController {
    private func fetchMovies(starting: Bool) {
        if starting {
            currentPage = 1
            showLoader()
            moviesTableView.setContentOffset(.zero, animated: true)
        }
        var query = ""
        if searchbar.text!.isEmpty {
            query = "Marvel"
        } else {
            query = searchbar.text!
        }
        
        APIManager.shared.fetchMovies(page: currentPage, queryString: query, method: .get, body: nil) { movies, total_page in
            self.hideLoader()
            if let movies = movies {
                DispatchQueue.main.async {
                    if starting {
                        self.results  = movies
                    } else {
                        self.results += movies
                    }
                    
                    self.currentPage += 1
                    self.totalPages = total_page ?? .max
                    self.moviesTableView.reloadData()
                    print("movies count: \(self.results.count)")
                }
            }
        }
    }
}
