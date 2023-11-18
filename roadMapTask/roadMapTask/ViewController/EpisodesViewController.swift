//
//  ViewController.swift
//  roadMapTask
//
//  Created by Kalandarov Vakil on 08.11.2023.
//

import UIKit

final class EpisodesViewController: UIViewController{
    
    //MARK: - properties
    private let flowLayout: UICollectionViewFlowLayout = {
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 357)
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 27
        return $0
    }(UICollectionViewFlowLayout())
    
    private lazy var episodeCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let searchController = UISearchController(searchResultsController: nil)
    private lazy var detailCharacters: [Results] = []
    private lazy  var filteredDetailCharacters: [Results] = []
    private var pagination: CharactersModel?
    private var networkService = NetworkService.shared
    private lazy var itemIndexArray = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "titleLaunchScreen"))
        createSearchBar()
        createCollectionView()
        getInfoCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.episodeCollection.reloadData()
    }
    
    
    private func getInfoCharacters(){
        networkService.getInfoCharacters(http: "https://rickandmortyapi.com/api/episode") { result in
            switch result{
            case .success(let model):
                DispatchQueue.main.async {
                    self.pagination = model
                    self.detailCharacters = model.results
                    self.episodeCollection.reloadData()
                }
            case.failure(_):
                print("Error")
            }
        }
    }
    
    private func createCollectionView(){
        self.episodeCollection = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        self.episodeCollection.delegate = self
        self.episodeCollection.dataSource = self
        self.episodeCollection.register(EpisodeCollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        self.episodeCollection.backgroundColor = .clear
        self.episodeCollection.keyboardDismissMode = .onDrag
        view.addSubview(episodeCollection)
    }
    
    private func createSearchBar() {
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        searchController.searchBar.layer.cornerRadius = 10
        searchController.searchBar.clipsToBounds = true
        searchController.searchBar.placeholder = "Name or episode (ex.S01E01)..."
    }
    
    private func filterCharacters(for searchText: String) {
        filteredDetailCharacters = detailCharacters.filter { item in
            return item.episode.lowercased().contains(searchText.lowercased())
        }
        self.episodeCollection.reloadData()
    }
    
    @objc private func handleGesture(){
        detailCharacters.remove(at: itemIndexArray)
        self.episodeCollection.reloadData()
    }
}

extension EpisodesViewController:  UICollectionViewDelegate,UICollectionViewDataSource,UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterCharacters(for: searchController.searchBar.text ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        cell.contentView.addGestureRecognizer(swipeLeft)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""{
            return filteredDetailCharacters.count
        }else{
            return detailCharacters.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? EpisodeCollectionViewCell {
            cell.delegate = self
            if searchController.isActive && searchController.searchBar.text != ""{
                cell.createCell(item: filteredDetailCharacters[indexPath.row])
            }else{
                cell.createCell(item: detailCharacters[indexPath.row])
            }
            if indexPath.row + 5 ==  detailCharacters.count{
                networkService.getInfoCharacters(http: pagination?.info.next ?? "") { result in
                    switch result{
                    case .success(let model):
                        DispatchQueue.main.async {
                            self.pagination = model
                            self.detailCharacters.append(contentsOf: model.results)
                            self.episodeCollection.reloadData()
                        }
                    case.failure(_):
                        self.showErrorAlert(text: "Error")
                    }
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        if searchController.searchBar.text != ""{
            detailVC.arrayUrl = filteredDetailCharacters[indexPath.row].characters
        }else{
            detailVC.arrayUrl = detailCharacters[indexPath.row].characters
        }
        self.navigationController?.pushViewController(detailVC, animated: false)
    }
}

extension EpisodesViewController: EpisodeCollectionViewCellDelegate {
    func addFavourite(resultModel: Results?) {
        guard let resultModel else { return }
        networkService.add(results: resultModel)
    }
}
