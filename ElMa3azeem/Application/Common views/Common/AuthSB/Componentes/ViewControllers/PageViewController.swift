//
//  PageViewController.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 22/11/2022.
//

import UIKit

class PageViewController: UIPageViewController {
    // MARK: - Properties -

    private var subViewControllers = [UIViewController]()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .appColor(.MainColor)
        pageControl.tintColor = .white
        return pageControl
    }()

    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("skip".localized, for: .normal)
        button.setTitleColor(.appColor(.MainColor), for: .normal)
        button.addTarget(self, action: #selector(skipWasPressed(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var nextButton: UIButton = {
        let button = MainButton(title: "next".localized)
        button.addTarget(self, action: #selector(nextWasPressed(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var loginButton: UIButton = {
        let button = MainButton(title: "start your experience now".localized)
        button.addTarget(self, action: #selector(loginWasPressed(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 0
        return stack
    }()

    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 4
        stack.distribution = .equalSpacing
        return stack
    }()

    // MARK: - Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        view.backgroundColor = .clear
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraint()
    }

    // MARK: - Initialize -

    static func create(subViewControllers: [UIViewController]) -> PageViewController {
        let pageController = UIStoryboard(name: StoryBoard.Auth.rawValue, bundle: nil).instantiateViewController(identifier: "PageViewController") as! PageViewController
        pageController.subViewControllers = subViewControllers
        return pageController
    }

    // MARK: - Actions -

    @objc private func skipWasPressed(_ sender: UIButton) {
        defult.shared.setData(data: false, forKey: .isFiristLuanch)
        let vc = UIStoryboard(name: StoryBoard.Auth.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ChooseLoginType") as! ChooseLoginType
        let nav = UINavigationController(rootViewController: vc)
        MGHelper.changeWindowRoot(vc: nav)
    }

    @objc private func nextWasPressed(_ sender: UIButton) {
        guard let currentPage = viewControllers?.first else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        guard let currentIndex = subViewControllers.firstIndex(of: nextPage) else { return }
        pageControl.currentPage = currentIndex
        checkIfLastPageReached(currentPage: currentIndex)
        setViewControllers([nextPage], direction: Language.isArabic() ? .reverse : .forward, animated: true)
    }

    @objc private func loginWasPressed(_ sender: UIButton) {
        defult.shared.setData(data: false, forKey: .isFiristLuanch)
        let vc = UIStoryboard(name: StoryBoard.Auth.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ChooseLoginType") as! ChooseLoginType
        let nav = UINavigationController(rootViewController: vc)
        MGHelper.changeWindowRoot(vc: nav)
    }
}

// MARK: - Helper Functions -

extension PageViewController {
    private func configure() {
        delegate = self
        dataSource = self
        view.backgroundColor = .white
        setViewControllers([subViewControllers[0]], direction: Language.isArabic() ? .reverse : .forward, animated: true)

        pageControl.numberOfPages = subViewControllers.count
        pageControl.semanticContentAttribute = Language.isArabic() ? .forceRightToLeft : .forceLeftToRight

        nextButton.constrainHeight(constant: 50)
        loginButton.constrainHeight(constant: 50)

        buttonsStack.addArrangedSubview(nextButton)
        buttonsStack.addArrangedSubview(skipButton)
        buttonsStack.addArrangedSubview(loginButton)
        
        mainStack.addArrangedSubview(pageControl)
        mainStack.addArrangedSubview(buttonsStack)

        view.addSubview(mainStack)
    }

    private func setConstraint() {
        buttonsStack.anchor(top: nil, leading: mainStack.leadingAnchor,
                            bottom: nil,
                            trailing: mainStack.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        mainStack.anchor(top: nil,
                         leading: view.safeAreaLayoutGuide.leadingAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         trailing: view.safeAreaLayoutGuide.trailingAnchor,
                         padding: .init(top: 0, left: 20, bottom: 20, right: 20))
    }

    private func checkIfLastPageReached(currentPage: Int) {
        if currentPage == subViewControllers.count - 1 {
            loginButton.isHidden = false
            skipButton.isHidden = true
            nextButton.isHidden = true
        } else {
            loginButton.isHidden = true
            skipButton.isHidden = false
            nextButton.isHidden = false
        }
    }
}

// MARK: - UIPageViewControllerDelegate and DataSource -

extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentPage = subViewControllers.firstIndex(of: viewController) else { return nil }
        pageControl.currentPage = currentPage
        checkIfLastPageReached(currentPage: currentPage)
        if currentPage <= 0 {
            return nil
        }
        return subViewControllers[currentPage - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentPage = subViewControllers.firstIndex(of: viewController) else { return nil }
        pageControl.currentPage = currentPage
        checkIfLastPageReached(currentPage: currentPage)
        if currentPage >= subViewControllers.count - 1 {
            return nil
        }
        return subViewControllers[currentPage + 1]
    }
}
