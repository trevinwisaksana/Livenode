//
//  FileMenuPresentableView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 04/09/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class FileMenuPresentableView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError() }
    
    private func setup() {
        let view = FileMenuView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.fillInSuperview()
    }
    
}

// MARK: - FileMenuViewDelegate

extension FileMenuPresentableView: FileMenuViewDelegate {
    func fileMenuView(_ fileMenuView: FileMenuView, didSelectItemAtIndexPath indexPath: IndexPath) {
        transition(using: indexPath)
    }

    private func transition(using indexPath: IndexPath) {
        guard let navigationController = parentViewController?.parent as? UINavigationController else {
            return
        }
        
        switch indexPath.row {
        case 0:
            let colorPicker = Presenter.inject(.colorPickerView)
            navigationController.pushViewController(colorPicker, animated: true)
        default:
            break
        }
    }
}

// MARK: - FileMenuViewDataSource

extension FileMenuPresentableView: FileMenuViewDataSource {
    func viewModel(inFileMenuView fileMenuView: FileMenuView) -> FileMenuViewModel {
        return FileMenu()
    }
}
