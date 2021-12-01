//
//  SearchSettingsPresenter.swift
//  TheMovieDB
//
//  Created by user on 01.12.2021.
//

import UIKit

protocol SearchSettingsPresenterProtocol: AnyObject {
    var viewController: SearchSettingsViewControllerProtocol? { get set }
    var interactor: SearchSettingsInteractorProtocol? { get set }
    
    func setAdultFillter(_ isOn: Bool)
    func getAdultFillter() -> Bool
}

final class SearchSettingsPresenter: SearchSettingsPresenterProtocol {
    weak var viewController: SearchSettingsViewControllerProtocol?
    var interactor: SearchSettingsInteractorProtocol?
    
    func setAdultFillter(_ isOn: Bool) {
        interactor?.setAdultFillter(isOn)
    }
    
    func getAdultFillter() -> Bool {
        return interactor?.getAdultFillter() ?? false
    }
}
