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
}
