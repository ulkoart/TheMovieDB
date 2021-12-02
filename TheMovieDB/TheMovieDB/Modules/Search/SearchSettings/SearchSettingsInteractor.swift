//
//  SearchSettingsInteractor.swift
//  TheMovieDB
//
//  Created by user on 01.12.2021.
//

import Foundation

protocol SearchSettingsInteractorProtocol {
    var presenter: SearchSettingsPresenterProtocol? { get set }
    
    func setAdultFillter(_ isOn: Bool)
    func getAdultFillter() -> Bool
}

final class SearchSettingsInteractor: SearchSettingsInteractorProtocol {
    static let adultFillterValue = "AnimeFillter"
    
    weak var presenter: SearchSettingsPresenterProtocol?
    private let defaults = UserDefaults.standard
    
    func setAdultFillter(_ isOn: Bool) {
        defaults.set(isOn, forKey: SearchSettingsInteractor.adultFillterValue)
    }
    
    func getAdultFillter() -> Bool {
        return defaults.bool(forKey: SearchSettingsInteractor.adultFillterValue)
    }
}
