//
//  DetailCategoryTransactionAmoutViewController.swift
//  Saver
//
//  Created by 이상민 on 6/10/24.
//

import UIKit

class DetailCategoryTransactionAmoutViewController: UIViewController{
    
    //MARK: - property
    let saverEntries: [SaverModel]
    
    //MARK: - 카태고리 날짜별 데이터 테이블
    private lazy var categoryListTableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.register(CategoryListDetailTableCellTableViewCell.self, forCellReuseIdentifier: "categoryCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(saverEntries: [SaverModel]) {
        self.saverEntries = saverEntries
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
        
    }
    
    func setup(){
        
        view.addSubview(categoryListTableView)

        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            categoryListTableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            categoryListTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            categoryListTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            categoryListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailCategoryTransactionAmoutViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        saverEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryListTableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryListDetailTableCellTableViewCell
        cell.configureCell(entry: saverEntries[indexPath.row])
        return cell
    }
}
