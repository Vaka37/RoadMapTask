//
//  InformationTableView.swift
//  roadMapTask
//
//  Created by Kalandarov Vakil on 15.11.2023.
//

import Foundation
import UIKit

final class InformationTableView: UITableViewCell{
    
    let identefire = "InfoCell"
    
    private lazy var titleCell: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        return $0
    }(UILabel())
    
    private lazy var infoLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.thin)
        return $0
    }(UILabel())
    
    func createCell(titleLabel:String,item: String){
        self.selectionStyle = .none
        contentView.addSubview(titleCell)
        contentView.addSubview(infoLabel)
        titleCell.text = titleLabel
        infoLabel.text = item
        createAnchor()
    }
    
    private func createAnchor(){
        NSLayoutConstraint.activate([
            titleCell.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,constant: 9),
            titleCell.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            
            infoLabel.topAnchor.constraint(equalTo: self.titleCell.bottomAnchor),
            infoLabel.leftAnchor.constraint(equalTo: self.titleCell.leftAnchor)
        ])
    }
}
