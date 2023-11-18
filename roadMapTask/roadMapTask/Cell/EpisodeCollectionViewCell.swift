//
//  EpisodeCollectionViewCell.swift
//  roadMapTask
//
//  Created by Kalandarov Vakil on 12.11.2023.
//

import Foundation
import UIKit


protocol EpisodeCollectionViewCellDelegate: AnyObject {
    func addFavourite(resultModel: Results?)
}

final class EpisodeCollectionViewCell: UICollectionViewCell{
    
    weak var delegate: EpisodeCollectionViewCellDelegate?
    
    var episodeModel: Episode?
    var resultModel: Results?
    private lazy var isFavourites = false
    var identefire = "My cell"
    private lazy var avatar: UIImageView = {
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private lazy var name: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        return $0
    }(UILabel())
    
    private lazy var episodeName: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 1
        $0.minimumScaleFactor = 0.5
        $0.adjustsFontSizeToFitWidth = true
        $0.sizeToFit()
        return $0
    }(UILabel())
    
    private lazy var informationBottomView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(named: "informationColorView")
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        return $0
    }(UIView())
    
    private lazy var monitorPlayIcon: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "MonitorPlay")
        return $0
    }(UIImageView())
    
    private lazy var isFavouritesItemButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "noFavourites"), for: .normal)
        $0.addTarget(self, action: #selector(addFavourites), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private var networkService = NetworkService.shared
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.layer.cornerRadius = 15
        contentView.addSubview(avatar)
        contentView.addSubview(name)
        contentView.addSubview(informationBottomView)
        informationBottomView.addSubview(episodeName)
        informationBottomView.addSubview(monitorPlayIcon)
        informationBottomView.addSubview(isFavouritesItemButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createCell(item: Results){
        self.backgroundColor = .white
        createAnchor()
        createShadowCell()
        getEpisode(item: item)
    }
    
    private func getEpisode(item: Results){
        networkService.getEpisode(http: item.characters.last ?? "") { result in
            switch result{
            case .success(let model):
                DispatchQueue.main.async {
                    self.avatar.downloaded(from: model.image)
                    self.name.text = model.name
                    self.episodeName.text = "\(item.name) | \(item.episode)"
                    self.episodeModel = model
                    self.resultModel = item
                    self.isFavourites = self.networkService.arrayFavorites.contains(where: { $0.id == self.resultModel?.id })
                    if self.isFavourites{
                        self.isFavouritesItemButton.setImage(UIImage(named: "isFavourites"), for: .normal)
                    } else {
                        self.isFavouritesItemButton.setImage(UIImage(named: "noFavourites"), for: .normal)
                    }
                }
            case.failure(_):
                print("Error")
            }
        }
    }
    
    private func createShadowCell() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        self.contentView.clipsToBounds = true
    }
    
    @objc private func addFavourites(){
        isFavourites.toggle()
        animate(isFavouritesItemButton)
        delegate?.addFavourite(resultModel: resultModel)
    }
    
    private func animate(_ button: UIButton) {
        UIView.animate(withDuration: 0.4, animations: {
            button.transform = CGAffineTransform.identity.translatedBy(x: 60, y: 0)
        }, completion: { (finish) in
            UIView.animate(withDuration: 0.4, animations: {
                button.transform = .identity
                self.isFavouritesItemButton.setImage(UIImage(named:self.isFavourites ? "isFavourites" : "noFavourites"), for: .normal)
            })
        })
    }
    
    private func createAnchor(){
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: self.topAnchor),
            avatar.heightAnchor.constraint(equalToConstant: self.bounds.height / 1.5),
            avatar.rightAnchor.constraint(equalTo: self.rightAnchor),
            avatar.leftAnchor.constraint(equalTo: self.leftAnchor),
            
            name.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 10),
            name.leftAnchor.constraint(equalTo: avatar.leftAnchor,constant: 10),
            
            informationBottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            informationBottomView.widthAnchor.constraint(equalToConstant: self.bounds.width),
            informationBottomView.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 12),
            
            monitorPlayIcon.centerYAnchor.constraint(equalTo: informationBottomView.centerYAnchor),
            monitorPlayIcon.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 22),
            monitorPlayIcon.widthAnchor.constraint(equalToConstant: 33),
            monitorPlayIcon.heightAnchor.constraint(equalToConstant: 33),
            
            isFavouritesItemButton.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -16),
            isFavouritesItemButton.centerYAnchor.constraint(equalTo: monitorPlayIcon.centerYAnchor),
            isFavouritesItemButton.widthAnchor.constraint(equalToConstant: 40),
            isFavouritesItemButton.heightAnchor.constraint(equalToConstant: 40),
            
            episodeName.leftAnchor.constraint(equalTo: monitorPlayIcon.rightAnchor,constant: 6),
            episodeName.centerYAnchor.constraint(equalTo: monitorPlayIcon.centerYAnchor),
            episodeName.rightAnchor.constraint(equalTo: isFavouritesItemButton.leftAnchor, constant: -7)
        ])
    }
}
