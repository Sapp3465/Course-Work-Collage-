//
//  ImageInputViewController.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/28/21.
//

import UIKit
import Photos

class ImageInputViewController: ViewController {

    private let activityIndicator = ActivityIndicator()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: SquareCollectionViewFlowLayout())
    private let button: Button = Button(title: "CREATE_COLLAGE".localized)
    private let documentManager = DocumentManager(configuration: .photos)

    private var imagesLinks = [Int: URL]() {
        didSet {
            self.collectionView.reloadData()
        }
    }

    private var selectedUrls = [Int: URL]()

    weak var delegate: ImageInputViewControllerDelegate?

    //Mark: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutViews()

        self.title = "SHARED_PHOTOS".localized
        button.bring(to: .disabled)

        collectionView.registerCell(with: ImageCollectioniewCell.self)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.delegate = self
        collectionView.dataSource = self

        button.addTarget(self, action: #selector(usePhotos), for: .touchUpInside)

        requestPhotos()
    }

    //Mark: - Private API
    private func requestPhotos() {
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .background).async {
            let links = self.documentManager.fileUrls()
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if links.isEmpty {
                    self.showWarning(with: "Unable to load photos from your directory! Upload photos via itunes!")
                } else {
                    self.imagesLinks = links
                }
            }
        }
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        let indexes = self.selectedUrls.keys.map( { IndexPath(row: $0, section: 0)} )
        self.selectedUrls.removeAll()
        self.collectionView.reloadItems(at: indexes)
    }

    @objc
    private func usePhotos() {

        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self,
                  let delegate = self.delegate else {
                return
            }
            let links = Array(self.selectedUrls.values)

            var images: [UIImage?] = Array(repeating: nil, count: links.count)

            DispatchQueue.concurrentPerform(iterations: links.count) { index in
                guard let data = try? Data(contentsOf: links[index]) else {
                    return
                }
                images[index] = UIImage(data: data)
            }

            let allImages = images.compactMap { $0 }

            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    delegate.didSelect(allImages)
                }
            }
        }
    }

}

//Mark: - Layout
extension ImageInputViewController {

    private func layoutViews() {
        layoutCollection()
        layoutButton()
        layoutActivityIndicator()
    }

    private func layoutCollection() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)

        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }

    private func layoutButton() {
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.heightAnchor.constraint(equalToConstant: 47).isActive = true
        button.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 10).isActive = true
        button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true

        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }

    private func layoutActivityIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }

}

//Mark: - UICollectionViewDataSource
extension ImageInputViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesLinks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectioniewCell = collectionView.dequeueCell(at: indexPath)
        cell.setState(selectedUrls.keys.contains(indexPath.row) ? .selected : .normal)
        return cell
    }

}

//Mark: - UICollectionViewDelegate
extension ImageInputViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImageCollectioniewCell else {
            return
        }

        let cellB = cell.bounds
        DispatchQueue.global(qos: .background).async {
            if let url = self.imagesLinks[indexPath.row],
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                let resised = image.resizeImage(targetSize: cellB.size)
                DispatchQueue.main.async {
                    if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectioniewCell,
                       collectionView.visibleCells.contains(cell) {
                        cell.install(resised)
                    }
                }
            }
        }

        cell.setState(selectedUrls.keys.contains(indexPath.row) ? .selected : .normal)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectioniewCell else {
            return
        }

        cell.setState(cell.state == .normal ? .selected : .normal, animated: true)

        if cell.state == .selected {
            selectedUrls[indexPath.row] = imagesLinks[indexPath.row]
        } else {
            selectedUrls.removeValue(forKey: indexPath.row)
        }

        button.bring(to: (2...10 ~= selectedUrls.count) ? .activated : .disabled)
    }

}
