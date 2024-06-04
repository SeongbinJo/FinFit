//
//  CalendarPopUpViewController.swift
//  Saver
//
//  Created by 조성빈 on 6/5/24.
//

import UIKit

class CalendarPopUpViewController: UIViewController {
    private var backgroundView: UIView = UIView()
    private var yearLabel: UILabel = UILabel()
    private var monthCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        setupBackgroundView()
    }

    func setupBackgroundView() {
        backgroundView.backgroundColor = .green
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.text = "2024년"
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(yearLabel)
        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10),
            yearLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            
            backgroundView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.7),
            backgroundView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.3),
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
