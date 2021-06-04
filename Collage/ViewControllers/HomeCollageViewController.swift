//
//  HomeCollageViewController.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/28/21.
//

import UIKit

class HomeCollageViewController: ViewController {

    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: PagingCollectionViewFlowLayout())
    private let imageInputController: ImageInputController = .init()
    private var collageControllers: [CollageViewController] = []

    //Mark: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutViews()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(with: UICollectionViewCell.self)
        collectionView.isPagingEnabled = true
        title = "Collage!"

        addNewController()
    }

    private func addNewController() {
        let newController = CollageViewController()
        newController.delegate = self
        newController.imagePicker = self.imageInputController
        collageControllers.append(newController)
    }

}

extension HomeCollageViewController {

    private func layoutViews() {
        layoutImageView()
    }

    private func layoutImageView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)

        collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

}

extension HomeCollageViewController: CollageViewControllerDelegate {

    func didPresentCollage() {
        print("Presented")
        addNewController()
        collectionView.insertItems(at: [IndexPath(row: collageControllers.count-1, section: 0)])
    }

}

//Mark: - UICollectionViewDataSource
extension HomeCollageViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collageControllers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueCell(at: indexPath)
        return cell
    }

}

//Mark: - UICollectionViewDelegate
extension HomeCollageViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let controller = collageControllers[indexPath.row]
        cell.addSubview(controller.view)
        addChild(controller)

        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.topAnchor.constraint(equalTo: cell.safeAreaLayoutGuide.topAnchor).isActive = true
        controller.view.leadingAnchor.constraint(equalTo: cell.safeAreaLayoutGuide.leadingAnchor).isActive = true
        controller.view.trailingAnchor.constraint(equalTo: cell.safeAreaLayoutGuide.trailingAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: cell.safeAreaLayoutGuide.bottomAnchor).isActive = true
        controller.didMove(toParent: self)
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let controller = collageControllers[indexPath.row]
        controller.willMove(toParent: nil)
        controller.removeFromParent()
        controller.view.removeFromSuperview()
    }

}
