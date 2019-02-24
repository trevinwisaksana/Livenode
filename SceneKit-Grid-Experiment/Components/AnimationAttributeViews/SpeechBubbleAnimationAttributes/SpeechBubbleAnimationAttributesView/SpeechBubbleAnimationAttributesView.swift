//
//  SpeechBubbleAnimationAttributesView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 21/10/18.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

public protocol SpeechBubbleAnimationAttributesViewDelegate: class {
    func speechBubbleAnimationAttributesView(_ alertAnimationAttributesView: SpeechBubbleAnimationAttributesView, didTapAddAnimationButton button: UIButton, animation: SpeechBubbleAnimationAttributes)
    func speechBubbleAnimationAttributesView(_ alertAnimationAttributesView: SpeechBubbleAnimationAttributesView, didUpdateAnimationDuration duration: TimeInterval, forAnimationAtIndex index: Int)
}

public class SpeechBubbleAnimationAttributesView: UIView {
    
    // MARK: - Internal properties
    
    private enum SpeechBubbleAnimationAttributesSection: Int {
        case speechBubbleTextField
        case animationDuration
        case addAnimationButton
        
        var sectionNumber: Int {
            return self.rawValue
        }
    }
    
    private static let numberOfItemsInSection: Int = 3
    private static let speechBubbleTitleCellHeight: CGFloat = 90.0
    private static let animationDurationCellHeight: CGFloat = 90.0
    private static let addAnimationCellHeight: CGFloat = 60.0
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Public Properties
    
    public weak var delegate: SpeechBubbleAnimationAttributesViewDelegate?
    public var dataSource: SpeechBubbleAnimationAttributes?
    
    // MARK: - Setup
    
    public init(delegate: SpeechBubbleAnimationAttributesViewDelegate) {
        super.init(frame: .zero)
        
        self.delegate = delegate
        
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        tableView.register(cell: SpeechBubbleTitleCell.self)
        tableView.register(cell: AnimationDurationCell.self)
        tableView.register(cell: AddAnimationCell.self)
        
        addSubview(tableView)
        tableView.fillInSuperview()
    }
    
    // MARK: - Public
    
    public func reloadData() {
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate

extension SpeechBubbleAnimationAttributesView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectNodeAnimation(atIndex: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    private func didSelectNodeAnimation(atIndex index: Int) {
        switch index {
        case 0:
            break
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource

extension SpeechBubbleAnimationAttributesView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SpeechBubbleAnimationAttributesView.numberOfItemsInSection
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupCell(with: indexPath)
    }
    
    private func setupCell(with indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case SpeechBubbleAnimationAttributesSection.speechBubbleTextField.sectionNumber:
            let cell: SpeechBubbleTitleCell = tableView.dequeueReusableCell()
            
            return cell
            
        case SpeechBubbleAnimationAttributesSection.animationDuration.sectionNumber:
            let cell: AnimationDurationCell = tableView.dequeueReusableCell()
            cell.delegate = self
            cell.model = dataSource
            
            return cell
            
        case SpeechBubbleAnimationAttributesSection.addAnimationButton.sectionNumber:
            let cell: AddAnimationCell = tableView.dequeueReusableCell()
            cell.delegate = self
            
            return cell
            
        default:
            fatalError("Index out of range.")
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case SpeechBubbleAnimationAttributesSection.speechBubbleTextField.sectionNumber:
            return SpeechBubbleAnimationAttributesView.speechBubbleTitleCellHeight
            
        case SpeechBubbleAnimationAttributesSection.animationDuration.sectionNumber:
            return SpeechBubbleAnimationAttributesView.animationDurationCellHeight
            
        case SpeechBubbleAnimationAttributesSection.addAnimationButton.sectionNumber:
            return SpeechBubbleAnimationAttributesView.addAnimationCellHeight
            
        default:
            return 60.0
        }
    }
}

// MARK: - AddAnimationCellDelegate

extension SpeechBubbleAnimationAttributesView: AddAnimationCellDelegate {
    public func addAnimationCell(_ addAnimationCell: AddAnimationCell, didTapAddAnimationButton button: UIButton) {
        guard let animatedNodeLocation = State.nodeAnimationTarget?.position else { return }
        dataSource?.nodeLocation = animatedNodeLocation
        
        guard let dataSource = dataSource else { return }
        
        delegate?.speechBubbleAnimationAttributesView(self, didTapAddAnimationButton: button, animation: dataSource)
    }
}

// MARK: - AnimationDurationCellDelegate

extension SpeechBubbleAnimationAttributesView: AnimationDurationCellDelegate {
    public func animationDurationCell(_ animationDurationCell: AnimationDurationCell, didUpdateAnimationDuration duration: TimeInterval) {
        dataSource?.duration = duration
        
        guard let animationIndex = dataSource?.animationIndex else { return }
        delegate?.speechBubbleAnimationAttributesView(self, didUpdateAnimationDuration: duration, forAnimationAtIndex: animationIndex)
    }
}
