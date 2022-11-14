//
//  NewsTableViewCell.swift
//  News
//
//  Created by Murat Sağlam on 6.11.2022.
//

import UIKit

class NewsTableViewCellModel
{
    let title : String
    let subtitle : String
    let imageURL: URL?
    var imageData : Data? = nil
    
    init
    (
        title : String,
        subtitle : String,
        imageURL: URL?
    )
    {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        
    }
}

class NewsTableViewCell: UITableViewCell
{
    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLable : UILabel =
    {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 25, weight: .medium)
        return label
    }()
    
    private let subtitleLabel : UILabel =
    {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let newsImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLable)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsImageView)
    }

    required init?(coder: NSCoder)
    {
        fatalError()
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        newsTitleLable.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width - 170, height: 70)
        subtitleLabel.frame = CGRect(x: 10, y: 70, width: contentView.frame.size.width - 170, height: contentView.frame.size.height/2)
        newsImageView.frame = CGRect(x: contentView.frame.size.width-150, y: 5, width: 140, height: contentView.frame.size.height - 10)

    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        newsTitleLable.text = nil
        subtitleLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewModel : NewsTableViewCellModel)
    {
        newsTitleLable.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        
        //Image
        if let data = viewModel.imageData
        {
            newsImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL
        {
            URLSession.shared.dataTask(with: url)
            {   [weak self] data, _, error in
                guard let data = data, error == nil else
                {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async
                {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
}
