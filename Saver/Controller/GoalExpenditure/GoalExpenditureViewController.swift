//
//  GoalExpenditureViewController.swift
//  Saver
//
//  Created by 조성빈 on 6/26/24.
//

import UIKit

class GoalExpenditureViewController: UIViewController {
    
    private var scrollView: UIScrollView = UIScrollView()
    
    private var viewInScrollView: UIStackView = UIStackView()
    
    private var segmentButton: UISegmentedControl = UISegmentedControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        setupSegmentButton()
    }
    
    func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        viewInScrollView.axis = .vertical
        viewInScrollView.alignment = .center
        viewInScrollView.distribution = .fillEqually
        viewInScrollView.backgroundColor = .green
        viewInScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(viewInScrollView)
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            viewInScrollView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            viewInScrollView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            viewInScrollView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            viewInScrollView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            viewInScrollView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupSegmentButton() {
        segmentButton = UISegmentedControl(items: ["지출 목표", "고정 지출"])
        segmentButton.selectedSegmentIndex = 0 // '지출 목표'로 초기화
        segmentButton.addAction(UIAction { [weak self] _ in
            print(self?.segmentButton.selectedSegmentIndex)
        }, for: .valueChanged)
        segmentButton.translatesAutoresizingMaskIntoConstraints = false
        
        viewInScrollView.addSubview(segmentButton)
        
        NSLayoutConstraint.activate([
            segmentButton.topAnchor.constraint(equalTo: viewInScrollView.topAnchor),
            segmentButton.leadingAnchor.constraint(equalTo: viewInScrollView.leadingAnchor, constant: 24),
            segmentButton.trailingAnchor.constraint(equalTo: viewInScrollView.trailingAnchor, constant: -24),
        ])
    }
    
}
