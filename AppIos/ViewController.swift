//
//  ViewController.swift
//  AppIos
//
//  Created by user214997 on 3/15/22.
//

import UIKit

class ViewController: UIViewController {
    
    let apiKey = "aad3716237ce5a86c2a02e2a48f662c1";
    let baseUrl = "https://api.themoviedb.org/3/tv/";
    
    @IBOutlet weak var showsTable:UITableView!
    
    var showsList: [Show] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showsTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        let url = URL(string: baseUrl + "airing_today?api_key=" + apiKey + "&language=fr-FR")!;
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
                        self.showsList = shows.results;
                        self.showsTable.reloadData();
                    }
                  } else {
                    return
                  }
        }).resume();
    }
}


extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint(showsList.count)
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
        txtDescDetail.text = showDetail!.overview == "" ? "Synopsis pas disponible" : showDetail!.overview;
        txtVoteAverageDetail.text = String(showDetail!.voteAverage) + " / 10 "
        txtFirstAirDateDetail.text = showDetail!.firstAirDate
        txtOriginalCountryDetail.text = showDetail!.originalCountry[0]
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://image.tmdb.org/t/p/w342/\(showDetail!.posterPath)")!)) {
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

