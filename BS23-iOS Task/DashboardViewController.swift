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
    
    let apiKey = "b2fb874a21f88f43e69c6491a6f49e00"
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
        
        moviesTableView.register(UINib(nibName: "ContentTableViewCell", bundle: nil), forCellReuseIdentifier: "ContentTableViewCell")
        searchbar.delegate = self
        self.navigationItem.title = "Dashboard"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchMovies(starting: true)
    }
    
    private func showLoader() {
        activityView.isHidden = false
        activityView.startAnimating()
    }
    
    
    private func hideLoader() {
        activityView.isHidden = true
        activityView.stopAnimating()
    }
}

extension DashboardViewController: UISearchBarDelegate {
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
    
   /* func loadData(starting: Bool, query: String) {
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(searchbar.text!)&page=3"
        guard isFetching == false else { return }
        
        if starting {
            currentPage = 1
            showLoader()
            moviesTableView.setContentOffset(.zero, animated: true)
        }
        
        print("load-data \(currentPage)")
        
        isFetching = true
        
        APIManager.shared.callService(urlString: urlString, method: "GET", body: nil) { [weak self] data in
            if starting {
                self?.hideLoader()
            }
            guard let weakSelf = self else {
                return
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                    
                    if starting {
                        weakSelf.results  = movieResponse.movies ?? []
                    } else {
                        weakSelf.results += movieResponse.movies ?? []
                    }
                    DispatchQueue.main.async {
                        weakSelf.moviesTableView.reloadData()
                    }
                    print("movies count: \(weakSelf.results.count)")
                    self?.currentPage += 1
                    self?.totalPages = movieResponse.totalPages ?? .max
                }
                catch {
                    print(error)
                }
                print("task ok")
            } else {
                print("medicine is not available for page: \(self!.currentPage)")
            }
            self?.isFetching = false
        }
    } */
    
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
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(query)&page=\(currentPage)"
        APIManager.shared.callService(urlString: urlString, method: "GET", body: nil) { [weak self] data in
            DispatchQueue.main.async {
                self!.hideLoader()
                guard let weakSelf = self else {
                    return
                }
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                        
                        if starting {
                            weakSelf.results  = movieResponse.movies ?? []
                        } else {
                            weakSelf.results += movieResponse.movies ?? []
                        }
                        
                        self?.currentPage += 1
                        self?.totalPages = movieResponse.totalPages ?? .max
                        weakSelf.moviesTableView.reloadData()
                        print("movies count: \(weakSelf.results.count)")
                    }
                    catch {
                        print(error)
                    }
                    print("task ok")
                }
            }
        }
    }
}
