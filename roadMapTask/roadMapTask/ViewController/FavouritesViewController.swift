//
//  FavouritesViewController.swift
//  roadMapTask
//
//  Created by Kalandarov Vakil on 09.11.2023.
//

import Foundation
import UIKit


class FavouritesViewController: UIViewController{
    //MARK: - properties
    private let flowLayout: UICollectionViewFlowLayout = {
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 357)
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 27
        return $0
    }(UICollectionViewFlowLayout())
    
    var favouritesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    var detailCharacters: [Results] = []
    private var networkService = NetworkService.shared
    private lazy var itemIndexArray = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBar()
        createCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailCharacters = networkService.arrayFavorites
        favouritesCollectionView.reloadData()
        createSearchBar()
    }
    
    private func createCollectionView(){
        self.favouritesCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        self.favouritesCollectionView.delegate = self
        self.favouritesCollectionView.dataSource = self
        self.favouritesCollectionView.register(EpisodeCollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        self.favouritesCollectionView.backgroundColor = .clear
        self.favouritesCollectionView.keyboardDismissMode = .onDrag
        view.addSubview(favouritesCollectionView)
    }
    
    private func createSearchBar() {
        navigationItem.title = "Favourites episodes"
    }
}

extension FavouritesViewController:  UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailCharacters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? EpisodeCollectionViewCell {
            cell.delegate = self
            cell.createCell(item: detailCharacters[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.arrayUrl = detailCharacters[indexPath.row].characters
        self.navigationController?.pushViewController(detailVC, animated: false)
    }
}

extension FavouritesViewController: EpisodeCollectionViewCellDelegate {
    func addFavourite(resultModel: Results?) {
        guard let resultModel else { return }
        networkService.add(results: resultModel)
    }
}
