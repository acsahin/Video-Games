//
//  HomeViewController.swift
//  Video Games
//
//  Created by ACS on 3.03.2021.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController{
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var searchText: UITextField!
    
    var collectionData = [VideoGame]()
    
    let network = APINetwork()
    
    var pages = [UIViewController]()
    var pageCount: Int = 3
    var pageViewController: UIPageViewController?
    var currentIndex = 0
    var pendingIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        network.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        searchText.delegate = self
                
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
            if text.count >= 4 {
                stackView.isHidden = true
                collectionData = network.baseData.filter{
                    $0.name.lowercased().contains(text)
                }
                collectionView.reloadData()
            }else {
                container.isHidden = false
                pageControl.isHidden = false
            }
        } else {
            container.isHidden = false
            pageControl.isHidden = false
        }
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
        
        print(collectionData[indexPath.row].name)
        
        cell.backgroundColor = .black
        cell.layer.cornerRadius = 20
        
        cell.layer.shadowColor = UIColor.darkGray.cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.shadowOffset = CGSize(width: -5, height: -5)
        cell.layer.shadowRadius = 5
        
        cell.layer.masksToBounds = false
        
        return cell
    }
}


extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
}
