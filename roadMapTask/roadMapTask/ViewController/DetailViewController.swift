//
//  DetailViewController.swift
//  roadMapTask
//
//  Created by Kalandarov Vakil on 12.11.2023.
//

import Foundation
import UIKit
import AVFoundation

final class DetailViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var arrayUrl: [String] = []
    private lazy var arrayInfoTitle = ["Gender","Status","Specie","Origin","Type","Location"]
    private var modelEpisode: Episode?
    private lazy var imagePicker = UIImagePickerController()
    private lazy var networkService = NetworkService.shared
    private lazy var imageCache = ImageCache.shared
    private lazy var infoTableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(InformationTableView.self, forCellReuseIdentifier: InformationTableView().identefire)
        $0.dataSource = self
        $0.delegate = self
        return $0
    }(UITableView())
    
    private lazy var cameraIconButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "CameraIcon"), for: .normal)
        $0.addTarget(self, action: #selector(iconCameraButtonMethod), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var avatarImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 75
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        $0.layer.borderWidth = 5
        return $0
    }(UIImageView())
    
    private lazy var nameCharacters: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    private lazy var informationsLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.light)
        $0.textColor = .systemGray
        $0.text = "Informations"
        return $0
    }(UILabel())
    
    private lazy var navigationBarView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .red
        return $0
    }(UIView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetailInformation()
    }
    
    private func getDetailInformation(){
        NetworkService().getEpisode(http: arrayUrl.last ?? "") { result in
            switch result{
            case .success(let model):
                DispatchQueue.main.async {
                    self.avatarImageView.downloaded(from: model.image)
                    self.modelEpisode = model
                    self.createDetailVC()
                }
            case.failure(_):
                self.showErrorAlert(text: "Проверте подключение интернета")
            }
        }
    }
    
    private func createDetailVC(){
        view.backgroundColor = .white
        view.addSubview(avatarImageView)
        view.addSubview(nameCharacters)
        view.addSubview(informationsLabel)
        view.addSubview(infoTableView)
        view.addSubview(cameraIconButton)
        getInfoCharacters()
        createNavigatoinBar()
        createAnchor()
    }
    
    private func getInfoCharacters(){
        nameCharacters.text = modelEpisode?.name
    }
    
    private func createNavigatoinBar(){
        let backImage = UIImage(named: "backButton")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.backItem?.title = "GO BACK"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        let rirghtImage = UIButton(frame: CGRect(x: 0, y: 0, width: 47, height: 47))
        rirghtImage.setImage(UIImage(named: "logo-black"), for: .normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rirghtImage)
    }
    
    @objc private func iconCameraButtonMethod(){
        let alert = UIAlertController(title: "Заггрузите изображение", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func openGallary() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func createAnchor(){
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 124),
            avatarImageView.widthAnchor.constraint(equalToConstant: 150),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            
            cameraIconButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            cameraIconButton.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 10),
            cameraIconButton.widthAnchor.constraint(equalToConstant: 24),
            cameraIconButton.heightAnchor.constraint(equalToConstant: 24),
            
            nameCharacters.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 48),
            nameCharacters.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            
            informationsLabel.topAnchor.constraint(equalTo: nameCharacters.bottomAnchor, constant: 18),
            informationsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            infoTableView.topAnchor.constraint(equalTo: informationsLabel.bottomAnchor, constant: 16),
            infoTableView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor),
            infoTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayInfoTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableView().identefire, for: indexPath) as? InformationTableView{
            guard let modelEpisode = modelEpisode else {return cell}
            var modelRawValue = "Unknown"
            switch indexPath.row {
            case 0 :
                modelRawValue = modelEpisode.gender
            case 1:
                modelRawValue = modelEpisode.status
            case 2:
                modelRawValue = modelEpisode.species
            case 3:
                modelRawValue = modelEpisode.origin.name
            case 4:
                modelRawValue = modelEpisode.type
            case 5:
                modelRawValue = modelEpisode.location.name
            default:
                return cell
            }
            cell.createCell(titleLabel: arrayInfoTitle[indexPath.row], item: modelRawValue)
            return cell
        }
        return UITableViewCell()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            avatarImageView.image = photo
            avatarImageView.contentMode = .scaleAspectFit
            imageCache.push(image: photo, key: NSString(string: modelEpisode?.image ?? ""))
            dismiss(animated: true, completion: nil)
        }
    }
}
