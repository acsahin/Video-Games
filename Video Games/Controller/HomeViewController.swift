//
//  HomeViewController.swift
//  Video Games
//
//  Created by ACS on 3.03.2021.
//

import UIKit

class HomeViewController: UIViewController{
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionData = [VideoGame]()
    
    let network = APINetwork()
    
    var pages = [UIViewController]()
    var pageCount: Int = 3
    var pageViewController: UIPageViewController?
    var currentIndex = 0
    var pendingIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        
        network.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
                
        self.collectionView.register(UINib.init(nibName: "VideoGameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "videoGameCell")
        
        
        pageControllerInit()
        
        //pageControl.isHidden = true
        //container.isHidden = true
    }
    
    func pageControllerInit() {
        for i in 0 ..< pageCount {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as? PageContentViewController {
                vc.index = i
                pages.append(vc)
            }
        }
        pageViewController = self.children[0] as? UIPageViewController
        pageViewController!.delegate = self
        pageViewController!.dataSource = self
        pageViewController!.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        pageControl.numberOfPages = pageCount
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


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoGameCell", for: indexPath) as! VideoGameCollectionViewCell
        cell.label.text = collectionData[indexPath.row].name
        cell.imageView.image = UIImage(named: "2")
        cell.ratingLabel.text = String(collectionData[indexPath.row].rating)
        cell.dateLabel.text = collectionData[indexPath.row].released
        
        print(collectionData[indexPath.row].name)
        
        cell.backgroundColor = .black
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        
        return cell
    }
}

extension HomeViewController: APINetworkDelegate {
    func didUpdateVideoGames(_ apiNetwork: APINetwork, videoGames: [VideoGame]) {
        DispatchQueue.main.async {
            self.collectionData = videoGames
            self.collectionView.reloadData()
        }
    }
    
}
