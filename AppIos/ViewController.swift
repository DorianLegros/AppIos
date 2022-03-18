//
//  ViewController.swift
//  AppIos
//
//  Created by user214997 on 3/15/22.
//

import UIKit

let apiKey = "aad3716237ce5a86c2a02e2a48f662c1";
let baseUrl = "https://api.themoviedb.org/3/";

class ViewController: UIViewController {
    
    @IBOutlet weak var showsTable:UITableView!
    
    var showsList: [Show] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showsTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        let url = URL(string: baseUrl + "tv/airing_today?api_key=" + apiKey + "&language=fr-FR")!;
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                  if let error = error {
                    return
                  }
                  guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
                  else {
                    debugPrint("Error with the response, unexpected status code: \(response)")
                    debugPrint("Error with the response, unexpected status code:" + response.debugDescription)
                    return
                  }
                  if let data = data {
                    let shows = try! JSONDecoder().decode(ShowResult.self, from: data)
                    DispatchQueue.main.async() {
                        self.showsList = shows.results!;
                        self.showsTable.reloadData();
                    }
                  } else {
                    return
                  }
        }).resume();
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
    }
}


extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showsList.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell;
        cell.onBind(data: showsList[indexPath.row])
        return cell;
    }
    
   func numberOfSections(in tableView: UITableView) -> Int {
          return 1
      }
    // gérer le click sur une cellule
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         var showDetailView : ShowDetailsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "showDetailView")
         showDetailView.showDetail = showsList[indexPath.row]
         present(showDetailView, animated: false, completion: nil)
         
     }
}

class ShowDetailsController : UIViewController{
    @IBOutlet weak var txtTitleDetail:UILabel!
    @IBOutlet weak var txtDescDetail:UILabel!
    @IBOutlet weak var showImageDetail:UIImageView!
    @IBOutlet weak var txtVoteAverageDetail:UILabel!
    @IBOutlet weak var txtFirstAirDateDetail:UILabel!
    @IBOutlet weak var txtOriginalCountryDetail:UILabel!
    
    var showDetail : Show?
    // quand la vue apparaît, après sa création
    override func viewDidLoad() {
        super.viewDidLoad();
        txtTitleDetail.text = showDetail!.name
        txtDescDetail.text = showDetail!.overview == "" ? "Synopsis indisponible" : showDetail!.overview;
        txtVoteAverageDetail.text = String(showDetail!.voteAverage!) + " / 10 "
        txtFirstAirDateDetail.text = showDetail!.firstAirDate
        txtOriginalCountryDetail.text = showDetail!.originalCountry![0]
        if showDetail!.posterPath != nil {
            URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://image.tmdb.org/t/p/w342/\(showDetail!.posterPath!)")!)) {
                (data, req, error) in
                
                do {
                    var datas = try data
                    DispatchQueue.main.async {
                        self.showImageDetail.image = UIImage(data: datas!);
                    }
                } catch {
                    
                }
            }.resume();
        }
    }
}

class TopController : UIViewController {
    
    @IBOutlet weak var label: UILabel!
}

class ShowSearchController : UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var showsSearchedList: [Show] = []
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self;
        //showsSearchedTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchActive = true;
        }

        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchActive = false;
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchActive = false;
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchActive = false;
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String?) {
            
            print("toto")
            print(searchText)
            if searchText == nil { return };
            //let url = URL(string: baseUrl + "search/tv?api_key=" + apiKey + "&language=fr-FR&page=1&query=" + searchText! + "&include_adult=false")!;
            let encodedSearchText = searchText!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
                        let url = URL(string: baseUrl + "search/tv?api_key=" + apiKey + "&language=fr-FR&page=1&query=" + encodedSearchText! + "&include_adult=false")!;
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                      if let error = error {
                        return
                      }
                      guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
                      else {
                        debugPrint("Error with the response, unexpected status code: \(response)")
                        debugPrint("Error with the response, unexpected status code:" + response.debugDescription)
                        return
                      }
                      if let data = data {
                        let shows = try! JSONDecoder().decode(ShowResult.self, from: data)
                        DispatchQueue.main.async() {
                            debugPrint(shows.results)
                            self.showsSearchedList = shows.results!;
                            self.tableView.reloadData();
                        }
                      } else {
                        return
                      }
            }).resume();
            
            if(showsSearchedList.count == 0){
                searchActive = false;
            } else {
                searchActive = true;
            }
            self.tableView.reloadData();
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return showsSearchedList.count;
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchedShowCell", for: indexPath) as! SearchedShowTableCell;
            cell.searchedShowTitle?.text = showsSearchedList[indexPath.row].name;
            cell.searchedShowDescription?.text = showsSearchedList[indexPath.row].overview == "" ? "Synopsis indisponible" : showsSearchedList[indexPath.row].overview;
            if showsSearchedList[indexPath.row].posterPath != nil {
                URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://image.tmdb.org/t/p/w342/\(showsSearchedList[indexPath.row].posterPath!)")!)) {
                    (data, req, error) in
                    
                    do {
                        var datas = try data
                        DispatchQueue.main.async {
                            cell.searchedShowImage.image = UIImage(data: datas!);
                        }
                    } catch {
                        
                    }
                }.resume();
            }
            return cell;
        }
        
        override func numberOfSections(in tableView: UITableView) -> Int {
              return 1
        }
    
        // gérer le click sur une cellule
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             var showDetailView : ShowDetailsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "showDetailView")
             showDetailView.showDetail = showsSearchedList[indexPath.row]
             present(showDetailView, animated: false, completion: nil)
             
     }
}

class SearchedShowTableCell : UITableViewCell {
    //@IBOutlet weak var searchedShowImage: UIImageView!
    @IBOutlet weak var searchedShowImage: UIImageView!
    //@IBOutlet weak var searchedShowTitle: UILabel!
    @IBOutlet weak var searchedShowTitle: UILabel!
    //@IBOutlet weak var searchedShowDescription: UILabel!feef
    @IBOutlet weak var searchedShowDescription: UILabel!
}

class TopShowController : UITableViewController {
    var showsTopShowList: [Show] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: baseUrl + "tv/top_rated?api_key=" + apiKey + "&language=fr-FR&page=1&")!;
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                  if let error = error {
                    return
                  }
                  guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
                  else {
                    debugPrint("Error with the response, unexpected status code: \(response)")
                    debugPrint("Error with the response, unexpected status code:" + response.debugDescription)
                    return
                  }
                  if let data = data {
                    let shows = try! JSONDecoder().decode(ShowResult.self, from: data)
                    DispatchQueue.main.async() {
                        debugPrint(shows.results)
                        self.showsTopShowList = shows.results!;
                        self.tableView.reloadData();
                    }
                  } else {
                    return
                  }
        }).resume();
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showsTopShowList.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topShowCell", for: indexPath) as! TopShowTableCell;
        cell.topShowTitle?.text = showsTopShowList[indexPath.row].name;
        cell.topShowDescription?.text = showsTopShowList[indexPath.row].overview == "" ? "Synopsis indisponible" : showsTopShowList[indexPath.row].overview;
        if showsTopShowList[indexPath.row].posterPath != nil {
            URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://image.tmdb.org/t/p/w342/\(showsTopShowList[indexPath.row].posterPath!)")!)) {
                (data, req, error) in
                
                do {
                    var datas = try data
                    DispatchQueue.main.async {
                        cell.topShowImage.image = UIImage(data: datas!);
                    }
                } catch {
                    
                }
            }.resume();
        }
        return cell;
    }
    // gérer le click sur une cellule
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         var showDetailView : ShowDetailsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "showDetailView")
         showDetailView.showDetail = showsTopShowList[indexPath.row]
         present(showDetailView, animated: false, completion: nil)
         
 }
}

class TopShowTableCell : UITableViewCell {
    //@IBOutlet weak var searchedShowImage: UIImageView!
    @IBOutlet weak var topShowImage: UIImageView!
    //@IBOutlet weak var searchedShowTitle: UILabel!
    @IBOutlet weak var topShowTitle: UILabel!
    //@IBOutlet weak var searchedShowDescription: UILabel!feef
    @IBOutlet weak var topShowDescription: UILabel!
}
