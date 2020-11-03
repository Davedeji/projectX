//
//  NotificationsTableVC.swift
//  projectX
//
//  Created by Radomyr Bezghin on 6/15/20.
//  Copyright © 2020 Radomyr Bezghin. All rights reserved.
//
 /*
 create a separate UIView file and do all the autolayout there
 init a view of that type here in UIView Controller and pin it to the edges
 
 UIView file
 Segmented controll
 UITableView vertical
 -> custom cell, separate file of type UITableViewCell
 */



import UIKit


class NotificationsTableVC: UIViewController {
    
    // make sure all lists have the same count
    var notifications = [String]()
    var notificationspic = [String]()
    var notificationsdate = [String]()
    
    
    
    let missions = ["too much lemon", "grind in league", "paint brush"]
    let missionspic = ["bigslug.png", "xbox.png", "sluglogoo.png"]
    let missionsdate = ["2 days", "a week", "a week"]
    
    
    let missions1 = ["Need help fixing my laptop!", "Look after my cat Look after my cat Look after my cat Look after my cat Look after my cat Look after my cat Look after my cat Look after my cat Look after my cat Look after my cat Look after my cat Look after my cat Look after my cat Look after my cat. I hate cats", "Borrowing a mic!", "Grab some food for me", "Look after my pets!"]
    let usernames = ["Brosef Doesef", "Kirill Zhuze", "Gurpreet Dhillon", "Jake Nations", "Radomyr Bezghin"]
    // will make a uilabel for • in future
    let missions1date = ["• 7/30", "• 6/30", "• 7/30", "• 7/30", "• 7/30"]
    let channels = ["Photography","Gaming","International","UCSC","UCSC"]
    let missionactions = ["Selected","Completed","Completed","Completed","Completed"]
    
    
    
    
    
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.text = "Mailroom"
        label.textAlignment = .center
        return label
    }()
    
    let segmentController : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Notifications", "Missions"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        sc.layer.backgroundColor = UIColor.white.cgColor
        sc.addTarget(self, action: #selector(performAnimation), for: .valueChanged)
        return sc
    }()
    
    let viewForTableViews : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let notifTableView : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.tableFooterView = UIView()
        tv.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.CellID)
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 100
        return tv
    }()
    
    let missionView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let missionLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "Mission Deadlines"
        label.textAlignment = .left
        return label
    }()
    
    let missionCollection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = CGFloat.greatestFiniteMagnitude
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MissionCell.self, forCellWithReuseIdentifier: MissionCell.CellID)
        cv.alwaysBounceVertical = false
        cv.backgroundColor = .white
        return cv
    }()
    
    let missionTable : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.tableFooterView = UIView()
        tv.register(MissionsCell.self, forCellReuseIdentifier: MissionsCell.Cell1ID)
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 100
        return tv
    }()
    
    var leftNotifAnchor : NSLayoutConstraint?
    var rightNotifAnchor : NSLayoutConstraint?
    var leftMissionAnchor : NSLayoutConstraint?
    var rightMissionAnchor : NSLayoutConstraint?
    
    override func viewDidLayoutSubviews() {
        GetData.getNotifications { (notifs) in
            for notif in notifs {
                self.notifications.append(notif.preview)
                self.notificationsdate.append(notif.timestamp)
                self.notificationspic.append(notif.image)
            }
            DispatchQueue.main.async {
                self.notifTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NotificationsData.createNotifications()
        
        
        view.backgroundColor = .white
        
        notifTableView.delegate = self
        notifTableView.dataSource = self
        
        missionCollection.delegate = self
        missionCollection.dataSource = self
        missionCollection.prefetchDataSource = self
        
        missionTable.delegate = self
        missionTable.dataSource = self
        
        missionView.addSubview(missionLabel)
        missionView.addSubview(missionCollection)
        missionView.addSubview(missionTable)
        
        viewForTableViews.addSubview(notifTableView)
        viewForTableViews.addSubview(missionView)
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(segmentController)
        self.view.addSubview(viewForTableViews)
        
        let titleLabelTop = titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32)
        let titleLabelLeft = titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32)
        let segmentControllerTop = segmentController.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        let segmentControllerWidth = segmentController.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        
        NSLayoutConstraint.activate([titleLabelTop, titleLabelLeft,segmentControllerTop, segmentControllerWidth])
        
        // notification table constraints
        
        notifTableView.topAnchor.constraint(equalTo:
            viewForTableViews.safeAreaLayoutGuide.topAnchor).isActive = true
        notifTableView.bottomAnchor.constraint(equalTo:
            viewForTableViews.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        leftNotifAnchor = notifTableView.leadingAnchor.constraint(equalTo: viewForTableViews.safeAreaLayoutGuide.leadingAnchor)
        leftNotifAnchor?.isActive = true
        rightNotifAnchor = notifTableView.trailingAnchor.constraint(equalTo: viewForTableViews.safeAreaLayoutGuide.leadingAnchor)
        rightNotifAnchor?.isActive = false
        
        notifTableView.widthAnchor.constraint(equalTo:
            viewForTableViews.safeAreaLayoutGuide.widthAnchor).isActive = true
        
        // mission view constraints
        
        missionView.topAnchor.constraint(equalTo:
            viewForTableViews.safeAreaLayoutGuide.topAnchor).isActive = true
        missionView.bottomAnchor.constraint(equalTo:
            viewForTableViews.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        leftMissionAnchor = missionView.leadingAnchor.constraint(equalTo: viewForTableViews.safeAreaLayoutGuide.trailingAnchor)
        leftMissionAnchor?.isActive = true
        rightMissionAnchor = missionView.trailingAnchor.constraint(equalTo: viewForTableViews.safeAreaLayoutGuide.trailingAnchor)
        rightMissionAnchor?.isActive = false
        
        missionView.widthAnchor.constraint(equalTo:
            viewForTableViews.safeAreaLayoutGuide.widthAnchor).isActive = true
        
        
        // mission deadlines label
        let missionTableRatio : CGFloat = 0.65
        let missionLabelRatio : CGFloat = 0.15
        
        missionLabel.topAnchor.constraint(equalTo: missionView.safeAreaLayoutGuide.topAnchor).isActive = true
        missionLabel.leftAnchor.constraint(
            equalTo: missionView.safeAreaLayoutGuide.leftAnchor, constant: 32).isActive = true
        missionLabel.heightAnchor.constraint(
            equalTo: missionView.heightAnchor, multiplier: missionLabelRatio * (1 - missionTableRatio)).isActive = true
        
        // mission table constraints
        missionTable.bottomAnchor.constraint(equalTo: missionView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        missionTable.leadingAnchor.constraint(equalTo: missionView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        missionTable.trailingAnchor.constraint(equalTo: missionView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        missionTable.heightAnchor.constraint(
            equalTo: missionView.heightAnchor, multiplier: missionTableRatio).isActive = true
        
        // mission collection constraints
        missionCollection.topAnchor.constraint(equalTo: missionLabel.bottomAnchor).isActive = true
        missionCollection.leadingAnchor.constraint(
            equalTo: missionView.safeAreaLayoutGuide.leadingAnchor, constant: 5).isActive = true
        missionCollection.trailingAnchor.constraint(
            equalTo: missionView.safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
        missionCollection.heightAnchor.constraint(
            equalTo: missionView.heightAnchor, multiplier: (1 - missionLabelRatio) * (1 - missionTableRatio)).isActive = true
        
        // view for other views constraints
        
        viewForTableViews.addAnchors(top: segmentController.bottomAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0))
    }
   
    
    @objc func performAnimation(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut,
            animations:
            {
                if(self.segmentController.selectedSegmentIndex == 0){
                    //move home to the right
                    self.leftNotifAnchor?.isActive = true
                    self.rightNotifAnchor?.isActive = false
                    //move recommendation to the right
                    self.leftMissionAnchor?.isActive = true
                    self.rightMissionAnchor?.isActive = false
                    self.viewForTableViews.layoutIfNeeded()
                } else if (self.segmentController.selectedSegmentIndex == 1){
                    //move home to the left
                    self.leftNotifAnchor?.isActive = false
                    self.rightNotifAnchor?.isActive = true
                    //move recommendation to the left
                    self.leftMissionAnchor?.isActive = false
                    self.rightMissionAnchor?.isActive = true
                    self.viewForTableViews.layoutIfNeeded()
                }
        }, completion: nil)
    }
    
    
}

extension NotificationsTableVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.notifTableView {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.CellID, for: indexPath) as? NotificationCell else {
                   fatalError("Wrong cell")
               }
        addData(toCell: cell, withIndex: indexPath.row)
        return cell
        }
        else if tableView == self.missionTable{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MissionsCell.Cell1ID, for: indexPath) as? MissionsCell else {
                       fatalError("Wrong cell")
                   }
            addData1(toCell: cell, withIndex: indexPath.row)
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MissionsCell.Cell1ID, for: indexPath) as? MissionsCell else {
                                fatalError("Wrong cell")
                            }
            return cell
            
        }
    }


    func addData(toCell cell: NotificationCell, withIndex index: Int ){
        
        cell.dateUILabel.text = notificationsdate[index]
        cell.previewtxtLabel.text = notifications[index]
        cell.notifimage.image = UIImage(named: notificationspic[index])
    }
    func addData1(toCell cell: MissionsCell, withIndex index: Int ){
        cell.dateUILabel.text = missions1date[index]
        cell.nameUILabel.text = usernames[index]
        cell.previewtxtLabel.text = missions1[index]
        cell.selectionUILabel.text = missionactions[index]
        cell.channelUILabel.setTitle(channels[index], for: .normal)
        //cell.channelUILabel.text = channels[index]
        cell.notifimage.image = UIImage(named: notificationspic[index])
    }
}

extension NotificationsTableVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        guard let cell = missionCollection.dequeueReusableCell(
            withReuseIdentifier: MissionCell.CellID, for: indexPath) as? MissionCell else {fatalError("Wrong cell") }
        
        addDataMission(toCell: cell, withIndex: indexPath.item)
        return cell
    }
    
    func addDataMission(toCell cell: MissionCell, withIndex index: Int) {
        cell.deadlineLabel.text = "In \(missionsdate[index])"
        cell.previewtxtLabel.text = "\"\(missions[index])\""
        cell.missionImage.image = UIImage(named: missionspic[index])
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.height - 10, height: collectionView.bounds.height - 10)
    }
}


extension NotificationsTableVC: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("Prefetch: \(indexPaths)")
    }
}