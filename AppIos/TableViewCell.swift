//
//  TableViewCell.swift
//  AppIos
//
//  Created by user214997 on 3/16/22.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var txtTitle:UILabel!
    @IBOutlet weak var txtDesc:UILabel!
    @IBOutlet weak var showImage:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func onBind(data: Show) {
        txtTitle.text = data.name;
        txtDesc.text = data.overview == "" ? "No description." : data.overview;
        if data.posterPath != nil {
            URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://image.tmdb.org/t/p/w342/\(data.posterPath!)")!)) {
                (data, req, error) in
                
                do {
                    var datas = try data
                    DispatchQueue.main.async {
                        self.showImage.image = UIImage(data: datas!);
                    }
                } catch {
                    
                }
            }.resume();
        }
    }
}
