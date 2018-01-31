//
//  ViewController.swift
//  newsReaderApp
//
//  Created by Mohamed on 12/18/17.
//  Copyright © 2017 Mohamed. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var articles: [Article]? = []
    var source = "techcrunch"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArticles(fromSource: source)
        
    }
    
    func fetchArticles(fromSource provider: String){
        
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v2/top-headlines?sources=\(provider)&apiKey=b5fa9d00f400429db7ff35c60922f32e")!)
        let task = URLSession.shared.dataTask(with: urlRequest){  (data,response,error) in
            if error != nil
            {
                print(error)
                return
            }
            
            self.articles = [Article]()
            do{
                let json = try JSONSerialization.jsonObject(with: data! , options: .mutableContainers) as! [String:AnyObject]
                
                if   let articlesfromjson = json["articles"] as? [[String:AnyObject]] {
                    
                    for articleFromJson in articlesfromjson {
                        let article = Article()
                        if let title = articleFromJson["title"] as? String , let author = articleFromJson["author"] as? String , let desc = articleFromJson["description"] as? String , let url = articleFromJson["url"] as? String , let imgToUrl = articleFromJson["urlToImage"] as? String {
                            
                            article.author = author
                            article.desc = desc
                            article.headline = title
                            article.url = url
                            article.imgUrl = imgToUrl
                            
                        }
                        self.articles?.append(article)
                        
                    }
                }
                DispatchQueue.main.sync {
                    self.tableView.reloadData()

                }

            }catch let error {
                print(error)
            }
            
            
        }
        
        task.resume()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "web") as! webViewViewController
        
        webVC.url = self.articles?[indexPath.item].url
        
        self.present(webVC, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        cell.title.text = self.articles?[indexPath.item].headline
        cell.desc.text = self.articles?[indexPath.item].desc
        cell.author.text = self.articles?[indexPath.item].author
        cell.imgView.downloadImage(from: (self.articles?[indexPath.item].imgUrl!)!)
        
        return cell
    }
    
    let menuManager = MenuManager()
    @IBAction func menuPressed(_ sender: Any) {
        
        menuManager.openMenu()
        menuManager.mainVC = self
    }
    

}

extension UIImageView{
    
    func downloadImage(from url: String)
    {
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil{
                print(error)
                return
            }
            
            DispatchQueue.main.sync {
                self.image = UIImage(data: data!)
            }
            
        }
        task.resume()
        
    }
}

















