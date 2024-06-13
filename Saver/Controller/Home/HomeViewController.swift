import UIKit

class HomeViewController: UIViewController {
    // 날짜 관련
    private var dateFormatter: DateFormatter = DateFormatter()
    private var calendar: Calendar = Calendar.current
    
    // 스크롤 뷰
    private var scrollView: UIScrollView = UIScrollView()
    
    // 최상단 HStackView
    private var monthTotalAmountLabel: UILabel = UILabel()
    private var currentSpendingAmountLabel: UILabel = UILabel()
    private var addTransactionButton: UIButton = UIButton(type: .system)
    private var titleHStackView: UIStackView = UIStackView()
    
    // 달력의 년/월 선택 버튼
    private var yearMonthButtonLabel: UILabel = UILabel()
    private var changeMonthButton: UIButton = UIButton(type: .system)
    
    // <, >, today 버튼
    private var prevMonthButton: UIButton = UIButton(type: .system)
    private var nextMonthButton: UIButton = UIButton(type: .system)
    private var todayButton: UIButton = UIButton(type: .system)
    private var prevNextButtonStackView: UIStackView = UIStackView()
    
    // 달력 뷰를 위 아래로 감싸는 선
    private var topLineView: UIView = UIView()
    private var bottomLineView: UIView = UIView()
    
    // 달력 관련 뷰
    private var weekDayOfStackView: UIStackView = UIStackView()
    private var calendarCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var calendarCollectionViewHeightConstraint: NSLayoutConstraint!
    private var todayString: String = ""
    private var isToday: Bool = false
    private var selectedIndexPath: IndexPath?
    private var calendarView: UIView = UIView()
    
    // 콜렉션 뷰의 날짜 클릭했을 때 저장되는 변수
    private var selectedDate: Date?
    
    // 달력 아래의 테이블 뷰 관련
    private var currentDayTitle: UILabel = UILabel()
    private var currentDayAmount: UILabel = UILabel()
    private var transactionTableView: UITableView = UITableView(frame: .zero, style: .plain)
    private var transactionTableViewHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .saverBackground
        // 앱 실행 후 데이터 fetch
        ShareData.shared.loadSaverEntries()
        // 앱 실행 후 오늘 날짜의 테이블 뷰 리스트 가져오기위함
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        ShareData.shared.getYearMonthTransactionData(year: todayComponents.year!, month: todayComponents.month!)
        
        dateFormatter.dateFormat = "yyyy년 M월"
        todayString = dateFormatter.string(from: Date())
        
        CalendarManager.manager.configureCalendar(date: Date())
        CalendarManager.manager.updateDays()
        CalendarManager.manager.updateYearMonthLabel(label: self.yearMonthButtonLabel)
        self.totalAmountCurrentMonth()
        checkToday()

        setupTitleHStackView()
        setupScrollView()
        setupchangeMonthButton()
        setupWeekDayOfStackView()
        setupCalendarView()
        setupPrevNextMonthStackView()
        setupTransactionTableView()
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 레이아웃이 완료된 후 높이 업데이트
        updateCollectionViewHeight()
        updateTableViewHeight()
    }
    
    func checkToday() {
        if self.yearMonthButtonLabel.text == self.todayString {
            self.isToday = true
        }else {
            self.isToday = false
        }
    }
    
    //MARK: - View 관련 Setup
    //MARK: - 스크롤 뷰
    func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleHStackView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    //MARK: - 소비금액 타이틀 & 내역추가 버튼
    func setupTitleHStackView() {
        currentSpendingAmountLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        currentSpendingAmountLabel.numberOfLines = 0
        currentSpendingAmountLabel.textColor = .white
        currentSpendingAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 0, bottom: 0, trailing: 0)
        config.imagePlacement = .trailing
        config.imagePadding = 5
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        config.attributedTitle = AttributedString("내역추가", attributes: container)
        addTransactionButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        addTransactionButton.configuration?.imagePlacement = .trailing
        addTransactionButton.tintColor = .white
        addTransactionButton.configuration = config
        addTransactionButton.addAction(UIAction {_ in
            print("내역추가 버튼 클릭. (현재 테이블 뷰. 셀 관련 액션 테스트 중")
            let addAmountViewController = AddAmountViewController()
            addAmountViewController.delegate = self
            self.navigationController?.pushViewController(addAmountViewController, animated: true)

            self.totalAmountCurrentMonth() // 내역 삭제할 때마다 월별 합계금액 타이틀 변경
            self.updateTableViewHeight()
            self.transactionTableView.reloadData()
            self.calendarCollectionView.reloadData()
        }, for: .touchUpInside)
        addTransactionButton.setContentHuggingPriority(.required, for: .horizontal)

        addTransactionButton.translatesAutoresizingMaskIntoConstraints = false

        titleHStackView.axis = .horizontal
        titleHStackView.distribution = .fill
        titleHStackView.alignment = .top
        titleHStackView.addArrangedSubview(currentSpendingAmountLabel)
        titleHStackView.addArrangedSubview(addTransactionButton)
        titleHStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleHStackView)
        
        NSLayoutConstraint.activate([
            titleHStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleHStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleHStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    //MARK: - ChangeMonthButton의 configuration
    func ConfigurationChangeMonthButton() {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.imagePlacement = .trailing
        config.imagePadding = 5
        
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 22, weight: .light)
        config.attributedTitle = AttributedString(yearMonthButtonLabel.text ?? "정보없음", attributes: container)
        
        changeMonthButton.setImage(UIImage(systemName: "calendar"), for: .normal)
        changeMonthButton.tintColor = .neutral20
        changeMonthButton.configuration = config
    }
    
    //MARK: - changeMonthButton setup
    func setupchangeMonthButton() {
        ConfigurationChangeMonthButton()
        
        changeMonthButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            let calendarPopUpViewController = CalendarPopUpViewController(nibName: nil, bundle: nil)
            calendarPopUpViewController.delegate = self
            calendarPopUpViewController.modalPresentationStyle = .overFullScreen
            present(calendarPopUpViewController, animated: false)
        }, for: .touchUpInside)
        
        changeMonthButton.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(changeMonthButton)
        
        NSLayoutConstraint.activate([
            changeMonthButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            changeMonthButton.leadingAnchor.constraint(equalTo: titleHStackView.leadingAnchor),
        ])
    }
    
    //MARK: - PrevMonthButton/NextMonthButton StackView setup
    func setupPrevNextMonthStackView() {
        prevMonthButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        prevMonthButton.addAction(UIAction { _ in
            CalendarManager.manager.prevMonth()
            
            let prevMonthComponents = self.calendar.dateComponents([.year, .month], from: CalendarManager.manager.calendarDate)
            ShareData.shared.getYearMonthTransactionData(year: prevMonthComponents.year!, month: prevMonthComponents.month!)
            self.changeCalendarMethod(date: CalendarManager.manager.calendarDate)
        }, for: .touchUpInside)
        nextMonthButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        nextMonthButton.addAction(UIAction { _ in
            CalendarManager.manager.nextMonth()
            let nextMonthComponents = self.calendar.dateComponents([.year, .month], from: CalendarManager.manager.calendarDate)
            ShareData.shared.getYearMonthTransactionData(year: nextMonthComponents.year!, month: nextMonthComponents.month!)
            self.changeCalendarMethod(date: CalendarManager.manager.calendarDate)
        }, for: .touchUpInside)
        todayButton.setTitle("Today", for: .normal)
        todayButton.addAction(UIAction { _ in
            self.changeCalendarMethod(date: Date())
            self.changeCurrentDayTitleByTodayButton()
            let todayComponents = self.calendar.dateComponents([.year, .month, .day], from: Date())
            ShareData.shared.getYearMonthTransactionData(year: todayComponents.year!, month: todayComponents.month!)
            self.changeCalendarMethod(date: CalendarManager.manager.calendarDate)
            self.currentDayAmount.text = "\(ShareData.shared.totalAmountIndDay(day: todayComponents.day!)) 원"
        }, for: .touchUpInside)
        
        prevNextButtonStackView.axis = .horizontal
        prevNextButtonStackView.alignment = .center
        prevNextButtonStackView.spacing = 20
        prevNextButtonStackView.tintColor = .neutral20
        
        prevNextButtonStackView.addArrangedSubview(prevMonthButton)
        prevNextButtonStackView.addArrangedSubview(todayButton)
        prevNextButtonStackView.addArrangedSubview(nextMonthButton)
        
        prevNextButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(prevNextButtonStackView)
        
        NSLayoutConstraint.activate([
            prevNextButtonStackView.topAnchor.constraint(equalTo: changeMonthButton.topAnchor),
            prevNextButtonStackView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor)
        ])
    }
    
    
    //MARK: - 일~토 요일 스택뷰
    func setupWeekDayOfStackView() {
        topLineView.backgroundColor = .neutral20
        topLineView.translatesAutoresizingMaskIntoConstraints = false
        
        weekDayOfStackView.axis = .horizontal
        weekDayOfStackView.distribution = .fillEqually
        weekDayOfStackView.alignment = .center

        
        let weekOfDay: [String] = ["일", "월", "화", "수", "목", "금", "토"]
        
        for day in weekOfDay {
            let weekLabel: UILabel = UILabel()
            weekLabel.text = day
            weekLabel.textAlignment = .center
            switch day {
            case "일":
                weekLabel.textColor = .spendingAmount
            case "토":
                weekLabel.textColor = .primaryBlue80
            default:
                weekLabel.textColor = .neutral20
            }
            
            weekDayOfStackView.addArrangedSubview(weekLabel)
        }
        
        weekDayOfStackView.tintColor = .neutral20
        
        weekDayOfStackView.translatesAutoresizingMaskIntoConstraints = false
        
        calendarView.addSubview(topLineView)
        calendarView.addSubview(weekDayOfStackView)
        
        NSLayoutConstraint.activate([
            topLineView.topAnchor.constraint(equalTo: calendarView.topAnchor),
            topLineView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            topLineView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: 0.5),
            
            weekDayOfStackView.topAnchor.constraint(equalTo: topLineView.bottomAnchor, constant: 10),
            weekDayOfStackView.leadingAnchor.constraint(equalTo: topLineView.leadingAnchor),
            weekDayOfStackView.trailingAnchor.constraint(equalTo: topLineView.trailingAnchor)
        ])
    }
    

    
    //MARK: - 캘린더 뷰 setup
    func setupCalendarView() {
        // 달력 콜렉션 뷰
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        calendarCollectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "CalendarCell")
        calendarCollectionView.backgroundColor = .clear
        calendarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.addSubview(calendarCollectionView)
        
        // 달력 아래 라인
        bottomLineView.backgroundColor = .neutral20
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.addSubview(bottomLineView)
        
        
        NSLayoutConstraint.activate([
            calendarCollectionView.topAnchor.constraint(equalTo: weekDayOfStackView.bottomAnchor, constant: 5),
            calendarCollectionView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            calendarCollectionView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            
            bottomLineView.topAnchor.constraint(equalTo: calendarCollectionView.bottomAnchor),
            bottomLineView.leadingAnchor.constraint(equalTo: calendarCollectionView.leadingAnchor),
            bottomLineView.trailingAnchor.constraint(equalTo: calendarCollectionView.trailingAnchor),
            bottomLineView.bottomAnchor.constraint(equalTo: calendarView.bottomAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        calendarCollectionViewHeightConstraint = calendarCollectionView.heightAnchor.constraint(equalToConstant: 0)
        calendarCollectionViewHeightConstraint.isActive = true
        
        scrollView.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: changeMonthButton.bottomAnchor, constant: 15),
            calendarView.leadingAnchor.constraint(equalTo: titleHStackView.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: titleHStackView.trailingAnchor),
        ])

    }
    
    //MARK: - 콜렉션 뷰 동적 높이 조절
    func updateCollectionViewHeight() {
        let numberOfItems = calendarCollectionView.numberOfItems(inSection: 0)
        let rows = ceil(Double(numberOfItems) / 7.0)
        let cellHeight = self.calendarView.frame.width / 7
        let newHeight = (CGFloat(rows) * cellHeight) + ((rows - 1) * 11)
        
        calendarCollectionViewHeightConstraint.constant = newHeight
    }
    
    //MARK: - 날짜별 Transaction 테이블 뷰
    func setupTransactionTableView() {
        self.dateFormatter.dateFormat = "M월 d일 E요일"
        self.dateFormatter.locale = Locale(identifier: "ko-KR")
        currentDayTitle.text = self.dateFormatter.string(from: Date())
        currentDayTitle.textColor = .neutral20
        currentDayTitle.translatesAutoresizingMaskIntoConstraints = false
        
        let todayComponents = self.calendar.dateComponents([.day], from: Date())
        currentDayAmount.text = "\(ShareData.shared.totalAmountIndDay(day: todayComponents.day!)) 원"
        currentDayAmount.textColor = .neutral20
        currentDayAmount.font = UIFont.systemFont(ofSize: 25)
        currentDayAmount.translatesAutoresizingMaskIntoConstraints = false
        
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        transactionTableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionCell")
        transactionTableView.backgroundColor = .clear
        transactionTableView.showsVerticalScrollIndicator = false
        transactionTableView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(currentDayTitle)
        scrollView.addSubview(currentDayAmount)
        scrollView.addSubview(transactionTableView)
        
        NSLayoutConstraint.activate([
            currentDayTitle.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 15),
            currentDayTitle.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            
            currentDayAmount.topAnchor.constraint(equalTo: currentDayTitle.bottomAnchor, constant: 5),
            currentDayAmount.leadingAnchor.constraint(equalTo: currentDayTitle.leadingAnchor),
            
            transactionTableView.topAnchor.constraint(equalTo: currentDayAmount.bottomAnchor, constant: 10),
            transactionTableView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            transactionTableView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
//            transactionTableView.heightAnchor.constraint(equalToConstant: 100),
            transactionTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        transactionTableViewHeightConstraint = transactionTableView.heightAnchor.constraint(equalToConstant: 0)
        transactionTableViewHeightConstraint.isActive = true
    }
    
    //MARK: - 테이블 뷰 높이 동적 조절
    func updateTableViewHeight() {
        let numberOfRows = transactionTableView.numberOfRows(inSection: 0)
        let rowHeight = 70 // UITableView 델리겟의 row 높이와 맞춰줌
        let newHeight = CGFloat(numberOfRows * rowHeight)
        
        transactionTableViewHeightConstraint.constant = newHeight
    }
    
    //MARK: - Prev, Next, Today 버튼의 공통 메서드
    // 달력과 달력의 년/월을 나타내는 Label의 업데이트
    func changeCalendarMethod(date: Date) {
        CalendarManager.manager.configureCalendar(date: date)
        CalendarManager.manager.updateDays()
        CalendarManager.manager.updateYearMonthLabel(label: self.yearMonthButtonLabel)
        self.totalAmountCurrentMonth()
        self.checkToday()
        // yearMonthButtonLabel로 버튼을 사용 -> config로 title을 지정해주었기 때문에 다시 지정해주어야함.
        self.ConfigurationChangeMonthButton()
        self.calendarCollectionView.reloadData()
    }
    
    //MARK: - Today 버튼을 누르면 currentDayTitle.text 변경
    func changeCurrentDayTitleByTodayButton() {
        self.selectedDate = Date()
        self.dateFormatter.dateFormat = "M월 d일 E요일"
        self.currentDayTitle.text = self.dateFormatter.string(from: Date())
        self.transactionTableView.reloadData()
    }
    
    
    // 이번달의 내역 총 합계
    func totalAmountCurrentMonth() {
        self.monthTotalAmountLabel.text = ShareData.shared.totalAmountInMonth()
        print(ShareData.shared.getYearMonthData().count)
        if ShareData.shared.getYearMonthData().count >= 1 {
            if self.monthTotalAmountLabel.text?.first == "-" {
                self.currentSpendingAmountLabel.text = "이번 달 거래금액\n\(self.monthTotalAmountLabel.text ?? "-") 원"
            }else {
                self.currentSpendingAmountLabel.text = "이번 달 거래금액\n\(self.monthTotalAmountLabel.text ?? "-") 원"
            }
        }else {
            self.currentSpendingAmountLabel.text = "이번 달의\n내역이 존재하지 않습니다."
        }
    }
    
    
    


}

extension HomeViewController: CalendarPopUpViewControllerDelegate, TransactionTableViewButtonDelegate {
    //MARK: - 델리게이트 필수 메서드
    // CalendarPopUpViewControllerDelegate 필수 메서드
    func updateCalendar(date: Date) {
        CalendarManager.manager.configureCalendar(date: date)
        CalendarManager.manager.updateDays()
        CalendarManager.manager.updateYearMonthLabel(label: self.yearMonthButtonLabel)
        self.totalAmountCurrentMonth()
        self.checkToday()
        // yearMonthButtonLabel로 버튼을 사용 -> config로 title을 지정해주었기 때문에 다시 지정해주어야함.
        ConfigurationChangeMonthButton()
        
        let dateComponents = self.calendar.dateComponents([.year, .month], from: CalendarManager.manager.calendarDate)
        ShareData.shared.getYearMonthTransactionData(year: dateComponents.year!, month: dateComponents.month!)
        self.changeCalendarMethod(date: CalendarManager.manager.calendarDate)
        
        calendarCollectionView.reloadData()
    }
    
    
    // TransactionTableViewButtonDelegate 필수 메서드
    func deleteTransaction(transaction: SaverModel) {
        ShareData.shared.removeData(transaction: transaction)
        let todayComponents = self.calendar.dateComponents([.day], from: transaction.transactionDate)
        self.currentDayAmount.text = "\(ShareData.shared.totalAmountIndDay(day: todayComponents.day!)) 원"
        self.totalAmountCurrentMonth() // 내역 삭제할 때마다 월별 합계금액 타이틀 변경
        transactionTableView.reloadData()
        self.updateTableViewHeight()
        calendarCollectionView.reloadData()
        print("삭제 클릭")
    }
    
    func editTransaction(transaction: SaverModel) {
        let addAmountViewController = AddAmountViewController()
        addAmountViewController.delegate = self
        addAmountViewController.transaction = transaction
        navigationController?.pushViewController(addAmountViewController, animated: true)
    }
    
    func saveTransactionInAddView(transaction: SaverModel) {
        ShareData.shared.dbController.insertData(data: transaction)
        let components = self.calendar.dateComponents([.year, .month], from: self.selectedDate ?? Date())
        ShareData.shared.getYearMonthTransactionData(year: components.year!, month: components.month!)
        let dateComponents = self.calendar.dateComponents([.day], from: transaction.transactionDate)
        self.currentDayAmount.text = "\(ShareData.shared.totalAmountIndDay(day: dateComponents.day!)) 원"
        self.totalAmountCurrentMonth() // 내역 추가할 때마다 월별 합계금액 타이틀 변경
        self.transactionTableView.reloadData()
        self.calendarCollectionView.reloadData()
        print("저장 일단 완료.")
    }
    
    func editTransactionInAddView(oldTransactoin: SaverModel, newTransaction: SaverModel) {
        ShareData.shared.dbController.updateData(model: oldTransactoin, data: newTransaction)
        let components = self.calendar.dateComponents([.year, .month], from: self.selectedDate ?? Date())
        ShareData.shared.getYearMonthTransactionData(year: components.year!, month: components.month!)
        let dateComponents = self.calendar.dateComponents([.day], from: oldTransactoin.transactionDate)
        self.currentDayAmount.text = "\(ShareData.shared.totalAmountIndDay(day: dateComponents.day!)) 원"
        self.totalAmountCurrentMonth() // 내역 추가할 때마다 월별 합계금액 타이틀 변경
        self.transactionTableView.reloadData()
        self.calendarCollectionView.reloadData()
        print("업뎃 일단 완료.")
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero // 열 간의 간격을 0으로 설정
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calendarView.frame.width / 7
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let countOfCell = CalendarManager.manager.countOfDays()
        return countOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCollectionViewCell
        cell.backgroundColor = .clear
        
        let days = CalendarManager.manager.getDays()
        let yearMonthComponents = calendar.dateComponents([.year, .month], from: CalendarManager.manager.calendarDate)
        let dateComponents = DateComponents(year: yearMonthComponents.year, month: yearMonthComponents.month, day: days[indexPath.row])
        let date = calendar.date(from: dateComponents)
        
        if self.selectedDate == date {
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 0.7)
        }
        
        cell.configureCell(date: date ?? Date(), day: days[indexPath.row], isToday: self.isToday)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 이전에 선택한 셀 초기화
        if let previousIndexPath = self.selectedIndexPath {
            let prevCell = collectionView.cellForItem(at: previousIndexPath) as? CalendarCollectionViewCell
            prevCell?.backgroundColor = .clear
            prevCell?.contentView.layer.cornerRadius = 0
            prevCell?.contentView.layer.borderWidth = 0
        }
        
        // 선택한 셀 불러오기
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell {
            if cell.numberOfDayLabel.text != ""{
                self.selectedIndexPath = indexPath
                cell.contentView.layer.borderWidth = 1
                cell.contentView.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 0.7)
//                cell.contentView.layer.borderColor = d
                
                let days = CalendarManager.manager.getDays()
                
                let yearMonthComponents = calendar.dateComponents([.year, .month], from: CalendarManager.manager.calendarDate)
                let dateComponents = DateComponents(year: yearMonthComponents.year, month: yearMonthComponents.month, day: days[indexPath.row])
                let date = calendar.date(from: dateComponents)
                
            
                let totalAmountInDay = ShareData.shared.totalAmountIndDay(day: days[indexPath.row])
                self.currentDayAmount.text = "\(totalAmountInDay) 원"
                
                self.dateFormatter.dateFormat = "M월 d일 E요일"
                self.currentDayTitle.text = self.dateFormatter.string(from: date ?? Date())
                
                self.selectedDate = date // 선택한 날짜를 저장 -> 테이블 뷰 리스트 불러올 때 사용!
                self.transactionTableView.reloadData() // 날짜 선택할 때마다 테이블 뷰 리로드!
            }else {
                print("잘못된 날짜 선택입니다.")
            }
        }
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selectedDateComponents = self.calendar.dateComponents([.day], from: self.selectedDate ?? Date())
        if ShareData.shared.getTransactionListOfDay(day: selectedDateComponents.day ?? 1).count > 0 {
            return ShareData.shared.getTransactionListOfDay(day: selectedDateComponents.day ?? 1).count
        }else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionTableViewCell
        cell.delegate = self
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        let selectedDateComponents = self.calendar.dateComponents([.day], from: self.selectedDate ?? Date())
        let data = ShareData.shared.getTransactionListOfDay(day: selectedDateComponents.day ?? 1)
        if data.count > 0 {
            cell.configureCell(transaction: data[indexPath.row])
            return cell
        }else {
            cell.configureNilCell()
            self.currentDayAmount.text = ""
            return cell
        }
    }
    
    
}
