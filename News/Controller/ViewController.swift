//
//  ViewController.swift
//  News
//
//  Created by Murat Sağlam on 6.11.2022.
//

// MARK: - API Link
// https://newsapi.org/v2/top-headlines?country=TR&apiKey=8549c57c277f4c19a4fadb8b1ff48c38

import UIKit
import SafariServices

class ViewController: UIViewController
{
    
    // MARK: - TableView Oluşturuldu
    private let tableView: UITableView =
    {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    // MARK: - Article Diziyi Oluşturarak Gelen Veriyi Diziye Ekledik.
    private var articles = [Article]()
    private var viewModels = [NewsTableViewCellModel]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "News"
        
        // MARK: - TableView Özellikleri
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        
        // MARK: - Delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        // MARK: - API Kontrol
        fetchTopStories()

    }

    //MARK: - API Görünümleri Denetlemek
    private func fetchTopStories()
    {
        APICaller.shared.getTopStroies
        {  [weak self] (result) in
            switch result
            {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap(
                    {
                        NewsTableViewCellModel(
                            title: $0.title,
                            subtitle: $0.description ?? "No Description",
                            imageURL: URL(string: $0.urlToImage ?? ""))
                    })
                
                DispatchQueue.main.async
                {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

    //MARK: TableView Protokoller
extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    //MARK: TableView Görünüm
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModels.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else
        {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else
        {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        
    }
    
    //MARK: Maximum 150 Haber Sıralanması
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150
    }
}


