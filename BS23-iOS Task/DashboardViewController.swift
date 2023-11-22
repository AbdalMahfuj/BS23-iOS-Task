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
    @IBOutlet weak var movieSearchbar   : UISearchBar!
    @IBOutlet weak var activityView     : UIActivityIndicatorView!
    
    let apiKey = "b2fb874a21f88f43e69c6491a6f49e00"
    var results: [Movie] = []
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
        movieSearchbar.delegate = self
        self.navigationItem.title = "Dashboard"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchTVShow(with: "marvel")
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


extension DashboardViewController { // API 
    private func fetchTVShow(with query: String) {
        showLoader()
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(query)"
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
                        self?.totalPages = movieResponse.totalPages ?? .max
                        weakSelf.results  = movieResponse.movies ?? []
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

extension DashboardViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        clear()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        if let text = searchBar.text, text.count > 0 {
            clear()
            fetchTVShow(with: text)
        }
        else {
            clear()
        }
    }
    
    func clear() {
        results = []
        moviesTableView.reloadData()
    }
}


extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
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
        if currentPage <= totalPages && indexPath.row == results.count - 1 - 8 {
            print("fetch API")
            loadData(starting: false)
        }
    }
}
