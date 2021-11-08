//
//  CatsAndDogsView.swift
//  Homework4
//
//  Created by Евгений Самарин on 02.11.2021.
//

import Foundation
import UIKit
import SnapKit
import Combine
import Kingfisher

final class CatsAndDogsViewController: UIViewController {

    // MARK: - Instance Properties

    private let viewModel = CatsAndDogsViewModel()
    private var cancellable = Set<AnyCancellable>()

    // MARK: -

    private var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Cats", "Dogs"])
        let font = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13)]
        control.setTitleTextAttributes(font, for: .normal)
        control.selectedSegmentIndex = 0
        return control
    }()

    private var moreButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSMutableAttributedString(string: "more", attributes: [NSAttributedString.Key.kern: 0.34]), for: .normal)
        button.layer.cornerRadius = 20
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 255 / 255, green: 155 / 255, blue: 138 / 255, alpha: 1)
        return button
    }()

    private var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()

    private var scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Score"
        return label
    }()

    private var catsFact: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center 
        return label
    }()

    private var dogsImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private var contentPlaceholder: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Content"
        return label
    }()

    // MARK: - UIViewControllers methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationBarItems()
        self.setupView()
        self.setupConstraints()
        self.bindings()
    }

    // MARK: - Instance Methods

    private func setupNavigationBarItems() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 0.94)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.title = "Cats and dogs"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(self.onResetButtonTapped))
    }

    private func setupView() {
        self.view.backgroundColor = .white

        self.view.addSubview(self.segmentControl)
        self.view.addSubview(self.moreButton)
        self.view.addSubview(self.contentView)
        self.view.addSubview(self.scoreLabel)
        self.contentView.addSubview(self.catsFact)
        self.contentView.addSubview(self.dogsImageView)
        self.contentView.addSubview(self.contentPlaceholder)

        self.moreButton.addTarget(nil, action: #selector(self.onMoreButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        self.segmentControl.snp.makeConstraints { make in

            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(27)
            make.leading.equalToSuperview().offset(95)
            make.trailing.equalToSuperview().offset(-84)
        }

        self.contentView.snp.makeConstraints { make in
            make.top.equalTo(self.segmentControl.snp.bottom).offset(41)
            make.height.equalTo(204)
            make.leading.equalTo(18)
            make.trailing.equalTo(-18)
        }

        self.moreButton.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.bottom).offset(12)
            make.width.equalTo(144)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }

        self.scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(self.moreButton.snp.bottom).offset(19)
            make.centerX.equalToSuperview()
        }

        self.catsFact.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.centerX.centerY.equalToSuperview()
        }

        self.dogsImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }

        self.contentPlaceholder.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }

    private func bindings() {
        self.bindViewModelToView()
        self.bindViewToViewModel()
    }

    private func bindViewToViewModel() {
        self.segmentControl.publisher(for: \.selectedSegmentIndex)
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                if value % 2 == 0 {
                    self?.viewModel.contentType = .cats
                    self?.catsFact.isHidden = false
                    self?.dogsImageView.isHidden = true
                    if self?.viewModel.score.catsScore == 0 {
                        self?.contentPlaceholder.isHidden = false
                    } else {
                        self?.contentPlaceholder.isHidden = true
                    }
                } else {
                    self?.viewModel.contentType = .dogs
                    self?.catsFact.isHidden = true
                    self?.dogsImageView.isHidden = false
                    if self?.viewModel.score.dogsScore == 0 {
                        self?.contentPlaceholder.isHidden = false
                    } else {
                        self?.contentPlaceholder.isHidden = true
                    }
                }
            }
            .store(in: &self.cancellable)

    }

    private func bindViewModelToView() {
        self.viewModel.$catsFact
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fact in
                if !fact.isEmpty {
                    self?.catsFact.text = fact
                    self?.contentPlaceholder.isHidden = true
                    self?.catsFact.isHidden = false
                } else {
                    self?.contentPlaceholder.isHidden = false
                    self?.catsFact.isHidden = true
                }
                
            }
            .store(in: &self.cancellable)

        self.viewModel.$score
            .receive(on: DispatchQueue.main)
            .sink { [weak self] score in
                self?.scoreLabel.attributedText = NSMutableAttributedString(string: "Score: \(score.catsScore) cats and \(score.dogsScore) dogs", attributes: [NSAttributedString.Key.kern: 0.34])
            }
            .store(in: &self.cancellable)

        self.viewModel.$dogsImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stringUrl in
                if !stringUrl.isEmpty {
                    self?.dogsImageView.kf.setImage(with: URL(string: stringUrl))
                    self?.contentPlaceholder.isHidden = true
                    self?.dogsImageView.isHidden = false
                } else {
                    self?.contentPlaceholder.isHidden = false
                    self?.dogsImageView.isHidden = true
                }
            }
            .store(in: &self.cancellable)

        self.viewModel.errorResult
            .receive(on: DispatchQueue.main)
            .sink {[weak self] error in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Ok", style: .cancel)
                alert.addAction(okButton)
                self?.present(alert, animated: true)
            }
            .store(in: &self.cancellable)
    }

    @objc private func onMoreButtonTapped() {
        self.viewModel.getContent()
    }

    @objc private func onResetButtonTapped() {
        self.viewModel.resetView()
    }
}
