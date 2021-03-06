//
//  HomeViewController.swift
//  Video Games
//
//  Created by ACS on 3.03.2021.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController{
    
    //PageView
    @IBOutlet weak var pageControl: UIPageControl!
    var pages = [UIViewController]()
    var pageCount: Int = 3
    var pageViewController: UIPageViewController?
    var currentIndex = 0
    var pendingIndex: Int?
    
    //CollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    var collectionData = [VideoGame]()
    var chosenVideoGameSlug = ""
    
    //This stackview only used for "isHidden" property
    //to show/hide onSearch
    @IBOutlet weak var stackView: UIStackView!
    
    //Search Text Field
    @IBOutlet weak var searchText: UITextField!

    //NetworkConnection
    let network = APINetwork()
    
    let noItemTextLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        noItemTextLabel.isHidden = true
        
        network.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        searchText.delegate = self
        
        searchText.clearsOnBeginEditing = false
                
        //Init collectionView with custom cell
        self.collectionView.register(UINib.init(nibName: "VideoGameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "videoGameCell")
        
        pageControl.pageIndicatorTintColor = .darkGray
        pageControl.currentPageIndicatorTintColor = .black
    }
    
    func pageControllerInit(videoGameList: [VideoGame]) {
        for i in 0 ..< pageCount {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as? PageContentViewController {
                vc.videoGame = videoGameList[i]
                pages.append(vc)
            }
        }
        pageViewController = self.children[0] as? UIPageViewController
        pageViewController!.delegate = self
        pageViewController!.dataSource = self
        pageViewController!.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        pageControl.numberOfPages = pageCount
    }
    
    
    //TextField value
    @IBAction func searchTextChanged(_ sender: UITextField) {
        if let text = sender.text {
            
            //If there is more than 3 characters
            //Hide UIPageView
            //Expand CollectionView to bottom of search text
            if text.count >= 4 {
                self.view.willRemoveSubview(noItemTextLabel)
                noItemTextLabel.isHidden = true
                stackView.isHidden = true
                collectionView.isHidden = false
                collectionData.removeAll()
                collectionView.reloadData()
                collectionData = network.baseData.filter{
                    $0.name.lowercased().contains(text.lowercased())
                }
                collectionView.reloadData()
                
                //If there is no book,
                //Show only text at center
                if collectionData.count == 0 {
                    stackView.isHidden = true
                    collectionView.isHidden = true
                    noItemTextLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
                    noItemTextLabel.center = self.view.center
                    noItemTextLabel.text = "No item :("
                    noItemTextLabel.textColor = .black
                    noItemTextLabel.tintColor = .black
                    noItemTextLabel.isHidden = false
                    self.view.addSubview(noItemTextLabel)
                }
            }
        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    
    //On return button (keyboard)
    //If text char number is less than 4
    //show main view
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let currentText = textField.text {
            if currentText.count < 4 {
                textField.text = ""
                noItemTextLabel.isHidden = true
                stackView.isHidden = false
                collectionData = Array(network.baseData[self.pageCount..<network.baseData.count])
                collectionView.reloadData()
            }
        }
        return true
    }
    
    
    //Show main view
    //If text field is cleared
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        noItemTextLabel.isHidden = true
        stackView.isHidden = false
        collectionView.isHidden = false
        collectionData = Array(network.baseData[self.pageCount..<network.baseData.count])
        collectionView.reloadData()
        return true
    }
}


//PageView extension
extension HomeViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.firstIndex(of: viewController)!
        if currentIndex == pages.count - 1 {
            return nil
        }
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.firstIndex(of: viewController)!
        if currentIndex == 0 {
            return nil
        }
        let previousIndex = abs((currentIndex - 1) % pages.count)
        return pages[previousIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = pages.firstIndex(of: pendingViewControllers.first!)
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let pendingIndex = pendingIndex {
                currentIndex = pendingIndex
                pageControl.currentPage = currentIndex
            }
        }
    }
}


//Collection View
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoGameCell", for: indexPath) as! VideoGameCollectionViewCell
        
        cell.label.text = collectionData[indexPath.row].name
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: URL(string: collectionData[indexPath.row].background_image))
        cell.ratingLabel.text = String(collectionData[indexPath.row].rating)
        cell.dateLabel.text = collectionData[indexPath.row].released
        
        cell.backgroundColor = .black
        cell.layer.cornerRadius = 20
        cell.layer.shadowColor = UIColor.darkGray.cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.shadowOffset = CGSize(width: -5, height: -5)
        cell.layer.shadowRadius = 5
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    
    //On tap collectionView cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(collectionData[indexPath.row].name)
        chosenVideoGameSlug = collectionData[indexPath.row].slug
        self.performSegue(withIdentifier: "goToDetailView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailView" {
            if let detailVC = segue.destination as? DetailsViewController {
                detailVC.vg = chosenVideoGameSlug
            }
        }
    }
    
}


//Notify CollectionData Changes -Delegate
extension HomeViewController: APINetworkDelegate {
    func didUpdateVideoGames(_ apiNetwork: APINetwork, videoGames: [VideoGame]) {
        DispatchQueue.main.async {
            self.pageControllerInit(videoGameList: Array(videoGames[0..<self.pageCount]))
            self.collectionData = Array(videoGames[self.pageCount..<videoGames.count])
            self.collectionView.reloadData()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
