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
    
    private var viewModel     : MovieViewModel!
    
    
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
        
        initiate()
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
        activityView.isHidden = true
        activityView.stopAnimating()
    }
    
    private func initiate(){
        viewModel = MovieViewModel()
        
        viewModel.onFetchStart = {
            if self.viewModel.starting {
                self.showLoader()
                self.moviesTableView.setContentOffset(.zero, animated: true)
            }
        }
        
        viewModel.onFetchDone = {
            self.hideLoader()
            self.moviesTableView.reloadData()
        }
        
        viewModel.fetchMovies(starting: true)
    }
}

// MARK: - Searchbar
extension DashboardViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            viewModel.fetchMovies(starting: true)
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.fetchMovies(starting: true, query: searchBar.text!)
    }
    
}


// MARK: - Tableview

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as! ContentTableViewCell
        cell.selectionStyle = .none
        cell.setUI(movie: viewModel.movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailShowVC = DetailShowViewController.initVC(movie: viewModel.movies[indexPath.row])
        self.navigationController?.pushViewController(detailShowVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.currentPage <= viewModel.totalPages && indexPath.row == viewModel.movies.count - 1 - 5 {
            viewModel.fetchMovies(starting: false, query: searchbar.text!)
        }
    }
}

