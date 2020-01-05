//
//  TableView.swift
//  MemeMe-v1
//
//  Created by Work  on 10/12/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
}

class SentMemesTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {

//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    memes = appDelegate.memes
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
     var titles: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource =  self
        tableView.delegate = self
        tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    //    let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! TableViewCell
        let meme = self.memes[indexPath.row]
    
        cell.cellTitle.text = meme.topText + "..." + meme.bottomText
        cell.cellImage.image =  meme.memedImage
        
            return cell
        
    }



}
