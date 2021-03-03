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
    
    var pages = [UIViewController]()
    var pageCount: Int = 3
    var pageViewController: UIPageViewController?
    var currentIndex = 0
    var pendingIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        
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
    
    @IBAction func pageControlValueChanged(_ sender: UIPageControl) {
        if sender.currentPage > currentIndex {
            pageViewController!.setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
        } else {
            pageViewController!.setViewControllers([pages[sender.currentPage]], direction: .reverse, animated: true, completion: nil)
        }
        currentIndex = sender.currentPage
    }
}

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
