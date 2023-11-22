//
//  DashboardViewController.swift
//  BS23-iOS Task
//
//  Created by MAHFUJ on 23/11/23.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var movieSearchbar: UISearchBar!
    
    var results: [Movie] = []
    
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
        
        fetchTVShow(with: "flower")
    }
}


extension DashboardViewController { // API 
    private func fetchTVShow(with query: String) {
      //  SVProgressHUD.show()
        // https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1
        let urlString = "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1"
        
        APIManager.shared.callService(urlString: urlString, method: "GET", body: nil) { [weak self] data in
            DispatchQueue.main.async {
     //           SVProgressHUD.dismiss()
                
                guard let weakSelf = self else {
                    return
                }
                if let data = data {
                    do {
                        weakSelf.results  = try JSONDecoder().decode([Movie].self, from: data)
                        //                    weakSelf.results = [singleresule]
                        weakSelf.moviesTableView.reloadData()
                        print(weakSelf.results.count)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell", for: indexPath) as! ContentTableViewCell
      //  cell.setUI(tvshow: results[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailShowVC = DetailShowViewController.initVC(result: results[indexPath.row])
        self.navigationController?.pushViewController(detailShowVC, animated: true)
    }
}
